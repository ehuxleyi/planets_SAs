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


% ##### THIS PARTICULAR SCRIPT CHECKS TO SEE IF JOB HAS FINISHED ON  #####
% ##### IRIDIS4, AND IF IT HAS THEN RETRIEVES AND SAVES THE RESULTS  #####


% use the generic versions of the scripts and functions unless different
% versions are provided here
addpath('../../default_SA_code', '-end');

% read in shared parameters, filenames etc
initialise_retriever;

% calculate information about the tasks and initialise arrays in which to
% put results
task_allocation;

% set up my cluster profile
clustertoby = parcluster;

% see if there are any of my jobs
[pending queued running completed] = findJob(clustertoby);
myjobs = findJob(clustertoby);

if isempty(pending)
    fprintf('no jobs pending\n');
else
    fprintf('%d jobs are pending\n', length(pending));
    pending
end
if isempty(queued)
    fprintf('no jobs queued\n');
else
    fprintf('%d jobs are queued\n', length(queued));
    queued
end
if isempty(running)
    fprintf('no jobs running\n');
else
    fprintf('%d jobs are running\n', length(running));
    running
end
if isempty(completed)
    fprintf('no jobs completed\n');
    finished_flag = 0;
else
    fprintf('%d jobs are completed\n', length(completed));
    completed
    finished_flag = 1;
end

% only try and retrieve the results if one or more jobs have finished
if (finished_flag == 1)
    
    % for each finished job
    for kkk = 1:length(completed)
        
        % delete any previous results to make sure no unintentional carryover
        clear idd tpout trout task_number pl tp rl tr;
        
        % retrieve the results from all of the tasks in this job
        jobres = fetchOutputs(completed(kkk));
        
        % calculate the first and last numbers of the tasks that will be
        % included in this job
        taskbc = ((kkk-1) * ntasksperjob) + 1;
        taskec = min((kkk*ntasksperjob), ntasks);
        
        % extract the results from each task and transfer to a structure.
        % note that the tasks overall are numbered from 1 to ntasks, but in
        % each job are numbered from taskbc to taskec. To avoid
        % duplication, saved matfiles need to correspond to the overall
        % task number, not to its number within the individual job
        for tt = 1:(1+taskec-taskbc)
            
            % overall task number
            tto = taskbc + tt - 1;
            
            fprintf('transferring task %d results to a structure\n', tto);
            
            % get this task's results (array of planets' properties, plus
            % array of runs' properties)
            % **NOTE**: have to access using {} in order to return the
            % actual structures. Accessing using () returns instead a 1x1
            % cell array holding the structures
            tpout = jobres{tt,1};
            trout = jobres{tt,2};
            
            % work out how many runs are in this task (usually = ntaskruns,
            % but can be less). Each run is likely to be of a different
            % planet
            nr = sum(~isnan(task_planets(tto,:)));
            
            % prepare information to be saved into matfile
            if (length(completed) == 1)
                idd = sprintf('results/%s/task_%d', savename, tto);
            elseif (length(completed) > 1)
                idd = sprintf('results/%s/job%d_task_%d',savename,kkk,tto);
            end
            task_number = tto;   % overall task number
            pl = [task_planets(tto,1:nr)]; % list of planets
            tp = tpout;   % array of planets' properties
            rl = [task_runs(tto,1:nr)]; % list of runs
            tr = trout;   % array of runs' properties
            
            fprintf('saving task %d results to a matfile\n', tto);
            
            save (idd, 'savename', 'task_number', 'pl', 'tp', 'rl', 'tr');
        end
               
        % save a header file to the results directory
        hname = sprintf('results/%s/header.mat', savename);
        svname = savename; np = nplanets; nr = nreruns; nt = ntasks;
        save (hname, 'svname', 'np', 'nr', 'nt');
    end
    
else
    
    fprintf('\n     Exiting because no completed runs to retrieve results from\n\n');
    
end
