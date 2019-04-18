
% script to calculate (and store for later) statistics over multiple
% planets, and over multiple instances of the same planet.
% For each of a number of metrics, the frequency distributions of (a) all
% planets (runs), and (c) of all surviving planets (successful runs), are
% compared.
% -------------------------------------------------------------------------


% FIRST OF ALL CREATE A LIST OF THE NUMBERS OF ALL SUCCESSFUL PLANETS

ngoodruns = 0;
nhabplanets = 0;
nperfectplanets = 0;
goodplanets = zeros([1 nplanets]);

for pp = 1:nplanets
    
    a_run_survived = 0;
    all_runs_survived = 1;
    
    for kk = 1:nreruns
        rr = (pp-1)*nreruns+kk;
        % if the run was successful (remained habitable)...
        if (runs(rr).result == 1)
            % set a flag to show that this planet had at least one
            % successful run
            a_run_survived = 1;
            % copy this run to the array of successful runs
            ngoodruns = ngoodruns + 1;
            goodruns(ngoodruns) = runs(rr);
        else
            all_runs_survived = 0;
        end;
    end;
    
    % if at least one instance of this planet survived...
    if (a_run_survived == 1)
        planets(pp).any_survived = 1;
        % copy this planet to the array of survivors
        nhabplanets = nhabplanets + 1;
        goodplanets(nhabplanets) = pp;
    else
        planets(pp).any_survived = 0;
    end;
    
    % if all instances of this planet survived...
    if (all_runs_survived == 1)
        planets(pp).all_survived = 1;
        nperfectplanets = nperfectplanets + 1;
    else
        planets(pp).all_survived = 0;
    end;
end;


% SECONDLY CALCULATE THE FREQUENCY DISTRIBUTIONS TO PLOT
% split the range of each metric up into 40 bins (or another number if
% necessary) and calculate frequencies for each of those 40 bins

% first the properties of planets
calc_planet_freqs;
% then the properties of runs
calc_run_freqs;


% CREATE THE DIRECTORIES TO STORE THE SAVED FIGURES, IF NECESSARY
sname = ['results/' savename];   % save all results in 'results' directory
if ~exist([sname '/pngs'], 'dir')
    mkdir([sname '/pngs']);
end;
if ~exist([sname '/figs'], 'dir')
    mkdir([sname '/figs']);
end;


% FINALLY PLOT THE RESULTS
if ((nplanets*nreruns) > 100)
    plot_run_histograms;
end;
if (nplanets > 100)
    plot_planet_histograms;
    plot_successrates;
end;

% check that the count of the number of (at least sometimes) persistently
% habitable planets agrees with the count made earlier
if (nhabplanets ~= ngoodplanets)
    fprintf('\n****Warning: nhabplanets (%d) and ngoodplanets (%d)disagree\n\n', ...
        nhabplanets, ngoodplanets);
end;

% DISPLAY SOME OVERALL STATISTICS (PARTLY AS CHECKS)
fprintf('\n   From saved results: %d out of %d planets survived sometimes', ...
    nhabplanets, nplanets);
fprintf('\n   From saved results: %d out of %d planets were perfect', ...
    nperfectplanets, nplanets);
fprintf('\n   From saved results: %d out of %d runs were successful\n', ...
    ngoodruns, (nplanets*nreruns));

% more output calculations (summary for paper)
summary_for_paper;

% save all the figures to image files, and workspace to a MAT file
h = get(0,'children');
h = sort(h);
for ii=1:length(h)
    if (strfind(version,'R2014b') ~= [])
        hnum = h(ii).Number;
    elseif (strfind(version,'R2015') ~= [])
        hnum = h(ii).Number;
    elseif (strfind(version,'R2016') ~= [])
        hnum = h(ii).Number;;
    else
        hnum = h(ii);
    end
    saveas(h(ii), [sname '/pngs/figure' int2str(hnum)], 'png');
    saveas(h(ii), [sname '/figs/figure' int2str(hnum)], 'fig');
end;

% save everything EXCEPT FIGURES to a matfile
allvars = whos;
tosave = cellfun(@isempty, regexp({allvars.class}, '^matlab\.(ui|graphics)\.'));
save('workspace_dump.mat', allvars(tosave).name);
save([sname '/workspace_dump.mat'], allvars(tosave).name);
