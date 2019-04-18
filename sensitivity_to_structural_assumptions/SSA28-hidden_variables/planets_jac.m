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
global Tmin Tmax Tgap Tnodes nTnodes Tfeedbacks
global H1min H1max H1gap H1nodes nH1nodes H1feedbacks
global H2min H2max H2gap H2nodes nH2nodes H2feedbacks
global H3min H3max H3gap H3nodes nH3nodes H3feedbacks
global k1 k2 k3 k4 k5 k6

out = zeros([4 4]); out(:) = NaN;
T = in(1);
H1 = in(2);
H2 = in(3);
H3 = in(4);


%% derivative of dT/dt with respect to T

% work out which 'nodes' this particular value of T is between
node_bef = 1 + floor((T-Tmin)/Tgap);
node_aft = 1 + ceil((T-Tmin)/Tgap);
if (node_bef < 1)
    node_bef = 1;
elseif (node_bef > nTnodes)
    node_bef = nTnodes;
end
if (node_aft < 1)
    node_aft = 1;
elseif (node_aft > nTnodes)
    node_aft = nTnodes;
end

% if T is outside the habitable range
if ((T < Tmin) || (T > Tmax))
    out(1,1) = 0.0;       % doesn't matter anymore
    
    % if T is exactly at a node, then use the value for that node
elseif (node_bef == node_aft)
    % no change directly at a node
    out(1,1) = 0;
    
else
    % as the trend affects all nodes equally, it's not needed. Just
    % calculate the slope of dT/dt against T
    out(1,1) = (Tfeedbacks(node_aft) - Tfeedbacks(node_bef)) / ...
              (Tnodes(node_aft) - Tnodes(node_bef));
end;


%% derivative of dT/dt with respect to H1
out(1,2) = k1;


%% derivative of dT/dt with respect to H2
out(1,3) = k2;


%% derivative of dT/dt with respect to H3
out(1,4) = k3;


%% derivative of dH1/dt with respect to T
out(2,1) = k4;


%% derivative of dH1/dt with respect to H1

% work out which 'nodes' this particular value of H1 is between
node_bef = 1 + floor((H1-H1min)/H1gap);
node_aft = 1 + ceil((H1-H1min)/H1gap);
if (node_bef < 1)
    node_bef = 1;
elseif (node_bef > nH1nodes)
    node_bef = nH1nodes;
end
if (node_aft < 1)
    node_aft = 1;
elseif (node_aft > nH1nodes)
    node_aft = nH1nodes;
end

if (H1 <= (H1min-5))     % below zone in which dH1/dt brought to zero
    out(2,2) = 0.0;      % no change
elseif (H1 < H1min)      % within zone in which dH1/dt brought to zero
    out(2,2) = H1nodes(1) / 5;
elseif ((H1 >= H1min) && (H1 <= H1max))    % within normal limits
    if (node_bef == node_aft)    % if H1 is exactly at a node
        out(2,2) = 0;            %  then assume zero slope
    else                         % if H1 is between nodes
        out(2,2) = (H1feedbacks(node_aft) - H1feedbacks(node_bef)) / ...
              (H1nodes(node_aft) - H1nodes(node_bef));
    end
elseif (H1 < (H1max+5))  % within zone in which dH1/dt brought to zero
    out(2,2) = (0-H1nodes(nH1nodes)) / 5;
elseif (H1 >= (H1max+5)) % above zone in which dH1/dt brought to zero
    out(2,2) = 0.0;      % no change
else
    error('pl_ODE: should never get here 2');
end


%% derivative of dH1/dt with respect to H2
out(2,3) = 0;


%% derivative of dH1/dt with respect to H3
out(2,4) = 0;


%% derivative of dH2/dt with respect to T
out(3,1) = k5;


%% derivative of dH2/dt with respect to H1
out(3,2) = 0;


%% derivative of dH2/dt with respect to H2

% work out which 'nodes' this particular value of H2 is between
node_bef = 1 + floor((H2-H2min)/H2gap);
node_aft = 1 + ceil((H2-H2min)/H2gap);
if (node_bef < 1)
    node_bef = 1;
elseif (node_bef > nH2nodes)
    node_bef = nH2nodes;
end
if (node_aft < 1)
    node_aft = 1;
elseif (node_aft > nH2nodes)
    node_aft = nH2nodes;
end

if (H2 <= (H2min-5))     % below zone in which dH2/dt brought to zero
    out(3,3) = 0.0;      % no change
elseif (H2 < H2min)      % within zone in which dH2/dt brought to zero
    out(3,3) = H2nodes(1) / 5;
elseif ((H2 >= H2min) && (H2 <= H2max))    % within normal limits
    if (node_bef == node_aft)    % if H2 is exactly at a node
        out(3,3) = 0;            %  then assume zero slope
    else                         % if H2 is between nodes
        out(3,3) = (H2feedbacks(node_aft) - H2feedbacks(node_bef)) / ...
              (H2nodes(node_aft) - H2nodes(node_bef));
    end
elseif (H2 < (H2max+5))  % within zone in which dH2/dt brought to zero
    out(3,3) = (0-H2nodes(nH2nodes)) / 5;
elseif (H2 >= (H2max+5)) % above zone in which dH2/dt brought to zero
    out(3,3) = 0.0;      % no change
else
    error('pl_ODE: should never get here 2');
end


%% derivative of dH2/dt with respect to H3
out(3,4) = 0;


%% derivative of dH3/dt with respect to T
out(4,1) = k6;


%% derivative of dH3/dt with respect to H1
out(4,2) = 0;


%% derivative of dH3/dt with respect to H2
out(4,3) = 0;


%% derivative of dH3/dt with respect to H3

% work out which 'nodes' this particular value of H3 is between
node_bef = 1 + floor((H3-H3min)/H3gap);
node_aft = 1 + ceil((H3-H3min)/H3gap);
if (node_bef < 1)
    node_bef = 1;
elseif (node_bef > nH3nodes)
    node_bef = nH3nodes;
end
if (node_aft < 1)
    node_aft = 1;
elseif (node_aft > nH3nodes)
    node_aft = nH3nodes;
end

if (H3 <= (H3min-5))     % below zone in which dH3/dt brought to zero
    out(4,4) = 0.0;      % no change
elseif (H3 < H3min)      % within zone in which dH3/dt brought to zero
    out(4,4) = H3nodes(1) / 5;
elseif ((H3 >= H3min) && (H3 <= H3max))    % within normal limits
    if (node_bef == node_aft)    % if H3 is exactly at a node
        out(4,4) = 0;            %  then assume zero slope
    else                         % if H3 is between nodes
        out(4,4) = (H3feedbacks(node_aft) - H3feedbacks(node_bef)) / ...
              (H3nodes(node_aft) - H3nodes(node_bef));
    end
elseif (H3 < (H3max+5))  % within zone in which dH3/dt brought to zero
    out(4,4) = (0-H3nodes(nH3nodes)) / 5;
elseif (H3 >= (H3max+5)) % above zone in which dH3/dt brought to zero
    out(4,4) = 0.0;      % no change
else
    error('pl_ODE: should never get here 2');
end

% =========================================================================
