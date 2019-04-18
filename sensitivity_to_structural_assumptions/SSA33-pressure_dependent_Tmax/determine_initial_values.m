% This script sets the starting temperature of a planet.
% Every planet starts off habitable, so this is done by randomly choosing
% (uniform distribution) a temperature from within the habitable range.
%--------------------------------------------------------------------------

% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
function [initialT, initialP] = ...
    determine_initial_values(minT, rangeT)

% where:
%    minT    is the minimum possible initial T
%    rangeT  is the width of the range of possible initial Ts
%    initialT  is the initial temperature that the function returns
%    initialP is the initial P value that the function returns

% set initial temperature for this run using a random number from a
% uniform distribution between minT and maxT
initialT = minT + rangeT * rand;

% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
% initialise all hidden variables to random values, chosen from a uniform
% distribution between -100 and +100
initialP = 200.0*rand - 100.0;
