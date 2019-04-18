function [out] = planets_ODE(time, in)

% this file contains the function to calculate the rate of change of
% planetary surface temperature over time (dT/dt), for a given current
% value of the current planetary surface temperature (T)

% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
% also the rate of change of P

% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
% share via global (to slave) variables because difficult to pass as
% arguments
global Tmin Tmax0 Tgap Tnodes Tfeedbacks trendT nTnodes 
global Pmin Pmax Pgap Pnodes Pfeedbacks trendP nPnodes 
global k1 k2 max_duration

out = in;
% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
T = in(1);
P = in(2);


%% ----- Differential equation for temperature -----

% the value of dT/dt (rate of change of planetary temperature over time)
% depends on the planetary temperature. The value of dT/dt at any precise
% value of T is interpolated between specified values at regular intervals

% first of all calculate f1(T)
f1T = interp1(Tnodes(1:nTnodes), Tfeedbacks(1:nTnodes), T, 'linear');
% <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
if ((T <= Tmin) || (T >= Tmax0))
    f1T = 0.0;
end;

% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
% same as SA28 (hidden variables) except have removed the impacts from P
out(1) = f1T + (trendT*(time/1e6));
% =========================================================================


%% ----- Differential equation for P -----
% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>

% the value of dP/dt (rate of change of P over time) depends on the
% current value of P. The value of dP/dt at any precise value of P is
% interpolated between specified values at regular intervals

% first of all calculate f2(P)
% add "protectors" below -100.0 and above +100.0 to stop P running away to
% -infinity or +infinity
x = [ -200.0 (Pnodes(1)-1) Pnodes(1:nPnodes) ...
    (Pnodes(nPnodes)+1) 200.0];
y = [ 100.0 100.0 Pfeedbacks(1:nPnodes) -100.0 -100.0];
f2P = interp1(x, y, P, 'linear');

% now add the impacts from T and the trend over time
% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
% remove the connection to temperature
out(2) = f2P + (trendP*(time/1e6));
% =========================================================================

out(3) = 0.0;
