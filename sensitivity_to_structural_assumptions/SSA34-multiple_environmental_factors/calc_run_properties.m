
% This script calls various functions to calculate different properties
% of a run. These will later be compared to how often the planet survives
% so as to give a clue as to which factors are most important in
% determining survival likelihood
%--------------------------------------------------------------------------

% work out how long the run lasted for before exceeding temperature limits
% (or end of run reached at 3 By)
run_duration = t(end);

% run was successful if remained habitable throughout the whole duration
% (allow for rounding errors etc)
if ((run_duration >= max_duration) || ...
    (abs((max_duration-run_duration)/max_duration) < 0.001))
    run_result = 1;
    % give a different answer depending in whether failed because got too
    % hot (0) or too cold (-1)    
% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
elseif (y(end,1) >= Tmax)
    run_result = 0;
elseif (y(end,1) <= Tmin)
    run_result = -1;
elseif (y(end,2) >= H1max)
    run_result = 10;
elseif (y(end,2) <= H1min)
    run_result = 11;
elseif (y(end,3) >= H2max)
    run_result = 20;
elseif (y(end,3) <= H2min)
    run_result = 21;
elseif (y(end,4) >= H3max)
    run_result = 30;
elseif (y(end,4) <= H3min)
    run_result = 31;
else
    str = sprintf('[calc_run_properties] Unclear why run ended: \n    time = %.3f By, T = %.3f, H1 = %.3f, H2 = %.3f and H3 = %.3f\n    trends: %.3f,  %.3f,  %.3f,  %.3f', ...
        (t(end)/1e6), y(end,1), y(end,2), y(end,3), y(end,4), ...
        trendT, trendH1, trendH2, trendH3);
    error(str);
end
    
% calculate the magnitude of the largest perturbation during the duration
% of the run (however long it actually lasted)
mm = 1;    % counter for perturbations
biggest_actual_perturbation = 0.0;
biggest_perturbation_time = NaN;
% for each perturbation in the list that occurred before the end of the run
while ((mm <= pcounter) && (perturbations(mm,1) <= run_duration))
    if (abs(perturbations(mm,2)) > abs(biggest_actual_perturbation))
        biggest_actual_perturbation = perturbations(mm,2);
        biggest_perturbation_time = perturbations(mm,1);
    end
    mm = mm + 1;
end

% calculate the standard deviation of the history of temperature during the
% run
Tstddev = std(y(:,1));

% calculate the mode temperature, i.e. the most frequently occurring value.
% Since T is a floating point number, calculate the most frequently
% occurring integer temperature.
% NB1: using floor not round so if upper limit to habitability is 30C then
% highest possible mode value is 29C.
% NB2: if there are multiple most frequent values then 'mode' returns only
% the lowest one, so there is a second (small?) inbuilt bias towards the
% lower end of the range and answer is not always telling the whole story.
Tmost_frequent = mode(floor(y(:,1)));

% fit a straight line to the temperature time-series and calculate the
% slope (i.e. the long-term trend). In this case 'trend' refers to the
% observed trend in T rather than the imposed trend in dT/dt. To avoid
% problems with infinitely steep slopes, they are calculated as angles
% (i.e. between -pi/2 and +pi/2)
coeffs = polyfit(t, y(:,1), 1);
trendslope = coeffs(1) * 1e6;         % slope
Ttrend_observed = atan(trendslope/100) * 180.0 / pi;    % units of degrees

% calculate the fraction of time spent in each stable attractor, in
% the most powerful stable attractor, and the fraction of time spent
% elsewhere (not in any stable attractor)
num_tpoints = length(t);
tpoint_counters = zeros([1 nattractors]);   % initialise counters
elsewhere_counter = 0;
for ttt = 1:num_tpoints
    % calculate the length of time nearest this timepoint (equals half the
    % distance either way to adjacent timepoints)
    if (ttt == 1)
        timehere = 0.5*t(ttt+1);
    elseif (ttt == num_tpoints)
        timehere = 0.5*(run_duration-t(ttt-1));
    else
        timehere = 0.5*(t(ttt+1)-t(ttt-1));
    end
    within_sa = 0;
    for kk = 1:nattractors    % for each stable attractor
        if ((y(ttt,1) >= attractors(kk,9)) && ...
            (y(ttt,1) <= attractors(kk,10)))     % if within stable attractor limits
            tpoint_counters(kk) = tpoint_counters(kk) + timehere;
            within_sa = 1;
        end
    end
    if (within_sa == 0)
        elsewhere_counter = elsewhere_counter + timehere;
    end
end
% convert to fractions of total time (by dividing by the run duration)
for kk = 1:nattractors            
    tpoint_counters(kk) = tpoint_counters(kk) / run_duration;
end
elsewhere_counter = elsewhere_counter / run_duration;

% calculate the position of the stable attractor the system spent the most
% time in
nmostoccupied = 0;
greatest_time = 0;
for kk = 1:nattractors            
    if (tpoint_counters(kk) > greatest_time)
        nmostoccupied = kk;
        greatest_time = tpoint_counters(kk);
    end
end
if (~isnan(nmostoccupied) && (nmostoccupied > 0))
    pos_dominant_sa = attractors(nmostoccupied,1);
else
    pos_dominant_sa = NaN;
end

% populate the results structure for this run
runs(plc).runnumber = run_number;      % overall number of the run
runs(plc).planetnumber = tplanets(plc);% number of the planet
runs(plc).rerunnumber = truns(plc);    % which rerun it is
runs(plc).result = run_result;         % outcome of run (whether it stayed habitable for 3 By or not)
runs(plc).length = run_duration;       % how long it lasted for in units of By 
runs(plc).max_potential_perturbation = max_perturbation;   % magnitude of largest 'kick' if continued for 3 By
runs(plc).max_actual_perturbation = biggest_actual_perturbation;   % magnitude of largest actual 'kick'
runs(plc).Tinit = Tinit;               % starting temperature
% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
runs(plc).Tfinal  = y(end,1);           % temperature at end of run
runs(plc).H1init  = H1init;             % starting value of H1
runs(plc).H1final = y(end,2);           % value of H1 at end of run
runs(plc).H2init  = H2init;             % starting value of H2
runs(plc).H2final = y(end,3);           % value of H2 at end of run
runs(plc).H3init  = H3init;             % starting value of H3
runs(plc).H3final = y(end,4);           % value of H3 at end of run
runs(plc).standard_deviation = Tstddev;% standard deviation of T during run
runs(plc).Ttrend = Ttrend_observed;    % observed trend over time of T during run
runs(plc).Tmode = Tmost_frequent;      % mode (most frequent) T during run
% if there is at least one stable attractor
if (nattractors > 0)
    runs(plc).frtime_in_sas = 1.0 - elsewhere_counter;   % fraction of time during run spent within stable attractor limits
    runs(plc).frtime_elsewhere = elsewhere_counter;      % fraction of time during run spent outside stable attractor limits
    runs(plc).frtime_mostpowerful_sa = tpoint_counters(nmostpowerful);   % fraction of time during run spent within the limits of the most powerful stable attractor limits
    % if at least some time was spent in a stable attractor (might have
    % spent the whole time in a runaway feedback zone)
    if (nmostoccupied > 0)
        runs(plc).frtime_mostoccupied_sa = ...
            tpoint_counters(nmostoccupied);   % fraction of time during run spent within the most occupied stable attractor (i.e. the most time spent in any of the SAs)
    else
        runs(plc).frtime_mostoccupied_sa = 0.0;
    end;
    runs(plc).pos_mostocuupied_sa = pos_dominant_sa;      % position of the most occupied stable attractor
else
    runs(plc).frtime_in_sas = 0.0;
    runs(plc).frtime_elsewhere = 1.0;
    runs(plc).frtime_mostpowerful_sa = NaN;
    runs(plc).frtime_mostoccupied_sa = NaN;
    runs(plc).pos_mostocuupied_sa = NaN;
end

% print out run properties
%if (verbose)
    fprintf('\nRUN #%d of planet %d (%d overall) PROPERTIES AND RESULT:\n', ...
        truns(plc), tplanets(plc), run_number);
    fprintf ('  Remained habitable for %.3f By: T varied between %.1f and %.1f C\n', ...
        (t(end)/1e6), min(y(:,1)), max(y(:,1)));
    fprintf('  starting temperature = %.1f C\n', Tinit);

    fprintf('  largest actual perturbation was %.1f C (at %d My)\n', ...
        biggest_actual_perturbation, round(biggest_perturbation_time/1e3));
    fprintf('  largest potential perturbation was %.1f C\n', max_perturbation);
    fprintf('  standard deviation of actual T = %.1f C\n', Tstddev);
    fprintf('  slope of best-fit line to results = %.1f deg C per By\n', ...
        trendslope);
    fprintf('  mode temperature = %.1f C\n', Tmost_frequent);
    fprintf('  %d%% of the time was spent in SAs, %d%% outside SAs\n', ...
        round(100*(1.0-elsewhere_counter)), round(100*elsewhere_counter));
    % if there is at least one SAs and some time has been spent in SAs
    if ((nattractors > 0) && (elsewhere_counter < 0.99))
        fprintf('  %d%% of the time was spent in the most powerful SA\n', ...
            round(100*tpoint_counters(nmostpowerful)));
        fprintf('  most time (%d%%) was spent in the SA with ZC at %.1f C\n', ...
            round(100*tpoint_counters(nmostoccupied)), pos_dominant_sa);
    else
        fprintf('  no time was spent in stable attractors\n');
    end
%end
