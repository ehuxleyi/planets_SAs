% slave function - the code that will be farmed out to multiple processors
% during parallel runs. Each function call carries out one task.
%--------------------------------------------------------------------------

function [planets, runs] = ts_slave(argss)

% where:
%   sim_name   = the name of the simulation (character string)
%   tc         = the number of the task (out of many to implement the whole
%                simulation)
%   tplanets   = a vector list of the numbers of the planets to execute
%   truns      = a vector list of the numbers of the runs to execute
%   pnumnodes  = list of the numbers of nodes of each planet
%   pnodes     = lists of the temperatures of each node of each planet
%   pfeedbacks = lists of the dT/dt's of each node of each planet
%   ptrends    = vector list of the imposed trend in T for each planet
%   pblamdas   = vector list of the expected numbers of large perturbations
%   pmlamdas   = vector list of the expected numbers of medium perturbations
%   pllamdas   = vector list of the expected numbers of small perturbations
%   tresults_p = results of the runs in this task in terms of planets info
%   tresults_r = results of the runs in this task in terms of run info
%
% and:
%   planets   = array of planet properties to return
%   runs      = array of run properties to return

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


% ##### THIS PARTICULAR SCRIPT CARRIES OUT A SPECIFIC TASK (PART OF  #####
% ##### THE SIMULATION) ALLOCATED TO IT BY THE MASTER PROGRAM).      #####
% ##### EACH TASK CONSISTS OF A SUBSET OF THE PLANETS AND RERUNS     #####

% unpack the arguments from the structure passed to this function
sim_name = argss.arg1;
tc = argss.arg2;
tplanets = argss.arg3;
truns = argss.arg4;
pnumnodes = argss.arg5;
pnodes = argss.arg6;
pfeedbacks = argss.arg7;
ptrends = argss.arg8;
pblambdas = argss.arg9;
pmlambdas = argss.arg10;
pllambdas = argss.arg11;
% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
pks = argss.arg12;

initialise_slave;

% carry out the specific planets and runs in this task

% FOR EACH RUN IN THIS TASK
for plc = 1 : length(tplanets)    % plc = counter for planets
    
    
    %% FIRST OF ALL SET UP THE RUN
    
    % calculate the overall number of this run out of all runs in the whole
    % simulation
    run_number = (tplanets(plc)-1)*nreruns + truns(plc);
    
    % initialise the random number generator for this run
    init_run_rng;
    
    if (verbose)
        fprintf('Planet %d (rerun %d), as part of task %d\n', ...
            tplanets(plc), truns(plc), tc);
    end;
    
    % [1] allocate this planet's set of intrinsic feedbacks from the
    % information supplied to the function
    % <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
    nTnodes  = pnumnodes(plc,1);               % number of nodes
    nPnodes = pnumnodes(plc,2);               % number of nodes
    % <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
    Tgap = Trange0 / (nTnodes-1);
    Pgap = Prange / (nPnodes-1);
    for qq = 1:nnodes_max
        Tnodes(qq) = pnodes(plc,qq,1);             % T of nodes
        Tfeedbacks(qq) = pfeedbacks(plc,qq,1);     % dT/dt of nodes
    end;
    % <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
    for qq = 1:nnodes_max
        Pnodes(qq) = pnodes(plc,qq,2);             % T of nodes
        Pfeedbacks(qq) = pfeedbacks(plc,qq,2);     % dT/dt of nodes
    end;
    
    % [2] Randomly determine an overall cooling or warming trend to add to the
    % planet (Earth has experienced a 25% increase in solar luminosity since
    % 3 Bya - Faint Young Sun - but this is higher than most potentially
    % habitable planets, and other factors can lead to overall cooling trends,
    % for instance biological evolution leading to progressive removal of
    % greenhouse gases from the atmosphere, or increase in albedo due to
    % increasing area of continents over time).
    % Apply as a linearly increasing increment (decrement) to the sum of
    % feedbacks, i.e. whose value starts off at zero and, by the end of the
    % run, eventually increases in magnitude to the value calculated below.
    % Maximum magnitude = one half of maximum heating or cooling.
    
    % [2] get this planet's cooling or warming trend
    % <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
    trendT = ptrends(plc,1);       % heating or cooling trend
    trendP = ptrends(plc,2);
    
    % [3] Randomly initialise the planet's 'neighbourhood'. This consists
    % of allocating overall perturbation frequencies to represent the type
    % of galaxy the planet is in, where in that galaxy it is, the nature of
    % the star it is orbiting (if just one), and the nature of the
    % planetary system it is in
    lambda_big    = pblambdas(plc);
    lambda_mid    = pmlambdas(plc);
    lambda_little = pllambdas(plc);
    
    % [4] Randomly initialise the planet's surface temperature for just
    % this rerun of this planet
    % <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
    [Tinit, Pinit] = determine_initial_values(Tmin, Trange0);
    
    % calculate additional and higher-level planet properties that will be
    % used in later analysis
    calc_planet_properties;
    
    % plot the initial and final (after 3By of trend) feedback patterns
    % for this planet
    if (verbose)
        plot_feedbacks;
    end;
    
    % overall number of this run out of all runs in the whole
    % simulation
    run_number = (tplanets(plc)-1)*nreruns + truns(plc);
    
    % set up random perturbations in advance, where they consist of
    % changes to earth surface temperature.
    determine_perturbations;
    
    % <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
    % recalculate the upper limit of the habitable temperature range
    Tmax = Tmaxvar(Pinit, Pmin, Pmax);
    
    
    %% NOW ACTUALLY RUN THE PLANET THROUGH ITS COMPLETE HISTORY OR UNTIL IT
    %  GOES STERILE
    
    %% FIRST PART OF THE RUN - UP TO THE TIME OF THE FIRST PERTURBATION
    
    % ----- Sort out mechanics/parameterisation of simulation -----
    tstart	= 0;   % start time (of first stage)
    tfinal	= perturbations(1,1);    % end time (of first stage)
    steps   = 0;
    limit   = 1000000;
    refine  = 1;   % no extra output between time steps
    stcounter = 0; % stage counter
    
    % ----- Set up initial conditions -----
    y0 = [ Tinit Pinit 0.0 ];
    
    % ----- Set up ODE options for Matlab engine -----
    options = odeset('Events', @events_pl, 'Refine', refine, ...
        'Reltol', 1e-4, 'Abstol', 0.05, 'MaxStep', 1000, ...
        'InitialStep', 0.01);
    
    % Solve until the temperature exceeds habitable bounds or end of
    % run is reached
    % planets_ODE = the function containing the ODE
    % [tstart tfinal] = start and end times of the run (if no event)
    % y0 = initial conditions
    % options = options set up above using odeset
    [t,y,te,ye,ie] = ode23s(@planets_ODE,[tstart tfinal], y0, options);
    % t = vector containing the time at each timestep
    % y = vector containing T at each timestep
    % te = time at which an event occurred (Earth went sterile)
    % ye = value of T when this occurred
    
    t1 = t;
    y1 = y;
    
    % <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
    % recalculate the upper limit of the habitable temperature range
    Tmax = Tmaxvar(y(2), Pmin, Pmax);
    
    %% OTHER STAGES OF RUN
    % continue the run from perturbation to perturbation until end reached
    % or planet gone sterile
    % <<<<<<<<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>>>
    % sterility depends on other environmental factors, not just T
    while (((round(t(end))) < max_duration) && (y(end,1) > Tmin) && ...
            (y(end,1) < Tmax) && (y(end,2) > Pmin) && ...
            (y(end,2) < Pmax) && (stcounter < pcounter))
        
        % ----- Sort out mechanics/parameterisation of simulation -----
        stcounter = stcounter + 1;    % increment stage counter
        tstart	= t(end);     % continue from end of last stage
        if (stcounter < pcounter)   % if more perturbations left to do
            tfinal	= perturbations((stcounter+1),1); % until next perturbation
        else     % if all perturbations done
            tfinal	= max_duration; % until end of run
        end;
        steps   = 0;
        limit   = 1000000;
        refine  = 1;   % no extra output between time steps
        
        % ----- Set up initial conditions -----
        y(end,1) = y(end,1) + perturbations(stcounter,2);  % add perturbation
        y0 = y(end,:);
        
        % Solve until the temperature exceeds habitable bounds or end of run is
        % reached (for explanation of inputs and outputs, see above)
        [t,y,te,ye,ie] = ode23s(@planets_ODE,[tstart tfinal], y0, options);
        
        % accumulate output results in arrays
        t = [t1; t];
        y = [y1; y];
        t1 = t;
        y1 = y;
        
        % <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
        % recalculate the upper limit of the habitable temperature range
        Tmax = Tmaxvar(y(2), Pmin, Pmax);
        
    end;  % of all stageposts (steps from one perturbation to another)
    
    
    %% TIDY UP AFTER RUN FINISHED
    
    % Show the temperature history as a figure
    if (verbose)
        plot_history;
    end
    
    % calculate run properties and populate the results structure for
    % this run
    calc_run_properties;
    
    % populate part of the results structure for this planet
    planets(plc).pnumber = tplanets(plc);     % number of this planet
    % <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
    planets(plc).nTnodes  = nTnodes;           % number of nodes
    planets(plc).nPnodes  = nPnodes;           % number of nodes
    for qq = 1:nnodes_max
        planets(plc).Tnodes(qq) = Tnodes(qq); % T of each node
        planets(plc).Tfeedbacks(qq) = Tfeedbacks(qq);  % dT/dt of each node
    end;
    for qq = 1:nnodes_max
        planets(plc).Pnodes(qq) = Pnodes(qq); % P of each node
        planets(plc).Pfeedbacks(qq) = Pfeedbacks(qq);  % dP/dt of each node
    end;
    % <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
    planets(plc).trendT = trendT;              % heating or cooling trend
    planets(plc).trendP = trendP;
    planets(plc).lambda_big = lambda_big;       % big P freq (av number)
    planets(plc).lambda_mid = lambda_mid;       % mid P freq (av number)
    planets(plc).lambda_little = lambda_little; % little P freq (av number)
    
end;  % of all planets for this task
