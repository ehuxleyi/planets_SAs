
% This script sets the long-term radiation budget trend for an 
% individual planet. Each planet will be subject to one or more temporal
% changes to the major terms in its radiation budget. For instance, over 3
% billion years the brightness (luminosity, i.e. the heating effect on the
% planet) of the planet's star will change according to well-understood
% patterns determined by the class of the star, its mass and its
% metallicity. Other factors can also drive long-term trends, for instance
% biological evolution can lead to progressive removal of greenhouse gases
% from the atmosphere, especially when they are a source of essential
% nutrient as in the case of carbon for land plants. Likewise, an increase
% in albedo could occur, as it has on Earth, for a planet experiencing
% plate tectonics, if this leads to an increase in the area of continents
% over time (land has higher albedo than ocean).

% This is done by adding a time-dependent amount to the feedbacks. The
% time-dependent amount ramps up over time, from zero at the beginning of
% the run to three times the trend value (which is per By) at the end of
% the run. The trend can be positive (tending to make the planet warmer
% over time), negative (tending to make it cooler) or zero (no trend).
%--------------------------------------------------------------------------

% <<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>
% run without any trend
trend = 0.0;
