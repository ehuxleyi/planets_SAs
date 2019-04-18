function [value, isterminal, direction] = events(t, y);

% Locates the time where planetary surface temperature exits the habitable 
% range, and causes the integration to be stopped at that point

% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
global Tmin Tmax H1min H1max H2min H2max H3min H3max

% artificial function which is zero at habitability limits and nowhere else
% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
% make the planet go sterile if any of the environmental parameters goes
% outside limits, not only if temperature leaves the habitable envelope
if ((y(1) <= Tmin) || (y(1) >= Tmax) || ...
        (y(2) <= H1min) || (y(2) >= H1max) || ...
        (y(3) <= H2min) || (y(3) >= H2max) || ...
        (y(4) <= H3min) || (y(4) >= H3max))
    c1 = 0.0;
    %fprintf('in events at time = %.1f, (c1 = 1)\n', t)
else
    c1 = 1.0;
end;
value      = c1;
isterminal = 1;    % These are terminal, stop integration
direction  = 0;    % regardless of direction solution is moving in
% =========================================================================
