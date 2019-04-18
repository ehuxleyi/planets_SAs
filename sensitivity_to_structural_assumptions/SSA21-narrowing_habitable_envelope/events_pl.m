function [value, isterminal, direction] = events(t, y, Tnodes, Tgap, ...
    nnodes, Tfeedbacks, trend)

% Locates the time where planetary surface temperature exits the habitable 
% range, and causes the integration to be stopped at that point

% <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
global Tmin Tmax

% artificial function which is zero at habitability limits and nowhere else
if ((y(1) < Tmin) || (y(1) > Tmax))
    c1 = 0.0;
    %fprintf('in events at time = %.1f, (c1 = 1)\n', t)
else
    c1 = 1.0;
end;
value      = c1;
isterminal = 1;    % These are terminal, stop integration
direction  = 0;    % regardless of direction solution is moving in
% =========================================================================
