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
global Tmin Tmax Tnodes nnodes Tfeedbacks trend

out = in;
T = in;

% ----- Differential equation -----

% the value of dT/dt (rate of change of planetary temperature over time)
% depends on the planetary temperature. The value of dT/dt at any precise
% value of T is interpolated between specified values at regular intervals

% <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
% deleted all node_bef and node_aft calculations

% if T is outside the habitable range then print message to say so
if ((T(1) < Tmin) || (T(1) > Tmax))
    %fprintf ('T (%.1f) not habitable but run continuing...\n', T(1));
    out(1) = 0.0;       % doesn't matter anymore
    
% <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
% deleted special calculations for exactly at a node

% if T is within the habitable range
else
    % add the effect of the trend over time (e.g. due to increasing
    % solar luminosity)
    % <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
    bit = trend * (time/1e6);
    feedbacks = Tfeedbacks + bit;
    out(1) = interp1(Tnodes(1:nnodes), feedbacks(1:nnodes), T(1));
end;

out(2) = 0.0;
% =========================================================================
