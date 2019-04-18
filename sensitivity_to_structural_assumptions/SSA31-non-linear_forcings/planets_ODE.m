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
global Tmin Tmax Tgap Tnodes nnodes Tfeedbacks trend
% <<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
global gamma

out = in;
T = in(1);

% ----- Differential equation -----

% the value of dT/dt (rate of change of planetary temperature over time)
% depends on the planetary temperature. The value of dT/dt at any precise
% value of T is interpolated between specified values at regular intervals

% work out which 'nodes' this particular value of T is between.
% in order to prevent errors due to array indices < 0 or > size of array
% (when this function is being called with T<Tmin or T>TMax for integration
% purposes), protect against invalid values
node_bef = 1 + floor((T-Tmin)/Tgap);
node_aft = 1 + ceil((T-Tmin)/Tgap);
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

% <<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
% calculate the impact of the trend according to non-linear dynamics.
% Default way of doing it is to add    (trend * (time/1e6))
trend_impact = (3*trend) * ((time/3e6)^gamma);

% if T is outside the habitable range then print message to say so
if ((T < Tmin) || (T > Tmax))
    %fprintf ('T (%.1f) not habitable but run continuing...\n', T);
    out(1) = 0.0;       % doesn't matter anymore
    
    % if T is exactly at a node, then use the feedback value for that node
elseif (node_bef == node_aft)
    % add the effect of the trend over time (e.g. due to increasing
    % solar luminosity)
    % <<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
    out(1) = Tfeedbacks(node_aft) + trend_impact;
    
    % else if T is between nodes then calculate dT/dt by interpolation
else
    % calculate weightings for dT/dt at nodes before and after T
    weight_bef = (Tnodes(node_aft)-T) / Tgap;
    weight_aft = (T-Tnodes(node_bef)) / Tgap;
    % linear interpolation between dT/dt values at the two nodes
    temp = (Tfeedbacks(node_bef)*weight_bef) + ...
        (Tfeedbacks(node_aft)*weight_aft);
    % add the effect of the trend over time (e.g. due to increasing 
    % solar luminosity)
    % <<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
    out(1) = temp + trend_impact;
    
end;

out(2) = 0.0;
% =========================================================================

% check code
% trend = 1.0;
% gamma = [6 5 4 3 2 1 1 1/2 1/3 1/4 1/5 1/6];
% for ii = 1:length(gamma)
%     g = gamma(ii);
%     for jj = 1:300
%         time(jj) = jj/100.0;
%         trend_impact(jj) = 3 * trend * ((time(jj)/3)^g);
%     end
%     plot (time,trend_impact);
%     hold on;
% end