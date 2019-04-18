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
global Tmin0 Tmax0 Tgap Tnodes nnodes Tfeedbacks

out = [in'; 0 0];
T = in(1);

% ----- Differential equation -----

% the value of the Jacobian 
% depends on the planetary temperature. The value of dT/dt at any precise
% value of T is interpolated between specified values at regular intervals

% work out which 'nodes' this particular value of T is between.
% in order to prevent errors due to array indices < 0 or > size of array
% (when this function is being called with T<Tmin or T>TMax for integration
% purposes), protect against invalid values
node_bef = 1 + floor((T-Tmin0)/Tgap);
node_aft = 1 + ceil((T-Tmin0)/Tgap);
if (node_bef < 1)
    node_bef = 1;
elseif (node_bef > nnodes)
    node_bef = nnodes;
end;
if (node_aft < 1)
    node_aft = 1;
elseif (node_aft > nnodes)
    node_aft = nnodes;
end;

% if T is outside the habitable range 
if ((T < Tmin0) || (T > Tmax0))
    out(1) = 0.0;       % doesn't matter anymore
    
    % if T is exactly at a node, then use the value for that node
elseif (node_bef == node_aft)
    % no change directly at a node
    out(1) = 0;
    
else
    % as the trend affects all nodes equally, it's not needed. Juts
    % calculate the slope of dT/dt against T
    out(1) = (Tfeedbacks(node_aft) - Tfeedbacks(node_bef)) / ...
              (Tnodes(node_aft) - Tnodes(node_bef));
end;

out(2) = 0.0;
% =========================================================================
