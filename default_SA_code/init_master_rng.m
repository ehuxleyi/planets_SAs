% script to initialise the random number generator (seed it appropriately)

if (rndmode == 1) % truly random
    rng('shuffle', 'twister');
else % 'deterministically random' (same set of random numbers every time)
    rng(nplanets);
    error('rndmode should be 1');
end;