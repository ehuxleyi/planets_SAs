% script to set the values of constants used in the simulation
%--------------------------------------------------------------------------

global nplanets nreruns max_duration nnodes_max nbinsd
global Tmin Tmax H1min H1max H2min H2max H3min H3max
global Tgap H1gap H2gap H3gap
global nTnodes nH1nodes nH2nodes nH3nodes
global H1range H2range H3range
global Tnodes Tfeedbacks H1nodes H1feedbacks H2nodes H2feedbacks 
global H3nodes H3feedbacks 
global trendT trendH1 trendH2 trendH3
global rndmode
global k1 k2 k3 k4 k5 k6
global fTsd fTmin fTmax fTrange trendTsd trendTmin trendTmax trendTrange 
global fH1sd fH1min fH1max fH1range trendH1sd trendH1min trendH1max trendH1range 
global fH2sd fH2min fH2max fH2range trendH2sd trendH2min trendH2max trendH2range 
global fH3sd fH3min fH3max fH3range trendH3sd trendH3min trendH3max trendH3range 

% first of all set flags
verbose = 0;        % '1' = lots of print statements and plots, '0' = few
rndmode = 1;        % '1' = truly random, '2' = deterministically random (same every run)

% set values of constants
nplanets = 50000;                % no. of distinct planets
nreruns = 50;                  % no of times each planet is rerun from scratch
nruns = nplanets*nreruns;     % total number of runs to carry out
ntaskruns = 12500;               % max number of runs per task; (parallel code)
maxntasks = ceil(2*nreruns/ntaskruns);   % maximum number of tasks per simulation
ntasksperjob = 200;           % seems to fall over at more than 250 tasks
njobs = ceil(nruns/(ntaskruns*ntasksperjob));   % the number of jobs needed for the whole simulation
ntasks = ceil(nruns/ntaskruns); % number of tasks per simulation
max_duration = 3e6;           % length of run: 3 billion y = 3 million ky
Tmin = double(-10.0);         % minimum habitable temperature (lower limit of habitable range) (degrees C)
Tmax = double(60.0);          % maximum habitable temperature (upper limit of habitable range) (degrees C)
Trange = Tmax-Tmin;           % width of habitable envelope (degrees C)
% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
H1min = double(-100.0);      % minimum H1
H1max = double(100.0);       % maximum H1
H1range = H1max-H1min;       % width of H1 range
H2min = double(-100.0);      % minimum H2
H2max = double(100.0);       % maximum H2
H2range = H2max-H2min;       % width of H2 range
H3min = double(-100.0);      % minimum H3
H3max = double(100.0);       % maximum H3
H3range = H3max-H3min;       % width of H3 range
nnodes_max = 20;              % number of node points at which dT/dt needs to be specified
% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
fTsd = 100.0;               % standard deviation of feedback strengths (degrees C per ky)
fTmax = +4 * fTsd;           % maximum likely feedback strength (4 sigma) (degrees C per ky)
fTmin = -4 * fTsd;           % minimum likely feedback strength (-4 sigma) (degrees C per ky)
fTrange = 2 * fTsd * 4;      % range of likely feedback values (+/- 4 sigma) (degrees C per ky)
fH1sd = 100.0;               % standard deviation of feedback strengths (degrees C per ky)
fH1max = +4 * fH1sd;           % maximum likely feedback strength (4 sigma) (degrees C per ky)
fH1min = -4 * fH1sd;           % minimum likely feedback strength (-4 sigma) (degrees C per ky)
fH1range = 2 * fH1sd * 4;      % range of likely feedback values (+/- 4 sigma) (degrees C per ky)
fH2sd = 100.0;               % standard deviation of feedback strengths (degrees C per ky)
fH2max = +4 * fH2sd;           % maximum likely feedback strength (4 sigma) (degrees C per ky)
fH2min = -4 * fH2sd;           % minimum likely feedback strength (-4 sigma) (degrees C per ky)
fH2range = 2 * fH2sd * 4;      % range of likely feedback values (+/- 4 sigma) (degrees C per ky)
fH3sd = 100.0;               % standard deviation of feedback strengths (degrees C per ky)
fH3max = +4 * fH3sd;           % maximum likely feedback strength (4 sigma) (degrees C per ky)
fH3min = -4 * fH3sd;           % minimum likely feedback strength (-4 sigma) (degrees C per ky)
fH3range = 2 * fH3sd * 4;      % range of likely feedback values (+/- 4 sigma) (degrees C per ky)
% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
trendTsd = 50.0;            % standard deviation of trends in dT/dt (degrees C per ky per By)
trendTmax = +4 * trendTsd;   % maximum likely trend in dT/dt (degrees C per ky per By)
trendTmin = -4 * trendTsd;   % minimum likely trend in dT/dt (degrees C per ky per By)
trendTrange = 2*trendTsd*4;  % range of likely trend values (+/- 4 sigma) (degrees C per ky per By)
trendH1sd = 50.0;            % standard deviation of trends in dH1/dt
trendH1max = +4 * trendH1sd;   % maximum likely trend in dT/dt
trendH1min = -4 * trendH1sd;   % minimum likely trend in dT/dt
trendH1range = 2*trendH1sd*4;  % range of likely trend values (+/- 4 sigma)
trendH2sd = 50.0;            % standard deviation of trends in dH2/dt
trendH2max = +4 * trendH2sd;   % maximum likely trend in dT/dt
trendH2min = -4 * trendH2sd;   % minimum likely trend in dT/dt
trendH2range = 2*trendH2sd*4;  % range of likely trend values (+/- 4 sigma)
trendH3sd = 50.0;            % standard deviation of trends in dH3/dt
trendH3max = +4 * trendH3sd;   % maximum likely trend in dT/dt
trendH3min = -4 * trendH3sd;   % minimum likely trend in dT/dt
trendH3range = 2*trendH3sd*4;  % range of likely trend values (+/- 4 sigma)
nbinsd = 20;                  % default number of bins for the histograms

% automatically construct a results directory name from the date, size and
% a stub indicating the platform on which it is run
str = datestr(now);
savename = sprintf('SA28_%dx%d_%s%s%s', nplanets, nreruns, ...
    str(1:2), str(4:6), str(8:11));
% savename = sprintf('SA28_20000x50_17Sep2017');

% parameters controlling numbers of 3 different classes of perturbations.
% These numbers are the maximum average numbers, i.e. the largest expected
% values, i.e. the values corresponding to those neighbourhoods in which
% there is the greatest frequency of perturbations
% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
% decrease the perturbation frequencies by 4 because 4 different variables
% all affected by each perturbation
maxavnumber_littlep = 20000/4;
littlep_mean = 2.0;
littlep_std = 1.0;
maxavnumber_midp = 400/4;
midp_mean = 8.0;
midp_std = 4.0;
maxavnumber_bigp = 5/4;
bigp_mean = 32.0;
bigp_std = 16.0;

% likely upper limit on magnitude of largest perturbation (99.994% of
% a normal distribution lies within +/- 4 standard deviations)
exp_pmax = bigp_mean+(4.0*bigp_std);


