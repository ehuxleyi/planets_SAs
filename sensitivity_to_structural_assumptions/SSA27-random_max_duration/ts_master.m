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


% ##### THIS PARTICULAR SCRIPT INITIALISES THE SIMULATION, DECIDES   #####
% ##### TASKS AND THEN SUBMITS THEM TO MDCS                          #####

% use the generic versions of the scripts and functions unless different
% versions are provided here
addpath('../../default_SA_code', '-end');

% create empty arrays of the right size, and give constants the appropriate
% values
initialise_master;

% determine the intrinisic (as opposed to run-specific) properties of each
% planet
for ii = 1:nplanets
    
    % Randomly initialise the temperature feedbacks of this planet.
    % This is done by defining the sign and strength of feedback (i.e.
    % dT/dt) across the habitable temperature range. We are not interested
    % in the behaviour once outside the habitable envelope because all
    % planets are started off inside it, and are no longer considered once
    % they leave it. In other words, we are only interested in whether
    % planets remain CONTINUOUSLY HABITABLE. Planets that briefly become
    % sterile and then swiftly return to habitable conditions are no good,
    % because life will have been extinguished. It is assumed for the
    % purposes of this study that 3 billion years of continuous cumulative
    % evolution are required to generate intelligent observers
    
    % [1] give this planet a random set of intrinsic feedbacks
    determine_feedbacks;
    
    % [2] Randomly determine an overall cooling or warming trend to add to the
    % planet (Earth has experienced a 25% increase in solar luminosity since
    % 3 Bya - Faint Young Sun - but this is higher than most potentially
    % habitable planets, and other factors can lead to overall cooling trends,
    % for instance biological evolution leading to progressive removal of
    % greenhouse gases from the atmosphere, or increase in albedo due to
    % increasing area of continents over time).
    % Apply as a linearly increasing increment (decrement) to the sum of
    % feedbacks, i.e. whose value starts off at zero and subsequently
    % increases (decreases) over time
    determine_trend;
    
    % [3] Randomly initialise the planet's 'neighbourhood'. This consists
    % of allocating overall perturbation frequencies to represent the type
    % of galaxy the planet is in, where in that galaxy it is, the nature of
    % the star it is orbiting (if just one), and the nature of the
    % planetary system it is in
    determine_neighbourhood;
    
    % save the key planet details in an array
    % allocate this planet's set of intrinsic feedbacks
    planets(ii).nnodes = nnodes;          % number of nodes
    for qq = 1:nnodes_max
        planets(ii).Tnodes(qq) = Tnodes(qq);          % T of nodes
        planets(ii).Tfeedbacks(qq) = Tfeedbacks(qq);  % dT/dt of each node
    end
    % allocate this planet's cooling or warming trend
    planets(ii).trend = trend;            % number of nodes
    % allocate this planet's expected numbers of perturbations
    planets(ii).lambda_big = lambda_big;        % big P freq (av number)
    planets(ii).lambda_mid = lambda_mid;        % mid P freq (av number)
    planets(ii).lambda_little = lambda_little;  % little P freq (av number)
end  % of all planets

% before running the simulation, save all setup information to a matfile
save init.mat planets nplanets nreruns ntaskruns

% decide how to split up the whole simulation into separate tasks
task_allocation;

% save some information needed later by the retriever
save intermediate ntasks task_planets task_runs;


% #### PARALLEL BIT ####

% set up a cluster
ct = parcluster;

% for each job submitted to the Iridis4 cluster
for jj = 1 : njobs
    
    % create a job, to run on that cluster, but do not submit it yet
    jt = createJob(ct);

    % calculate the first and last numbers of the tasks that will be
    % included in this job
    taskbc = ((jj-1) * ntasksperjob) + 1;
    taskec = min((jj*ntasksperjob), ntasks);
    
    fprintf('   about to start adding tasks %d-%d to job number %d\n', ...
        taskbc, taskec, jj);
    
    % for each task
    for tt = taskbc:taskec
        
        % work out how many runs are in this task (usually = ntaskruns, but can
        % be less). Each run is likely to be of a different planet.
        nr = sum(~isnan(task_planets(tt,:)));
        
        % initialise arrays in which to pass task information to slave
        task_nnodes    = double(zeros([nr 1])); % numbers of nodes of each planet
        task_nodes     = double(zeros([nr nnodes_max])); % T at each node of each planet
        task_feedbacks = double(zeros([nr nnodes_max])); % feedback (dT/dt) at each node of each planet
        task_trends    = double(zeros([nr 1])); % trend for each planet
        task_blambdas  = double(zeros([nr 1])); % big P freqs for each planet
        task_mlambdas  = double(zeros([nr 1])); % mid P freqs for each planet
        task_llambdas  = double(zeros([nr 1])); % little P freqs for each planet
        
        % populate arrays with task information to pass to slave
        for kk = 1 : nr   % for each run in this task
            pp = task_planets(tt,kk);  % calculate the planet number
            task_nnodes(kk) = planets(pp).nnodes;
            for qq = 1:task_nnodes(kk)
                task_nodes(kk,qq)     = planets(pp).Tnodes(qq);
                task_feedbacks(kk,qq) = planets(pp).Tfeedbacks(qq);
            end
            % fill unused nodes with NaNs (e.g. if only 5 nodes but array has
            % space for 20)
            for qq = (task_nnodes(kk)+1):nnodes_max
                task_nodes(kk,qq)     = NaN;
                task_feedbacks(kk,qq) = NaN;
            end
            task_trends(kk) = planets(pp).trend
            task_blambdas(kk) =  planets(pp).lambda_big;
            task_mlambdas(kk) =  planets(pp).lambda_mid;
            task_llambdas(kk) =  planets(pp).lambda_little;
        end
        
        fprintf('\nTASK NUMBER <<< %d >>> \n', tt);
        
        % put the arrays with the task information into a single structure
        s = struct('arg1', savename, ...   % string
            'arg2', tt, ...                    % integer
            'arg3', [task_planets(tt,1:nr)], ...    % vector of integers
            'arg4', [task_runs(tt,1:nr)], ...       % vector of integers
            'arg5', task_nnodes, ...       % vector of integers
            'arg6', task_nodes, ...        % array of doubles
            'arg7', task_feedbacks, ...    % array of doubles
            'arg8', task_trends, ...       % vector of doubles
            'arg9', task_blambdas, ...     % vector of doubles
            'arg10', task_mlambdas, ...    % vector of doubles
            'arg11', task_llambdas);        % vector of doubles
        
        % create a new task object to run an instance of the slave program,
        % and add it to the pending job
        taskt = createTask(jt,@ts_slave,2,{s}); % input = s, 2 outputs
    end
    
    % display the job to check that tasks were added to the job
    jt.Tasks
    
    % submit the job to the PBS batch queue
    submit(jt);
end

% exit, leaving the job running on the cluster
