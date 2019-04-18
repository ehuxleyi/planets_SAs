
% script to plot out the temperature evolution for an individual planet,
% i.e. how the temperature changed over the planet's history, from the
% starting point (time at which it was initially habitable) up until the
% time at which its temperature became too cold or too hot to still be
% habitable or until 3 By lears later (sufficiently long for intelligent
% observers to have evolved)
% -------------------------------------------------------------------------

%define colours to be used
skyblue = [0.7 0.7 1.0];
lightblue = [56 195 253] ./ 255;
lightgrey = [0.8 0.8 0.8];
darkgrey = [0.2 0.2 0.2];
black = [0 0 0];

% set some variables for local use
ltime = t;
est = y(:,1);
jumps = perturbations;
njumps = pcounter;

% Show the temperature history as a figure (figure 11 for run 1, figure 12
% for run 2 etc)
fign = 2 + jj;
while (fign > 12)
    fign = fign - 10;
end
figr=figure(fign);

% position the figure
pos2 = get(figr,'Position');
pos2(1) = 1200;
pos2(2) = 590 - (40*jj);
while (pos2(2) < 0)
    pos2(2) = pos2(2) + 570;
end;
set(figr,'Position', pos2);

% show axis lines at top and right as well as at left and bottom
ax = gca; set(gca, 'Box', 'on'); 
hold on;

% plot Earth surface temperature against time (in My)
% plot Earth surface temperature against time (in My)
li = plot((ltime/1e3), est, 'Color', lightblue);
ylim([(Tmin-5) (Tmax+5)]);
gg = xlim;
plotxmin = gg(1);
plotxmax = (ltime(end)/1e3);
hold on;

% plot on zones of runaway warming and runaway cooling
if (icehT ~= -999.9)
    fill([0 0 plotxmax plotxmax], [Tmin icehT icehT Tmin], lightgrey, ...
        'EdgeColor', 'none');
    hold on;
end;
if (greenhT ~= -999.9)
    fill([0 0 plotxmax plotxmax], [greenhT Tmax Tmax greenhT], ...
        lightgrey, 'EdgeColor', 'none');
    hold on;
end;

% plot on habitability limits
fill([0 0 plotxmax plotxmax], [Tmin-5 Tmin Tmin Tmin-5],darkgrey, ...
    'EdgeColor', 'k');
hold on;
line([0 plotxmax], [Tmin Tmin], 'LineWidth', 4, 'Color', black);
hold on;
fill([0 0 plotxmax plotxmax], [Tmax Tmax+5 Tmax+5 Tmax],darkgrey, ...
    'EdgeColor', 'k');
hold on;
line([0 plotxmax], [Tmax Tmax], 'LineWidth', 4, 'Color', black);
hold on;

% plot blue strip and triangles to show perturbations
fill([0 0 plotxmax plotxmax], [Tmin-15 Tmin-5 Tmin-5 Tmin-15], skyblue, ...
    'EdgeColor', 'k');
% only show those perturbations that are both large and which occur before
% the end of the run
jumps2 = jumps;
njumps2 = 0;
njumps3 = 0;
for kk = 1:njumps
    if  (abs(jumps(kk,2)) > 1.0)
        njumps3 = njumps3 + 1;   % counter for all large jumps
        if (jumps(kk,1) < ltime(end))
            njumps2 = njumps2 + 1;   % counter for large jumps before end
            jumps2(njumps2,:) = jumps(kk,:);
        end;
    end;
end;
% show them as triangles whose size is proportional to the size of the
% impact
for kk = 1:njumps2
    symsize = round(5.0*abs(jumps2(kk,2)/5.0));  % scale size to perturb
    if (jumps2(kk,2) > 0.0)    % point triangle upwards for T increase
        plot((jumps2(kk,1)/1e3), (Tmin-10), '^r', 'MarkerSize', symsize);
    else                      % point triangle downwards for T decrease
        plot((jumps2(kk,1)/1e3), (Tmin-10), 'vr', 'MarkerSize', symsize);
    end;
    hold on;
end;

% set axes limits
xlim([0 plotxmax]);
ylim([(Tmin-15) (Tmax+5)]);
hold on;

% make the time units be plotted in normal (not scientific) notation
% xt = get(gca, 'xtick');
% for i = 1:length(xt)
%     xticklabel{i} = sprintf('%1.5f', xt(i));
% end;
% xticklabel{1} = sprintf('0');
% set(gca, 'xticklabel', xticklabel);

% label axes
str = sprintf('Temperature history of planet');
title(str);
xlabel('time (My)');
ylabel('planetary temperature ({\circ}C)');

% make axes and tickmarks visible
set(gca, 'Layer', 'top');
uistack(ax,'top'); 

% show the starting temperature
plot(0, Tinits(1), 'gs', 'LineWidth', 2, 'MarkerEdgeColor', 'k', ...
    'MarkerFaceColor', 'g', 'MarkerSize', 8);
hold on;

% show the positions of stable attractors
for kk = 1:nattractors
    plot(0, attractors(kk,1), 'ro', 'LineWidth', 2, 'MarkerSize', 2);
    hold on;
    plot(0, attractors(kk,1), 'ro', 'LineWidth', 2, 'MarkerSize', 8);
    hold on;
end;

% bring the line to the top
uistack(li,'top');

drawnow;
