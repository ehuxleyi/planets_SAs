% script to calculate the asymmetry of the feedbacks. A symmetrical system
% of feedbacks will have equal amounts of +ve (warming) and -ve (cooling)
% feedbacks either side of the mid-point temperature. In theory, the best
% possible system of feedbacks is likely to be one where the feedbacks are
% strongly cooling at all temperatures above the mid-point, strongly
% warming at all temperatures below the mid-point, i.e. highly unbalanced
% (asymmetrical). This metric calculates the degree of asymmetry, going
% from the likely worst scenario (dT/dt = -delTmax at all low Ts, =
% +delTmax at all high Ts) to the likely best scenario (dT/dt = +delTmax at
% all low Ts, = -delTmax at all high Ts)

TTnumber = 200;
% <<<<<<<<<<< SPECIAL THIS SA >>>>>>>>>>
Tmid = (Tmin+Tmax)/2.0;
% <<<<<<<<<<< SPECIAL THIS SA >>>>>>>>>>
TTgap = (Trange/TTnumber);
asymm = 0;

% work out which nodes this particular value of T is between.
% <<<<<<<<<<< SPECIAL THIS SA >>>>>>>>>>
for TT = Tmin : TTgap : Tmax
    
    % calculate dT/dt at this T:
    
    % <<<<<<<<<<< SPECIAL THIS SA >>>>>>>>>>
    qq = 1;
    while TT > Tnodes(qq)
        qq = qq + 1;
    end
    
    % <<<<<<<<<<< SPECIAL THIS SA >>>>>>>>>>
    % if T is exactly at a node, then use the feedback value for that node
    if (TT == Tnodes(qq))
        delTT = Tfeedbacks(qq);
        
        % else if T is between nodes then calculate dT/dt by interpolation
    else
        
        % <<<<<<<<<<< SPECIAL THIS SA >>>>>>>>>>
        % work out which nodes this particular value of T is between.
        node_bef = qq-1;
        node_aft = qq;
        
        % <<<<<<<<<<< SPECIAL THIS SA >>>>>>>>>>
        % calculate weightings for dT/dt at nodes before and after T
        weight_bef = (Tnodes(node_aft)-TT) / (Tnodes(qq)-Tnodes(qq-1));
        weight_aft = (TT-Tnodes(node_bef)) / (Tnodes(qq)-Tnodes(qq-1));
        
        % linear interpolation between dT/dt values at the two nodes (and
        % for this purpose calculate only at the beginning, ignoring any
        % contribution of the trend in dT/dt)
        delTT = (Tfeedbacks(node_bef)*weight_bef) + ...
            (Tfeedbacks(node_aft)*weight_aft);
    end;
    
    % add the +ve or -ve contribution to the asymmetry
    if (TT < Tmid)
        asymm = asymm + (TTgap*delTT);
    elseif (TT > Tmid)
        asymm = asymm - (TTgap*delTT);  % i.e. -ve dT/dt adds to asymm
    end;
end;
