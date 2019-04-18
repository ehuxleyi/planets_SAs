function [out] = planets_jac(time, in)

% this file contains the function to calculate Jacobian of the ODE, i.e.
% the derivative with respect to temperature of the rate of change of
% planetary surface temperature over time (dT/dt). This is the same as the
% slope on the graphs from plot_feedbacks

% *******
% Note that planets_ODE and planets_jac go as a pair: if one is changed
% then so too should the other (probably)
% ******* 

% share via global (to slave) variables because difficult to pass as
% arguments
global Tmin Tmax Tnodes nnodes Tfeedbacks

out = [in'; 0 0];
T = in(1);

% ----- Differential equation -----

% the value of the Jacobian 
% depends on the planetary temperature. The value of dT/dt at any precise
% value of T is interpolated between specified values at regular intervals

% <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
% deleted all node_bef and node_aft calculations

% if T is outside the habitable range 
if ((T < Tmin) || (T > Tmax))
    out(1) = 0.0;       % doesn't matter anymore

% <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
% deleted special calculations for exactly at a node
    
% if T is within the habitable range
else
    
    % <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
    % need to calculate the slope differently depending on where at
    if (T > (Tmax-1))
       slope = interp1(Tnodes(1:nnodes), Tfeedbacks(1:nnodes), T, 'spline') - ...
               interp1(Tnodes(1:nnodes), Tfeedbacks(1:nnodes), (T-1), 'spline');
    elseif (T < (Tmin+1))
       slope = interp1(Tnodes(1:nnodes), Tfeedbacks(1:nnodes), (T+1), 'spline') - ...
               interp1(Tnodes(1:nnodes), Tfeedbacks(1:nnodes), T, 'spline');        
    else  % T somewhere in the middle
       slope = interp1(Tnodes(1:nnodes), Tfeedbacks(1:nnodes), (T+0.5), 'spline') - ...
               interp1(Tnodes(1:nnodes), Tfeedbacks(1:nnodes), (T-0.5), 'spline')
    end
    
    % as the trend affects all nodes equally, it's not needed. Just
    % calculate the slope of dT/dt against T
    out(1) = slope;
end;

out(2) = 0.0;
% =========================================================================
