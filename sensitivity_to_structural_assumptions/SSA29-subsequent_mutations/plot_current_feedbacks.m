% script to plot the current temperature rates of change (dT/dt, i.e. sum
% of all feedbacks) for all different planetary temperatures. Feedbacks
% outside the habitable range are not of interest because recovery from
% sterility is considered to be too late. Stable attractors (x-axis
% intercepts where dT/dt is decreasing, going from +ve to -ve values) are
% indicated in red. Runaway feedback zones are indicated by grey shading.
% Mutations times are indicated by blue circles

% attractor properties were already calculated for the initial state, in
% 'calc_planet_properties. These can now be used in the plotting.
  
%set up the figure
fv = figure(201);
pos = get(fv,'Position');
pos(1) = 50;
pos(2) = 50;
set(fv,'Position', pos);
   
% calculate the current shape of dT/dt
xx = Tmin:1:Tmax;
for iii = 1:length(xx)
    res = planets_ODE(t(end), [xx(iii) 0]);
    yy(iii) = res(1);
end

% plot the  patterns
plot(xx, yy, '-b', 'LineWidth', 1);    % replot over the shaded areas
hold on;

% axis
line([Tmin Tmax], [0 0], 'LineWidth', 1, 'Color', [0 0 0]);
hold on;

% axes
str = sprintf('Current feedbacks of planet %d', ii);
title(str);
xlabel('planetary temperature ({\circ}C)');
ylabel('dT/dt ({\circ}C ky^{-1})');
ybot = -300;
ytop = 300;
axis([Tmin Tmax ybot ytop]);

hold off;

