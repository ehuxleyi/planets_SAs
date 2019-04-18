% This script sets the starting temperature of a planet.
% Every planet considered here starts off habitable, at the point when life
% first evolves, so this is done by randomly choosing (uniform
% distribution) a temperature from within the habitable range
%--------------------------------------------------------------------------

function [initialT] = determine_initial_T(minT, rangeT)

% where:
%    minT     is the minimum possible initial T
%    rangeT   is the width of the range of possible initial Ts
%    initialT is the initial temperature that the function returns

% set initial temperature for this run using the function 'rand', which
% provides a random number from a uniform distribution between 0 and 1
initialT = minT + rangeT * rand;
