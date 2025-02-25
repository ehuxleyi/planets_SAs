
% this script is to calculate frequency distributions for different run
% properties, ready to be plotted
% it also creates lists of run properties, both for each and every
% run, and also for 'good' (survived) runs only
%--------------------------------------------------------------------------

nruns = nplanets*nreruns;

% initialise the arrays
fr_maxpotps = zeros([nbinsd 2]);  % 1st row: all runs, 2nd: successful ones
fr_maxactps = zeros([nbinsd 2]);
fr_initTs = zeros([nbinsd 2]);
fr_stdTs = zeros([nbinsd 2]);
fr_trendTs = zeros([nbinsd 2]);
fr_modeTs = zeros([nbinsd 2]);
fr_timeouts = zeros([nbinsd 2]);
fr_timesas = zeros([nbinsd 2]);
fr_timepowsas = zeros([nbinsd 2]);
fr_timeoccsas = zeros([nbinsd 2]);
% last one is only calculated for all runs (successful ones have 3By
% duration)
fr_durations = zeros([nbinsd 1]);
allruns_maxpotps = zeros([nruns 1]);
allruns_maxactps = zeros([nruns 1]);
allruns_initTs = zeros([nruns 1]);
allruns_stdTs = zeros([nruns 1]);
allruns_trendTs = zeros([nruns 1]);
allruns_modeTs = zeros([nruns 1]);
allruns_timeouts = zeros([nruns 1]);
allruns_timesas = zeros([nruns 1]);
allruns_timepowsas = zeros([nruns 1]);
allruns_timeoccsas = zeros([nruns 1]);
allruns_durations = zeros([nruns 1]);
goodruns_maxpotps = zeros([ngoodruns 1]);
goodruns_maxactps = zeros([ngoodruns 1]);
goodruns_initTs = zeros([ngoodruns 1]);
goodruns_stdTs = zeros([ngoodruns 1]);
goodruns_trendTs = zeros([ngoodruns 1]);
goodruns_modeTs = zeros([ngoodruns 1]);
goodruns_timeouts = zeros([ngoodruns 1]);
goodruns_timesas = zeros([ngoodruns 1]);
goodruns_timepowsas = zeros([ngoodruns 1]);
goodruns_timeoccsas = zeros([ngoodruns 1]);
ratio_maxpotps = zeros([nbinsd 1]);
ratio_maxactps = zeros([nbinsd 1]);
ratio_initTs = zeros([nbinsd 1]);
ratio_stdTs = zeros([nbinsd 1]);
ratio_trendTs = zeros([nbinsd 1]);
ratio_modeTs = zeros([nbinsd 1]);
ratio_timeouts = zeros([nbinsd 1]);
ratio_timesas = zeros([nbinsd 1]);
ratio_timepowsas = zeros([nbinsd 1]);
ratio_timeoccsas = zeros([nbinsd 1]);
% these next are just for scatterplots
allruns_nodes = zeros([nruns 1]);
allruns_attrs = zeros([nruns 1]);
allruns_trends = zeros([nruns 1]);
allruns_llambdas = zeros([nruns 1]);
allruns_mlambdas = zeros([nruns 1]);
allruns_blambdas = zeros([nruns 1]);
allruns_widths = zeros([nruns 1]);
allruns_heights = zeros([nruns 1]);
allruns_strengths = zeros([nruns 1]);
allruns_powers = zeros([nruns 1]);
allruns_pos1s = zeros([nruns 1]);
allruns_dist1s = zeros([nruns 1]);
allruns_pos2s = zeros([nruns 1]);
allruns_dist2s = zeros([nruns 1]);
allruns_runaways = zeros([nruns 1]);
allruns_asymms = zeros([nruns 1]);

ngr2 = 0;    % number of good runs (2nd count)

% count up numbers in each bin
for rr=1:nruns
    
    % compile a simple list of the values of each property for all runs
    allruns_maxpotps(rr) = runs(rr).max_potential_perturbation;
    allruns_maxactps(rr) = runs(rr).max_actual_perturbation;
    allruns_initTs(rr) = runs(rr).Tinit;
    allruns_stdTs(rr) = runs(rr).standard_deviation;
    allruns_trendTs(rr) = runs(rr).Ttrend;
    allruns_modeTs(rr) = runs(rr).Tmode;
    allruns_timeouts(rr) = runs(rr).frtime_elsewhere;
    allruns_timesas(rr) = runs(rr).frtime_in_sas;
    allruns_timepowsas(rr) = runs(rr).frtime_mostpowerful_sa;
    allruns_timeoccsas(rr) = runs(rr).frtime_mostoccupied_sa;
    allruns_durations(rr) = runs(rr).length/1e6;   % ky to By
    % these next are just for scatterplots
    pp = round(runs(rr).planetnumber);
    allruns_nodes(rr) = planets(pp).nnodes;
    allruns_attrs(rr) = planets(pp).nattractors;
    allruns_trends(rr) = planets(pp).trend;
    allruns_llambdas(rr) = planets(pp).lambda_little;
    allruns_mlambdas(rr) = planets(pp).lambda_mid;
    allruns_blambdas(rr) = planets(pp).lambda_big;
    allruns_widths(rr) = planets(pp).max_attr_width;
    allruns_heights(rr) = planets(pp).max_attr_height;
    allruns_strengths(rr) = planets(pp).max_attr_strength;
    allruns_powers(rr) = planets(pp).max_attr_power;
    allruns_pos1s(rr) = planets(pp).max_attr_pos1;
    allruns_dist1s(rr) = planets(pp).max_attr_dist1;
    allruns_pos2s(rr) = planets(pp).max_attr_pos2;
    allruns_dist2s(rr) = planets(pp).max_attr_dist2;
    allruns_runaways(rr) = (planets(pp).pcrunaway/100.0); % to fraction
    allruns_asymms(rr) = planets(pp).asymmetry;

    % calculate which bin this run falls in, for each property
    % the next two lines assume that the maximum perturbations vary in
    % absolute size between -exp_pmax and +exp_pmax
    maxpotpbin = 1+floor(nbinsd*abs(runs(rr).max_potential_perturbation+exp_pmax)/(2.0*exp_pmax));
    maxactpbin = 1+floor(nbinsd*abs(runs(rr).max_actual_perturbation+exp_pmax)/(2.0*exp_pmax));
    initTbin = 1+floor(nbinsd*(runs(rr).Tinit-Tmin)/Trange);
    % the next line assumes that the standard deviation of temperature
    % through time can vary between 0 and one quarter of the T range
    stdTbin = 1+floor(nbinsd*runs(rr).standard_deviation/25.0);
    % the next line is based on the observed trend of temperature against
    % time being calculated as an angle in degrees (-90 to +90)
    trendTbin = 1+floor(nbinsd*(runs(rr).Ttrend+90.0)/180.0);
    modeTbin = 1+floor(nbinsd*(runs(rr).Tmode-(Tmin-10.0))/(Trange+20.0));
    timeoutbin = 1+floor(nbinsd*runs(rr).frtime_elsewhere);
    % special case: if spent 100% of time out of SAs then put in last bin
    if (runs(rr).frtime_elsewhere == 1.0)
        timeoutbin = nbinsd;
    end;
    timesabin = 1+floor(nbinsd*runs(rr).frtime_in_sas);
    % special case: if spent 100% of time in SAs then put in last bin
    if (runs(rr).frtime_in_sas == 1.0)
        timesabin = nbinsd;
    end;
    timepowsabin = 1+floor(nbinsd*runs(rr).frtime_mostpowerful_sa);
    % special case: if spent 100% of time in most powerful SA then put in last bin
    if (runs(rr).frtime_mostpowerful_sa == 1.0)
        timepowsabin = nbinsd;
    end;
    timeoccsabin = 1+floor(nbinsd*runs(rr).frtime_mostoccupied_sa);
    % special case: if spent 100% of time in most occupied SA then put in last bin
    if (runs(rr).frtime_mostoccupied_sa == 1.0)
        timeoccsabin = nbinsd;
    end;
    durationbin = 1+floor(nbinsd*runs(rr).length/3e6);
    % <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>> replace max_duration with 3
    % special case: if duration was exactly 3By then put in last bin
    if (runs(rr).length >= 3e6)
        durationbin = nbinsd;
    end;
    
    % check the values produced are as expected
    if ((maxpotpbin < 1) || (maxpotpbin > nbinsd))
%         fprintf('***WARNING*** bad value (%f) of maxpotpbin at run %d in calc_run_freq\n', maxpotpbin, rr);
        maxpotpbin = NaN; % if unable to calculate a valid index then don't
    end;
    if ((maxactpbin < 1) || (maxactpbin > nbinsd))
%         fprintf('***WARNING*** bad value (%f) of maxactpbin at run %d in calc_run_freq\n', maxactpbin, rr);
        maxactpbin = NaN;
    end;
    if ((initTbin < 1) || (initTbin > nbinsd))
%         fprintf('***WARNING*** bad value (%f) of initTbin at run %d in calc_run_freq\n', initTbin, rr);
        initTbin = NaN;
    end;
    if ((stdTbin < 1) || (stdTbin > nbinsd))
%         fprintf('***WARNING*** bad value (%f) of stdTbin at run %d in calc_run_freq\n', stdTbin, rr);
        stdTbin = NaN;
    end;
    if ((trendTbin < 1) || (trendTbin > nbinsd))
%         fprintf('***WARNING*** bad value (%f) of trendTbin at run %d in calc_run_freq\n', trendTbin, rr);
        trendTbin = NaN;
    end;
    if ((modeTbin < 1) || (modeTbin > nbinsd))
%         fprintf('***WARNING*** bad value (%f) of modeTbin at run %d in calc_run_freq\n', modeTbin, rr);
        modeTbin = NaN;
    end;
    if ((timeoutbin < 1) || (timeoutbin > nbinsd))
%         fprintf('***WARNING*** bad value (%f) of timeoutbin at run %d in calc_run_freq\n', timeoutbin, rr);
        timeoutbin = NaN;
    end;
    if ((timesabin < 1) || (timesabin > nbinsd))
%         fprintf('***WARNING*** bad value (%f) of timesabin at run %d in calc_run_freq\n', timesabin, rr);
        timesabin = NaN;
    end;
    if ((timepowsabin < 1) || (timepowsabin > nbinsd))
%         fprintf('***WARNING*** bad value (%f) of timepowsabin at run %d in calc_run_freq\n', timepowsabin, rr);
        timepowsabin = NaN;
    end;
    if ((timeoccsabin < 1) || (timeoccsabin > nbinsd))
%         fprintf('***WARNING*** bad value (%f) of timeoccsabin at run %d in calc_run_freq\n', timeoccsabin, rr);
        timeoccsabin = NaN;
    end;
    if ((durationbin < 1) || (durationbin > nbinsd))
%         fprintf('***WARNING*** bad value (%f) of durationbin at run %d in calc_run_freq\n', durationbin, rr);
        durationbin = NaN;
    end;
        
    % increment the counters for that bin
    if isfinite(maxpotpbin)
        fr_maxpotps(maxpotpbin,1) = fr_maxpotps(maxpotpbin,1) + 1;
    end;
    if isfinite(maxactpbin)
        fr_maxactps(maxactpbin,1) = fr_maxactps(maxactpbin,1) + 1;
    end;
    if isfinite(initTbin)
        fr_initTs(initTbin,1) = fr_initTs(initTbin,1) + 1;
    end;
    if isfinite(stdTbin)
        fr_stdTs(stdTbin,1) = fr_stdTs(stdTbin,1) + 1;
    end;
    if isfinite(trendTbin)
        fr_trendTs(trendTbin,1) = fr_trendTs(trendTbin,1) + 1;
    end;
    if isfinite(modeTbin)
        fr_modeTs(modeTbin,1) = fr_modeTs(modeTbin,1) + 1;
    end;
    if isfinite(timeoutbin)
        fr_timeouts(timeoutbin,1) = fr_timeouts(timeoutbin,1) + 1;
    end;
    if isfinite(timesabin)
        fr_timesas(timesabin,1) = fr_timesas(timesabin,1) + 1;
    end;
    if isfinite(timepowsabin)
        fr_timepowsas(timepowsabin,1) = fr_timepowsas(timepowsabin,1) + 1;
    end;
    if isfinite(timeoccsabin)
        fr_timeoccsas(timeoccsabin,1) = fr_timeoccsas(timeoccsabin,1) + 1;
    end;
    if isfinite(durationbin)
        fr_durations(durationbin,1) = fr_durations(durationbin,1) + 1;
    end;
    
    % if this run remained habitable (was a "good" run)
    if (runs(rr).result == 1)
         
        % increment counter for number of survivor planets
        ngr2 = ngr2 + 1;
               
        % compile a simple list of the values of each property for all runs
        goodruns_maxpotps(ngr2) = runs(rr).max_potential_perturbation;
        goodruns_maxactps(ngr2) = runs(rr).max_actual_perturbation;
        goodruns_initTs(ngr2) = runs(rr).Tinit;
        goodruns_stdTs(ngr2) = runs(rr).standard_deviation;
        goodruns_trendTs(ngr2) = runs(rr).Ttrend;
        goodruns_modeTs(ngr2) = runs(rr).Tmode;
        goodruns_timeouts(ngr2) = runs(rr).frtime_elsewhere;
        goodruns_timesas(ngr2) = runs(rr).frtime_in_sas;
        goodruns_timepowsas(ngr2) = runs(rr).frtime_mostpowerful_sa;
        goodruns_timeoccsas(ngr2) = runs(rr).frtime_mostoccupied_sa;
        
        % increment the counters for that bin for survivor runs
        if isfinite(maxpotpbin)
            fr_maxpotps(maxpotpbin,2) = fr_maxpotps(maxpotpbin,2) + 1;
        end;
        if isfinite(maxactpbin)
            fr_maxactps(maxactpbin,2) = fr_maxactps(maxactpbin,2) + 1;
        end;
        if isfinite(initTbin)
            fr_initTs(initTbin,2) = fr_initTs(initTbin,2) + 1;
        end;
        if isfinite(stdTbin)
            fr_stdTs(stdTbin,2) = fr_stdTs(stdTbin,2) + 1;
        end;
        if isfinite(trendTbin)
            fr_trendTs(trendTbin,2) = fr_trendTs(trendTbin,2) + 1;
        end;
        if isfinite(modeTbin)
            fr_modeTs(modeTbin,2) = fr_modeTs(modeTbin,2) + 1;
        end;
        if isfinite(timeoutbin)
            fr_timeouts(timeoutbin,2) = fr_timeouts(timeoutbin,2) + 1;
        end;
        if isfinite(timesabin)
            fr_timesas(timesabin,2) = fr_timesas(timesabin,2) + 1;
        end;
        if isfinite(timepowsabin)
            fr_timepowsas(timepowsabin,2) = fr_timepowsas(timepowsabin,2) + 1;
        end;
        if isfinite(timeoccsabin)       
            fr_timeoccsas(timeoccsabin,2) = fr_timeoccsas(timeoccsabin,2) + 1;
        end;
    end;
end;

% normalise to totals
for ll = 1:nbinsd  % number of bins
    if (fr_maxpotps(ll,1) ~= 0)
        fr_maxpotps(ll,1) = fr_maxpotps(ll,1) / nruns;
    else
        fr_maxpotps(ll,1) = NaN;
    end;
    if (fr_maxpotps(ll,2) ~= 0)
        fr_maxpotps(ll,2) = fr_maxpotps(ll,2) / ngoodruns;
    else
        fr_maxpotps(ll,2) = NaN;
    end;
    if (fr_maxactps(ll,1) ~= 0)
        fr_maxactps(ll,1) = fr_maxactps(ll,1) / nruns;
    else
        fr_maxactps(ll,1) = NaN;
    end;
    if (fr_maxactps(ll,2) ~= 0)
        fr_maxactps(ll,2) = fr_maxactps(ll,2) / ngoodruns;
    else
        fr_maxactps(ll,2) = NaN;
    end;
    if (fr_initTs(ll,1) ~= 0)
        fr_initTs(ll,1) = fr_initTs(ll,1) / nruns;
    else
        fr_initTs(ll,1) = NaN;
    end;
    if (fr_initTs(ll,2) ~= 0)
        fr_initTs(ll,2) = fr_initTs(ll,2) / ngoodruns;
    else
        fr_initTs(ll,2) = NaN;
    end;
    if (fr_stdTs(ll,1) ~= 0)
        fr_stdTs(ll,1) = fr_stdTs(ll,1) / nruns;
    else
        fr_stdTs(ll,1) = NaN;
    end;
    if (fr_stdTs(ll,2) ~= 0)
        fr_stdTs(ll,2) = fr_stdTs(ll,2) / ngoodruns;
    else
        fr_stdTs(ll,2) = NaN;
    end;
    if (fr_trendTs(ll,1) ~= 0)
        fr_trendTs(ll,1) = fr_trendTs(ll,1) / nruns;
    else
        fr_trendTs(ll,1) = NaN;
    end;
    if (fr_trendTs(ll,2) ~= 0)
        fr_trendTs(ll,2) = fr_trendTs(ll,2) / ngoodruns;
    else
        fr_trendTs(ll,2) = NaN;
    end;
    if (fr_modeTs(ll,1) ~= 0)
        fr_modeTs(ll,1) = fr_modeTs(ll,1) / nruns;
    else
        fr_modeTs(ll,1) = NaN;
    end;
    if (fr_modeTs(ll,2) ~= 0)
        fr_modeTs(ll,2) = fr_modeTs(ll,2) / ngoodruns;
    else
        fr_modeTs(ll,2) = NaN;
    end;
    if (fr_timeouts(ll,1) ~= 0)
        fr_timeouts(ll,1) = fr_timeouts(ll,1) / nruns;
    else
        fr_timeouts(ll,1) = NaN;
    end;
    if (fr_timeouts(ll,2) ~= 0)
        fr_timeouts(ll,2) = fr_timeouts(ll,2) / ngoodruns;
    else
        fr_timeouts(ll,2) = NaN;
    end;
    if (fr_timesas(ll,1) ~= 0)
        fr_timesas(ll,1) = fr_timesas(ll,1) / nruns;
    else
        fr_timesas(ll,1) = NaN;
    end;
    if (fr_timesas(ll,2) ~= 0)
        fr_timesas(ll,2) = fr_timesas(ll,2) / ngoodruns;
    else
        fr_timesas(ll,2) = NaN;
    end;
    if (fr_timepowsas(ll,1) ~= 0)
        fr_timepowsas(ll,1) = fr_timepowsas(ll,1) / nruns;
    else
        fr_timepowsas(ll,1) = NaN;
    end;
    if (fr_timepowsas(ll,2) ~= 0)
        fr_timepowsas(ll,2) = fr_timepowsas(ll,2) / ngoodruns;
    else
        fr_timepowsas(ll,2) = NaN;
    end;
    if (fr_timeoccsas(ll,1) ~= 0)
        fr_timeoccsas(ll,1) = fr_timeoccsas(ll,1) / nruns;
    else
        fr_timeoccsas(ll,1) = NaN;
    end;
    if (fr_timeoccsas(ll,2) ~= 0)
        fr_timeoccsas(ll,2) = fr_timeoccsas(ll,2) / ngoodruns;
    else
        fr_timeoccsas(ll,2) = NaN;
    end;
    if (fr_durations(ll,1) ~= 0)
        fr_durations(ll,1) = fr_durations(ll,1) / nruns;
    else
        fr_durations(ll,1) = NaN;
    end;
end;

if (ngr2 ~= ngoodruns)
    fprintf('***WARNING: ngr2 (%d) and ngoodruns (%d) should be equal but are not\n\n', ngr2, ngoodruns);
end;

% now calculate ratios of frequencies of successful runs to frequencies
% of all runs (as an indication of whether there is any link to
% probability of habitability; this would be indicated by the former
% exceeding the latter)
for mm = 1:nbinsd  % maximum potential perturbation
    % when there are no planets of any sort in this bin
    if ((fr_maxpotps(mm,1) == 0) || isnan(fr_maxpotps(mm,1)))
        ratio_maxpotps(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_maxpotps(mm,2) == 0) || isnan(fr_maxpotps(mm,2)))
            ratio_maxpotps(mm) = 0.0;
        % when there are some of both
        else
            ratio_maxpotps(mm) = fr_maxpotps(mm,2) / fr_maxpotps(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd  % maximum perturbation actually encountered
    % when there are no planets of any sort in this bin
    if ((fr_maxactps(mm,1) == 0) || isnan(fr_maxactps(mm,1)))
        ratio_maxactps(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_maxactps(mm,2) == 0) || isnan(fr_maxactps(mm,2)))
            ratio_maxactps(mm) = 0.0;
        % when there are some of both
        else
            ratio_maxactps(mm) = fr_maxactps(mm,2) / fr_maxactps(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd  % initial (starting) temperature
    % when there are no planets of any sort in this bin
    if ((fr_initTs(mm,1) == 0) || isnan(fr_initTs(mm,1)))
        ratio_initTs(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_initTs(mm,2) == 0) || isnan(fr_initTs(mm,2)))
            ratio_initTs(mm) = 0.0;
        % when there are some of both
        else
            ratio_initTs(mm) = fr_initTs(mm,2) / fr_initTs(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd  % standard deviation of temperature during the run
    % when there are no planets of any sort in this bin
    if ((fr_stdTs(mm,1) == 0) || isnan(fr_stdTs(mm,1)))
        ratio_stdTs(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_stdTs(mm,2) == 0) || isnan(fr_stdTs(mm,2)))
            ratio_stdTs(mm) = 0.0;
        % when there are some of both
        else
            ratio_stdTs(mm) = fr_stdTs(mm,2) / fr_stdTs(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd  % average trend over time (from line-fitting)
    % when there are no planets of any sort in this bin
    if ((fr_trendTs(mm,1) == 0) || isnan(fr_trendTs(mm,1)))
        ratio_trendTs(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_trendTs(mm,2) == 0) || isnan(fr_trendTs(mm,2)))
            ratio_trendTs(mm) = 0.0;
        % when there are some of both
        else
            ratio_trendTs(mm) = fr_trendTs(mm,2) / fr_trendTs(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd  % mode (most frequent) temperature
    % when there are no planets of any sort in this bin
    if ((fr_modeTs(mm,1) == 0) || isnan(fr_modeTs(mm,1)))
        ratio_modeTs(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_modeTs(mm,2) == 0) || isnan(fr_modeTs(mm,2)))
            ratio_modeTs(mm) = 0.0;
        % when there are some of both
        else
            ratio_modeTs(mm) = fr_modeTs(mm,2) / fr_modeTs(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd  % fractions of time spent outside any SAs
    % when there are no planets of any sort in this bin
    if ((fr_timeouts(mm,1) == 0) || isnan(fr_timeouts(mm,1)))
        ratio_timeouts(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_timeouts(mm,2) == 0) || isnan(fr_timeouts(mm,2)))
            ratio_timeouts(mm) = 0.0;
        % when there are some of both
        else
            ratio_timeouts(mm) = fr_timeouts(mm,2) / fr_timeouts(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd  % fractions of time spent within SAs
    % when there are no planets of any sort in this bin
    if ((fr_timesas(mm,1) == 0) || isnan(fr_timesas(mm,1)))
        ratio_timesas(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_timesas(mm,2) == 0) || isnan(fr_timesas(mm,2)))
            ratio_timesas(mm) = 0.0;
        % when there are some of both
        else
            ratio_timesas(mm) = fr_timesas(mm,2) / fr_timesas(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd  % fractions of time spent within the most powerful SA
    % when there are no planets of any sort in this bin
    if ((fr_timepowsas(mm,1) == 0) || isnan(fr_timepowsas(mm,1)))
        ratio_timepowsas(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_timepowsas(mm,2) == 0) || isnan(fr_timepowsas(mm,2)))
            ratio_timepowsas(mm) = 0.0;
        % when there are some of both
        else
            ratio_timepowsas(mm) = fr_timepowsas(mm,2) / fr_timepowsas(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd  % fractions of time spent within the most occupied SA
    % when there are no planets of any sort in this bin
    if ((fr_timeoccsas(mm,1) == 0) || isnan(fr_timeoccsas(mm,1)))
        ratio_timeoccsas(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_timeoccsas(mm,2) == 0) || isnan(fr_timeoccsas(mm,2)))
            ratio_timeoccsas(mm) = 0.0;
        % when there are some of both
        else
            ratio_timeoccsas(mm) = fr_timeoccsas(mm,2) / fr_timeoccsas(mm,1);
        end;
    end;
end;
