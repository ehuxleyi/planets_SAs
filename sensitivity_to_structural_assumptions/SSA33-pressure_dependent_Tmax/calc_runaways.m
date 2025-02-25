
% script to calculate the locations of any zones where the system runs away
% to temperatures that are either too cold or too hot.
%--------------------------------------------------------------------------

% calculate the extent of the zone of runaway cooling, if there is one
runaway_freeze = Tmin;
% at the cold end of the habitable envelope, there can only be a runaway
% feedback to sterility if the first (left-most) node has negative dT/dt
% (tendency for the system to get even colder when already nearly too cold)
if (feedbacks(1) < 0.0)
    intercept_found = 0;
    nn = 2;
    % find the first x-axis intercept (temperature at which the tendency is
    % no longer to get cooler over time)
    while ((intercept_found == 0) && (nn <= nTnodes))
        if (feedbacks(nn) > 0.0)
            xintercept = Tnodes(nn-1) + ...
                (Tgap*(0.0-feedbacks(nn-1) / ...
                (feedbacks(nn)-feedbacks(nn-1))));
            intercept_found = 1;
            nn = nn + 1;
        else
            nn = nn + 1;
        end;
    end;
    if (intercept_found == 0)
        % the case where there is no +ve node
        xcs_icehouse = [Tnodes(1) Tnodes(1:nTnodes) Tnodes(nTnodes)];
        ycs_icehouse = [0 feedbacks(1:nTnodes) 0];
        % <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
        runaway_freeze = Tmax0;
    else
        xcs_icehouse = [Tnodes(1) Tnodes(1:(nn-2)) xintercept];
        ycs_icehouse = [0 feedbacks(1:(nn-2)) 0];
        runaway_freeze = xintercept;
    end;
end;

% calculate the extent of the zone of runaway warming, if there is one
% <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
runaway_boil = Tmax0;
% at the warm end of the habitable envelope, there can only be a runaway
% feedback to sterility if the last (right-most) node has positive dT/dt
% (tendency for the system to get even warmer when already nearly too warm)
if (feedbacks(nTnodes) > 0.0)
    intercept_found = 0;
    nn = nTnodes;
    % find the last x-axis intercept (temperature at which the tendency is
    % no longer to get cooler over time)
    while ((intercept_found == 0) && (nn > 0))
        if (feedbacks(nn) < 0.0)
            xintercept = Tnodes(nn) + ...
                (Tgap*(0-feedbacks((nn)) / ...
                (feedbacks(nn+1)-feedbacks((nn)))));
            intercept_found = 1;
            nn = nn - 1;
        else
            nn = nn - 1;
        end;
    end;
    if (intercept_found == 0)
        % the case where there is no -ve node!
        xcs_greenhouse = [Tnodes(1) Tnodes(1:nTnodes) Tnodes(nTnodes)];
        ycs_greenhouse = [0 feedbacks(1:nTnodes) 0];
        runaway_boil = Tmin;
    else
        xcs_greenhouse = [Tnodes(nTnodes) Tnodes(nTnodes:-1:(nn+1)) xintercept];
        ycs_greenhouse = [0 feedbacks(nTnodes:-1:(nn+1)) 0];
        runaway_boil = xintercept;
    end;
end;
