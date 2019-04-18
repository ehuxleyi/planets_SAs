
% script to plot comparitive frequency distributions for planets
% [all planets versus (sometimes) habitable planets]
% -------------------------------------------------------------------------

% <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>>
% lots of replacement made in this file

% first multi-panel figure for planet histograms (part 1, all planets)
f = figure(22); clf('reset');
set (f, 'Position', [500 200 400 800]);

% bar chart of distributions versus number of nodes
subplot(6,1,1);
x = 1:nnodes_max;
bar(x,fr_nodes(:,1));
xlim([1 nnodes_max+1]);
xlabel('# nodes'); ylabel('freq');

% bar chart of distributions versus number of stable attractors
subplot(6,1,2);
x = 0:nnodes_max;   % can have 0 stable attractors
bar(x,fr_attrs(:,1));
xlim([-1 (nnodes_max/2+1)]);
xlabel('# stable attractors'); ylabel('freq');

% bar chart of distributions versus greatest stable attractor width
subplot(6,1,3);
x = (Trange/(2*nbinsd)) : (Trange/nbinsd) : ...
    (((2*nbinsd)-1)*Trange/(2*nbinsd));
bar(x,fr_widths(:,1));
xlim([0 Trange]);
xlabel('max. SA width'); ylabel('freq');

% bar chart of distributions versus greatest stable attractor strength
subplot(6,1,4);
x = (fTrange/(4*nbinsd)) : (fTrange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*fTrange/(4*nbinsd));
bar(x,fr_strengths(:,1));
xlim([0 (fTrange/2.0)]);
xlabel('max. SA strength'); ylabel('freq');

% bar chart of distributions versus greatest stable attractor power
subplot(6,1,5);
powmax = Trange*(fTrange/2.0);
x = (powmax/(2*nbinsd)) : (powmax/nbinsd) : (powmax-(powmax/(2*nbinsd)));
bar(x,fr_powers(:,1));
xlim([0 powmax]);
xlabel('max. SA power'); ylabel('freq');

% bar chart of distributions versus asymmetry (a planet is more likely to
% be successful if dT/dt is generally +ve at low T, -ve at high T)
subplot(6,1,6);
asymm_max = Trange*fTrange/2.0;
thisgap = 2.0 * asymm_max / nbinsd;
x = (-asymm_max+(thisgap/2.0)) : thisgap : (asymm_max-(thisgap/2.0));
bar(x,fr_asymms(:,1));
xlim([-asymm_max asymm_max]);
xlabel('asymmetry in feedbacks'); ylabel('freq');

% title for this fgure (not for the subplot)
[a,h] = suplabel('Planet Bar Charts 1 (for all planets)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% second multi-panel figure for planet bar charts (part 1, hab planets)
f = figure(23); clf('reset');
set (f, 'Position', [600 200 400 800]);

% bar chart of distributions versus number of nodes
subplot(6,1,1);
x = 1:nnodes_max;
bar(x,fr_nodes(:,2));
xlim([1 nnodes_max+1]);
xlabel('# nodes'); ylabel('freq');

% bar chart of distributions versus number of stable attractors
subplot(6,1,2);
x = 0:nnodes_max;   % can have 0 stable attractors
bar(x,fr_attrs(:,2));
xlim([-1 (nnodes_max/2+1)]);
xlabel('# stable attractors'); ylabel('freq');

% bar chart of distributions versus greatest stable attractor width
subplot(6,1,3);
x = (Trange/(2*nbinsd)) : (Trange/nbinsd) : ...
    (((2*nbinsd)-1)*Trange/(2*nbinsd));
bar(x,fr_widths(:,2));
xlim([0 Trange]);
xlabel('max. SA width'); ylabel('freq');

% bar chart of distributions versus greatest stable attractor strength
subplot(6,1,4);
x = (fTrange/(4*nbinsd)) : (fTrange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*fTrange/(4*nbinsd));
bar(x,fr_strengths(:,2));
xlim([0 (fTrange/2.0)]);
xlabel('max. SA strength'); ylabel('freq');

% bar chart of distributions versus greatest stable attractor power
subplot(6,1,5);
powmax = Trange*(fTrange/2.0);
x = (powmax/(2*nbinsd)) : (powmax/nbinsd) : (powmax-(powmax/(2*nbinsd)));
bar(x,fr_powers(:,2));
xlim([0 powmax]);
xlabel('max. SA power'); ylabel('freq');

% bar chart of distributions versus asymmetry (a planet is more likely to
% be successful if dT/dt is generally +ve at low T, -ve at high T)
subplot(6,1,6);
asymm_max = Trange*fTrange/2.0;
thisgap = 2.0 * asymm_max / nbinsd;
x = (-asymm_max+(thisgap/2.0)) : thisgap : (asymm_max-(thisgap/2.0));
bar(x,fr_asymms(:,2));
xlim([-asymm_max asymm_max]);
xlabel('asymmetry in feedbacks'); ylabel('freq');

% title for this figure (not for the subplot)
[a,h] = suplabel('Planet Bar Charts 1 (for hab planets)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% third multi-panel figure for planet bar charts (part 2, all planets)
f = figure(24); clf('reset');
set (f, 'Position', [700 200 400 800]);

% bar chart of distributions versus trends
subplot(6,1,1);
trendr = trendTmax-trendTmin;
x = (trendTmin+(trendr/(2*nbinsd))) : (trendr/nbinsd) : ...
    (trendTmax-(trendr/(2*nbinsd)));
bar(x,fr_trends(:,1));
xlim([trendTmin trendTmax]);
xlabel('imposed trend in dT/dt'); ylabel('freq');

% bar chart of distributions versus potency of runaway feedbacks
subplot(6,1,2);
x = (0.0+(1.0/(2*nbinsd))) : (1.0/nbinsd) : ...
    (1.0-(1.0/(2*nbinsd)));
bar(x,fr_runaways(:,1));
xlim([0.0 1.0]);
xlabel('runaway fraction (of T range)'); ylabel('freq');

% bar chart of distributions versus positions of main stable attractor
% (first definition)
subplot(6,1,3);
x = (Tmin+(Trange/(2*nbinsd))) : (Trange/nbinsd) : ...
    (Tmax-(Trange/(2*nbinsd)));
bar(x,fr_pos1s(:,1));
xlim([Tmin Tmax]);
xlabel('position of main SA (def1)'); ylabel('freq');

% bar chart of distributions versus distances of main stable attractor
% from midpoint (first definition)
subplot(6,1,4);
x = (Trange/(4*nbinsd)) : (Trange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*Trange/(4*nbinsd));
bar(x,fr_dist1s(:,1));
xlim([0.0 Trange*0.55]);
xlabel('offset of main SA (def1)'); ylabel('freq');

% bar chart of distributions versus positions of main stable attractor
% (second definition)
subplot(6,1,5);
x = (Tmin+(Trange/(2*nbinsd))) : (Trange/nbinsd) : ...
    (Tmax-(Trange/(2*nbinsd)));
bar(x,fr_pos2s(:,1));
xlim([Tmin Tmax]);
xlabel('position of main SA (def2)'); ylabel('freq');

% bar chart of distributions versus distances of main stable attractor
% from midpoint (second definition)
subplot(6,1,6);
x = (Trange/(4*nbinsd)) : (Trange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*Trange/(4*nbinsd));
bar(x,fr_dist2s(:,1));
xlim([0.0 Trange*0.55]);
xlabel('offset of main SA (def2)'); ylabel('freq');

[a,h] = suplabel('Planet Bar Charts 2 (for all planets)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% fourth multi-panel figure for planet bar charts (part 2, hab planets)
f = figure(25); clf('reset');
set (f, 'Position', [800 200 400 800]);

% bar chart of distributions versus trends
subplot(6,1,1);
trendr = trendTmax-trendTmin;
x = (trendTmin+(trendr/(2*nbinsd))) : (trendr/nbinsd) : ...
    (trendTmax-(trendr/(2*nbinsd)));
bar(x,fr_trends(:,2));
xlim([trendTmin trendTmax]);
xlabel('imposed trend in dT/dt'); ylabel('freq');

% bar chart of distributions versus potency of runaway feedbacks
subplot(6,1,2);
x = (0.0+(1.0/(2*nbinsd))) : (1.0/nbinsd) : ...
    (1.0-(1.0/(2*nbinsd)));
bar(x,fr_runaways(:,2));
xlim([0.0 1.0]);
xlabel('runaway fraction (of T range)'); ylabel('freq');

% bar chart of distributions versus positions of main stable attractor
% (first definition)
subplot(6,1,3);
x = (Tmin+(Trange/(2*nbinsd))) : (Trange/nbinsd) : ...
    (Tmax-(Trange/(2*nbinsd)));
bar(x,fr_pos1s(:,2));
xlim([Tmin Tmax]);
xlabel('position of main SA (def1)'); ylabel('freq');

% bar chart of distributions versus distances of main stable attractor
% from midpoint (first definition)
subplot(6,1,4);
x = (Trange/(4*nbinsd)) : (Trange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*Trange/(4*nbinsd));
bar(x,fr_dist1s(:,2));
xlim([0.0 Trange*0.55]);
xlabel('offset of main SA (def1)'); ylabel('freq');

% bar chart of distributions versus positions of main stable attractor
% (second definition)
subplot(6,1,5);
x = (Tmin+(Trange/(2*nbinsd))) : (Trange/nbinsd) : ...
    (Tmax-(Trange/(2*nbinsd)));
bar(x,fr_pos2s(:,2));
xlim([Tmin Tmax]);
xlabel('position of main SA (def2)'); ylabel('freq');

% bar chart of distributions versus distances of main stable attractor
% from midpoint (second definition)
subplot(6,1,6);
x = (Trange/(4*nbinsd)) : (Trange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*Trange/(4*nbinsd));
bar(x,fr_dist2s(:,2));
xlim([0.0 Trange*0.55]);
xlabel('offset of main SA (def2)'); ylabel('freq');

[a,h] = suplabel('Planet Bar Charts 2 (for hab planets)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% ###### NOW DO IT ALL AGAIN BUT ALLOWING MATLAB TO CALCULATE THE ######
% ###### HISTOGRAMS RATHER THAN DOING MANUALLY                    ######

% first multi-panel figure for planet histograms
f = figure(26); clf('reset');
set (f, 'Position', [900 200 400 800]); 

subplot(6,1,1);
edges = 1.5:1:(nnodes_max+0.5) ;    % can be between 2 and nnodes_max
hcounts = histc(allplanets_nodes,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([1 (nnodes_max+1)]);
xlabel('# nodes'); ylabel('count');

subplot(6,1,2);
edges = -0.5:1:(floor(nnodes_max/2)+0.5);    % can be between 0 and (nnodes_max/2)
hcounts = histc(allplanets_attrs,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([-1 (floor(nnodes_max/2)+1)]);
xlabel('# stable attractors'); ylabel('count');

subplot(6,1,3);
bargap = Trange/nbinsd;
edges = 0.0:bargap:Trange;
hcounts = histc(allplanets_widths,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0 Trange]);
xlabel('max. SA width'); ylabel('count');

subplot(6,1,4);
bargap = fTrange/(2.0*nbinsd);
edges = 0.0:bargap:(fTrange/2.0);
hcounts = histc(allplanets_strengths,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0 (fTrange/2.0)]);
xlabel('max. SA strength'); ylabel('count');

subplot(6,1,5);
powmax = Trange*(fTrange/2.0);
bargap = powmax/nbinsd;
edges = 0.0:bargap:powmax;
hcounts = histc(allplanets_powers,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0 powmax]);
xlabel('max. SA power'); ylabel('count');

subplot(6,1,6);
asymm_max = Trange*fTrange/2.0;
bargap = 2.0*asymm_max/nbinsd;
edges = -asymm_max:bargap:asymm_max;
hcounts = histc(allplanets_asymms,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([-asymm_max asymm_max]);
xlabel('asymmetry of feedbacks'); ylabel('count');

[a,h] = suplabel('Planet Histograms 1 (for all planets)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% second multi-panel figure for planet histograms
f = figure(27); clf('reset');
set (f, 'Position', [1000 200 400 800]);

subplot(6,1,1);
edges = 1.5:1:(nnodes_max+0.5) ;    % can be between 2 and nnodes_max
hcounts = histc(goodplanets_nodes,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([1 (nnodes_max+1)]);
xlabel('# nodes'); ylabel('count');

subplot(6,1,2);
edges = -0.5:1:(floor(nnodes_max/2)+0.5);    % can be between 0 and (nnodes_max/2)
hcounts = histc(goodplanets_attrs,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([-1 (floor(nnodes_max/2)+1)]);
xlabel('# stable attractors'); ylabel('count');

subplot(6,1,3);
bargap = Trange/nbinsd;
edges = 0.0:bargap:Trange;
hcounts = histc(goodplanets_widths,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0 Trange]);
xlabel('max. SA width'); ylabel('count');

subplot(6,1,4);
bargap = fTrange/(2.0*nbinsd);
edges = 0.0:bargap:(fTrange/2.0);
hcounts = histc(goodplanets_strengths,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0 (fTrange/2.0)]);
xlabel('max. SA strength'); ylabel('count');

subplot(6,1,5);
powmax = Trange*(fTrange/2.0);
bargap = powmax/nbinsd;
edges = 0.0:bargap:powmax;
hcounts = histc(goodplanets_powers,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0 powmax]);
xlabel('max. SA power'); ylabel('count');

subplot(6,1,6);
asymm_max = Trange*fTrange/2.0;
bargap = 2.0*asymm_max/nbinsd;
edges = -asymm_max:bargap:asymm_max;
hcounts = histc(goodplanets_asymms,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([-asymm_max asymm_max]);
xlabel('asymmetry of feedbacks'); ylabel('count');

[a,h] = suplabel('Planet Histograms 1 (for hab planets)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% third multi-panel figure for planet histograms
f = figure(28);
set (f, 'Position', [1000 200 400 800]);

subplot(6,1,1);
trendr = trendTmax-trendTmin;
bargap = trendr/nbinsd;
edges = trendTmin:bargap:trendTmax;
hcounts = histc(allplanets_trends,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([trendTmin trendTmax]);
xlabel('imposed trend in dT/dt'); ylabel('count');

subplot(6,1,2);
bargap = 1.0/nbinsd;
edges = 0.0:bargap:1.0;
hcounts = histc(allplanets_runaways,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0.0 1.0]);
xlabel('runaway fraction (of T range)'); ylabel('count');

subplot(6,1,3);
bargap = Trange/nbinsd;
edges = Tmin:bargap:Tmax;
hcounts = histc(allplanets_pos1s,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([Tmin Tmax]);
xlabel('position of main SA (def1)'); ylabel('count');

subplot(6,1,4);
bargap = (Trange/2.0)/nbinsd;
edges = 0.0:bargap:(Trange/2.0);
hcounts = histc(allplanets_dist1s,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0.0 Trange*0.55]);
xlabel('offset of main SA (def1)'); ylabel('count');

subplot(6,1,5);
bargap = Trange/nbinsd;
edges = Tmin:bargap:Tmax;
hcounts = histc(allplanets_pos2s,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([Tmin Tmax]);
xlabel('position of main SA (def2)'); ylabel('count');

subplot(6,1,6);
bargap = (Trange/2.0)/nbinsd;
edges = 0.0:bargap:(Trange/2.0);
hcounts = histc(allplanets_dist2s,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0.0 Trange*0.55]);
xlabel('offset of main SA (def2)'); ylabel('count');

[a,h] = suplabel('Planet Histograms 2 (for all planets)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% fourth multi-panel figure for planet histograms
f = figure(29); clf('reset');
set (f, 'Position', [1100 200 400 800]);

subplot(6,1,1);
trendr = trendTmax-trendTmin;
bargap = trendr/nbinsd;
edges = trendTmin:bargap:trendTmax;
hcounts = histc(goodplanets_trends,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([trendTmin trendTmax]);
xlabel('imposed trend in dT/dt'); ylabel('count');

subplot(6,1,2);
bargap = 1.0/nbinsd;
edges = 0.0:bargap:1.0;
hcounts = histc(goodplanets_runaways,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0.0 1.0]);
xlabel('runaway fraction (of T range)'); ylabel('count');

subplot(6,1,3);
bargap = Trange/nbinsd;
edges = Tmin:bargap:Tmax;
hcounts = histc(goodplanets_pos1s,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([Tmin Tmax]);
xlabel('position of main SA (def1)'); ylabel('count');

subplot(6,1,4);
bargap = (Trange/2.0)/nbinsd;
edges = 0.0:bargap:(Trange/2.0);
hcounts = histc(goodplanets_dist1s,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0.0 Trange*0.55]);
xlabel('offset of main SA (def1)'); ylabel('count');

subplot(6,1,5);
bargap = Trange/nbinsd;
edges = Tmin:bargap:Tmax;
hcounts = histc(goodplanets_pos2s,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([Tmin Tmax]);
xlabel('position of main SA (def2)'); ylabel('count');

subplot(6,1,6);
bargap = (Trange/2.0)/nbinsd;
edges = 0.0:bargap:(Trange/2.0);
hcounts = histc(goodplanets_dist2s,edges);
hcounts(end-1) = hcounts(end-1) + hcounts(end);
bar(edges,hcounts,'histc');
xlim([0.0 Trange*0.55]);
xlabel('offset of main SA (def2)'); ylabel('count');

[a,h] = suplabel('Planet Histograms 2 (for hab planets)');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% ###### NOW DO IT ALL AGAIN BUT THIS TIME PRODUCING GRAPHS   ######
% ###### SHOWING THE TWO PROBABILITY DISTIRBUTION FUNCTIONS       ######
% ###### (FREQUENCY DISTRIBUTIONS?)                               ######

% first multi-panel figure for planet pdfs
f = figure(30); clf('reset');
set (f, 'Position', [1200 200 400 800]);

% pdfs of distributions versus number of nodes
subplot(6,1,1);
x = 1:nnodes_max;
plot(x,fr_nodes(:,1),'-k^',x,fr_nodes(:,2),'-ro');
xlim([1 nnodes_max+1]);
xlabel('# nodes'); ylabel('probability');
legend('all','survivors', 'Location', 'best');

% pdfs of distributions versus number of stable attractors
subplot(6,1,2);
x = 0:nnodes_max;   % can have 0 stable attractors
plot(x,fr_attrs(:,1),'-k^',x,fr_attrs(:,2),'-ro');
xlim([-1 (nnodes_max/2+1)]);
xlabel('# stable attractors'); ylabel('probability');

% pdfs of distributions versus greatest stable attractor width
subplot(6,1,3);
x = (Trange/(2*nbinsd)) : (Trange/nbinsd) : ...
    (((2*nbinsd)-1)*Trange/(2*nbinsd));
plot(x,fr_widths(:,1),'-k^',x,fr_widths(:,2),'-ro');
xlim([0 Trange]);
xlabel('max. SA width'); ylabel('probability');

% pdfs of distributions versus greatest stable attractor strength
subplot(6,1,4);
x = (fTrange/(4*nbinsd)) : (fTrange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*fTrange/(4*nbinsd));
plot(x,fr_strengths(:,1),'-k^',x,fr_strengths(:,2),'-ro');
xlim([0 (fTrange/2.0)]);
xlabel('max. SA strength'); ylabel('probability');

% pdfs of distributions versus greatest stable attractor power
subplot(6,1,5);
powmax = Trange*(fTrange/2.0);
x = (powmax/(2*nbinsd)) : (powmax/nbinsd) : (powmax-(powmax/(2*nbinsd)));
plot(x,fr_powers(:,1),'-k^',x,fr_powers(:,2),'-ro');
xlim([0 powmax]);
xlabel('max. SA power'); ylabel('probability');

% pdfs of distributions versus left-right asymmetry of feedbacks
subplot(6,1,6);
asymm_max = Trange*fTrange/2.0;
asymm_gap = 2.0*asymm_max/nbinsd;
x = (-asymm_max+(asymm_gap/2.0)) : asymm_gap : (asymm_max-(asymm_gap/2.0));
plot(x,fr_asymms(:,1),'-k^',x,fr_asymms(:,2),'-ro');
xlim([-asymm_max asymm_max]);
xlabel('asymmetry of feedbacks'); ylabel('probability');

[a,h] = suplabel('Planet PDFs 1');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% second multi-panel figure for planet pdfs
f = figure(31); clf('reset');
set (f, 'Position', [1300 200 400 800]);

% pdfs of distributions versus trends
subplot(7,1,1);
trendr = trendTmax-trendTmin;
x = (trendTmin+(trendr/(2*nbinsd))) : (trendr/nbinsd) : ...
    (trendTmax-(trendr/(2*nbinsd)));
plot(x,fr_trends(:,1),'-k^',x,fr_trends(:,2),'-ro');
xlim([trendTmin trendTmax]);
xlabel('imposed trend in dT/dt'); ylabel('probability');
legend('all','survivors', 'Location', 'best');

% pdfs of distributions versus potency of runaway feedbacks
subplot(7,1,2);
x = (0.0+(1.0/(2*nbinsd))) : (1.0/nbinsd) : ...
    (1.0-(1.0/(2*nbinsd)));
plot(x,fr_runaways(:,1),'-k^',x,fr_runaways(:,2),'-ro');
xlim([0.0 1.0]);
xlabel('runaway fraction (of T range)'); ylabel('probability');

% pdfs of distributions versus positions of main stable attractor
% (first definition)
subplot(7,1,3);
x = (Tmin+(Trange/(2*nbinsd))) : (Trange/nbinsd) : ...
    (Tmax-(Trange/(2*nbinsd)));
plot(x,fr_pos1s(:,1),'-k^',x,fr_pos1s(:,2),'-ro');
xlim([Tmin Tmax]);
xlabel('position of main SA (def1)'); ylabel('probability');

% pdfs of distributions versus distances of main stable attractor
% from midpoint (first definition)
subplot(7,1,4);
x = (Trange/(4*nbinsd)) : (Trange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*Trange/(4*nbinsd));
plot(x,fr_dist1s(:,1),'-k^',x,fr_dist1s(:,2),'-ro');
xlim([0.0 Trange*0.55]);
xlabel('offset of main SA (def1)'); ylabel('probability');

% pdfs of distributions versus positions of main stable attractor
% (second definition)
subplot(7,1,5);
x = (Tmin+(Trange/(2*nbinsd))) : (Trange/nbinsd) : ...
    (Tmax-(Trange/(2*nbinsd)));
plot(x,fr_pos2s(:,1),'-k^',x,fr_pos2s(:,2),'-ro');
xlim([Tmin Tmax]);
xlabel('position of main SA (def2)'); ylabel('probability');

% pdfs of distributions versus distances of main stable attractor
% from midpoint (second definition)
subplot(7,1,6);
x = (Trange/(4*nbinsd)) : (Trange/(2*nbinsd)) : ...
    (((2*nbinsd)-1)*Trange/(4*nbinsd));
plot(x,fr_dist2s(:,1),'-k^',x,fr_dist2s(:,2),'-ro');
xlim([0.0 Trange*0.55]);
xlabel('offset of main SA (def2)'); ylabel('probability');

% A SPECIAL EXTRA ONE, FOR AVERAGE DURATIONS OF SOMETIMES VS NEVER
% SUCCESSFUL PLANETS 
subplot(7,1,7);
thisgap = max_duration/nbinsd;
x = (thisgap/2.0) : thisgap : (max_duration-(thisgap/2.0));
plot(x,fr_avdurations(:,1),'-k^',x,fr_avdurations(:,2),'-ro');
xlim([0.0 max_duration]);
xlabel('Average planet survival durations'); ylabel('probability');

[a,h] = suplabel('Planet PDFs 2');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% ###### FINALLY DO IT ALL AGAIN BUT THIS TIME SHOWING THE    #######
% ###### DISTRIBUTION OF HABITABLE PLANETS COMPARED TO THE    #######
% ###### EXPECTED DISTRIBUTION IF WHAT IT IS PLOTTED AGAINST  #######
% ###### HAS NO EFFECT ON OR CONNECTION WITH HABITABILITY     #######

% there are more habitable planets in this bin than expected if
% fr_xxxx(i,2) > fr_xxxx(i,1)

% first multi-panel figure for planet ratios
f = figure(32); clf('reset');
set (f, 'Position', [1200 200 400 800]);

% ratios of distributions versus number of nodes
subplot(6,1,1);
x = 1:nnodes_max;
plot(x,ratio_nodes(:),'-bo');
xlim([1 nnodes_max+1]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('# nodes'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_nodes(nn)>4)
       text(x(nn),3.5,'\^{}');text(x(nn),3.2,'\^{}'); 
   end;
end;

% ratios of distributions versus number of stable attractors
subplot(6,1,2);
x = 0:nnodes_max;   % can have 0 stable attractors
plot(x,ratio_attrs(:),'-bo');
xlim([-1 (nnodes_max/2+1)]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('# stable attractors'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_attrs(nn)>4)
       text(x(nn),3.5,'\^{}');text(x(nn),3.2,'\^{}'); 
   end;
end;

% ratios of distributions versus greatest stable attractor width
subplot(6,1,3);
thisgap = Trange/nbinsd;
x = (thisgap/2.0) : thisgap : (Trange-(thisgap/2.0));
plot(x,ratio_widths(:),'-bo');
xlim([0 Trange]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('max. SA width'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_widths(nn)>4)
       text(x(nn),3.5,'\^{}');text(x(nn),3.2,'\^{}'); 
   end;
end;

% ratios of distributions versus greatest stable attractor strength
subplot(6,1,4);
thisgap = (fTrange/(2*nbinsd));
x = (thisgap/2.0) : thisgap : ((fTrange/2.0)-(thisgap/2.0));
plot(x,ratio_strengths(:),'-bo');
xlim([0 (fTrange/2.0)]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('max. SA strength'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_strengths(nn)>4)
       text(x(nn),3.5,'\^{}');text(x(nn),3.2,'\^{}'); 
   end;
end;

% ratios of distributions versus greatest stable attractor power
subplot(6,1,5);
powmax = Trange*(fTrange/2.0);
thisgap = powmax/nbinsd;
x = (thisgap/2.0) : thisgap : (powmax-(thisgap/2.0));
plot(x,ratio_powers(:),'-bo');
xlim([0 powmax]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('max. SA power'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_powers(nn)>4)
       text(x(nn),3.5,'\^{}');text(x(nn),3.2,'\^{}'); 
   end;
end;

% ratios of distributions versus left-right asymmetry of feedbacks
subplot(6,1,6);
asymm_max = Trange*fTrange/2.0;
asymm_gap = 2.0*asymm_max/nbinsd;
x = (-asymm_max+(asymm_gap/2.0)) : asymm_gap : (asymm_max-(asymm_gap/2.0));
plot(x,ratio_asymms(:),'-bo');
xlim([-asymm_max asymm_max]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('asymmetry of feedbacks'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_asymms(nn)>4)
       text((x(nn)-(asymm_gap/3)),3.5,'\^{}');text((x(nn)-(asymm_gap/3)),3.2,'\^{}'); 
   end;
end;

[a,h] = suplabel('Planet ratios 1');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');


% second multi-panel figure for planet ratios
f = figure(33); clf('reset');
set (f, 'Position', [1300 200 400 800]);

% ratios of distributions versus trends
subplot(7,1,1);
trendr = trendTmax-trendTmin;
thisgap = trendr/nbinsd;
x = (trendTmin+(thisgap/2.0)) : thisgap : (trendTmax-(thisgap/2.0));
plot(x,ratio_trends(:),'-bo');
xlim([trendTmin trendTmax]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('imposed trend in dT/dt'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_trends(nn)>4)
       text(x(nn),3.5,'\^{}');text(x(nn),3.2,'\^{}'); 
   end;
end;

% ratios of distributions versus potency of runaway feedbacks
subplot(7,1,2);
thisgap = 1.0/nbinsd;
x = (0.0+(thisgap/2.0)) : thisgap : (1.0-(thisgap/2.0));
plot(x,ratio_runaways(:),'-bo');
xlim([0.0 1.0]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('runaway fraction (of T range)'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_runaways(nn)>4)
       text(x(nn),3.5,'\^{}');text(x(nn),3.2,'\^{}'); 
   end;
end;

% ratios of distributions versus positions of main stable attractor
% (first definition)
subplot(7,1,3);
thisgap = Trange/nbinsd;
x = (Tmin+(thisgap/2.0)) : thisgap : (Tmax-(thisgap/2.0));
plot(x,ratio_pos1s(:),'-bo');
xlim([Tmin Tmax]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('position of main SA (def1)'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_pos1s(nn)>4)
       text(x(nn),3.5,'\^{}');text(x(nn),3.2,'\^{}'); 
   end;
end;

% ratios of distributions versus distances of main stable attractor
% from midpoint (first definition)
subplot(7,1,4);
thisgap = Trange/(2*nbinsd);
x = (thisgap/2.0) : thisgap : ((Trange/2.0)-(thisgap/2.0));
plot(x,ratio_dist1s(:),'-bo');
xlim([0.0 Trange*0.55]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('offset of main SA (def1)'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_dist1s(nn)>4)
       text(x(nn),3.5,'\^{}');text(x(nn),3.2,'\^{}'); 
   end;
end;

% ratios of distributions versus positions of main stable attractor
% (second definition)
subplot(7,1,5);
thisgap = Trange/nbinsd;
x = (Tmin+(thisgap/2.0)) : thisgap : (Tmax-(thisgap/2.0));
plot(x,ratio_pos2s(:),'-bo');
xlim([Tmin Tmax]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('position of main SA (def2)'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_pos2s(nn)>4)
       text(x(nn),3.5,'\^{}');text(x(nn),3.2,'\^{}'); 
   end;
end;

% ratios of distributions versus distances of main stable attractor
% from midpoint (second definition)
subplot(7,1,6);
thisgap = Trange/(2*nbinsd);
x = (thisgap/2.0) : thisgap : ((Trange/2.0)-(thisgap/2.0));
plot(x,ratio_dist2s(:),'-bo');
xlim([0.0 Trange*0.55]); ylim([0 4]);
set(gca,'Ytick',0:4,'YtickLabel',{'0','1','2','3','4'});
xlabel('offset of main SA (def2)'); ylabel('ratio');
hold on; plot([-1e9 1e9],[1 1],':k');
% plot a symbol to indicate any ratios > 4 which otherwise do not show
hold on;
for nn = 1:length(x)
   if (ratio_dist2s(nn)>4)
       text(x(nn),3.5,'\^{}');text(x(nn),3.2,'\^{}'); 
   end;
end;

[a,h] = suplabel('Planet ratios 2');
set(h, 'FontSize', 15);   set (h, 'FontWeight', 'Bold');
