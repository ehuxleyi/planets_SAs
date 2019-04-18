
% This script calls various functions to calculate various derived
% properties of a planet. These will later be compared to how often the
% planet survives so as to give a clue as to which factors are most
% important in determining survival likelihood.
%--------------------------------------------------------------------------

% calculate the properties of any stable attractors for this planet.
% do this only for the initial state, before affected by the trend
feedbacks = Tfeedbacks;
calc_attractor_properties;
% copy dummy values for plotting to real values for analysis
nattractors = nattr;   attractors = attr;

% calculate the asymmetry of the feedbacks (left +ve & right -ve will tend
% to favour stability whereas left -ve & right +ve is inimical to it)
% again, do this only for the initial state, before affected by the trend
calc_asymmetry;

% likewise for runaway feedback zones
calc_runaways;
% copy dummy values for plotting to real values for analysis
icehT = runaway_freeze;
greenhT = runaway_boil;

% now loop over all of the stable attractors for this planet to calculate
% properties for the set of feedbacks as a whole, such as the power and
% position of the most powerful stable attractor
if (nattractors ~= 0)   % at least one stable attractor exists
    maxstrength = 0;
    maxpower = 0;
    nmostpowerful = NaN;
    for mm = 1:nattractors
        if (attractors(mm,12) > maxstrength)
            maxstrength = attractors(mm,12);
        end;
        if (attractors(mm,13) > maxpower)
            maxpower = attractors(mm,13);
            nmostpowerful = mm;
        end;
    end;
    pos1mostpowerful = attractors(nmostpowerful,1);
    dist1mostpowerful = attractors(nmostpowerful,14);
    % an alternative definition of the 'position' of a stable attractor is
    % its midpoint (half-way between its LH and RH edges) rather than its
    % zero crossing point
    pos2mostpowerful = 0.5 * ...
        (attractors(nmostpowerful,9)+attractors(nmostpowerful,10));
    dist2mostpowerful = abs(pos2mostpowerful-(0.5*(Tmax+Tmin)));
else    % no stable attractors for this planet so set all to NaNs
    maxstrength = NaN;
    maxpower = NaN;
    pos1mostpowerful = NaN;
    dist1mostpowerful = NaN;
    pos2mostpowerful = NaN;
    dist2mostpowerful = NaN;
end;

% <<<<<<<<<<<<<<<< SPECIAL FOR TESTING PURPOSES >>>>>>>>>>>>>>>
% now loop over all of the cycles for this planet
max_cyc_ampl = 0.0;
if (ncycles ~= 0)   % at least one cycle exists
    for iii = 1:ncycles
        if (camplitudes(iii) > max_cyc_ampl)
            max_cyc_ampl = camplitudes(iii);
        end
    end
else
    max_cyc_ampl = NaN;
    error('should be a minimum of 2 cycles but there are none');
end

% now calculate the absolute magnitude of the temporal trend
trend_size = abs(trend);

% calculate the percentage of the habitable temperature range that
% is susceptible to a runaway icehouse or a runaway greenhouse positive
% feedback (needed for statistics)
pc_runaway = 100.0 * ((icehT-Tmin) + (Tmax-greenhT)) / (Tmax-Tmin);

% save planet information for later analysis
planets(plc).nattractors = nattractors;   % number of stable attractors
planets(plc).lambda_big = lambda_big;   % perturbation expected Ns
planets(plc).lambda_mid = lambda_mid;
planets(plc).lambda_little = lambda_little;
planets(plc).ncycles = ncycles;
planets(plc).max_cycle_amplitude = max_cyc_ampl;
planets(plc).max_attr_strength = maxstrength;
planets(plc).max_attr_power = maxpower;
planets(plc).max_attr_pos1 = pos1mostpowerful;
planets(plc).max_attr_dist1 = dist1mostpowerful;
planets(plc).max_attr_pos2 = pos2mostpowerful;
planets(plc).max_attr_dist2 = dist2mostpowerful;
planets(plc).pcrunaway = pc_runaway;
planets(plc).asymmetry = asymm;
% <<<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
planets(plc).ncycles  = ncycles;       % number of cycles
for qq = 1:8
    planets(plc).cycle_periods(qq) = NaN;        % period of cycle
    planets(plc).cycle_amplitudes(qq) = NaN;     % amplitude of cycle
end;
maxa = 0.0;
for qq = 1:ncycles
    planets(plc).cycle_periods(qq) = cperiods(qq);        % period of cycle
    planets(plc).cycle_amplitudes(qq) = camplitudes(qq);     % amplitude of cycle
    if (abs(camplitudes(qq)) > maxa)
        maxa = camplitudes(qq);
    end
end;
planets(plc).max_cycle_amplitude = maxa;

% print out planet properties
if (verbose)
    fprintf('CHARACTERISTICS OF THIS PLANET:\n');
    fprintf('  number of nodes = %d\n', nnodes);
    fprintf('  number of attractors = %d\n', nattractors);
    fprintf('  number of cycles = %d C\n', ncycles);
    fprintf('  max cycle amplitude = %.1f C ky-1\n', max_cyc_ampl);
    fprintf('  max attractor strength = %d C ky-1\n', round(maxstrength));
    fprintf('  max attractor power = %d C (C ky-1)\n', round(maxpower));
    fprintf('  position of zc of most powerful attractor = %.1f C\n', pos1mostpowerful);
    fprintf('  distance from midpoint of zc of most powerful attractor = %.1f C\n', dist1mostpowerful);
    fprintf('  position of middle of most powerful attractor = %.1f C\n', pos2mostpowerful);
    fprintf('  distance from midpoint of middle of most powerful attractor = %.1f C\n', dist2mostpowerful);
    fprintf('  %d%% of habitable range occ. by runaway feedbacks\n', round(pc_runaway));
    if (icehT > Tmin)
        fprintf('  runaway cooling predicted below %.0f C\n', round(icehT));
    end;
    if (greenhT < Tmax)
        fprintf('  runaway warming predicted above %.0f C\n', round(greenhT));
    end;
    fprintf('  asymmetry of feedbacks = %d (max possible = %d)\n', ...
        round(asymm), (Trange*frange/2.0));
    fprintf('  trend = %d (C ky-1) By-1\n', round(trend));
    fprintf('  expected number of large perturbations = %d \n', lambda_big);
    fprintf('  expected number of medium perturbations = %d \n', lambda_mid);
    fprintf('  expected number of little perturbations = %d \n', lambda_little);
    fprintf('  number of cycles = %d, of max amplitude %.2f\n', ncycles, max_cyc_ampl);
end;
