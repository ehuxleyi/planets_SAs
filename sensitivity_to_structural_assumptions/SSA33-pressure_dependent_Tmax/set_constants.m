% script to set the values of constants used in the simulation
%--------------------------------------------------------------------------

global rndmode nplanets nreruns max_duration nnodes_max nbinsd
% <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
global Tmin Tmax Tmax0 Trange0
global Pmin Pmax Prange
global fTsd fTmin fTmax fTrange trendTsd trendTmin trendTmax trendTrange 
global fPsd fPmin fPmax fPrange trendPsd trendPmin trendPmax trendPrange 

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
% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
% Tmax0 is the maximum possible value of Tmax, i.e. the value at Tmax at
% Pmax, the highest possible atmospheric pressure (10 MPa)
Tmax0 = double(301.33);      % maximum habitable temperature (upper limit of habitable range) (degrees C)
Trange0 = Tmax0-Tmin;        % width of habitable envelope (degrees C)
% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
Pmin = double(-100.0);       % minimum P (arbitrary units)
Pmax = double(100.0);        % maximum P (arbitrary units)
Prange = Pmax-Pmin;          % width of P range
nnodes_max = 20;             % number of node points at which dT/dt needs to be specified
% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
fTsd = 100.0;                % standard deviation of feedback strengths (degrees C per ky)
fTmax = +4 * fTsd;           % maximum likely feedback strength (4 sigma) (degrees C per ky)
fTmin = -4 * fTsd;           % minimum likely feedback strength (-4 sigma) (degrees C per ky)
fTrange = 2 * fTsd * 4;      % range of likely feedback values (+/- 4 sigma) (degrees C per ky)
fPsd = 100.0;                % standard deviation of feedback strengths
fPmax = +4 * fPsd;           % maximum likely feedback strength (4 sigma)
fPmin = -4 * fPsd;           % minimum likely feedback strength (-4 sigma)
fPrange = 2 * fPsd * 4;      % range of likely feedback values (+/- 4 sigma)
% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
trendTsd = 50.0;             % standard deviation of trends in dT/dt (degrees C per ky per By)
trendTmax = +4 * trendTsd;   % maximum likely trend in dT/dt (degrees C per ky per By)
trendTmin = -4 * trendTsd;   % minimum likely trend in dT/dt (degrees C per ky per By)
trendTrange = 2*trendTsd*4;  % range of likely trend values (+/- 4 sigma) (degrees C per ky per By)
trendPsd = 50.0;             % standard deviation of trends in dP/dt
trendPmax = +4 * trendPsd;   % maximum likely trend in dT/dt
trendPmin = -4 * trendPsd;   % minimum likely trend in dT/dt
trendPrange = 2*trendPsd*4;  % range of likely trend values (+/- 4 sigma)
nbinsd = 20;                 % default number of bins for the histograms

% automatically construct a results directory name from the date, size and
% a stub indicating the platform on which it is run
str = datestr(now);
savename = sprintf('SA33_I4_%dx%d_%s%s%s', nplanets, nreruns, ...
   str(1:2), str(4:6), str(8:11));
% savename = sprintf('SA33_I4_1000x50_30Apr2017');

% parameters controlling numbers of 3 different classes of perturbations.
% These numbers are the maximum average numbers, i.e. the largest expected
% values, i.e. the values corresponding to those neighbourhoods in which
% there is the greatest frequency of perturbations
% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
% decrease the perturbation frequencies by 2 because 2 different variables
% all affected by each perturbation
maxavnumber_littlep = 20000/2;
littlep_mean = 2.0;
littlep_std = 1.0;
maxavnumber_midp = 400/2;
midp_mean = 8.0;
midp_std = 4.0;
maxavnumber_bigp = 5/2;
bigp_mean = 32.0;
bigp_std = 16.0;

% likely upper limit on magnitude of largest perturbation (99.994% of a
% normal distribution lies within +/- 4 standard deviations) 
exp_pmax = bigp_mean+(4.0*bigp_std);

