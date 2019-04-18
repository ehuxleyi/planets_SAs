% script to try and calculate the boiling point of water as a function of
% variable atmospheric pressure

% units used here are:
% temperature K
% pressure Pa
% mass kg
% energy J

% a range of pressures from 0.001 bar (= 100 Pa) to 100 bars (= 10^7 Pa)
Pbar = 0.001:0.001:100.0;
% convert to Pa
PPa = Pbar * 1e5;

% the two constants in the equation. These should be the correct values, if
% I manipulated the formula (taken from here:
% http://chemistry.stackexchange.com/questions/14373/how-to-calculate-melting-boiling-points-at-different-pressures),
% derived from the Clausius-Clapeyron relation, correctly, and if I
% inserted the correct values for the latent heat of vaporisation and the
% gas constant
c1 = 4908;
c2 = 24.66;

% for each pressure
for ii = 1:length(PPa)
    
    % use the formula to calculate the boiling temperature of water
    TK(ii) = c1 / (c2 - log(PPa(ii)));
    
    % convert temperature to Celsius just for plotting purposes
    TC(ii) = TK(ii) - 273.25;
end

% plot out the results, using a log scale for the y-axis
semilogy(TC,Pbar,'-k');

xlabel('Boiling Temperature of Water (degrees Celsius)');
ylabel ('Atmospheric Pressure (bars)');
title('Effect of Temperature on the Boiling Point of Water');
% xlim([]);
% ylim([]);
