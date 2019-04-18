
% this script is to calculate frequency distributions for different planet
% properties, ready to be plotted
% it also creates lists of planet properties, both for each and every
% planet, and also for 'good' (survived at least once) planets only
%--------------------------------------------------------------------------

% initialise the arrays
fr_nodes = zeros([nnodes_max 2]);      % 1st row=all planets, 2nd=survivors
fr_attrs = zeros([(nnodes_max+1) 2]);  % NB can have 0 stable attractors
fr_trends = zeros([nbinsd 2]);
fr_blambdas = zeros([nbinsd 2]);
fr_mlambdas = zeros([nbinsd 2]);
fr_llambdas = zeros([nbinsd 2]);
fr_ncycles = zeros([nbinsd 2]);
fr_maxcycles = zeros([nbinsd 2]);
fr_strengths = zeros([nbinsd 2]);
fr_powers = zeros([nbinsd 2]);
fr_pos1s = zeros([nbinsd 2]);
fr_dist1s = zeros([nbinsd 2]);
fr_pos2s = zeros([nbinsd 2]);
fr_dist2s = zeros([nbinsd 2]);
fr_runaways = zeros([nbinsd 2]);
fr_asymms = zeros([nbinsd 2]);
fr_avdurations = zeros([nbinsd 2]);
allplanets_nodes = zeros([nplanets 1]);
allplanets_attrs = zeros([nplanets 1]);
allplanets_trends = zeros([nplanets 1]);
allplanets_blambdas = zeros([nplanets 1]);
allplanets_mlambdas = zeros([nplanets 1]);
allplanets_llambdas = zeros([nplanets 1]);
allplanets_ncycles = zeros([nplanets 1]);
allplanets_maxcycles = zeros([nplanets 1]);
allplanets_strengths = zeros([nplanets 1]);
allplanets_powers = zeros([nplanets 1]);
allplanets_pos1s = zeros([nplanets 1]);
allplanets_dist1s = zeros([nplanets 1]);
allplanets_pos2s = zeros([nplanets 1]);
allplanets_dist2s = zeros([nplanets 1]);
allplanets_runaways = zeros([nplanets 1]);
allplanets_asymms = zeros([nplanets 1]);
allplanets_avdurations = zeros([nplanets 1]);
allplanets_srates = zeros([nplanets 1]);
goodplanets_nodes = zeros([ngoodplanets 1]);
goodplanets_attrs = zeros([ngoodplanets 1]);
goodplanets_trends = zeros([ngoodplanets 1]);
goodplanets_blambdas = zeros([ngoodplanets 1]);
goodplanets_mlambdas = zeros([ngoodplanets 1]);
goodplanets_llambdas = zeros([ngoodplanets 1]);
goodplanets_ncycles = zeros([ngoodplanets 1]);
goodplanets_maxcycles = zeros([ngoodplanets 1]);
goodplanets_strengths = zeros([ngoodplanets 1]);
goodplanets_powers = zeros([ngoodplanets 1]);
goodplanets_pos1s = zeros([ngoodplanets 1]);
goodplanets_dist1s = zeros([ngoodplanets 1]);
goodplanets_pos2s = zeros([ngoodplanets 1]);
goodplanets_dist2s = zeros([ngoodplanets 1]);
goodplanets_runaways = zeros([ngoodplanets 1]);
goodplanets_asymms = zeros([ngoodplanets 1]);
goodplanets_avdurations = zeros([ngoodplanets 1]);
ratio_nodes = zeros([nnodes_max 1]);
ratio_attrs = zeros([(nnodes_max+1) 1]);  % NB can have 0 stable attractors
ratio_trends = zeros([nbinsd 1]);
ratio_blambdas = zeros([nbinsd 1]);
ratio_mlambdas = zeros([nbinsd 1]);
ratio_llambdas = zeros([nbinsd 1]);
ratio_ncycles = zeros([nbinsd 1]);
ratio_maxcycles = zeros([nbinsd 1]);
ratio_strengths = zeros([nbinsd 1]);
ratio_powers = zeros([nbinsd 1]);
ratio_pos1s = zeros([nbinsd 1]);
ratio_dist1s = zeros([nbinsd 1]);
ratio_pos2s = zeros([nbinsd 1]);
ratio_dist2s = zeros([nbinsd 1]);
ratio_runaways = zeros([nbinsd 1]);
ratio_asymms = zeros([nbinsd 1]);
ratio_avdurations = zeros([nbinsd 1]);

ns = 0;     % number of survivor planets

% count up numbers in each bin
for pp=1:nplanets
            
    % compile a simple list of the values of each property for all planets
    allplanets_nodes(pp) = planets(pp).nnodes;
    allplanets_attrs(pp) = planets(pp).nattractors;
    allplanets_trends(pp) = planets(pp).trend;
    allplanets_blambdas(pp) = planets(pp).lambda_big;
    allplanets_mlambdas(pp) = planets(pp).lambda_mid;
    allplanets_llambdas(pp) = planets(pp).lambda_little;   
    allplanets_ncycles(pp) = planets(pp).ncycles;
    allplanets_maxcycles(pp) = planets(pp).max_cycle_amplitude;
    allplanets_strengths(pp) = planets(pp).max_attr_strength;
    allplanets_powers(pp) = planets(pp).max_attr_power;
    allplanets_pos1s(pp) = planets(pp).max_attr_pos1;
    allplanets_dist1s(pp) = planets(pp).max_attr_dist1;
    allplanets_pos2s(pp) = planets(pp).max_attr_pos2;
    allplanets_dist2s(pp) = planets(pp).max_attr_dist2;
    allplanets_runaways(pp) = planets(pp).pcrunaway/100.0; % to fraction
    allplanets_asymms(pp) = planets(pp).asymmetry;
    allplanets_avdurations(pp) = planets(pp).avduration;
    allplanets_srates(pp) = planets(pp).successrate;
    
    % calculate which bin this planet falls in, for each property
    nodesbin = planets(pp).nnodes;
    attrsbin = 1 + planets(pp).nattractors;     % to avoid index of 0
    trendbin = 1+floor(nbinsd*(planets(pp).trend-trendmin) / ...
        (trendmax-trendmin)); % see "determine_trend" function
    blambdabin = 1+floor(nbinsd*planets(pp).lambda_big / ...
        maxavnumber_bigp); % see "determine_neighbourhood.m"
    mlambdabin = 1+floor(nbinsd*planets(pp).lambda_mid / ...
        maxavnumber_midp); % see "determine_neighbourhood.m"
    llambdabin = 1+floor(nbinsd*planets(pp).lambda_little / ...
        maxavnumber_littlep); % see "determine_neighbourhood.m"
    if (isfinite(planets(pp).ncycles))   % i.e. if not a NaN
        ncyclesbin = 1+floor(nbinsd*planets(pp).ncycles/8);
        % NB: if a property is at its absolute maximum (e.g. pcrunaway at
        % 100%) then it should be put into the 40th bin (if there are 40 in
        % total), to avoid having to have a 41st one solely for that
        % eventuality
        if (ncyclesbin == (nbinsd+1))
            ncyclesbin = nbinsd;
        end;
    else
        ncyclesbin = NaN;
    end;
    if (isfinite(planets(pp).max_cycle_amplitude))
        maxcyclesbin = 1+floor(nbinsd*planets(pp).max_cycle_amplitude/(fsd/5));    
        if (maxcyclesbin == (nbinsd+1))
            maxcyclesbin = nbinsd;
        end;
    else
        maxcyclesbin = NaN;
    end;
    if (isfinite(planets(pp).max_attr_strength))
        strengthbin = 1+floor(nbinsd*planets(pp).max_attr_strength/(frange/2.0));
        if (strengthbin == (nbinsd+1))
            strengthbin = nbinsd;
        end;
    else
        strengthbin = NaN;
    end;
    if (isfinite(planets(pp).max_attr_power))
        powmax = Trange*(frange/2.0);
        powerbin = 1+floor(nbinsd*planets(pp).max_attr_power/powmax);
        if (powerbin == (nbinsd+1))
            powerbin = nbinsd;
        end;
    else
        powerbin = NaN;
    end;
    if (isfinite(planets(pp).max_attr_pos1))
        pos1bin = 1+floor(nbinsd*(planets(pp).max_attr_pos1-Tmin)/Trange);
        if (pos1bin == (nbinsd+1))
            pos1bin = nbinsd;
        end;
    else
        pos1bin = NaN;
    end;
    if (isfinite(planets(pp).max_attr_dist1))
        dist1bin = 1+floor(nbinsd*planets(pp).max_attr_dist1/(Trange/2.0));
        if (dist1bin == (nbinsd+1))
            dist1bin = nbinsd;
        end;
    else
        dist1bin = NaN;
    end;
    if (isfinite(planets(pp).max_attr_pos2))
        pos2bin = 1+floor(nbinsd*(planets(pp).max_attr_pos2-Tmin)/Trange);
        if (pos2bin == (nbinsd+1))
            pos2bin = nbinsd;
        end;
    else
        pos2bin = NaN;
    end;
    if (isfinite(planets(pp).max_attr_dist2))
        dist2bin = 1+floor(nbinsd*planets(pp).max_attr_dist2/(Trange/2.0));
        if (dist2bin == (nbinsd+1))
            dist2bin = nbinsd;
        end;
    else
        dist2bin = NaN;
    end;
    if (isfinite(planets(pp).pcrunaway))
        runawaybin = 1+floor(nbinsd*planets(pp).pcrunaway/100.0);    
        if (runawaybin == (nbinsd+1))
            runawaybin = nbinsd;
        end;
    else
        runawaybin = NaN;
    end;    
    if (isfinite(planets(pp).asymmetry))
        asymm_max = Trange*frange/2.0;
        asymmbin = 1+floor(nbinsd*((planets(pp).asymmetry+asymm_max)/...
            (2.0*asymm_max)));    
        if (asymmbin == (nbinsd+1))
            asymmbin = nbinsd;
        end;
    else
        asymmbin = NaN;
    end;
    if (isfinite(planets(pp).avduration))
        avdurationbin = 1+floor(nbinsd*planets(pp).avduration/3.0);    
        if (avdurationbin == (nbinsd+1))
            avdurationbin = nbinsd;
        end;
    else
        avdurationbin = NaN;
    end;
    
    % check the values produced are as expected
    if ((nodesbin < 1) || (nodesbin > nnodes_max)) 
        fprintf('***WARNING*** bad value (%d) of nodesbin for planet %d in calc_planet_freq\n', nodesbin, pp);
        nodesbin = NaN;
    end;
    if ((attrsbin < 1) || (attrsbin > ((nnodes_max/2)+1))) 
        fprintf('***WARNING*** bad value (%d) of attrsbin for planet %d in calc_planet_freq\n', attrsbin, pp);
        attrsbin = NaN;
    end;
    if ((trendbin < 1) || (trendbin > nbinsd)) 
        fprintf('***WARNING*** bad value (%d) of trendbin for planet %d in calc_planet_freq\n', trendbin, pp);
        trendbin = NaN;
    end;    
    if ((blambdabin < 1) || (blambdabin > nbinsd)) 
        fprintf('***WARNING*** bad value (%d) of blambdabin for planet %d in calc_planet_freq\n', blambdabin, pp);
        blambdabin = NaN;
    end; 
    if ((mlambdabin < 1) || (mlambdabin > nbinsd)) 
        fprintf('***WARNING*** bad value (%d) of mlambdabin for planet %d in calc_planet_freq\n', mlambdabin, pp);
        mlambdabin = NaN;
    end; 
    if ((llambdabin < 1) || (llambdabin > nbinsd)) 
        fprintf('***WARNING*** bad value (%d) of llambdabin for planet %d in calc_planet_freq\n', llambdabin, pp);
        llambdabin = NaN;
    end; 
    if ((ncyclesbin < 1) || (ncyclesbin > nbinsd)) 
        fprintf('***WARNING*** bad value (%d) of ncyclesbin for planet %d in calc_planet_freq\n', ncyclesbin, pp);
        ncyclesbin = NaN;
    end;
    if ((maxcyclesbin < 1) || (maxcyclesbin > nbinsd)) 
        fprintf('***WARNING*** bad value (%d) of maxcyclesbin for planet %d in calc_planet_freq\n', maxcyclesbin, pp);
        maxcyclesbin = NaN;
    end;
    if ((strengthbin < 1) || (strengthbin > nbinsd)) 
        fprintf('***WARNING*** bad value (%d) of strengthbin for planet %d in calc_planet_freq\n', strengthbin, pp);
        strengthbin = NaN;
    end;
    if ((powerbin < 1) || (powerbin > nbinsd)) 
        fprintf('***WARNING*** bad value (%d) of powerbin for planet %d in calc_planet_freq\n', powerbin, pp);
        powerbin = NaN;
    end;
    if ((pos1bin < 1) || (pos1bin > nbinsd)) 
        fprintf('***WARNING*** bad value (%d) of pos1bin for planet %d in calc_planet_freq\n', pos1bin, pp);
        pos1bin = NaN;
    end;
    if ((dist1bin < 1) || (dist1bin > nbinsd)) 
        fprintf('***WARNING*** bad value (%d) of dist1bin for planet %d in calc_planet_freq\n', dist1bin, pp);
        dist1bin = NaN;
    end;
    if ((pos2bin < 1) || (pos2bin > nbinsd)) 
        fprintf('***WARNING*** bad value (%d) of pos2bin for planet %d in calc_planet_freq\n', pos2bin, pp);
        pos2bin = NaN;
    end;
    if ((dist2bin < 1) || (dist2bin > nbinsd)) 
        fprintf('***WARNING*** bad value (%d) of dist2bin for planet %d in calc_planet_freq\n', dist2bin, pp);
        dist2bin = NaN;
    end;
    if ((runawaybin < 1) || (runawaybin > nbinsd))
        fprintf('***WARNING*** bad value (%d) of runawaybin for planet %d in calc_planet_freq\n', runawaybin, pp);
        fprintf('icehT = %.3f, greenhT = %.3f, pcrunaway = %.3f and Trange = %.3f\n', icehT, greenhT, planets(pp).pcrunaway, Trange);
        runawaybin = NaN;
    end;
    if ((asymmbin < 1) || (asymmbin > nbinsd))
        fprintf('***WARNING*** bad value (%d) of asymmbin for planet %d in calc_planet_freq\n', asymmbin, pp);
        asymmbin = NaN;
    end;
    if ((avdurationbin < 1) || (avdurationbin > nbinsd))
        fprintf('***WARNING*** bad value (%d) of avdurationbin for planet %d in calc_planet_freq\n', avdurationbin, pp);
        avdurationbin = NaN;
    end;
    
    % increment the counters for that bin for all planets
    if isfinite(nodesbin)
        fr_nodes(nodesbin,1) = fr_nodes(nodesbin,1) + 1;
    end;
    if isfinite(attrsbin)
        fr_attrs(attrsbin,1) = fr_attrs(attrsbin,1) + 1;
    end;
    if isfinite(trendbin)
        fr_trends(trendbin,1) = fr_trends(trendbin,1) + 1;
    end;
    if isfinite(blambdabin)
        fr_blambdas(blambdabin,1) = fr_blambdas(blambdabin,1) + 1;
    end;
    if isfinite(mlambdabin)
        fr_mlambdas(mlambdabin,1) = fr_mlambdas(mlambdabin,1) + 1;
    end;
    if isfinite(llambdabin)
        fr_llambdas(llambdabin,1) = fr_llambdas(llambdabin,1) + 1;
    end;
    if isfinite(ncyclesbin)
        fr_ncycles(ncyclesbin,1) = fr_ncycles(ncyclesbin,1) + 1;
    end;
    if isfinite(maxcyclesbin)
        fr_maxcycles(maxcyclesbin,1) = fr_maxcycles(maxcyclesbin,1) + 1;
    end;
    if isfinite(strengthbin)
        fr_strengths(strengthbin,1) = fr_strengths(strengthbin,1) + 1;
    end;
    if isfinite(powerbin)
        fr_powers(powerbin,1) = fr_powers(powerbin,1) + 1;
    end;
    if isfinite(pos1bin)
        fr_pos1s(pos1bin,1) = fr_pos1s(pos1bin,1) + 1;
    end;
    if isfinite(dist1bin)
        fr_dist1s(dist1bin,1) = fr_dist1s(dist1bin,1) + 1;
    end;
    if isfinite(pos2bin)
        fr_pos2s(pos2bin,1) = fr_pos2s(pos2bin,1) + 1;
    end;
    if isfinite(dist2bin)
        fr_dist2s(dist2bin,1) = fr_dist2s(dist2bin,1) + 1;
    end;
    if isfinite(runawaybin)
        fr_runaways(runawaybin,1) = fr_runaways(runawaybin,1) + 1;
    end;
    if isfinite(asymmbin)
        fr_asymms(asymmbin,1) = fr_asymms(asymmbin,1) + 1;
    end;
    if isfinite(avdurationbin)
        fr_avdurations(avdurationbin,1) = fr_avdurations(avdurationbin,1) + 1;
    end;
    
    % if this planet ever survived (was a "good" planet)
    if (planets(pp).any_survived == 1)
        
        % increment counter for number of survivor planets
        ns = ns + 1;
        
        % compile a simple list of the values of each property for all good planets
        goodplanets_nodes(ns) = planets(pp).nnodes;
        goodplanets_attrs(ns) = planets(pp).nattractors;
        goodplanets_trends(ns) = planets(pp).trend;
        goodplanets_blambdas(ns) = planets(pp).lambda_big;
        goodplanets_mlambdas(ns) = planets(pp).lambda_mid;
        goodplanets_llambdas(ns) = planets(pp).lambda_little;
        goodplanets_ncycles(ns) = planets(pp).ncycles;
        goodplanets_maxcycles(ns) = planets(pp).max_cycle_amplitude;
        goodplanets_strengths(ns) = planets(pp).max_attr_strength;
        goodplanets_powers(ns) = planets(pp).max_attr_power;
        goodplanets_pos1s(ns) = planets(pp).max_attr_pos1;
        goodplanets_dist1s(ns) = planets(pp).max_attr_dist1;
        goodplanets_pos2s(ns) = planets(pp).max_attr_pos2;
        goodplanets_dist2s(ns) = planets(pp).max_attr_dist2;
        goodplanets_runaways(ns) = (planets(pp).pcrunaway/100.0); % to fraction
        goodplanets_asymms(ns) = (planets(pp).asymmetry);
        goodplanets_avdurations(ns) = planets(pp).avduration;
        
        % increment the counters for that bin for survivor planets
        if isfinite(nodesbin)
            fr_nodes(nodesbin,2) = fr_nodes(nodesbin,2) + 1;
        end;
        if isfinite(attrsbin)
            fr_attrs(attrsbin,2) = fr_attrs(attrsbin,2) + 1;
        end;
        if isfinite(trendbin)
            fr_trends(trendbin,2) = fr_trends(trendbin,2) + 1;
        end;
        if isfinite(blambdabin)
            fr_blambdas(blambdabin,2) = fr_blambdas(blambdabin,2) + 1;
        end;
        if isfinite(mlambdabin)
            fr_mlambdas(mlambdabin,2) = fr_mlambdas(mlambdabin,2) + 1;
        end;
        if isfinite(llambdabin)
            fr_llambdas(llambdabin,2) = fr_llambdas(llambdabin,2) + 1;
        end;
        if isfinite(ncyclesbin)
            fr_ncycles(ncyclesbin,2) = fr_ncycles(ncyclesbin,2) + 1;
        end;
        if isfinite(maxcyclesbin)
            fr_maxcycles(maxcyclesbin,2) = fr_maxcycles(maxcyclesbin,2) + 1;
        end;
        if isfinite(strengthbin)
            fr_strengths(strengthbin,2) = fr_strengths(strengthbin,2) + 1;
        end;
        if isfinite(powerbin)
            fr_powers(powerbin,2) = fr_powers(powerbin,2) + 1;
        end;
        if isfinite(pos1bin)
            fr_pos1s(pos1bin,2) = fr_pos1s(pos1bin,2) + 1;
        end;
        if isfinite(dist1bin)
            fr_dist1s(dist1bin,2) = fr_dist1s(dist1bin,2) + 1;
        end;
        if isfinite(pos2bin)
            fr_pos2s(pos2bin,2) = fr_pos2s(pos2bin,2) + 1;
        end;
        if isfinite(dist2bin)
            fr_dist2s(dist2bin,2) = fr_dist2s(dist2bin,2) + 1;
        end;
        if isfinite(runawaybin)
            fr_runaways(runawaybin,2) = fr_runaways(runawaybin,2) + 1;
        end;
        if isfinite(asymmbin)
            fr_asymms(asymmbin,2) = fr_asymms(asymmbin,2) + 1;
        end;
       if isfinite(avdurationbin)
            fr_avdurations(avdurationbin,2) = fr_avdurations(avdurationbin,2) + 1;
        end;
    end;
end;

% normalise to totals
for mm = 1:nnodes_max  % number of nodes
    if (fr_nodes(mm,1) ~= 0)
        fr_nodes(mm,1) = fr_nodes(mm,1) / nplanets;
    else
        fr_nodes(mm,1) = NaN;
    end;
    if (fr_nodes(mm,2) ~= 0)
        fr_nodes(mm,2) = fr_nodes(mm,2) / ngoodplanets;
    else
        fr_nodes(mm,2) = NaN;
    end;
end;
for mm = 1:nnodes_max  % number of stable attractors
    if (fr_attrs(mm,1) ~= 0)
        fr_attrs(mm,1) = fr_attrs(mm,1) / nplanets;
    else
        fr_attrs(mm,1) = NaN;
    end;
    if (fr_attrs(mm,2) ~= 0)
        fr_attrs(mm,2) = fr_attrs(mm,2) / ngoodplanets;
    else
        fr_attrs(mm,2) = NaN;
    end;
end;
for mm = 1:nbinsd  % imposed trend
    if (fr_trends(mm,1) ~= 0)
        fr_trends(mm,1) = fr_trends(mm,1) / nplanets;
    else
        fr_trends(mm,1) = NaN;
    end;
    if (fr_trends(mm,2) ~= 0)
        fr_trends(mm,2) = fr_trends(mm,2) / ngoodplanets;
    else
        fr_trends(mm,2) = NaN;
    end;
end;
for mm = 1:nbinsd
    if (fr_blambdas(mm,1) ~= 0)
        fr_blambdas(mm,1) = fr_blambdas(mm,1) / nplanets;
    else
        fr_blambdas(mm,1) = NaN;
    end;
    if (fr_blambdas(mm,2) ~= 0)
        fr_blambdas(mm,2) = fr_blambdas(mm,2) / ngoodplanets;
    else
        fr_blambdas(mm,2) = NaN;
    end;
end;
for mm = 1:nbinsd
    if (fr_mlambdas(mm,1) ~= 0)
        fr_mlambdas(mm,1) = fr_mlambdas(mm,1) / nplanets;
    else
        fr_mlambdas(mm,1) = NaN;
    end;
    if (fr_mlambdas(mm,2) ~= 0)
        fr_mlambdas(mm,2) = fr_mlambdas(mm,2) / ngoodplanets;
    else
        fr_mlambdas(mm,2) = NaN;
    end;
end;
for mm = 1:nbinsd
    if (fr_llambdas(mm,1) ~= 0)
        fr_llambdas(mm,1) = fr_llambdas(mm,1) / nplanets;
    else
        fr_llambdas(mm,1) = NaN;
    end;
    if (fr_llambdas(mm,2) ~= 0)
        fr_llambdas(mm,2) = fr_llambdas(mm,2) / ngoodplanets;
    else
        fr_llambdas(mm,2) = NaN;
    end;
end;
for mm = 1:nbinsd  % number of cycles
    if (fr_ncycles(mm,1) ~= 0)
        fr_ncycles(mm,1) = fr_ncycles(mm,1) / nplanets;
    else
        fr_ncycles(mm,1) = NaN;
    end;
    if (fr_ncycles(mm,2) ~= 0)
        fr_ncycles(mm,2) = fr_ncycles(mm,2) / ngoodplanets;
    else
        fr_ncycles(mm,2) = NaN;
    end;
end;
for mm = 1:nbinsd  % maximum cycle amplitude
    if (fr_maxcycles(mm,1) ~= 0)
        fr_maxcycles(mm,1) = fr_maxcycles(mm,1) / nplanets;
    else
        fr_maxcycles(mm,1) = NaN;
    end;
    if (fr_maxcycles(mm,2) ~= 0)
        fr_maxcycles(mm,2) = fr_maxcycles(mm,2) / ngoodplanets;
    else
        fr_maxcycles(mm,2) = NaN;
    end;
end;
for mm = 1:nbinsd    % strength
    if (fr_strengths(mm,1) ~= 0)
        fr_strengths(mm,1) = fr_strengths(mm,1) / nplanets;
    else
        fr_strengths(mm,1) = NaN;
    end;
    if (fr_strengths(mm,2) ~= 0)
        fr_strengths(mm,2) = fr_strengths(mm,2) / ngoodplanets;
    else
        fr_strengths(mm,2) = NaN;
    end;
end;
for mm = 1:nbinsd    % power
    if (fr_powers(mm,1) ~= 0)
        fr_powers(mm,1) = fr_powers(mm,1) / nplanets;
    else
        fr_powers(mm,1) = NaN;
    end;
    if (fr_powers(mm,2) ~= 0)
        fr_powers(mm,2) = fr_powers(mm,2) / ngoodplanets;
    else
        fr_powers(mm,2) = NaN;
    end;
end;
for mm = 1:nbinsd    % pos1
    if (fr_pos1s(mm,1) ~= 0)
        fr_pos1s(mm,1) = fr_pos1s(mm,1) / nplanets;
    else
        fr_pos1s(mm,1) = NaN;
    end;
    if (fr_pos1s(mm,2) ~= 0)
        fr_pos1s(mm,2) = fr_pos1s(mm,2) / ngoodplanets;
    else
        fr_pos1s(mm,2) = NaN;
    end;
end;
for mm = 1:nbinsd    % dist1
    if (fr_dist1s(mm,1) ~= 0)
        fr_dist1s(mm,1) = fr_dist1s(mm,1) / nplanets;
    else
        fr_dist1s(mm,1) = NaN;
    end;
    if (fr_dist1s(mm,2) ~= 0)
        fr_dist1s(mm,2) = fr_dist1s(mm,2) / ngoodplanets;
    else
        fr_dist1s(mm,2) = NaN;
    end;
end;
for mm = 1:nbinsd    % pos2
    if (fr_pos2s(mm,1) ~= 0)
        fr_pos2s(mm,1) = fr_pos2s(mm,1) / nplanets;
    else
        fr_pos2s(mm,1) = NaN;
    end;
    if (fr_pos2s(mm,2) ~= 0)
        fr_pos2s(mm,2) = fr_pos2s(mm,2) / ngoodplanets;
    else
        fr_pos2s(mm,2) = NaN;
    end;
end;
for mm = 1:nbinsd   % dist2
    if (fr_dist2s(mm,1) ~= 0)
        fr_dist2s(mm,1) = fr_dist2s(mm,1) / nplanets;
    else
        fr_dist2s(mm,1) = NaN;
    end;
    if (fr_dist2s(mm,2) ~= 0)
        fr_dist2s(mm,2) = fr_dist2s(mm,2) / ngoodplanets;
    else
        fr_dist2s(mm,2) = NaN;
    end;
end;
for mm = 1:nbinsd    % importance of runaway feedbacks
    if (fr_runaways(mm,1) ~= 0)
        fr_runaways(mm,1) = fr_runaways(mm,1) / nplanets;
    else
        fr_runaways(mm,1) = NaN;
    end;
    if (fr_runaways(mm,2) ~= 0)
        fr_runaways(mm,2) = fr_runaways(mm,2) / ngoodplanets;
    else
        fr_runaways(mm,2) = NaN;
    end;
end;
for mm = 1:nbinsd    % importance of feedback asymmetry
    if (fr_asymms(mm,1) ~= 0)
        fr_asymms(mm,1) = fr_asymms(mm,1) / nplanets;
    else
        fr_asymms(mm,1) = NaN;
    end;
    if (fr_asymms(mm,2) ~= 0)
        fr_asymms(mm,2) = fr_asymms(mm,2) / ngoodplanets;
    else
        fr_asymms(mm,2) = NaN;
    end;
end;
for mm = 1:nbinsd    % average survival time of runs
    if (fr_avdurations(mm,1) ~= 0)
        fr_avdurations(mm,1) = fr_avdurations(mm,1) / nplanets;
    else
        fr_avdurations(mm,1) = NaN;
    end;
    if (fr_avdurations(mm,2) ~= 0)
        fr_avdurations(mm,2) = fr_avdurations(mm,2) / ngoodplanets;
    else
        fr_avdurations(mm,2) = NaN;
    end;
end;

% now calculate ratios of frequencies of habitable planets to frequencies
% of all planets (as an indication of whether there is any link to
% probability of habitability; this would be indicated by the former
% exceeding the latter)
for mm = 1:nnodes_max  % number of nodes
    % when there are no planets of any sort in this bin
    if ((fr_nodes(mm,1) == 0) || isnan(fr_nodes(mm,1)))
        ratio_nodes(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_nodes(mm,2) == 0) || isnan(fr_nodes(mm,2)))
            ratio_nodes(mm) = 0.0;
        % when there are some of both
        else
            ratio_nodes(mm) = fr_nodes(mm,2) / fr_nodes(mm,1);
        end;
    end;
end;
for mm = 1:nnodes_max  % number of stable attractors
    % when there are no planets of any sort in this bin
    if ((fr_attrs(mm,1) == 0) || isnan(fr_attrs(mm,1)))
        ratio_attrs(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_attrs(mm,2) == 0) || isnan(fr_attrs(mm,2)))
            ratio_attrs(mm) = 0.0;
        % when there are some of both
        else
            ratio_attrs(mm) = fr_attrs(mm,2) / fr_attrs(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd  % imposed trend
    % when there are no planets of any sort in this bin
    if ((fr_trends(mm,1) == 0) || isnan(fr_trends(mm,1)))
        ratio_trends(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_trends(mm,2) == 0) || isnan(fr_trends(mm,2)))
            ratio_trends(mm) = 0.0;
        % when there are some of both
        else
            ratio_trends(mm) = fr_trends(mm,2) / fr_trends(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd  % large pertrubations
    % when there are no planets of any sort in this bin
    if ((fr_blambdas(mm,1) == 0) || isnan(fr_blambdas(mm,1)))
        ratio_blambdas(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_blambdas(mm,2) == 0) || isnan(fr_blambdas(mm,2)))
            ratio_blambdas(mm) = 0.0;
        % when there are some of both
        else
            ratio_blambdas(mm) = fr_blambdas(mm,2) / fr_blambdas(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd  % mid-sized pertrubations
    % when there are no planets of any sort in this bin
    if ((fr_mlambdas(mm,1) == 0) || isnan(fr_mlambdas(mm,1)))
        ratio_mlambdas(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_mlambdas(mm,2) == 0) || isnan(fr_mlambdas(mm,2)))
            ratio_mlambdas(mm) = 0.0;
        % when there are some of both
        else
            ratio_mlambdas(mm) = fr_mlambdas(mm,2) / fr_mlambdas(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd  % little pertrubations
    % when there are no planets of any sort in this bin
    if ((fr_llambdas(mm,1) == 0) || isnan(fr_llambdas(mm,1)))
        ratio_llambdas(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_llambdas(mm,2) == 0) || isnan(fr_llambdas(mm,2)))
            ratio_llambdas(mm) = 0.0;
        % when there are some of both
        else
            ratio_llambdas(mm) = fr_llambdas(mm,2) / fr_llambdas(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd  % number of cycles
    % when there are no planets of any sort in this bin
    if ((fr_ncycles(mm,1) == 0) || isnan(fr_ncycles(mm,1)))
        ratio_ncycles(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_ncycles(mm,2) == 0) || isnan(fr_ncycles(mm,2)))
            ratio_ncycles(mm) = 0.0;
        % when there are some of both
        else
            ratio_ncycles(mm) = fr_ncycles(mm,2) / fr_ncycles(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd  % maximum cycle amplitude
    % when there are no planets of any sort in this bin
    if ((fr_maxcycles(mm,1) == 0) || isnan(fr_maxcycles(mm,1)))
        ratio_maxcycles(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_maxcycles(mm,2) == 0) || isnan(fr_maxcycles(mm,2)))
            ratio_maxcycles(mm) = 0.0;
        % when there are some of both
        else
            ratio_maxcycles(mm) = fr_maxcycles(mm,2) / fr_maxcycles(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd    % strength
    % when there are no planets of any sort in this bin
    if ((fr_strengths(mm,1) == 0) || isnan(fr_strengths(mm,1)))
        ratio_strengths(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_strengths(mm,2) == 0) || isnan(fr_strengths(mm,2)))
            ratio_strengths(mm) = 0.0;
        % when there are some of both
        else
            ratio_strengths(mm) = fr_strengths(mm,2) / fr_strengths(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd    % power
    % when there are no planets of any sort in this bin
    if ((fr_powers(mm,1) == 0) || isnan(fr_powers(mm,1)))
        ratio_powers(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_powers(mm,2) == 0) || isnan(fr_powers(mm,2)))
            ratio_powers(mm) = 0.0;
        % when there are some of both
        else
            ratio_powers(mm) = fr_powers(mm,2) / fr_powers(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd    % pos1
    % when there are no planets of any sort in this bin
    if ((fr_pos1s(mm,1) == 0) || isnan(fr_pos1s(mm,1)))
        ratio_pos1s(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_pos1s(mm,2) == 0) || isnan(fr_pos1s(mm,2)))
            ratio_pos1s(mm) = 0.0;
        % when there are some of both
        else
            ratio_pos1s(mm) = fr_pos1s(mm,2) / fr_pos1s(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd    % dist1
    % when there are no planets of any sort in this bin
    if ((fr_dist1s(mm,1) == 0) || isnan(fr_dist1s(mm,1)))
        ratio_dist1s(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_dist1s(mm,2) == 0) || isnan(fr_dist1s(mm,2)))
            ratio_dist1s(mm) = 0.0;
        % when there are some of both
        else
            ratio_dist1s(mm) = fr_dist1s(mm,2) / fr_dist1s(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd    % pos2
    % when there are no planets of any sort in this bin
    if ((fr_pos2s(mm,1) == 0) || isnan(fr_pos2s(mm,1)))
        ratio_pos2s(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_pos2s(mm,2) == 0) || isnan(fr_pos2s(mm,2)))
            ratio_pos2s(mm) = 0.0;
        % when there are some of both
        else
            ratio_pos2s(mm) = fr_pos2s(mm,2) / fr_pos2s(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd   % dist2
    % when there are no planets of any sort in this bin
    if ((fr_dist2s(mm,1) == 0) || isnan(fr_dist2s(mm,1)))
        ratio_dist2s(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_dist2s(mm,2) == 0) || isnan(fr_dist2s(mm,2)))
            ratio_dist2s(mm) = 0.0;
        % when there are some of both
        else
            ratio_dist2s(mm) = fr_dist2s(mm,2) / fr_dist2s(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd    % importance of runaway feedbacks
    % when there are no planets of any sort in this bin
    if ((fr_runaways(mm,1) == 0) || isnan(fr_runaways(mm,1)))
        ratio_runaways(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_runaways(mm,2) == 0) || isnan(fr_runaways(mm,2)))
            ratio_runaways(mm) = 0.0;
        % when there are some of both
        else
            ratio_runaways(mm) = fr_runaways(mm,2) / fr_runaways(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd    % importance of feedback asymmetry
    % when there are no planets of any sort in this bin
    if ((fr_asymms(mm,1) == 0) || isnan(fr_asymms(mm,1)))
        ratio_asymms(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_asymms(mm,2) == 0) || isnan(fr_asymms(mm,2)))
            ratio_asymms(mm) = 0.0;
        % when there are some of both
        else
            ratio_asymms(mm) = fr_asymms(mm,2) / fr_asymms(mm,1);
        end;
    end;
end;
for mm = 1:nbinsd    % average survival time of runs
    % when there are no planets of any sort in this bin
    if ((fr_avdurations(mm,1) == 0) || isnan(fr_avdurations(mm,1)))
        ratio_avdurations(mm) = NaN;
    else
        % when there are some planets in this bin but no hab planets
        if ((fr_avdurations(mm,2) == 0) || isnan(fr_avdurations(mm,2)))
            ratio_avdurations(mm) = 0.0;
        % when there are some of both
        else
            ratio_avdurations(mm) = fr_avdurations(mm,2) / fr_avdurations(mm,1);
        end;
    end;
end;