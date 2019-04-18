% script to transfer runs and runs information from one task output file
% to the larger arrays for the whole simulation
% -------------------------------------------------------------------------

% for each planet in this task, transfer it across from the task array to
% the overall array

% for each planet in this task
for tpc = 1 : length(pl)  % this is the index of a planet in the task array
    % pp is the index of a planet in the overall array
    pp = tp(tpc).pnumber;
    planets(pp).pnumber = tp(tpc).pnumber;      % number of this planet
    planets(pp).nnodes  = tp(tpc).nnodes;       % number of nodes
    planets(pp).nattractors = tp(tpc).nattractors; % number of stable attractors
    for qq = 1:nnodes_max
        planets(pp).Tnodes(qq) = NaN;
        planets(pp).Tfeedbacks(qq) = NaN;
    end;
    for qq = 1:tp(tpc).nnodes
        planets(pp).Tnodes(qq) = tp(tpc).Tnodes(qq);  % T of each node
        planets(pp).Tfeedbacks(qq) = tp(tpc).Tfeedbacks(qq);% dT/dt of each node
    end; 
    planets(pp).trend = tp(tpc).trend;          % heating or cooling trend
    planets(pp).lambda_big = tp(tpc).lambda_big; % big P freq (av number)
    planets(pp).lambda_mid = tp(tpc).lambda_mid; % mid P freq (av number)
    planets(pp).lambda_little = tp(tpc).lambda_little; % little P freq (av number)
    % <<<<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
    planets(pp).initT = tp(tpc).initT;
    planets(pp).max_attr_width = tp(tpc).max_attr_width;
    planets(pp).max_attr_height = tp(tpc).max_attr_height;
    planets(pp).max_attr_strength = tp(tpc).max_attr_strength;
    planets(pp).max_attr_power = tp(tpc).max_attr_power;
    planets(pp).max_attr_pos1 = tp(tpc).max_attr_pos1;
    planets(pp).max_attr_dist1 = tp(tpc).max_attr_dist1;
    planets(pp).max_attr_pos2 = tp(tpc).max_attr_pos2;
    planets(pp).max_attr_dist2 = tp(tpc).max_attr_dist2;
    planets(pp).pcrunaway = tp(tpc).pcrunaway;
    planets(pp).asymmetry = tp(tpc).asymmetry;
end;

% for each run in this task, transfer it across from the task array to
% the overall array

% for each run in this task
for tpr = 1 : length(rl)  % this is the index of a run in the task array
    % rr is the index of a run in the overall array
    rr = tr(tpr).runnumber;
    runs(rr).planetnumber = tr(tpr).planetnumber;       % number of the planet
    runs(rr).rerunnumber = tr(tpr).rerunnumber;         % which rerun it is
    runs(rr).runnumber = tr(tpr).runnumber;             % number of the run
    runs(rr).result = tr(tpr).result;                   % outcome of run (whether it stayed habitable for 3 By or not)
    runs(rr).length =  tr(tpr).length;                  % how long it lasted for
    runs(rr).max_potential_perturbation = tr(tpr).max_potential_perturbation;  % magnitude of largest 'kick' if continued for 3 By
    runs(rr).max_actual_perturbation = tr(tpr).max_actual_perturbation; % magnitude of largest actual 'kick'
    runs(rr).Tinit = tr(tpr).Tinit;                     % starting temperature
    runs(rr).standard_deviation = tr(tpr).standard_deviation;  % standard deviation of T during run
    runs(rr).Ttrend =  tr(tpr).Ttrend;                  % observed trend over time of T during run
    runs(rr).Tmode = tr(tpr).Tmode;                     % mode (most frequent) T during run
    runs(rr).frtime_in_sas = tr(tpr).frtime_in_sas;     % fraction of time during run spent within stable attractor limits
    runs(rr).frtime_elsewhere = tr(tpr).frtime_elsewhere;              % fraction of time during run spent outside stable attractor limits
    runs(rr).frtime_mostpowerful_sa = tr(tpr).frtime_mostpowerful_sa;  % fraction of time during run spent within the limits of the most powerful stable attractor limits
    runs(rr).frtime_mostoccupied_sa = tr(tpr).frtime_mostoccupied_sa;  % fraction of time during run spent within the most occupied stable attractor (i.e. the most time spent in any of the SAs)
    runs(rr).pos_mostocuupied_sa = tr(tpr).pos_mostocuupied_sa;        % position of the most occupied stable attractor
    % <<<<<<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>>>
    runs(rr).trend = tp(tpr).trend;
    runs(rr).lambda_big = tp(tpr).lambda_big;
    runs(rr).lambda_mid = tp(tpr).lambda_mid;
    runs(rr).lambda_small = tp(tpr).lambda_little;
end
