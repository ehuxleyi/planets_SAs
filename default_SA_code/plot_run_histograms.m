% script to plot comparitive frequency distributions for runs
% [all runs versus habitable runs]
% -------------------------------------------------------------------------

% first multi-panel figure for run bar charts (part 1, all runs)
f = figure(42); clf('reset');
set (f, 'Position', [500 200 400 800]);

% bar chart of distributions versus maximum potential perturbation if run
% goes all the way
subplot(6,1,1);
prange = 2.0*exp_pmax;
thisgap = prange/nbinsd;
x = (-exp_pmax+(thisgap/2.0)) : thisgap : (exp_pmax-(thisgap/2.0));
bar(x,fr_maxpotps(:,1));
xlim([-exp_pmax exp_pmax]);
xlabel('max. potential perturbation'); ylabel('freq.');

% bar chart of distributions versus maximum experienced (actual)
% perturbation 
subplot(6,1,2);
prange = 2.0*exp_pmax;
thisgap = prange/nbinsd;
x = (-exp_pmax+(thisgap/2.0)) : thisgap : (exp_pmax-(thisgap/2.0));
bar(x,fr_maxactps(:,1));
xlim([-exp_pmax exp_pmax]);
xlabel('max. actual perturbation'); ylabel('freq.');

% bar chart of distributions versus initial (starting) temperature
subplot(6,1,3);
x = (Tmin+(Trange/(2*nbinsd))) : (Trange/nbinsd) : ...
    (Tmax-(Trange/(2*nbinsd)));
bar(x,fr_initTs(:,1));
xlim([Tmin Tmax]);
xlabel('initial T'); ylabel('freq.');

% bar chart of distributions versus standard deviation of temperature
% during the run
subplot(6,1,4);
x = (25/(2*nbinsd)) : (25/nbinsd) : (25-(25/(2*nbinsd)));
bar(x,fr_stdTs(:,1));
xlim([0 25]);
xlabel('standard deviation of T'); ylabel('freq.');

% bar chart of distributions versus average trend (from line-fitting) in
% observed temperature over time
subplot(6,1,5);
x = (-90+(180/(2*nbinsd))) : (180/nbinsd) : (90-(180/(2*nbinsd)));
bar(x,fr_trendTs(:,1));
xlim([-90 90]);
trendtext = sprintf('slope of actual trend in T (%cC per 10My, as an angle)', char(176));
xlabel(trendtext); ylabel('freq.');

% bar chart of distributions versus mode (most frequent) temperature during
% run
subplot(6,1,6);
x = ((Tmin-10)+((Trange+20)/(2*nbinsd))) : ((Trange+20)/nbinsd) : ...
    ((Tmax+10)-((Trange+20)/(2*nbinsd)));
bar(x,fr_modeTs(:,1));
xlim([(Tmin-10) (Tmax+10)]);
xlabel('mode T'); ylabel('freq.');

% title for this figure (not for the subplot)
[a,h] = suplabel('Run Bar Charts 1 (for all runs)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% second multi-panel figure for run barc harts (part 1, hab runs)
f = figure(43); clf('reset');
set (f, 'Position', [600 200 400 800]);

% bar chart of distributions versus maximum perturbation if run
% goes all the way
subplot(6,1,1);
thisgap = (2.0*exp_pmax)/nbinsd;
x = (-exp_pmax+(thisgap/2.0)) : thisgap : (exp_pmax-(thisgap/2.0));
bar(x,fr_maxpotps(:,2));
xlim([-exp_pmax exp_pmax]);
xlabel('max. potential perturbation'); ylabel('freq.');

% bar chart of distributions versus maximum experienced (actual)
% perturbation 
subplot(6,1,2);
thisgap = (2.0*exp_pmax)/nbinsd;
x = (-exp_pmax+(thisgap/2.0)) : thisgap : (exp_pmax-(thisgap/2.0));
bar(x,fr_maxactps(:,2));
xlim([-exp_pmax exp_pmax]);
xlabel('max. actual perturbation'); ylabel('freq.');

% bar chart of distributions versus initial (starting) temperature
subplot(6,1,3);
x = (Tmin+(Trange/(2*nbinsd))) : (Trange/nbinsd) : ...
    (Tmax-(Trange/(2*nbinsd)));
bar(x,fr_initTs(:,2));
xlim([Tmin Tmax]);
xlabel('initial T'); ylabel('freq.');

% bar chart of distributions versus standard deviation of temperature
% during the run
subplot(6,1,4);
x = (25/(2*nbinsd)) : (25/nbinsd) : (25-(25/(2*nbinsd)));
bar(x,fr_stdTs(:,2));
xlim([0 25]);
xlabel('standard deviation of T'); ylabel('freq.');

% bar chart of distributions versus average trend (from line-fitting) in
% observed temperature over time
subplot(6,1,5);
x = (-90+(180/(2*nbinsd))) : (180/nbinsd) : (90-(180/(2*nbinsd)));
bar(x,fr_trendTs(:,2));
xlim([-90 90]);
xlabel(trendtext); ylabel('freq.');

% bar chart of distributions versus mode (most frequent) temperature during
% run
subplot(6,1,6);
x = ((Tmin-10)+((Trange+20)/(2*nbinsd))) : ((Trange+20)/nbinsd) : ...
    ((Tmax+10)-((Trange+20)/(2*nbinsd)));
bar(x,fr_modeTs(:,2));
xlim([(Tmin-10) (Tmax+10)]);
xlabel('mode T'); ylabel('freq.');

% title for this figure (not for the subplot)
[a,h] = suplabel('Run Bar Charts 1 (for hab runs)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% third multi-panel figure for run bar charts (part 2, all runs)
f = figure(44); clf('reset');
set (f, 'Position', [700 200 400 800]);

% bar chart of distributions versus fractions of time spent outside any SAs
subplot(6,1,1);
x = (1.0/(2*nbinsd)) : (1.0/nbinsd) : (((2*nbinsd)-1)*1.0/(2*nbinsd));
bar(x,fr_timeouts(:,1));
xlim([0 1]);
xlabel('fraction of time outwith SAs'); ylabel('freq.');

% bar chart of distributions versus fractions of time spent within SAs
subplot(6,1,2);
x = (1/(2*nbinsd)) : (1.0/nbinsd) : (((2*nbinsd)-1)*1.0/(2*nbinsd));
bar(x,fr_timesas(:,1));
xlim([0 1]);
xlabel('fraction of time within SAs'); ylabel('freq.');

% bar chart of distributions versus fractions of time spent within the most
% powerful SA
subplot(6,1,3);
x = (1.0/(2*nbinsd)) : (1.0/nbinsd) : (((2*nbinsd)-1)*1.0/(2*nbinsd));
bar(x,fr_timepowsas(:,1));
xlim([0 1]);
xlabel('fraction of time within most powerful SA'); ylabel('freq.');

% bar chart of distributions versus fractions of time spent within the most
% occupied SA
subplot(6,1,4);
x = (1.0/(2*nbinsd)) : (1.0/nbinsd) : (((2*nbinsd)-1)*1.0/(2*nbinsd));
bar(x,fr_timeoccsas(:,1));
xlim([0 1]);
xlabel('fraction of time within most occupied SA'); ylabel('freq.');

% bar chart of distributions versus run durations
subplot(6,1,5);
x = (3.0/(2*nbinsd)) : (3.0/nbinsd) : (((2*nbinsd)-1)*3.0/(2*nbinsd));
bar(x,fr_durations);
xlim([0 (max_duration/1e6)]);
xlabel('run duration (By)'); ylabel('freq.');

% title for this figure (not for the subplot)
[a,h] = suplabel('Run Bar Charts 2 (for all runs)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% fourth multi-panel figure for run bar charts (part 2, hab runs)
f = figure(45); clf('reset');
set (f, 'Position', [800 200 400 800]);

% bar chart of distributions versus fractions of time spent outside any SAs
subplot(6,1,1);
x = (1.0/(2*nbinsd)) : (1.0/nbinsd) : (((2*nbinsd)-1)*1.0/(2*nbinsd));
bar(x,fr_timeouts(:,2));
xlim([0 1]);
xlabel('fraction of time outwith SAs'); ylabel('freq.');

% bar chart of distributions versus fractions of time spent within SAs
subplot(6,1,2);
x = (1/(2*nbinsd)) : (1.0/nbinsd) : (((2*nbinsd)-1)*1.0/(2*nbinsd));
bar(x,fr_timesas(:,2));
xlim([0 1]);
xlabel('fraction of time within SAs'); ylabel('freq.');

% bar chart of distributions versus fractions of time spent within the most
% powerful SA
subplot(6,1,3);
x = (1.0/(2*nbinsd)) : (1.0/nbinsd) : (((2*nbinsd)-1)*1.0/(2*nbinsd));
bar(x,fr_timepowsas(:,2));
xlim([0 1]);
xlabel('fraction of time within most powerful SA'); ylabel('freq.');

% bar chart of distributions versus fractions of time spent within the most
% occupied SA
subplot(6,1,4);
x = (1.0/(2*nbinsd)) : (1.0/nbinsd) : (((2*nbinsd)-1)*1.0/(2*nbinsd));
bar(x,fr_timeoccsas(:,2));
xlim([0 1]);
xlabel('fraction of time within most occupied SA'); ylabel('freq.');

% title for this figure (not for the subplot)
[a,h] = suplabel('Run Bar Charts 2 (for hab runs)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% ###### NOW DO IT ALL AGAIN BUT ALLOWING MATLAB TO CALCULATE THE ######
% ###### HISTOGRAMS RATHER THAN DOING MANUALLY                    ######

% first multi-panel figure for run histograms (part 1, all runs)
f = figure(46); clf('reset');
set (f, 'Position', [900 200 400 800]);

% histogram of distributions versus maximum potential perturbation if run
% goes all the way
subplot(6,1,1);
bargap = 2.0*exp_pmax/nbinsd;
edges = (-exp_pmax) : bargap : exp_pmax;
hcounts = histc(allruns_maxpotps,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([-exp_pmax exp_pmax]);
xlabel('max. potential perturbation'); ylabel('count.');

% histogram of distributions versus maximum experienced (actual)
% perturbation 
subplot(6,1,2);
bargap = 2.0*exp_pmax/nbinsd;
edges = (-exp_pmax) : bargap : exp_pmax;
hcounts = histc(allruns_maxactps,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([-exp_pmax exp_pmax]);
xlabel('max. actual perturbation'); ylabel('count.');

% histogram of distributions versus initial (starting) temperature
subplot(6,1,3);
bargap = Trange/nbinsd;
edges = Tmin : bargap : Tmax;
hcounts = histc(allruns_initTs,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([Tmin Tmax]);
xlabel('initial T'); ylabel('count.');

% histogram of distributions versus standard deviation of temperature
% during the run
subplot(6,1,4);
bargap = 25.0/nbinsd;
edges = 0.0 : bargap : 25.0;
hcounts = histc(allruns_stdTs,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0.0 25.0]);
xlabel('standard deviation of T'); ylabel('count.');

% histogram of distributions versus average trend (from line-fitting) in
% observed temperature over time
subplot(6,1,5);
bargap = 180.0/nbinsd;
edges = -90.0 : bargap : 90.0;
hcounts = histc(allruns_trendTs,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([-90.0 90.0]);
xlabel(trendtext); ylabel('count.');

% histogram of distributions versus mode (most frequent) temperature during
% run
subplot(6,1,6);
bargap = (Trange+20.0)/nbinsd;
edges = (Tmin-10.0) : bargap : (Tmax+10.0);
hcounts = histc(allruns_modeTs,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([(Tmin-10.0) (Tmax+10.0)]);
xlabel('mode T'); ylabel('count.');

% title for this figure (not for the subplot)
[a,h] = suplabel('Run Histograms 1 (for all runs)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% second multi-panel figure for run histograms (part 1, hab runs)
f = figure(47); clf('reset');
set (f, 'Position', [1000 200 400 800]);

% histogram of distributions versus maximum potential perturbation if run
% goes all the way
subplot(6,1,1);
prange = 2.0*exp_pmax;
bargap = prange/nbinsd;
edges = (-exp_pmax) : bargap : exp_pmax;
hcounts = histc(goodruns_maxpotps,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([-exp_pmax exp_pmax]);
xlabel('max. potential perturbation'); ylabel('count.');

% histogram of distributions versus maximum experienced (actual)
% perturbation 
subplot(6,1,2);
prange = 2.0*exp_pmax;
bargap = prange/nbinsd;
edges = (-exp_pmax) : bargap : exp_pmax;
hcounts = histc(goodruns_maxactps,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([-exp_pmax exp_pmax]);
xlabel('max. actual perturbation'); ylabel('count.');

% histogram of distributions versus initial (starting) temperature
subplot(6,1,3);
bargap = Trange/nbinsd;
edges = Tmin : bargap : Tmax;
hcounts = histc(goodruns_initTs,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([Tmin Tmax]);
xlabel('initial T'); ylabel('count.');

% histogram of distributions versus standard deviation of temperature
% during the run
subplot(6,1,4);
bargap = 25.0/nbinsd;
edges = 0.0 : bargap : 25.0;
hcounts = histc(goodruns_stdTs,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0.0 25.0]);
xlabel('standard deviation of T'); ylabel('count.');

% histogram of distributions versus average trend (from line-fitting) in
% observed temperature over time
subplot(6,1,5);
bargap = 180.0/nbinsd;
edges = -90.0 : bargap : 90.0;
hcounts = histc(goodruns_trendTs,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([-90.0 90.0]);
xlabel(trendtext); ylabel('count.');

% histogram of distributions versus mode (most frequent) temperature during
% run
subplot(6,1,6);
bargap = (Trange+20.0)/nbinsd;
edges = (Tmin-10.0) : bargap : (Tmax+10.0);
hcounts = histc(goodruns_modeTs,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([(Tmin-10.0) (Tmax+10.0)]);
xlabel('mode T'); ylabel('count.');

% title for this figure (not for the subplot)
[a,h] = suplabel('Run Histograms 1 (for hab runs)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% third multi-panel figure for run histograms (part 2, all runs)
f = figure(48); clf('reset');
set (f, 'Position', [1100 200 400 800]);

% histogram of distributions versus fractions of time spent outside any SAs
subplot(6,1,1);
bargap = (1.0/nbinsd);
edges = 0.0 : bargap : 1.0;
hcounts = histc(allruns_timeouts,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0 1]);
xlabel('fraction of time outwith SAs'); ylabel('count.');

% histogram of distributions versus fractions of time spent within SAs
subplot(6,1,2);
bargap = (1.0/nbinsd);
edges = 0.0 : bargap : 1.0;
hcounts = histc(allruns_timesas,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0 1]);
xlabel('fraction of time within SAs'); ylabel('count.');

% histogram of distributions versus fractions of time spent within the most
% powerful SA
subplot(6,1,3);
bargap = (1.0/nbinsd);
edges = 0.0 : bargap : 1.0;
hcounts = histc(allruns_timepowsas,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0 1]);
xlabel('fraction of time within most powerful SA'); ylabel('count.');

% histogram of distributions versus fractions of time spent within the most
% occupied SA
subplot(6,1,4);
bargap = (1.0/nbinsd);
edges = 0.0 : bargap : 1.0;
hcounts = histc(allruns_timeoccsas,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0 1]);
xlabel('fraction of time within most occupied SA'); ylabel('count.');

% histogram of distributions versus run durations
subplot(6,1,5);
bargap = ((max_duration/1e6)/nbinsd);
edges = 0.0 : bargap : (max_duration/1e6);
hcounts = histc(allruns_durations,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0 (max_duration/1e6)]);
xlabel('run duration (By)'); ylabel('count');

% title for this figure (not for the subplot)
[a,h] = suplabel('Run histograms 2 (for all runs)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% fourth multi-panel figure for run histograms (part 2, hab runs)
f = figure(49); clf('reset');
set (f, 'Position', [1200 200 400 800]);

% histogram of distributions versus fractions of time spent outside any SAs
subplot(6,1,1);
bargap = (1.0/nbinsd);
edges = 0.0 : bargap : 1.0;
hcounts = histc(goodruns_timeouts,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0 1]);
xlabel('fraction of time outwith SAs'); ylabel('count.');

% histogram of distributions versus fractions of time spent within SAs
subplot(6,1,2);
bargap = (1.0/nbinsd);
edges = 0.0 : bargap : 1.0;
hcounts = histc(goodruns_timesas,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0 1]);
xlabel('fraction of time within SAs'); ylabel('count.');

% histogram of distributions versus fractions of time spent within the most
% powerful SA
subplot(6,1,3);
bargap = (1.0/nbinsd);
edges = 0.0 : bargap : 1.0;
hcounts = histc(goodruns_timepowsas,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0 1]);
xlabel('fraction of time within most powerful SA'); ylabel('count.');

% histogram of distributions versus fractions of time spent within the most
% occupied SA
subplot(6,1,4);
bargap = (1.0/nbinsd);
edges = 0.0 : bargap : 1.0;
hcounts = histc(goodruns_timeoccsas,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0 1]);
xlabel('fraction of time within most occupied SA'); ylabel('count.');

% title for this figure (not for the subplot)
[a,h] = suplabel('Run histograms 2 (for hab runs)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% ###### NOW DO IT ALL AGAIN BUT THIS TIME PRODUCING GRAPHS       ######
% ###### SHOWING THE TWO PROBABILITY DISTIRBUTION FUNCTIONS       ######
% ###### (FREQUENCY DISTRIBUTIONS?)                               ######

% first multi-panel figure for run pdfs
f = figure(50); clf('reset');
set (f, 'Position', [1300 200 400 800]);

% pdfs of maximum potential perturbation if run goes all the way
subplot(6,1,1);
thisgap = (2.0*exp_pmax)/nbinsd;
x = (-exp_pmax+(thisgap/2.0)) : thisgap : (exp_pmax-(thisgap/2.0));
plot(x,fr_maxpotps(:,1),'-k^',x,fr_maxpotps(:,2),'-ro');
xlim([-exp_pmax exp_pmax]);
legend('all', 'survivors', 'Location', 'best');
xlabel('max. potential perturbation'); ylabel('probability');

% pdfs of maximum perturbation actually encountered up until the run ended
subplot(6,1,2);
thisgap = (2.0*exp_pmax)/nbinsd;
x = (-exp_pmax+(thisgap/2.0)) : thisgap : (exp_pmax-(thisgap/2.0));
plot(x,fr_maxactps(:,1),'-k^',x,fr_maxactps(:,2),'-ro');
xlim([-exp_pmax exp_pmax]);
xlabel('max. actual perturbation'); ylabel('probability');

% pdfs of initial (starting) temperature
subplot(6,1,3);
thisgap = Trange/nbinsd;
x = (Tmin+(thisgap/2.0)) : thisgap : (Tmax-(thisgap/2.0));
plot(x,fr_initTs(:,1),'-k^',x,fr_initTs(:,2),'-ro');
xlim([Tmin Tmax]);
xlabel('initial T'); ylabel('probability');

% pdfs of standard deviation of temperature during the run
subplot(6,1,4);
thisgap = 25.0/nbinsd;
x = (thisgap/2.0) : thisgap : (25.0-(thisgap/2.0));
plot(x,fr_stdTs(:,1),'-k^',x,fr_stdTs(:,2),'-ro');
xlim([0.0 25.0]);
xlabel('standard deviation of T'); ylabel('probability');

% pdfs of average trend over time (from line-fitting) of observed
% temperature
subplot(6,1,5);
thisgap = 180.0/nbinsd;
x = (-90.0+(thisgap/2.0)) : thisgap : (90.0-(thisgap/2.0));
plot(x,fr_trendTs(:,1),'-k^',x,fr_trendTs(:,2),'-ro');
xlim([-90.0 90.0]);
xlabel(trendtext); ylabel('probability');

% pdfs of mode (most frequent) temperature during run
subplot(6,1,6);
thisgap = (Trange+20.0)/nbinsd;
x = ((Tmin-10)+(thisgap/2.0)) : thisgap : ((Tmax+10)-(thisgap/2.0));
plot(x,fr_modeTs(:,1),'-k^',x,fr_modeTs(:,2),'-ro');
xlim([(Tmin-10) (Tmax+10)]);
xlabel('mode T'); ylabel('probability');

[a,h] = suplabel('Run PDFs 1');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% second multi-panel figure for run pdfs
f = figure(51); clf('reset');
set (f, 'Position', [1400 200 400 800]);

% pdfs of fractions of time spent outside any SAs
subplot(5,1,1);
thisgap = 1.0/nbinsd;
x = (thisgap/2.0) : thisgap : (1.0-(thisgap/2.0));
plot(x,fr_timeouts(:,1),'-k^',x,fr_timeouts(:,2),'-ro');
xlim([0.0 1.0]);
legend('all', 'survivors', 'Location', 'best');
xlabel('fraction of time outwith SAs'); ylabel('probability');

% pdfs of fractions of time spent within SAs
subplot(5,1,2);
thisgap = 1.0/nbinsd;
x = (thisgap/2.0) : thisgap : (1.0-(thisgap/2.0));
plot(x,fr_timesas(:,1),'-k^',x,fr_timesas(:,2),'-ro');
xlim([0.0 1.0]);
xlabel('fraction of time within SAs'); ylabel('probability');

% pdfs of fractions of time spent within the most powerful SA
subplot(5,1,3);
thisgap = 1.0/nbinsd;
x = (thisgap/2.0) : thisgap : (1.0-(thisgap/2.0));
plot(x,fr_timepowsas(:,1),'-k^',x,fr_timepowsas(:,2),'-ro');
xlim([0.0 1.0]);
xlabel('fraction of time within most powerful SA'); ylabel('probability');

% pdfs of fractions of time spent within the most occupied SA
subplot(5,1,4);
thisgap = 1.0/nbinsd;
x = (thisgap/2.0) : thisgap : (1.0-(thisgap/2.0));
plot(x,fr_timeoccsas(:,1),'-k^',x,fr_timeoccsas(:,2),'-ro');
xlim([0.0 1.0]);
xlabel('fraction of time within most occupied SA'); ylabel('probability');

% pdfs of run durations
subplot(5,1,5);
thisgap = (max_duration/1e6)/nbinsd;
x = (thisgap/2.0) : thisgap : ((max_duration/1e6)-(thisgap/2.0));
plot(x,fr_durations,'-k^');
xlim([0.0 (max_duration/1e6)]);
xlabel('run duration (By)'); ylabel('probability');

[a,h] = suplabel('Run PDFs 2');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% ###### FINALLY DO IT ALL AGAIN BUT THIS TIME SHOWING THE    #######
% ###### DISTRIBUTION OF HABITABLE PLANETS COMPARED TO THE    #######
% ###### EXPECTED DISTRIBUTION IF WHAT IT IS PLOTTED AGAINST  #######
% ###### HAS NO EFFECT ON OR CONNECTION WITH HABITABILITY     #######

% there are more habitable planets in this bin than expected if
% fr_xxxx(i,2) > fr_xxxx(i,1)

% first multi-panel figure for run ratios
f = figure(52); clf('reset');
set (f, 'Position', [1300 200 400 800]);

% ratios of maximum potential perturbation if run goes all the way
subplot(6,1,1);
thisgap = (2.0*exp_pmax)/nbinsd;
x = (-exp_pmax+(thisgap/2.0)) : thisgap : (exp_pmax-(thisgap/2.0));
plot(x,ratio_maxpotps(:),'-bo');
xlim([-exp_pmax exp_pmax]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('max. potential perturbation'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_maxpotps(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex');
   end;
end;

% ratios of maximum perturbation actually encountered up until the run ended
subplot(6,1,2);
thisgap = (2.0*exp_pmax)/nbinsd;
x = (-exp_pmax+(thisgap/2.0)) : thisgap : (exp_pmax-(thisgap/2.0));
plot(x,ratio_maxactps(:),'-bo');
xlim([-exp_pmax exp_pmax]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('max. actual perturbation'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_maxactps(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex');
   end;
end;

% ratios of initial (starting) temperature
subplot(6,1,3);
thisgap = Trange/nbinsd;
x = (Tmin+(thisgap/2.0)) : thisgap : (Tmax-(thisgap/2.0));
plot(x,ratio_initTs(:),'-bo');
xlim([Tmin Tmax]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('initial T'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_initTs(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex');
   end;
end;

% ratios of standard deviation of temperature during the run
subplot(6,1,4);
thisgap = 25.0/nbinsd;
x = (thisgap/2.0) : thisgap : (25.0-(thisgap/2.0));
plot(x,ratio_stdTs(:),'-bo');
xlim([0.0 25.0]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('standard deviation of T'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_stdTs(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex');
   end;
end;

% ratios of average trend over time (from line-fitting) of observed
% temperature
subplot(6,1,5);
thisgap = 180.0/nbinsd;
x = (-90.0+(thisgap/2.0)) : thisgap : (90.0-(thisgap/2.0));
plot(x,ratio_trendTs(:),'-bo');
xlim([-90.0 90.0]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel(trendtext); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_trendTs(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end;
end;

% ratios of mode (most frequent) temperature during run
subplot(6,1,6);
thisgap = (Trange+20.0)/nbinsd;
x = ((Tmin-10)+(thisgap/2.0)) : thisgap : ((Tmax+10)-(thisgap/2.0));
plot(x,ratio_modeTs(:),'-bo');
xlim([(Tmin-10) (Tmax+10)]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('mode T'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_modeTs(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end;
end;

[a,h] = suplabel('Run ratios 1');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% second multi-panel figure for run ratios
f = figure(53); clf('reset');
set (f, 'Position', [1400 200 400 800]);

% ratios of fractions of time spent outside any SAs
subplot(6,1,1);
thisgap = 1.0/nbinsd;
x = (thisgap/2.0) : thisgap : (1.0-(thisgap/2.0));
plot(x,ratio_timeouts(:),'-bo');
xlim([0.0 1.0]); ylim([0 4]); 
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('fraction of time outwith SAs'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_timeouts(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex');; 
   end;
end;
 
% ratios of fractions of time spent within SAs
subplot(6,1,2);
thisgap = 1.0/nbinsd;
x = (thisgap/2.0) : thisgap : (1.0-(thisgap/2.0));
plot(x,ratio_timesas(:),'-bo');
xlim([0.0 1.0]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('fraction of time within SAs'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_timesas(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end;
end;

% ratios of fractions of time spent within the most powerful SA
subplot(6,1,3);
thisgap = 1.0/nbinsd;
x = (thisgap/2.0) : thisgap : (1.0-(thisgap/2.0));
plot(x,ratio_timepowsas(:),'-bo');
xlim([0.0 1.0]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('fraction of time within most powerful SA'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_timepowsas(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex');
   end;
end;

% ratios of fractions of time spent within the most occupied SA
subplot(6,1,4);
thisgap = 1.0/nbinsd;
x = (thisgap/2.0) : thisgap : (1.0-(thisgap/2.0));
plot(x,ratio_timeoccsas(:),'-bo');
xlim([0.0 1.0]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('fraction of time within most occupied SA'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_timeoccsas(nn)>4)
       text((x(nn)-(thisgap/6)),3.5,'\uparrow', 'interpreter', 'tex'); 
   end;
end;

[a,h] = suplabel('Run ratios 2');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');
