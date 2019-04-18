% script to split out the whole simulation into a number of tasks, each of
% manageable size
% -------------------------------------------------------------------------

% The previous approach involved giving whole planets to specific tasks, or
% at least steppping through in a sequential, planet-by-planet way when
% splitting planets between tasks. This had the downside, however, that
% tasks which had to calculate all of the runs of a planet conducive to
% long-term habitability would take >100 times longer than other tasks.

% The new approach is to spread the reruns of the same planet between
% different tasks, so that the workload is shared more evenly between tasks

% initialise arrays to start off as all NaNs rather than all zeros
task_planets(:,:) = NaN;
task_runs(:,:) = NaN;

% now split up the simulation into a number of different separate tasks
tc = 1;        % number of the task being allocated a run
trunc = 1;     % position of the run within the task (whether 1st, 2nd etc)

% allocate to tasks all reruns of all planets, one by one
for i = 1:nplanets
    for j = 1:nreruns
        % allocate it to the task whose turn it is to receive one next
        task_planets(tc,trunc) = i;   % planet number
        task_runs(tc,trunc)    = j;   % rerun number
        % move the counter on, so that the next run goes to the next task
        tc = tc + 1;
        % if have just filled up a whole rank (e.g. the 3rd run of each
        % task)
        if (tc > ntasks)
            % move on to the next rank
            trunc = trunc + 1;
            % start with task 1 again
            tc = 1;
        end;
    end;
end;

fprintf ('TASK ALLOCATION: %d reruns of %d planets will be simulated\n', ...
    nreruns, nplanets);
fprintf ('                 in %d tasks, each of maximum %d runs\n\n', ...
    ntasks, ntaskruns);
