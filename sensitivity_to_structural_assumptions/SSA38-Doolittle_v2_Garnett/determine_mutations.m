%initialise mutation matrix
mutations = zeros(nnodes_max, nmutations_max);
mutation_times = NaN(nmutations_max, 1);
msizes = NaN(nmutations_max, 1);

nmutations = randi(nmutations_max+1)-1;
if nmutations > 0
     %for each mutation, pick a random time for it to happen
    mutation_times(1:nmutations) = sort(rand(nmutations, 1) * max_duration);
end
for mn = 1:nmutations
    %choose a number of nodes to be affected
    mutation_width = randi(nnodes);
    %and an arbitrary start point (node number) for the mutations to hit, 
    %allowing for the possibility of impacts centred outside the habitable
    %range which also affect inside (otherwise there is a bias towards
    %central nodes being more likely to be affected)
    mutation_minnode = randi(nnodes+mutation_width-1) - mutation_width + 1;
    % make a list of nodes affected, now excluding those outside the
    % habitable range
    mutation_node1 = max(mutation_minnode,1);    % never less than 1
    mutation_nodee = min((mutation_minnode+mutation_width),nnodes);    % never more than nnodes
    mutation_nodes = [mutation_node1:1:mutation_nodee];
    % calculate the magnitude of the impact
    mutation_size = normrnd(0, mutation_sd);
    msizes(mn) = mutation_size;
    mutations(mutation_nodes, mn) = mutation_size;
end;
