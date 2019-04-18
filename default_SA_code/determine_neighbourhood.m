% This script uses random numbers to set some parameters characterising the
% 'neighbourhood' (the planet's location). Of concern here are only those
% aspects of the neighbourhood which affect the likelihood/frequency of
% experiencing different size classes of random perturbation.

% Some of the relevant neighbourhood factors are:
%   (a) the type of galaxy that the planet is in (for instance the density
%       of stars in the galaxy affects how often supernovae and GRBs will
%       be so close as to have a major effect)
%   (b) the position within the galaxy, for the same reason (stars are more
%       closely packed near the centre)
%   (c) the nature of the star that the planet orbits, such as whether
%       that star is prone to flares or superflares and if so how strong
%       and frequent they are
%   (d) the nature of the planetary system within which the planet is
%       located, including the numbers and orbital stabilities of asteroids
%       and comets
%   (e) the intensity of geological activity of the planet

% The range of different neighbourhoods is implemented here by using
% random numbers to set the "expected values" (lambda coefficients of a
% Poisson distribution) for each of the three clases of perturbation:
%   (1) frequent minor ones (amplitude chosen randomly from a normal
%       distribution with mean 2 deg C and standard deviation 1 deg C)
%   (2) occasional moderate ones (amplitude chosen randomly from a normal
%       distribution with mean 8 deg C and standard deviation 4 deg C), and
%   (3) very infrequent major ones (amplitude chosen randomly from a normal
%       distribution with mean 32 deg C and standard deviation 16 deg C)

%--------------------------------------------------------------------------

% use random numbers to determine this planet's "neighbourhood", or in
% other words to determine the expected numbers of perturbations in each
% magnitude class (it is prescribed that there must be some smaller ones
% and at least a few mid-sized ones, but need not be any larger ones)
lambda_little = maxavnumber_littlep * (0.2 + 0.8*rand);   % 4,000 to 20,000
lambda_mid =    maxavnumber_midp    * (0.1 + 0.9*rand);   % 40 to 400
lambda_big =    maxavnumber_bigp    * rand;               % 0 to 5



