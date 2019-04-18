function [out] = planets_ODE(time, in)

% this file contains the function to calculate the rate of change of
% planetary surface temperature over time (dT/dt), for a given current
% value of the current planetary surface temperature (T)

% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
% also the rates of change of H1, H2 and H3

% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>
% share via global (to slave) variables because difficult to pass as
% arguments
global Tmin Tmax Tnodes Tfeedbacks trendT nTnodes 
global H1min H1max H1nodes H1feedbacks trendH1 nH1nodes 
global H2min H2max H2nodes H2feedbacks trendH2 nH2nodes 
global H3min H3max H3nodes H3feedbacks trendH3 nH3nodes 
global k1 k2 k3 k4 k5 k6

out = in;
T = in(1);
H1 = in(2);
H2 = in(3);
H3 = in(4);

% ----- Differential equation -----

% the value of dT/dt (rate of change of planetary temperature over time)
% depends on the planetary temperature and on H1, H2 & H3 values. The value
% of dT/dt at any precise value of T is interpolated between specified
% values at regular intervals

if (T < Tmin)      % too cold to be habitable
    delT = 0.0;
elseif ((T >= Tmin) && (T <= Tmax))    % within habitable limits
    % linear interpolation between nodes
    f1T = interp1(Tnodes(1:nTnodes), Tfeedbacks(1:nTnodes), T, 'linear');
    % now add the impacts from H1, H2 and H3 and the trend over time
    delT = f1T + (trendT*(time/1e6)) + (k1*H1) + (k2*H2) + (k3*H3);
elseif (T > Tmax)  %  too hot to be habitable
    delT = 0.0;
else
    error('pl_ODE: should never get here 1');
end

out(1) = delT;


%% ----- Differential equation for H1 -----
% the value of dH1/dt (rate of change of H1 over time) depends on the
% current value of H1. The value of dH1/dt at any precise value of H1 is
% interpolated between specified values at regular intervals

if (H1 <= (H1min-5))     % below zone in which dH1/dt brought to zero
    delH1 = 0.0;
elseif (H1 < H1min)      % within zone in which dH1/dt brought to zero
    delH1 = (H1-(H1min-5)) * H1nodes(1) / 5;
elseif ((H1 >= H1min) && (H1 <= H1max))    % within normal limits
    % linear interpolation between nodes
    f2H1 = interp1(H1nodes(1:nH1nodes), H1feedbacks(1:nH1nodes), H1, 'linear');
    % add trend and influence of T
    delH1 = f2H1 + (trendH1*(time/1e6)) + (k4*T);
elseif (H1 < (H1max+5))  % within zone in which dH1/dt brought to zero
    delH1 = ((H1max+5)-H1) * H1nodes(nH1nodes) / 5;
elseif (H1 >= (H1max+5)) % above zone in which dH1/dt brought to zero
    delH1 = 0.0;
else
    error('pl_ODE: should never get here 2');
end

out(2) = delH1;


%% ----- Differential equation for H2 -----
% the value of dH2/dt (rate of change of H2 over time) depends on the
% current value of H2. The value of dH2/dt at any precise value of H2 is
% interpolated between specified values at regular intervals

if (H2 <= (H2min-5))     % below zone in which dH2/dt brought to zero
    delH2 = 0.0;
elseif (H2 < H2min)      % within zone in which dH2/dt brought to zero
    delH2 = (H2-(H2min-5)) * H2nodes(1) / 5;
elseif ((H2 >= H2min) && (H2 <= H2max))    % within normal limits
    % linear interpolation between nodes
    f3H2 = interp1(H2nodes(1:nH2nodes), H2feedbacks(1:nH2nodes), H2, 'linear');
    % add trend and influence of T
    delH2 = f3H2 + (trendH2*(time/1e6)) + (k5*T);
elseif (H2 < (H2max+5))  % within zone in which dH2/dt brought to zero
    delH2 = ((H2max+5)-H2) * H2nodes(nH2nodes) / 5;
elseif (H2 >= (H2max+5)) % above zone in which dH2/dt brought to zero
    delH2 = 0.0;
else
    error('pl_ODE: should never get here 3');
end

out(3) = delH2;


%% ----- Differential equation for H3 -----
% <<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>

% the value of dH3/dt (rate of change of H3 over time) depends on the
% current value of H3. The value of dH3/dt at any precise value of H3 is
% interpolated between specified values at regular intervals

if (H3 <= (H3min-5))     % below zone in which dH3/dt brought to zero
    delH3 = 0.0;
elseif (H3 < H3min)      % within zone in which dH3/dt brought to zero
    delH3 = (H3-(H3min-5)) * H3nodes(1) / 5;
elseif ((H3 >= H3min) && (H3 <= H3max))    % within normal limits
    % linear interpolation between nodes
    f4H3 = interp1(H3nodes(1:nH3nodes), H3feedbacks(1:nH3nodes), H3, 'linear');
    % add trend and influence of T
    delH3 = f4H3 + (trendH3*(time/1e6)) + (k6*T);
elseif (H3 < (H3max+5))  % within zone in which dH3/dt brought to zero
    delH3 = ((H3max+5)-H3) * H3nodes(nH3nodes) / 5;
elseif (H3 >= (H3max+5)) % above zone in which dH3/dt brought to zero
    delH3 = 0.0;
else
    error('pl_ODE: should never get here 4');
end

out(4) = delH3;

% =========================================================================
