
% script to calculate various properties of the stable attr
% arising from this planet's set of climate feedbacks. A stable attractor
% occurs at a temperature Ts if the sum of feedbacks leads to net warming
% directly below Ts and net cooling directly above Ts.
%
% In dT/dt vs T space, the height of a stable attractor is the difference
% in dT/dt between the most negative and most positive dT/dt values. For
% this purpose a stable attractor consists of (1) all of the continuous
% region of positive dT/dt (warming) to the left of the zero crossing
% point, together with (2) all of the continuous region of negative dT/dt
% (cooling) to the right of the zero crossing point.
%
% Thirteen properties are calculated for each attractor:
%   (1) location (temperature of zero crossing point),
%   (2) number of nearest node to left of the crossing point,
%   (3) number of nearest node to right of the crossing point,
%   (4) number of left-most node in the stable attractor,
%   (5) number of right-most node in it,
%   (6) highest dT/dt
%   (7) lowest dT/dt
%   (8) height (highest - lowest dT/dt),
%   (9) leftmost limit of attractor (lowest T from where it returns),
%   (10) rightmost limit of attractor (highest T from where it returns),
%   (11) width (T of next crossing point to the right - T of next crossing
%       point to the left). This is a measure of the range of planetary
%       temperatures over which the stable attractor will return the planet
%       to the equilibrium temperature. It is particularly important in
%       determining how robustly the stable attractor can resist the
%       destabilising effects of temperature perturbations.
%   (12) 'strength' = smaller out of the distances from zero of the lowest
%       dT/dt (i.e. how negative it is) and the highest dT/dt (i.e. how
%       positive it is). This is a measure of the strength of the warming
%       and cooling feedbacks that tend to keep the system locked in this
%       stable attractor
%   (13) 'size' = width x 'strength'. This is an overall metric combining
%       two aspects of the propensity of the system to stay in this stable
%       attractor
%   (14) distance from the middle of the habitable range of the position of
%       this stable attractor position, i.e. a measure of whether it is
%       situated more centrally or more towards one of the edges of the
%       habitable zone
%--------------------------------------------------------------------------

% reset all values, to make sure nothing inherited by accident
nattr = 0;
attr(~isnan(attr)) = NaN;  % reset to NaNs

% find all of the stable attr and calculate their properties. They
% consist of zero crossing points corresponding to stable rather than
% unstable equilibria (i.e. those crossing from +ve to -ve rather than v-v)

% find x-axis intercepts from +ve to -ve (stable attr)
% <<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>
for kk = 2:nnodes
    if ((feedbacks(kk) < 0) && (feedbacks(kk-1) > 0))  % found an attractor
        
        nattr = nattr + 1;
        
        % calculate the location of the zero-crossing where this attractor
        % point is situated
        attr(nattr,1) = Tnodes(kk-1) + ...
            ((Tgap*feedbacks(kk-1)) / ...
             (feedbacks(kk-1)-feedbacks(kk)));
        
        % number of the preceding node
        attr(nattr,2) = kk - 1;
        
        % number of the following node
        attr(nattr,3) = kk;
        
        % go backwards in the node list until come to a -ve node or run out
        % of nodes
        mm = kk - 1;
        while ((mm > 1) && (feedbacks(mm-1) > 0))
            mm = mm - 1;
        end;
        attr(nattr,4) = mm;
        
        % go forwards in the node list until come to a +ve node or run out
        % of nodes
        mm = kk;
        % <<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>
        while ((mm < nnodes) && (feedbacks(mm+1) < 0))
            mm = mm+1;
        end;
        attr(nattr,5) = mm;
        
        % find maximum positive feedback (must lie to the left of the
        % attractor point)
        max_adT = 0;
        for mm = attr(nattr,4):attr(nattr,2)
            if (feedbacks(mm) > max_adT)
                max_adT = feedbacks(mm);
            end;
        end;
        attr(nattr,6) = max_adT;
        
        % find minimum positive feedback (must lie to the right of the
        % attractor point)
        min_adT = 0;
        for mm = attr(nattr,3):attr(nattr,5)
            if (feedbacks(mm) < min_adT)
                min_adT = feedbacks(mm);
            end;
        end;
        attr(nattr,7) = min_adT;
        
        % calculate the height of this attractor.
        attr(nattr,8) = max_adT - min_adT;
        
        % find left limit to this attractor (i.e. the lowest temperature at
        % which the net feedback is still warming, i.e. will still return
        % the system back towards the attractor point)
        nn = attr(nattr,4);
        if (nn == 1)     % reached left-hand edge
            % <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
            min_aT = Tmin0;
        else      % there exists a node further to the left
            min_aT = Tnodes(nn) - ...
                (feedbacks(nn) * Tgap / (feedbacks(nn)-feedbacks(nn-1)));
        end;
        attr(nattr,9) = min_aT;
        
        % find right limit to this attractor (i.e. the highest temperature
        % at which the net feedback is still cooling, i.e. will still
        % return the system back towards the attractor point)
        nn = attr(nattr,5);
        % <<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>
        if (nn == nnodes)     % reached right-hand edge
            % <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
            max_aT = Tmax0;
        else      % there exists a node further to the left
            max_aT = Tnodes(nn) + ...
                ((-feedbacks(nn)) * Tgap / (feedbacks(nn+1)-feedbacks(nn)));
        end;
        attr(nattr,10) = max_aT;
        
        % calculate the width of this attractor.
        attr(nattr,11) = max_aT - min_aT;
        
        % calculate the 'strength' of this attractor, here defined as the
        % smaller of the two heights of this attractor, where the two
        % heights are the two distances away from the line of dT/dt = zero.
        % In other words, how negative the minimum feedback is, or how
        % positive the maximum feedback is, whichever is smaller
        attr(nattr,12) = min([abs(max_adT) abs(min_adT)]);
        
        % calculate the 'size' or 'power' of the attractor. This metric
        % combines the width and the 'strength' into one overall measure of
        % how effective the attractor is likely to be at keeping the system
        % in its vicinity
        attr(nattr,13) = attr(nattr,11) * ...
            attr(nattr,12);
                 
        % calculate the distance from the location of this stable attractor
        % to the middle of the habitable temperature range
        % <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
        attr(nattr,14) = abs(attr(nattr,1) - (0.5*(Tmax0+Tmin0)));
    end;
end;

if (nattr > (nnodes_max/2))
    fprintf('  **** WARNING ****\n');
    fprintf('  Impossible number of stable attractors for this planet (%d)\n', ...
        nattr);
    fprintf('  **** WARNING ****\n');
end;

% print out the properties of each attractor
%for mm = 1:nattr
%    fprintf('  attractor %d: width = %.3f\n', mm, attr(mm,11));
%    fprintf('  attractor %d: height = %.3f\n', mm, attr(mm,8));
%    fprintf('  attractor %d: strength = %.3f\n', mm, attr(mm,12));
%    fprintf('  attractor %d: power = %.3f\n', mm, attr(mm,13));
%    fprintf('  attractor %d: dist to mid = %.3f\n', mm, attr(mm,14));
%end;

