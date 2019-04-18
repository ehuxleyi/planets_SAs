function [Tmaxnow] = Tmaxvar(time)

% <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>

% calculates Tmax as a function of time, for this sensitivity analysis
% where the habitable envelope narrows over time rather then remaining
% constant in extent

global Tmax0 max_duration

% Tmax (hottest survivable temperature) gets 20C cooler over the 3By
% duration
Tmaxnow =  Tmax0 - (20.0 * (time/max_duration));
% =========================================================================
