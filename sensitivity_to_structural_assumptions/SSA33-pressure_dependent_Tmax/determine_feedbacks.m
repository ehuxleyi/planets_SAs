
% This script sets the intrinsic feedback properties for an individual
% planet.
% This is done by randomly allocating a number of nodes to the planet, and
% randomly determining the strengths of the feedbacks at those nodes.
% Feedback strengths at intermediate temperatures (between nodes) can 
% subsequently be calculated by linear interpolation.
%--------------------------------------------------------------------------

% <<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>
% this whole file has been altered for this SA. Normally feedbacks are only
% determined for temperature, i.e. dT/dt. In this SA, however, there is
% now an additional sets of feedbacks, dP/dt. The two sets of feedbacks
% need also to be separately determined.


%% first of all set the direct feedbacks on temperature

% determine how many separate nodes there are for this planet (on the dT/dt
% vs T graph)
nTnodes = 2 + floor((nnodes_max-1)*r1(ii,1));    % between 2 and 20
Tgap   = Trange0 / (nTnodes-1.0);

% give each node a random strength of feedback, either warming or
% cooling
for nn = 1:nTnodes
    % assume a uniform probability distribution of feedbacks within the
    % range of possible values
    Tnodes(nn) = Tmin + Tgap*(nn-1);
    Tfeedbacks(nn) = r2(ii,nn,1) * fTsd;  % mean=0, sigma=fTsd
end;

% to get this to plot successfully even though there are a variable
% number of nodes, have to fill in any gaps at the end with duplicates
% of the last point
for nn = (nTnodes+1):nnodes_max
    Tnodes(nn) = NaN;
    Tfeedbacks(nn) = Tfeedbacks(nTnodes);
end;


%% next set the feedbacks on P

% determine how many separate nodes there are for this planet (on the
% dP/dt vs P graph)
nPnodes = 2 + floor((nnodes_max-1)*r1(ii,2));    % between 2 and 20
Pgap   = Prange / (nPnodes-1.0);

% give each node a random strength of feedback, either warming or
% cooling
for nn = 1:nPnodes
    % assume a uniform probability distribution of feedbacks within the
    % range of possible values
    Pnodes(nn) = Pmin + Pgap*(nn-1);
    Pfeedbacks(nn) = r2(ii,nn,2) * fPsd;  % mean=0, sigma=fsd
end;

% to get this to plot successfully even though there are a variable
% number of nodes, have to fill in any gaps at the end with duplicates
% of the last point
for nn = (nPnodes+1):nnodes_max
    % assume a uniform probability distribution of feedbacks within the
    % range of possible values
    Pfeedbacks(nn) = Pfeedbacks(nPnodes);
end;
