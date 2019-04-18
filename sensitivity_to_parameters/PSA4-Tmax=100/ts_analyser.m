% PROGRAM TO SIMULATE TEMPERATURE TRAJECTORIES OF A MYRIAD OF PLANETS

% Toby Tyrrell - 2015

% The idea of this model is to initialise and then compare performances
% of a menagerie of thousands of planets, each with a different set of
% intrinsic feedbacks on temperature. It is expected that different
% members of the menagerie will possess wildly different propensities for
% maintaining stable and habitable conditions over billions of years.

% Each different planet will have a randomly selected sum of temperature
% feedbacks.
% Each planet, once set up, will be 'run' hundreds or thousands of times
% to see if it makes it successfully through 3 billion years without once
% becoming uninhabitable (without once leaving the range of habitable
% temperatures, i.e. the 'habitable envelope').
% Each instance of each planet will be given a random initial temperature
% within the habitable envelope.

% In this way this model will address the question of how to account for
% 3 billion years of uninterrupted habitability on Earth (3 billion years
% of bio-persistence), despite several reasons for believing that such a
% phenomenon is extremely unlikely:
% 1. a short residence time (<1 million years) of atmospheric CO2, which
%    should therefore exhibit volatility unless stabilised;
% 2. warming of the sun over time, by more than 40% over the lifespan of
%    the Earth (hence the Faint Young Sun problem); and
% 3. prominent reminders of the ease of uninhabitability in the form of
%    Earth's nearest neighbours, Mars (too cold) and Venus (too hot).

% Some hypotheses that will be tested:
% A. that only planets with near-perfect thermostats will remain habitable
%    for so long
% B. [alternative to A] that planets with imperfect thermostats have
%    smaller but significant chances of remaining habitable for so long
% C. that the large majority of randomly determined planets have
%    exceptionally small chances of such prolonged habitability

% units to be used are
%    (1) thousands of years = ky (for time), and
%    (2) degrees centigrade (for temperature)
%--------------------------------------------------------------------------


% ##### THIS PARTICULAR SCRIPT ASSEMBLES ALL THE PREVIOUSLY PRODUCED #####
% ##### TASK RESULTS INTO ONE GIANT SET OF RESULTS AND THEN ANALYSES #####
% ##### AND PLOTS IT ALL OUT                                         #####

% use the generic versions of the scripts and functions unless different
% versions are provided here
addpath('../../default_SA_code', '-end');

initialise_analyser;

% find the directory where the task results should all be stored
dname = sprintf('results/%s', savename);
if ~exist(dname, 'dir')
    error('  ERROR: RESULTS DIRECTORY DOES NOT EXIST: %s\n\n', dname);
end;

% read in the header file and check that the expected information is in it
read_header;

fprintf('starting analyser for "%s" (%d planets, %d reruns each, in %d tasks)\n\n', ...
    svname, np, nr, nt);

fprintf('   ...looking for sets of results from different tasks...\n\n');

% check that all the task output files exist
errorfl = 0;
for tt = 1 : nt
    idd = sprintf('results/%s/task_%d.mat', savename, tt);
    if ~exist(idd, 'file')
        error('  ERROR: EXPECTED TASK OUTPUT FILE (%s) DOES NOT EXIST\n\n', idd);
        errorfl = 1;
    end;
end;

fprintf('   ...found all %d sets of task results, now reading them in...\n\n', nt);

% if all files are there then read them all in and transfer their results
% to the complete array for the whole simulation
if (errorfl == 0)
    for tt = 1 : nt    % for each task
        idd = sprintf('results/%s/task_%d', savename, tt);
        load(idd); % should read savename, task_number, pl, tp, rl and tr
        savename = svname;
        if (tt ~= task_number)
            error('  ERROR: TASK NUMBERS DO NOT AGREE (%d) (%d)\n\n', ...
                tt, task_number);
        end;
        array_transfers;    % transfer in the task results
        fprintf('have read in data from task number %d\n', tt);
    end;
end;

% check that the whole of the results arrays have been populated
for aa = 1 : nplanets
    if (isnan(planets(aa).pnumber) || isnan(planets(aa).nnodes) || ...
            (planets(aa).nnodes < 2))
        error('  ERROR: PLANET (%d) has no data\n\n', aa);
    end;
end;
for bb = 1 : nruns
    if (isnan(runs(bb).runnumber) || isnan(runs(bb).result) || ...
            (runs(bb).result < -1) || (runs(bb).result > 1))
        error('  ERROR: RUN (%d) has no data\n\n', bb);
    end;
end;

fprintf('   ...analysing the complete simulation results...\n\n');


% now that have the whole simulation results all in one, go through them
% and fill in any missing numbers (mainly planet statistics) and calculate
% statistics over whole planets (which could have been run over two or more
% tasks) and the whole population

ngoodruns = 0;
ntoohot = 0;
ntoocold = 0;

% FOR EACH PLANET
for ii = 1:nplanets
    
    if (verbose)
        fprintf('Planet number %d\n', ii);
    end;
    
    nsurvived = 0;             % counter for number of successful runs
    ndied = 0;                 % counter for number of failed runs
    sumduration = 0.0;         % counter for calculating average run duration
    
    % FOR EACH RERUN
    for jj = 1:nreruns
        
        runnumber = (ii-1)*nreruns + jj;
        
        % increment counters for planets surviving or dying, also how many
        % got too cold and how many got too hot
        % .result of 1 means survived, 0 means got too hot and -1 too cold       
        if (runs(runnumber).result == 1)
            nsurvived = nsurvived + 1;
            ngoodruns = ngoodruns + 1;
        else
            ndied = ndied + 1;
            if (runs(runnumber).result == 0)   % too hot
                ntoohot = ntoohot + 1;
            elseif (runs(runnumber).result == -1)   % too cold
                ntoocold = ntoocold + 1;
            else
                error('shouldnt be here');
            end
        end
        sumduration = sumduration + runs(runnumber).length;
    end;  % of all reruns of the same planet
    
    % calculate success statistics (incl. proportion of runs that went
    % full distance) for this planet
    planets(ii).nsuccess = nsurvived;
    planets(ii).nfail = ndied;
    if (nsurvived > 0)
        planets(ii).any_survived = 1;
    else
        planets(ii).any_survived = 0;
    end;
    planets(ii).successrate = nsurvived / nreruns;
    planets(ii).avduration = round(sumduration) / nreruns / 1e6;
    
    if (nsurvived > 0)
        ngoodplanets = ngoodplanets + 1;
    end;
    
    % summarise results over all reruns of this planet
    if ((nsurvived+ndied) ~= nreruns)
        error ('***WARNING*** error for planet %d (%d reruns, %d remained habitable, %d went sterile)\n\n', ...
            ii, nreruns, nsurvived, ndied);
    end;
%     fprintf ('\nPLANET #%d SUMMARY: of %d reruns, %d remained habitable, %d went sterile\n', ...
%         ii, nreruns, nsurvived, ndied);
%     fprintf ('\n                    average survival time was %d ky\n\n\n', ...
%         round((sumduration/nreruns)));
    
    if (verbose)
        % close all figures
        close all;
    end;
end;  % of all planets

% summarise results over all planets
fprintf ('OVERALL SUMMARY: %d out of %d planets survived at least once (%d reruns each)\n', ...
    ngoodplanets, nplanets, nreruns);

% summarise results over all planets
fprintf ('               : %d failed because got too cold, %d failed because got too hot\n', ...
    ntoocold, ntoohot);

% print the value of the metric (whether more to do with luck or more to do
% with mechanism)
metric = round(100.0 * ngoodruns / (ngoodplanets*nreruns));
pure_chance = round(100.0*ngoodruns/(nplanets*nreruns));
fprintf('\n  value of overall metric is %d%% ', metric);
fprintf('(100%% = pure destiny, %d%% = pure chance)\n', pure_chance);

fprintf('   ...plotting the complete simulation results...\n\n');

% plot some patterns showing how P(survival) was affected by various
% factors
plot_final_results;


% save everything in case computer shuts down, or to read in later, or to
% combine later with other results files
%save('runname');
%save testsave nplanets nreruns planets runs;

