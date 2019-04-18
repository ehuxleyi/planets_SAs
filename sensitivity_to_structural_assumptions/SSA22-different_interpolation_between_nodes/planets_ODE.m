function [out] = planets_ODE(time, in)

% this file contains the function to calculate the rate of change of
% planetary surface temperature over time (dT/dt), for a given current
% value of the current planetary surface temperature (T)

% *******
% Note that planets_ODE and planets_jac go as a pair: if one is changed
% then so too should the other (probably)
% *******

% share via global (to slave) variables because difficult to pass as
% arguments
% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>
global Tmin Tmax Tnodes nnodes Tfeedbacks trend

out = in;
T = in(1);

% ----- Differential equation -----

% the value of dT/dt (rate of change of planetary temperature over time)
% depends on the planetary temperature. The value of dT/dt at any precise
% value of T is interpolated between specified values at regular intervals

% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>
% deleted node_bef and node_aft calculations because no longer needed

% if T is outside the habitable range then print message to say so
if ((T < Tmin) || (T > Tmax))
    %fprintf ('T (%.1f) not habitable but run continuing...\n', T);
    out(1) = 0.0;       % doesn't matter anymore
    
% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>
% deleted special calculations for at a node because no longer needed
    
% else if T is inside habitable range then calculate dT/dt by interpolation
else
    % <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>
    % deleted weightings calculations because no longer needed
    
    % add the effect of the trend over time (e.g. due to increasing
    % solar luminosity)
    % <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>
    % interpolate using a spline
    bit = interp1(Tnodes(1:nnodes), Tfeedbacks(1:nnodes), T, 'spline');
    out(1) = bit + (trend * (time/1e6));
end;

out(2) = 0.0;
% =========================================================================
