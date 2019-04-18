function [out] = planets_ODE(time, in)

% this file contains the function to calculate the rate of change of
% planetary surface temperature over time (dT/dt), for a given current
% value of the current planetary surface temperature (T)

% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
% also the rates of change of H1, H2 and H3

% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
% share via global (to slave) variables because difficult to pass as
% arguments
global Tmin Tmax Tgap Tnodes Tfeedbacks trendT nTnodes 
global H1min H1max H1gap H1nodes H1feedbacks trendH1 nH1nodes 
global H2min H2max H2gap H2nodes H2feedbacks trendH2 nH2nodes 
global H3min H3max H3gap H3nodes H3feedbacks trendH3 nH3nodes 
global max_duration

out = in;
% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
T = in(1);
H1 = in(2);
H2 = in(3);
H3 = in(4);


%% ----- Differential equation for temperature -----

% the value of dT/dt (rate of change of planetary temperature over time)
% depends on the planetary temperature. The value of dT/dt at any precise
% value of T is interpolated between specified values at regular intervals

% first of all calculate f1(T)
f1T = interp1(Tnodes(1:nTnodes), Tfeedbacks(1:nTnodes), T, 'linear');
if ((T <= Tmin) || (T >= Tmax))
    f1T = 0.0;
end;

% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
% same as SA28 (hidden variables) except have removed the impacts from H1,
% H2 and H3
out(1) = f1T + (trendT*(time/1e6));
% =========================================================================


%% ----- Differential equation for H1 -----
% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>

% the value of dH1/dt (rate of change of H1 over time) depends on the
% current value of H1. The value of dH1/dt at any precise value of H1 is
% interpolated between specified values at regular intervals

% first of all calculate f2(H1)
% no rate of change outside limits, to stop H1 running away to -infinity or
% +infinity
x = [ -200.0 (H1nodes(1)-1) H1nodes(1:nH1nodes) ...
    (H1nodes(nH1nodes)+1) 200.0];
y = [ 0.0 0.0 H1feedbacks(1:nH1nodes) 0.0 0.0];
f2H1 = interp1(x, y, H1, 'linear');
if ((H1 <= H1min) || (H1 >= H1max))
    f2H1 = 0.0;
end;

% now add the impacts from T and the trend over time
% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
% remove the connection to temperature
out(2) = f2H1 + (trendH1*(time/1e6));
% =========================================================================


%% ----- Differential equation for H2 -----
% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>

% the value of dH2/dt (rate of change of H2 over time) depends on the
% current value of H2. The value of dH2/dt at any precise value of H2 is
% interpolated between specified values at regular intervals

% first of all calculate f3(H2)
% no rate of change outside limits, to stop H1 running away to -infinity or
% +infinity
x = [ -200.0 (H2nodes(1)-1) H2nodes(1:nH2nodes) ...
    (H2nodes(nH2nodes)+1) 200.0];
y = [ 0.0 0.0 H2feedbacks(1:nH2nodes) 0.0 0.0];
f3H2 = interp1(x, y, H2, 'linear');
if ((H2 <= H2min) || (H2 >= H2max))
    f3H2 = 0.0;
end;

% now add the impacts from T and the trend over time
% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
% remove the connection to temperature
out(3) = f3H2 + (trendH2*(time/1e6));
% =========================================================================


%% ----- Differential equation for H3 -----
% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>

% the value of dH3/dt (rate of change of H3 over time) depends on the
% current value of H3. The value of dH3/dt at any precise value of H3 is
% interpolated between specified values at regular intervals

% first of all calculate f4(H3)
% no rate of change outside limits, to stop H1 running away to -infinity or
% +infinity
x = [ -200.0 (H3nodes(1)-1) H3nodes(1:nH3nodes) ...
    (H3nodes(nH3nodes)+1) 200.0];
y = [ 0.0 0.0 H3feedbacks(1:nH3nodes) 0.0 0.0];
f4H3 = interp1(x, y, H3, 'linear');
if ((H3 <= H3min) || (H3 >= H3max))
    f4H3 = 0.0;
end;

% now add the impacts from T and the trend over time
% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
% remove the connection to temperature
out(4) = f4H3 + (trendH3*(time/1e6));
% =========================================================================

out(5) = 0.0;
