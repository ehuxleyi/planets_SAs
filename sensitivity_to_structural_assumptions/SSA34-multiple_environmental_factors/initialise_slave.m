
% This script initialises parameters and variables needed for the slave
% program to execute tasks
%--------------------------------------------------------------------------

% allow the following to be shared between main program and planets_ode
global nTnodes Tnodes Tfeedbacks Tgap trendT
global nH1nodes H1nodes H1feedbacks H1gap trendH1
global nH2nodes H2nodes H2feedbacks H2gap trendH2
global nH3nodes H3nodes H3feedbacks H3gap trendH3
global k1 k2 k3 k4 k5 k6

% define various constants and parameters used (to same values as in
% master)
set_constants;

% initialise arrays
Tnodes = double(zeros([1 nnodes_max]));     % T at each node
Tfeedbacks = double(zeros([1 nnodes_max])); % feedback (dT/dt) at each node
% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
H1nodes = double(zeros([1 nnodes_max]));    % H1 at each node
H1feedbacks = double(zeros([1 nnodes_max]));% feedback (dH1/dt) at each node
H2nodes = double(zeros([1 nnodes_max]));    % H2 at each node
H2feedbacks = double(zeros([1 nnodes_max]));% feedback (dH2/dt) at each node
H3nodes = double(zeros([1 nnodes_max]));    % H3 at each node
H3feedbacks = double(zeros([1 nnodes_max]));% feedback (dH3/dt) at each node
attractors = double(zeros([nnodes_max 14]));  % cannot be more attractors than nodes
attr       = double(zeros([nnodes_max 14]));  % what is this?

% set up structures and arrays to store information about each planet, to
% be used in later analysis 
for pp = 1 : length(tplanets)
    planets(pp).pnumber = NaN;        % number of this planet
    % <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
    planets(pp).nTnodes = NaN;         % number of nodes
    planets(pp).nH1nodes = NaN;         % number of nodes
    planets(pp).nH2nodes = NaN;         % number of nodes
    planets(pp).nH3nodes = NaN;         % number of nodes
    for qq = 1:nnodes_max
        planets(pp).Tnodes(qq) = NaN;         % T of each node
        planets(pp).Tfeedbacks(qq) = NaN;     % dT/dt of each node
    end;
    % <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
    for qq = 1:nnodes_max
        planets(pp).H1nodes(qq) = NaN;         % H1 of node
        planets(pp).H1feedbacks(qq) = NaN;     % dH1/dt of node
    end;
    for qq = 1:nnodes_max
        planets(pp).H2nodes(qq) = NaN;         % H2 of node
        planets(pp).H2feedbacks(qq) = NaN;     % dH2/dt of node
    end;
    for qq = 1:nnodes_max
        planets(pp).H3nodes(qq) = NaN;         % H3 of node
        planets(pp).H3feedbacks(qq) = NaN;     % dH3/dt of node
    end;
    % <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
    planets(pp).trendT = NaN;          % heating or cooling trend
    planets(pp).trendH1 = NaN;          % heating or cooling trend
    planets(pp).trendH2 = NaN;          % heating or cooling trend
    planets(pp).trendH3 = NaN;          % heating or cooling trend
    planets(pp).lambda_big = NaN;     % big P freq (av number)
    planets(pp).lambda_mid = NaN;     % mid P freq (av number)
    planets(pp).lambda_little = NaN;  % little P freq (av number)
    planets(pp).nattractors = NaN;    % number of stable attractors
    %     - including stable attractor properties of the planet
    planets(pp).max_attr_width = NaN;    % width of widest one
    planets(pp).max_attr_height = NaN;   % height of highest one
    planets(pp).max_attr_strength = NaN; % strength of strongest one
    planets(pp).max_attr_power = NaN;    % power of most powerful one
    planets(pp).max_attr_pos1 = NaN;     % position of most powerful one
    planets(pp).max_attr_dist1 = NaN;    % distance of most powerful one from centre of habitable range
    planets(pp).max_attr_pos2 = NaN;     % position of most powerful one
    planets(pp).max_attr_dist2 = NaN;    % distance of most powerful one from centre of habitable range
    %     - and other properties
    planets(pp).pcrunaway = NaN;    % percentage of temperature range susceptible to runaway feedbacks
    planets(pp).asymmetry = NaN;    % asymmetry of feedbacks
    %     - and statistics about results (performance of this planet)
    planets(pp).nsuccess = NaN;     % number of successful runs
    planets(pp).nfail = NaN;        % number of failed runs
    planets(pp).any_survived = NaN; % whether successful in any run (0 or 1)
    planets(pp).successrate = NaN;  % fraction of successful runs
    planets(pp).avduration = NaN;   % average time to failure    
    % <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
    planets(pp).k1 = NaN;   % coefficient
    planets(pp).k2 = NaN;   % coefficient
    planets(pp).k3 = NaN;   % coefficient
    planets(pp).k4 = NaN;   % coefficient
    planets(pp).k5 = NaN;   % coefficient
    planets(pp).k6 = NaN;   % coefficient
end;
    
% set up structures and arrays to store information about each run, to be
% used in later analysis
for rr = 1 : length(truns)
    runs(rr).runnumber = NaN;          % overall number of the run
    runs(rr).planetnumber = NaN;       % number of the planet
    runs(rr).rerunnumber = NaN;        % which rerun it is
    runs(rr).result = NaN;             % outcome of run (whether it stayed habitable for 3 By or not)
    runs(rr).length = NaN;             % how long it lasted for
    runs(rr).max_potential_perturbation = NaN; % magnitude of largest 'kick' if continued for 3 By
    runs(rr).max_actual_perturbation = NaN;   % magnitude of largest actual 'kick'
    % <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
    runs(rr).Tinit = NaN;              % starting temperature
    runs(rr).Tfinal = NaN;             % end temperature
    runs(rr).H1init = NaN;             % starting value of H1
    runs(rr).H1final = NaN;            % end value of H1
    runs(rr).H2init = NaN;             % starting value of H2
    runs(rr).H2final = NaN;            % end value of H2
    runs(rr).H3init = NaN;             % starting value of H3
    runs(rr).H3final = NaN;            % end value of H3
    runs(rr).standard_deviation = NaN; % standard deviation of T during run
    runs(rr).Ttrend = NaN;             % observed trend over time of T during run
    runs(rr).Tmode = NaN;              % mode (most frequent) T during run
    runs(rr).frtime_in_sas = NaN;      % fraction of time during run spent within stable attractor limits
    runs(rr).frtime_elsewhere = NaN;   % fraction of time during run spent outside stable attractor limits
    runs(rr).frtime_mostpowerful_sa = NaN;  % fraction of time during run spent within the limits of the most powerful stable attractor limits
    runs(rr).frtime_mostoccupied_sa = NaN;  % fraction of time during run spent within the most occupied stable attractor (i.e. the most time spent in any of the SAs)
    runs(rr).pos_mostocuupied_sa = NaN;     % position of the most occupied stable attractor
end;



