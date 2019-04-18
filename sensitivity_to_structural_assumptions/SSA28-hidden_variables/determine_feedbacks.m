
% This script sets the intrinsic feedback properties for an individual
% planet.
% This is done by randomly allocating a number of nodes to the planet, and
% randomly determining the strengths of the feedbacks at those nodes.
% Feedback strengths at intermediate temperatures (between nodes) can 
% subsequently be calculated by linear interpolation.
%--------------------------------------------------------------------------

% <<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>
% this whole file has been altered for this SA. Normally feedbacks are only
% determined for temperature, i.e. dT/dt. In this SA, however, there are
% now additional sets of feedbacks, dH1/dt, dH2/dt and dH3/dt. Each of
% these sets of feedbacks need also to be separately determined.


%% first of all set the direct feedbacks on temperature

% determine how many separate nodes there are for this planet (on the dT/dt
% vs T graph)
nTnodes = 2 + floor((nnodes_max-1)*r1(ii,1));    % between 2 and 20
Tgap   = Trange / (nTnodes-1.0);

% give each node a random strength of feedback, either warming or
% cooling
for nn = 1:nTnodes
    % assume a uniform probability distribution of feedbacks within the
    % range of possible values
    Tnodes(nn) = Tmin + Tgap*(nn-1);
    Tfeedbacks(nn) = r2(ii,nn,1) * fTsd;  % mean=0, sigma=fTsd
end

% to get this to plot successfully even though there are a variable
% number of nodes, have to fill in any gaps at the end with duplicates
% of the last point
for nn = (nTnodes+1):nnodes_max
    Tnodes(nn) = NaN;
    Tfeedbacks(nn) = Tfeedbacks(nTnodes);
end


%% next set the feedbacks on H1

% determine how many separate nodes there are for this planet (on the
% dH1/dt vs H1 graph)
nH1nodes = 2 + floor((nnodes_max-1)*r1(ii,2));    % between 2 and 20
H1gap   = H1range / (nH1nodes-1.0);

% give each node a random strength of feedback, either warming or
% cooling
for nn = 1:nH1nodes
    % assume a uniform probability distribution of feedbacks within the
    % range of possible values
    H1nodes(nn) = H1min + H1gap*(nn-1);
    H1feedbacks(nn) = r2(ii,nn,2) * fH1sd;  % mean=0, sigma=fsd
end;

% to get this to plot successfully even though there are a variable
% number of nodes, have to fill in any gaps at the end with duplicates
% of the last point
for nn = (nH1nodes+1):nnodes_max
    % assume a uniform probability distribution of feedbacks within the
    % range of possible values
    H1feedbacks(nn) = H1feedbacks(nH1nodes);
end;


%% <<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>
% next set the feedbacks on H2

% determine how many separate nodes there are for this planet (on the
% dH2/dt vs H2 graph)
nH2nodes = 2 + floor((nnodes_max-1)*r1(ii,3));    % between 2 and 20
H2gap   = H2range / (nH2nodes-1.0);

% give each node a random strength of feedback, either warming or
% cooling
for nn = 1:nH2nodes
    % assume a uniform probability distribution of feedbacks within the
    % range of possible values
    H2nodes(nn) = H2min + H2gap*(nn-1);
    H2feedbacks(nn) = r2(ii,nn,3) * fH2sd;  % mean=0, sigma=fsd
end;

% to get this to plot successfully even though there are a variable
% number of nodes, have to fill in any gaps at the end with duplicates
% of the last point
for nn = (nH2nodes+1):nnodes_max
    % assume a uniform probability distribution of feedbacks within the
    % range of possible values
    H2feedbacks(nn) = H2feedbacks(nH2nodes);
end;


%% <<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>
% next set the feedbacks on H3

% determine how many separate nodes there are for this planet (on the
% dH3/dt vs H3 graph)
nH3nodes = 2 + floor((nnodes_max-1)*r1(ii,4));    % between 2 and 20
H3gap   = H3range / (nH3nodes-1.0);

% give each node a random strength of feedback, either warming or
% cooling
for nn = 1:nH3nodes
    % assume a uniform probability distribution of feedbacks within the
    % range of possible values
    H3nodes(nn) = H3min + H3gap*(nn-1);
    H3feedbacks(nn) = r2(ii,nn,4) * fH3sd;  % mean=0, sigma=fsd
end;

% to get this to plot successfully even though there are a variable
% number of nodes, have to fill in any gaps at the end with duplicates
% of the last point
for nn = (nH3nodes+1):nnodes_max
    % assume a uniform probability distribution of feedbacks within the
    % range of possible values
    H3feedbacks(nn) = H3feedbacks(nH3nodes);
end;
