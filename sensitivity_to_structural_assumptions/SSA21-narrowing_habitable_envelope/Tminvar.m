function [Tminnow] = Tminvar(time)

% <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>

% calculates Tmin as a function of time, for this sensitivity analysis
% where the habitable envelope narrows over time rather then remaining
% constant in extent

global Tmin0 max_duration

% Tmin (coldest survivable temperature) gets 20C warmer over the 3By
% duration
Tminnow =  Tmin0 + 20.0 * (time/max_duration);
% =========================================================================
