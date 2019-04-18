% script to set the values of constants used in the simulation
%--------------------------------------------------------------------------

global rndmode nplanets nreruns max_duration Tmin Tmax Trange nnodes_max
global fsd fmin fmax frange trendsd trendmin trendmax trendrange nbinsd

% first of all set flags
verbose = 0;        % '1' = lots of print statements and plots, '0' = few
rndmode = 1;        % '1' = truly random, '2' = deterministically random (same every run)

% set values of constants
nplanets = 1000;                % no. of distinct planets
nreruns = 50;                  % no of times each planet is rerun from scratch
nruns = nplanets*nreruns;     % total number of runs to carry out
ntaskruns = 250;               % max number of runs per task; (parallel code)
maxntasks = ceil(2*nreruns/ntaskruns);   % maximum number of tasks per simulation
ntasksperjob = 200;           % seems to fall over at more than 250 tasks
njobs = ceil(nruns/(ntaskruns*ntasksperjob));   % the number of jobs needed for the whole simulation
ntasks = ceil(nruns/ntaskruns); % number of tasks per simulation
max_duration = 3e6;           % length of run: 3 billion y = 3 million ky
Tmin = double(-10.0);         % minimum habitable temperature (lower limit of habitable range) (degrees C)
Tmax = double(60.0);          % maximum habitable temperature (upper limit of habitable range) (degrees C)
Trange = Tmax-Tmin;           % width of habitable envelope (degrees C)
nnodes_max = 20;              % number of node points at which dT/dt needs to be specified
fsd = 100.0;               % standard deviation of feedback strengths (degrees C per ky)
fmax = +4 * fsd;           % maximum likely feedback strength (4 sigma) (degrees C per ky)
fmin = -4 * fsd;           % minimum likely feedback strength (-4 sigma) (degrees C per ky)
frange = 2 * fsd * 4;      % range of likely feedback values (+/- 4 sigma) (degrees C per ky)
trendsd = 50.0;            % standard deviatio of trends in dT/dt (degrees C per ky per By)
trendmax = +4 * trendsd;   % maximum likely trend in dT/dt (degrees C per ky per By)
trendmin = -4 * trendsd;   % minimum likely trend in dT/dt (degrees C per ky per By)
trendrange = 2*trendsd*4;  % range of likely trend values (+/- 4 sigma) (degrees C per ky per By)
nbinsd = 20;                  % default number of bins for the histograms

% automatically construct a results directory name from the date, size and
% a stub indicating the platform on which it is run
str = datestr(now);
savename = sprintf('SA25_I4_%dx%d_%s%s%s', nplanets, nreruns, ...
   str(1:2), str(4:6), str(8:11));
% savename = sprintf('SA25_I4_1000x50_05Apr2017');

% parameters controlling numbers of 3 different classes of perturbations.
% These numbers are the maximum average numbers, i.e. the largest expected
% values, i.e. the values corresponding to those neighbourhoods in which
% there is the greatest frequency of perturbations
maxavnumber_littlep = 20000;
maxavnumber_midp = 400;
maxavnumber_bigp = 5;
% parameters controlling magnitudes of 3 different classes of perturbations
littlep_mean = 2.0;
littlep_std = 1.0;
midp_mean = 8.0;
midp_std = 4.0;
bigp_mean = 32.0;
bigp_std = 16.0;
% likely upper limit on magnitude of largest perturbation (99.994% of a
% normal distribution lies within +/- 4 standard deviations) 
exp_pmax = bigp_mean+(4.0*bigp_std);


