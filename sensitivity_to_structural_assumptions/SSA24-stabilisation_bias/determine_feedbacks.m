
% This script sets the intrinsic feedback properties for an individual
% planet.
% This is done by randomly allocating a number of nodes to the planet, and
% randomly determining the strengths of the feedbacks at those nodes.
% Feedback strengths at intermediate temperatures (between nodes) can 
% subsequently be calculated by linear interpolation.
%--------------------------------------------------------------------------

% determine how many separate nodes there are for this planet (on the dT/dt
% vs T graph)
nnodes = 2 + floor((nnodes_max-1)*r1(ii));    % between 2 and 20
Tgap   = Trange / (nnodes-1.0);

% give each node a random strength of feedback, either warming or
% cooling
for nn = 1:nnodes
    % assume a uniform probability distribution of feedbacks within the
    % range of possible values
    Tnodes(nn) = Tmin + Tgap*(nn-1);
    Tfeedbacks(nn) = r2(ii,nn) * fsd;  % mean=0, sigma=fsd
    % <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
    % add the interpolated extra feedback to represent BBR
    Tfeedbacks(nn) = Tfeedbacks(nn) + ...
        interp1([Tmin Tmax], [(fsd/2) -(fsd/2)], Tnodes(nn));
end;

% to get this to plot successfully even though there are a variable
% number of nodes, have to fill in any gaps at the end with duplicates
% of the last point
for nn = (nnodes+1):nnodes_max
    Tnodes(nn) = NaN;
    Tfeedbacks(nn) = Tfeedbacks(nnodes);
end;
