% This script sets the starting temperature of a planet.
% Every planet starts off habitable, so this is done by randomly choosing
% (uniform distribution) a temperature from within the habitable range.
%--------------------------------------------------------------------------

function [initialT, initialH1, initialH2, initialH3] = ...
    determine_initial_values(minT, rangeT)

% where:
%    planet  is the planet number,
%    runs    is the list of run numbers
%    minT    is the minimum possible initial T
%    rangeT  is the width of the range of possible initial Ts
%    initialT  is the initial temperature that the function returns
%    initialH1 is the initial H1 value that the function returns
%    initialH2 is the initial H2 value that the function returns
%    initialH3 is the initial value that the function returns

% set initial temperature for this run using a random number from a
% uniform distribution between minT and maxT
initialT = minT + rangeT * rand;

% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
% initialise all hidden variables to random values, chosen from a uniform
% distribution between -100 and +100
initialH1 = 200.0*rand - 100.0;
initialH2 = 200.0*rand - 100.0;
initialH3 = 200.0*rand - 100.0;
