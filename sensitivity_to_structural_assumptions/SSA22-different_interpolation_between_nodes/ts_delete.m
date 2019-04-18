% script to delete my jobs from the cluster
%--------------------------------------------------------------------------

% find my jobs
clustertoby = parcluster;
myjobs = findJob(clustertoby);

% delete them
delete(myjobs);
clear myjobs;