% This script sets the starting temperature of a planet.
% Every planet starts off habitable, so this is done by randomly choosing
% (uniform distribution) a temperature from within the habitable range.
%--------------------------------------------------------------------------

function [initialT] = determine_initial_T(minT, rangeT)

% where:
%    planet  is the planet number,
%    runs    is the list of run numbers
%    minT    is the minimum possible initial T
%    rangeT  is the width of the range of possible initial Ts
%    initialTs is a list of initial temperatures that the function returns

% set initial temperature for this run using a random number from a
% uniform distribution between 0 and 1
initialT = minT + rangeT * rand;
