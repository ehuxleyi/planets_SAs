% script to transfer runs and runs information from one task output file
% to the larger arrays for the whole simulation
% -------------------------------------------------------------------------

% for each planet/run in this task, transfer it across from the task array
% to the overall array

% for each planet/run in this task
for tprc = 1 : length(pl)  % the index of a planet/run in the task array
    
    %% copy planet information across first
    
    % pp is the index of a planet in the overall array
    pp = pl(tprc);
    
    planets(pp).pnumber = pp;                       % number of this planet
    % <<<<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
    planets(pp).nTnodes  = tp(tprc).nTnodes;          % number of nodes
    planets(pp).nH1nodes  = tp(tprc).nH2nodes;          % number of nodes
    planets(pp).nH2nodes  = tp(tprc).nH2nodes;          % number of nodes
    planets(pp).nH3nodes  = tp(tprc).nH3nodes;          % number of nodes
    planets(pp).nattractors = tp(tprc).nattractors; % number of stable attractors
    % <<<<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
    for qq = 1:nnodes_max
        planets(pp).Tnodes(qq) = NaN;
        planets(pp).Tfeedbacks(qq) = NaN;
    end
    for qq = 1:nnodes_max
        planets(pp).H1nodes(qq) = NaN;
        planets(pp).H1feedbacks(qq) = NaN;
    end
    for qq = 1:nnodes_max
        planets(pp).H2nodes(qq) = NaN;
        planets(pp).H2feedbacks(qq) = NaN;
    end
    for qq = 1:nnodes_max
        planets(pp).H3nodes(qq) = NaN;
        planets(pp).H3feedbacks(qq) = NaN;
    end
   % <<<<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
    for qq = 1:tp(tprc).nTnodes
        planets(pp).Tnodes(qq) = tp(tprc).Tnodes(qq);  % T of each node
        planets(pp).Tfeedbacks(qq) = tp(tprc).Tfeedbacks(qq);% dT/dt of each node
    end
    for qq = 1:tp(tprc).nH1nodes
        planets(pp).H1nodes(qq) = tp(tprc).H1nodes(qq);  % H1 of each node
        planets(pp).H1feedbacks(qq) = tp(tprc).H1feedbacks(qq);% dH1/dt of each node
    end
    for qq = 1:tp(tprc).nH2nodes
        planets(pp).H2nodes(qq) = tp(tprc).H2nodes(qq);  % H2 of each node
        planets(pp).H2feedbacks(qq) = tp(tprc).H2feedbacks(qq);% dH2/dt of each node
    end
    for qq = 1:tp(tprc).nH3nodes
        planets(pp).H3nodes(qq) = tp(tprc).H3nodes(qq);  % H3 of each node
        planets(pp).H3feedbacks(qq) = tp(tprc).H3feedbacks(qq);% dH3/dt of each node
    end
    % <<<<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
    planets(pp).trendT = tp(tprc).trendT;          % heating or cooling trend
    planets(pp).trendH1 = tp(tprc).trendH1;          % heating or cooling trend
    planets(pp).trendH2 = tp(tprc).trendH2;          % heating or cooling trend
    planets(pp).trendH3 = tp(tprc).trendH3;          % heating or cooling trend
    planets(pp).lambda_big = tp(tprc).lambda_big; % big P freq (av number)
    planets(pp).lambda_mid = tp(tprc).lambda_mid; % mid P freq (av number)
    planets(pp).lambda_little = tp(tprc).lambda_little; % little P freq (av number)
    planets(pp).max_attr_width = tp(tprc).max_attr_width;
    planets(pp).max_attr_height = tp(tprc).max_attr_height;
    planets(pp).max_attr_strength = tp(tprc).max_attr_strength;
    planets(pp).max_attr_power = tp(tprc).max_attr_power;
    planets(pp).max_attr_pos1 = tp(tprc).max_attr_pos1;
    planets(pp).max_attr_dist1 = tp(tprc).max_attr_dist1;
    planets(pp).max_attr_pos2 = tp(tprc).max_attr_pos2;
    planets(pp).max_attr_dist2 = tp(tprc).max_attr_dist2;
    planets(pp).pcrunaway = tp(tprc).pcrunaway;
    planets(pp).asymmetry = tp(tprc).asymmetry;
    % <<<<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
    planets(pp).k1 = tp(tprc).k1;              % coefficient
    planets(pp).k2 = tp(tprc).k2;              % coefficient
    planets(pp).k3 = tp(tprc).k3;              % coefficient
    planets(pp).k4 = tp(tprc).k4;              % coefficient
    planets(pp).k5 = tp(tprc).k5;              % coefficient
    planets(pp).k6 = tp(tprc).k6;              % coefficient

    
    %% copy run information across second
    
    % rr is the index of a run in the overall array
    rr = ((pp-1)*nreruns) + rl(tprc);
    
    runs(rr).planetnumber = tr(tprc).planetnumber;       % number of the planet
    runs(rr).rerunnumber = tr(tprc).rerunnumber;         % which rerun it is
    runs(rr).runnumber = tr(tprc).runnumber;             % number of the run
    runs(rr).result = tr(tprc).result;                   % outcome of run (whether it stayed habitable for 3 By or not)
    runs(rr).length =  tr(tprc).length;                  % how long it lasted for
    runs(rr).max_potential_perturbation = tr(tprc).max_potential_perturbation;  % magnitude of largest 'kick' if continued for 3 By
    runs(rr).max_actual_perturbation = tr(tprc).max_actual_perturbation; % magnitude of largest actual 'kick'
    runs(rr).Tinit = tr(tprc).Tinit;                     % starting temperature
    % <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
    runs(rr).Tfinal  = tr(tprc).Tfinal;                  % temperature at end of run
    runs(rr).H1init  = tr(tprc).H1init;                  % starting H1 value
    runs(rr).H1final = tr(tprc).H1final;                 % end H1 value
    runs(rr).H2init  = tr(tprc).H2init;                  % starting H2 value
    runs(rr).H2final = tr(tprc).H2final;                 % end H2 value
    runs(rr).H3init  = tr(tprc).H3init;                  % starting H3 value
    runs(rr).H3final = tr(tprc).H3final;                 % end H3 value
    runs(rr).standard_deviation = tr(tprc).standard_deviation;  % standard deviation of T during run
    runs(rr).Ttrend =  tr(tprc).Ttrend;                  % observed trend over time of T during run
    runs(rr).Tmode = tr(tprc).Tmode;                     % mode (most frequent) T during run
    runs(rr).frtime_in_sas = tr(tprc).frtime_in_sas;     % fraction of time during run spent within stable attractor limits
    runs(rr).frtime_elsewhere = tr(tprc).frtime_elsewhere;              % fraction of time during run spent outside stable attractor limits
    runs(rr).frtime_mostpowerful_sa = tr(tprc).frtime_mostpowerful_sa;  % fraction of time during run spent within the limits of the most powerful stable attractor limits
    runs(rr).frtime_mostoccupied_sa = tr(tprc).frtime_mostoccupied_sa;  % fraction of time during run spent within the most occupied stable attractor (i.e. the most time spent in any of the SAs)
    runs(rr).pos_mostocuupied_sa = tr(tprc).pos_mostocuupied_sa;        % position of the most occupied stable attractor
end;