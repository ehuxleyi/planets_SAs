% script to plot the temperature rates of change (dT/dt, i.e. sum of all
% feedbacks) for all different planetary temperatures. Feedbacks outside
% the habitable range are not of interest because recovery from sterility
% is considered to be too late. Stable attractors (x-axis intercepts where
% dT/dt is decreasing, going from +ve to -ve values) are indicated in red.
% Runaway feedback zones are indicated by grey shading.
%
% The script gets called twice: the first time for the initial (starting)
% pattern of feedbacks, the second time for the final (after trend has been
% applied) pattern of feedbacks. The flag 'plotnumber' specifies which.
% -------------------------------------------------------------------------

% stop matlab displaying integers using scientific notation
format short;

% attractor properties were already calculated for the initial state, in
% 'calc_planet_properties. These can now be used in the plotting.
  
%set up the figure
fig1 = figure(1);
pos = get(fig1,'Position');
pos(1) = 850;
pos(2) = 550;
set(fig1,'Position', pos);
hold on;

% calculate where there are runaway (positive) feedbacks to
% uninhabitability and then add them to the plot
%calc_runaways;
if (runaway_freeze ~= Tmin)
    fill(xcs_icehouse, ycs_icehouse, [0.8 0.8 0.8]);
end;
if (runaway_boil ~= Tmax)
    fill(xcs_greenhouse, ycs_greenhouse, [0.8 0.8 0.8]);
end;

% plot the feedback patterns
plotx1 = Tnodes(1:nTnodes);
ploty1 = feedbacks(1:nTnodes);
plot(plotx1, ploty1, '-ko', 'LineWidth', 2); % replot over the shaded areas
hold on;

% axis
line([Tmin Tmax], [0 0], 'LineWidth', 1, 'Color', [0 0 0]);
hold on;

% show the positions of x-axis intercepts from +ve to -ve (stable attractors)
for aa = 1:nattr
    plot(attr(aa,1), 0, 'ro', 'LineWidth', 2, 'MarkerSize', 2);
    hold on;
    plot(attr(aa,1), 0, 'ro', 'LineWidth', 2, 'MarkerSize', 8);
    hold on;
end;

% show the starting temperatures for this run
% for kk = 1:nreruns
%     plot(Tinit, 0, 'gs', 'LineWidth', 2, 'MarkerEdgeColor', 'k', ...
%         'MarkerFaceColor', 'g', 'MarkerSize', 8);
%     hold on;
% end;

% add annotations showing the strength of the imposed forcing and the
% lambdas (expected numbers of perturbations)
dim = [.45 .18 .35 .1];
dim2 = [.35 .1 .35 .1];
str = sprintf('Long-term forcing = %.1f (%cC ky^{-1}) By^{-1}', ...
    trend, char(176));
str2 = sprintf('Expected perturbation numbers = %d, %d & %d', ...
    round(lambda_little), round(lambda_mid), round(lambda_big));
annotation('textbox',dim,'String',str,'FitBoxToText','on');
annotation('textbox',dim2,'String',str2,'FitBoxToText','on');

% overlay dimensions of stable attractors (on plot of starting feedbacks
% only)
for mm = 1:nattr
    % plot a red dotted box of same width and height as the stable
    % attractor
    xl = attr(mm,9);   xr = attr(mm,10);
    yb = attr(mm,7);   yu = attr(mm,6);
    plot([xl xr xr xl xl], [yu yu yb yb yu], '-.r', 'LineWidth', 1);
    hold on;
end;

% axes
str = sprintf('Initial feedbacks of planet %d (before trend)', tplanets(plc));
title(str);
xlabel('planetary temperature ({\circ}C)');
ylabel('dT/dt ({\circ}C ky^{-1})');
ybot = min(min(Tfeedbacks),(fmin*3/4));
ytop = max(max(Tfeedbacks),(fmax*3/4));
axis([Tmin Tmax ybot ytop]);

% now recalculate the attractor properties, but for the final state, after
% the imposition of all of the trend
feedbacks = Tfeedbacks + (max_duration/1e6)*trend;
calc_attractor_properties;

% setup the figure
fig2 = figure(2);
plotnumber = plotnumber + 1;
pos = get(fig2,'Position');
pos(1) = 850;
pos(2) = 50;
set(fig2,'Position', pos);
hold on;

% first calculate where there are runaway (positive) feedbacks to
% uninhabitability
calc_runaways;
% add runaway feedback zones to the eplot
if (runaway_freeze ~= Tmin)
    fill(xcs_icehouse, ycs_icehouse, [0.8 0.8 0.8]);
end;
if (runaway_boil ~= Tmax)
    fill(xcs_greenhouse, ycs_greenhouse, [0.8 0.8 0.8]);
end;

% plot the feedback patterns
plotx1 = Tnodes(1:nTnodes);
ploty1 = feedbacks(1:nTnodes);
plot(plotx1, ploty1, '-ko', 'LineWidth', 2);    % replot over the shaded areas
hold on;

% axis
line([Tmin Tmax], [0 0], 'LineWidth', 1, 'Color', [0 0 0]);
hold on;

% show the positions of x-axis intercepts from +ve to -ve (stable attractors)
for aa = 1:nattr
    plot(attr(aa,1), 0, 'ro', 'LineWidth', 2, 'MarkerSize', 2);
    hold on;
    plot(attr(aa,1), 0, 'ro', 'LineWidth', 2, 'MarkerSize', 8);
    hold on;
end;

% show the starting temperatures for this run
% for kk = 1:nreruns
%     plot(Tinit, 0, 'gs', 'LineWidth', 2, 'MarkerEdgeColor', 'k', ...
%         'MarkerFaceColor', 'g', 'MarkerSize', 8);
%     hold on;
% end;

% add annotations showing the strength of the imposed forcing and the
% lambdas (expected numbers of perturbations)
dim = [.45 .18 .35 .1];
dim2 = [.35 .1 .35 .1];
str = sprintf('Long-term forcing = %.1f (%cC ky^{-1}) By^{-1}', ...
    trend, char(176));
str2 = sprintf('Expected perturbation numbers = %d, %d & %d', ...
    round(lambda_little), round(lambda_mid), round(lambda_big));
annotation('textbox',dim,'String',str,'FitBoxToText','on');
annotation('textbox',dim2,'String',str2,'FitBoxToText','on');

% overlay dimensions of stable attractors
for mm = 1:nattr
    % plot a red dotted box of same width and height as the stable
    % attractor
    xl = attr(mm,9);   xr = attr(mm,10);
    yb = attr(mm,7);   yu = attr(mm,6);
    plot([xl xr xr xl xl], [yu yu yb yb yu], '-.r', 'LineWidth', 1);
    hold on;
end;

% axes
str = sprintf('Final feedbacks of planet %d (after 3By, trend = %d C ky-1 By-1)',...
      tplanets(plc), round(trend));
title(str);
xlabel('planetary temperature ({\circ}C)');
ylabel('dT/dt ({\circ}C ky^{-1})');
ybot = min(min(feedbacks),(fmin*3/4));
ytop = max(max(feedbacks),(fmax*3/4));
axis([Tmin Tmax ybot ytop]);

drawnow;
hold off;

