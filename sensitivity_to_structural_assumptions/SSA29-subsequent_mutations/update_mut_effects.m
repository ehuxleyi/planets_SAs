% This script updates the cumulative sum effect of all mutations that have
% taken place up to this time by adding one more mutation

global Tvec mut_effect_on_dT

switch muts(mutc,1)
    case 1
        % step increase or decrease
        for mmm = 1:length(mut_effect_on_dT)
            % add the same amount to dT/dt for each T value
            mut_effect_on_dT(mmm) = mut_effect_on_dT(mmm) + ...
                (muts(mutc,2) * muts(mutc,3));
        end
    case 2
        % addition of a slope that crosses the y-axis at Tmid
        for mmm = 1:length(mut_effect_on_dT)
            % add a linearly-changing amount between +maxv at Tmin and
            % -maxv at Tmax, all multipled by the sign
            maxv = muts(mutc,2);
            sign = muts(mutc,3);  % +1 or -1
            mut_effect_on_dT(mmm) = mut_effect_on_dT(mmm) + ...
                (sign * (maxv - (2.0*maxv*((Tvec(mmm)-Tmin)/Trange))));
        end
    case 3
        % addition of a pyramid-type function, centred on Tmid
        for mmm = 1:length(mut_effect_on_dT)
            % if below the mid-point temperature
            if (Tvec(mmm) <= Tmid)
                % add a linearly-changing amount between 0 at Tmin and
                % +maxv at Tmid, all multipled by the sign
                maxv = muts(mutc,2);
                sign = muts(mutc,3);  % +1 or -1
                Tmid = 0.5 * (Tmax+Tmin);
                mut_effect_on_dT(mmm) = mut_effect_on_dT(mmm) + ...
                    (sign * (maxv*((Tvec(mmm)-Tmin)/(Tmid-Tmin))));
            % else if above the mid-point temperature
            else
                % add a linearly-changing amount between 0 at Tmin and
                % +maxv at Tmid, all multipled by the sign
                maxv = muts(mutc,2);
                sign = muts(mutc,3);  % +1 or -1
                Tmid = 0.5 * (Tmax+Tmin);
                mut_effect_on_dT(mmm) = mut_effect_on_dT(mmm) + ...
                    (sign * (maxv*((Tmax-Tvec(mmm))/(Tmax-Tmid))));
            end
        end
    case 4
        % addition of a gaussian function, centred randomly but of 'width'
        % (standard deviation) equal to one tenth of Trange, and maximum
        % height equal to maxv
        for mmm = 1:length(mut_effect_on_dT)
                maxv = muts(mutc,2);
                sign = muts(mutc,3);  % +1 or -1
                sd = Trange/10.0;
                loc = muts(mutc,4);
                mut_effect_on_dT(mmm) = mut_effect_on_dT(mmm) + ...
                    (sign*maxv*sqrt(2.0*pi)*sd*normpdf(Tvec(mmm),loc,sd));
        end
end

% produce a (new?) figure showing the updated cumulative effect of all of
% the mutations
f = figure(200);
pos2 = get(f,'Position');
pos2(1) = 50;
set(f,'Position', pos2);
plot(Tvec, mut_effect_on_dT);
hold on;
line([Tmin Tmax], [0 0], 'LineWidth', 1, 'Color', [0 0 0]);
ylim([-300 300]);
title('Sum of Mutations (impact on dT/dt)');

% testing code
% x = [0.0:0.01:1.0];
% y = sqrt(2.0*pi) * 0.05 * normpdf(x,0.6,0.05);
% plot(x,y);

