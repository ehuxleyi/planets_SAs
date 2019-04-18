
% This script sets the intrinsic feedback properties for an individual
% planet.
% This is done by randomly allocating a number of nodes to the planet, and
% randomly determining the strengths of the feedbacks at those nodes.
% Feedback strengths at intermediate temperatures (between nodes) can 
% subsequently be calculated by linear interpolation.
%--------------------------------------------------------------------------

% determine how many separate nodes there are for this planet (on the dT/dt
% vs T graph)
% <<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>
nnodes = 20;
Tgap   = Trange / (nnodes-1.0);

% give each node a random strength of feedback, either warming or
% cooling
% <<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>
for nn = 1:10
    % assume a uniform probability distribution of feedbacks within the
    % range of possible values
    Tnodes(nn) = Tmin + Tgap*(nn-1);
    Tfeedbacks(nn) = 0.0;
end;
for nn = 11:20
    % assume a uniform probability distribution of feedbacks within the
    % range of possible values
    Tnodes(nn) = Tmin + Tgap*(nn-1);
    Tfeedbacks(nn) = 0.0;
end;
% <<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>

