function [Tmaxnow] = Tmaxvar(pressure,Pmin,Pmax)

% <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>

% calculates Tmax as a function of time, for this sensitivity analysis
% where Tmax is made to be a function of pressure, with pressure modelled
% as a separate state variable with its own ODE

% Tmax is assumed here to be the boiling point of water, which changes as
% function of pressure (atmospheric pressure, at the sea-surface) between
% 3C at the minimum pressure (10 kPa) and 301C at the maximum pressure (10
% MPa)

Pmin = -100.0;
Pmax = 100.0;

% convert pressure from the model arbitrary units to a pressure in Pascals
PPa_min = 1000;       % 1 kPa, i.e. one-hundredth of Earth's
PPa_max = 10000000;   % 10 MPa, i.e. one hundred times Earth's
if (pressure <= Pmin)
    PPa = PPa_min;
elseif (pressure >= Pmax)
    PPa = PPa_max;
else   % in between
    PPa = PPa_min + ((PPa_max-PPa_min) * (pressure-Pmin) / (Pmax-Pmin));
end

% calculate the boiling point of water (in K) at the current atmospheric
% pressure (Pascals) at mean sea-level, i.e. at the planet's surface
% The equation (derived from Clausius-Clapeyron relation) is taken from:
% http://chemistry.stackexchange.com/questions/
% 14373/how-to-calculate-melting-boiling-points-at-different-pressures
btk = 4908 / (24.66 - log(PPa));

% convert the boiling temperature in K to degrees C
Tmaxnow = btk - 273.25;
% =========================================================================


% testing code
% 
% 
% % a range of pressures from 0.001 bar (= 100 Pa) to 100 bars (= 10^7 Pa)
% Pbar = 0.001:0.001:100.0;
% % convert to Pa
% PPa = Pbar * 1e5;
% 
% % the two constants in the equation to use in the equation from here:
% % http://chemistry.stackexchange.com/questions/14373/how-to-calculate-melting-boiling-points-at-different-pressures),
% % derived from the Clausius-Clapeyron relation,
% c1 = 4908;
% c2 = 24.66;
% 
% % for each pressure
% for ii = 1:length(PPa)
%     
%     % use the formula to calculate the boiling temperature of water
%     TK(ii) = c1 / (c2 - log(PPa(ii)));
%     
%     % convert temperature to Celsius just for plotting purposes
%     TC(ii) = TK(ii) - 273.25;
% end
% 
% % plot out the results, using a log scale for the y-axis
% semilogy(TC,Pbar,'-k');
% xlabel('Boiling Temperature of Water (degrees Celsius)');
% ylabel ('Atmospheric Pressure (bars)');
% title('Effect of Temperature on the Boiling Point of Water');
% % xlim([]);
% % ylim([]);


