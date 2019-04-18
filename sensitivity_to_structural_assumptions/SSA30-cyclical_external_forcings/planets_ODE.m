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
% <<<<<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>>
global ncycles cperiods camplitudes

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

% if T is outside the habitable range then print message to say so
if ((T < Tmin) || (T > Tmax))
    %fprintf ('T (%.1f) not habitable but run continuing...\n', T);
    out(1) = 0.0;       % doesn't matter anymore
    
    % if T is exactly at a node, then use the feedback value for that node
elseif (node_bef == node_aft)
    % add the effect of the trend over time (e.g. due to increasing
    % solar luminosity)
    out(1) = Tfeedbacks(node_aft) + (trend * (time/1e6));
    
    % <<<<<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>>
    csum = 0;
    for iii = 1:8
        if (~isnan(cperiods(iii)))
            % both time and periods are in units of ky
            csum = csum + ...
                camplitudes(iii) * sin((2.0*pi*time/cperiods(iii)));
        end
    end
    out(1) = out(1) + csum;
    
    % else if T is between nodes then calculate dT/dt by interpolation
else
    % calculate weightings for dT/dt at nodes before and after T
    weight_bef = (Tnodes(node_aft)-T) / Tgap;
    weight_aft = (T-Tnodes(node_bef)) / Tgap;
    % linear interpolation between dT/dt values at the two nodes
    temp = (Tfeedbacks(node_bef)*weight_bef) + ...
        (Tfeedbacks(node_aft)*weight_aft);
    % add the effect of the trend over time (e.g. due to increasing solar
    % luminosity
    out(1) = temp + (trend * (time/1e6));
    
    % <<<<<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>>
    csum = 0;
    for iii = 1:ncycles
        % both time and periods are in units of ky
        csum = csum + camplitudes(iii) * sin((2.0*pi*time/cperiods(iii)));
    end
    out(1) = out(1) + csum;

end;

out(2) = 0.0;
% =========================================================================
