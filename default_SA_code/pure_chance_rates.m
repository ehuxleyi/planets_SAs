% script to calculate the most likely distribution of planet success rates
% if the success or failure (long-maintained habitability or eventual
% sterility) is purely a matter of chance. Also calculated are the 5% and
% 95% confidence intervals for that distribution.

% this is done using a Monte-Carlo approach in which the same number of
% planets and reruns as in the main simulation are carried out, but where
% success or failure is determined by the simple roll of a dice (random
% number generator) without any reference to the feedbacks. A large number
% of total simulations are carried out in order to get an understanding of
% the the mean and confidence interval values.

% required information at the outset: (1) nplanets,(2) nreruns and 
% (3)overall success rate

% the main outputs of this routine are: (1) a calculation of the median
% value of the overall metric, (2) confidence intervals (5% and 95%) of the
% overall metric, (3) a calculation of the expected (mean) distribution of
% planetary success rates if down to pure chance, (4) confidence intervals
% (5% and 95%) of the planetary success rates

overall_successrate = mean(allplanets_srates);   % as a fraction not a %

nsims = 1000;    % number of simulations to carry out

mc_results = zeros(nsims, nplanets);
ngoodr = zeros(nsims, 1);
ngoodp = zeros(nsims, 1);
metric = zeros(nsims, 1);

% carry out all the Monte Carlo runs

% for each repeat whole simulation
for aaa = 1:nsims
    
    % fprintf('%d\n', aaa);
    
    % for each planet
    for bbb = 1:nplanets
        
        nsuccesses_thisplanet = 0;
        
        % for each rerun of the same planet
        for ccc = 1:nreruns
            % determine if the run was successful using a "roll of the
            % dice"
            if (rand < overall_successrate)    % if remained habitable
                nsuccesses_thisplanet = nsuccesses_thisplanet + 1;
                ngoodr(aaa) = ngoodr(aaa) + 1;
            end;
        end;
        
        % calculate success percentage for this planet
        mc_results(aaa,bbb) = 100.0 * nsuccesses_thisplanet / nreruns;
        
        if (nsuccesses_thisplanet > 0)
            ngoodp(aaa) = ngoodp(aaa) + 1;
        end;
    end;
end;

fprintf('sorting the results\n');

% sort the planet success percentages in order of ascending success (least
% successful first, most successful last) within each simulation
sorted_mc_results = sort(mc_results,2);

% now carry out a second sort. this time the aim is to carry out a sort for
% each rank of the planets. Each simulation has a ranked list of planet
% success rates from 1 to nplanets. Here we take the data for each rank
% position and sort it in ascending order (least successful first, most
% successful last)
final_mc_results = sort(sorted_mc_results,1);

% extract the results for the 5th, 50th (i.e. median) and 95th centiles
i1  = round(nsims*0.01);
i5  = round(nsims*0.05);
i50 = round(nsims*0.50);
i95 = round(nsims*0.95);
i99 = round(nsims*0.99);
chance5  = final_mc_results(i5, :);
chance50 = final_mc_results(i50,:);
chance95 = final_mc_results(i95,:);

fprintf('plotting the results\n');

% plot out the results as a check
x = 1:nplanets;
figure (100);
nlines = min(50,nsims);
for aaa = 1:nlines
    plot(x, sorted_mc_results(aaa,:), ':k', 'LineWidth', 1);
    hold on;
end;
plot(x, chance5,  '--r', 'LineWidth', 3);
hold on;
plot(x, chance95, '--r', 'LineWidth', 3);
hold on;
plot(x, chance50, '-b',  'LineWidth', 3);
ylim([0 100]);

% calculate metric values for all of the simulations
for aaa = 1:nsims
    metric(aaa) = round(100.0 * ngoodr(aaa) / (ngoodp(aaa)*nreruns));
end;

% sort the list
sorted_metrics = sort(metric,1);

% print out the median metric and confidence intervals
fprintf('\n  median value of overall metric is %d%%\n', sorted_metrics(i50));
fprintf('\n  1%% value of overall metric is %d%%\n', sorted_metrics(i1));
fprintf('\n  5%% value of overall metric is %d%%\n', sorted_metrics(i5));
fprintf('\n  95%% value of overall metric is %d%%\n', sorted_metrics(i95));
fprintf('\n  99%% value of overall metric is %d%%\n', sorted_metrics(i99));
