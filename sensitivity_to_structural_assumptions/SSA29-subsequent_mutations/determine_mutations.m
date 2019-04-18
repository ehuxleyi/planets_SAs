% This script uses random numbers to set some parameters characterising the
% 'mutations' that might be experienced by a planet during the 3 By that we
% are looking to see if it stays habitable. In the standard model, planets
% are started off with a certain set of feedbacks which are then kept
% constant throughout, except for a long-term forcing which is applied on
% top. In this sensitivity analysis, mutations are randomly applied to the
% feedbacks at random points through the run. Mutations are distinct from
% perturbations because mutations permanently change the 'constitution'
% (feedbacks) of the planet whereas perturbations are temporary changes to
% planetary temperature, which may or may not be sustained. Individual
% perturbations can be counteracted by negative feedbacks, leading to no
% long-term effect. Mutations, on the other hand, persist regardless.
%
% Some examples of the changes (both biotic and abiotic) that the mutations
% are designed to represent include (taken from the history of Earth):
%   (a) the evolution of oxygenic photosynthesis
%   (b) or the evolution then rise to abundance of terrestrial plants
%       (colonising the land and eventually spreading forests across it)
%   (c) or the evolution and subsequent rise to abundance of pelagic
%       calcifying organisms
%   (d) or the advent of the C4 and CAM types of photosynthesis
%   (e) the postulated early collision of the precursor to Earth with
%       another sizeable mini-planet ('Theia'), leading to the formation of
%       the Moon and (arguably) subsequent stabilisation of Earth's orbital 
%       characteristics
%   (f) condensation of the ocean
%   (g) establishment of the magnetic field
%
%--------------------------------------------------------------------------

global Tvec mut_effect_on_dT

% use random numbers to determine this planet's mutations
% determine the number of mutations in this rerun (between 0 and 8)
nmuts = randi([0 8], 1, 1);

% create an (initially empty) array to hold the mutation properties:
%   [1] type of mutation (see below)
%   [2] amplitude of the mutation
%   [3] sign of the mutation (whether adding to or subtracting from dT/dt)
%   [4] position (whereabouts between Tmin and Tmax that it is centred)
%   [5] time of occurrence
muts = zeros(nmuts,5);

% for each mutation
for mmm = 1:nmuts
    
    % [1] type of each mutation:
    %     (a) is a step increase (decrease) in dT/dt which is the same for all
    %     values of T
    %     (b) is the addition of a sloped line of constant negative
    %     (positive) slope 
    %     (c) is the addition (subtraction) of a pyramid-type function which
    %     increases (decreases) linearly from zero at Tmin and Tmax to a
    %     maximum (minimum) at Tmid
    %     (d) is the addition (subtraction) of a normal distribution centred at
    %     a random point between Tmin and Tmax
    muts(mmm,1) = randi([1 4], 1, 1);
    
    % [2] amplitude of each mutation (from a normal distribution with
    % standard deviation the same as that for the initial feedbacks):
    muts(mmm,2) = abs(normrnd(0.0, fsd));
    
    % [3] sign of the mutation (-1 or +1)
    muts(mmm,3) = round(rand)*2 - 1;
    
    % [4] position (only relevant for the fourth type)
    if (muts(mmm,1) == 4)
        muts(mmm,4) = Tmin + Trange * rand;
    else
        muts(mmm,4) = NaN;
    end
    
    % [5] time of occurrence
    muts(mmm,5) = rand * max_duration;    % equal prob to occur at any time
end

% sort the mutations into chronological order
muts = sortrows(muts,5);

% create an array of events ('run_events'), which can be either
% perturbations or mutations
run_events = zeros((pcounter+nmuts),2);
pertc = 1;   mutc = 1;  eventc = 1;
event_time = 0.0;
% until max_duration is reached or all events included
while ((event_time <= max_duration) && (eventc <= (pcounter+nmuts)))
    % if there are both mutations and perturbations left
    if ((pertc <= pcounter) && (mutc <= nmuts))
        
        % if the next event is a perturbation then add it to the event list
        if (perturbations(pertc,1) <= muts(mutc,5))
            run_events(eventc,1) = perturbations(pertc,1);
            event_time = perturbations(pertc,1);
            run_events(eventc,2) = 1;  % use 1 to signify a perturbation event
            eventc = eventc + 1;
            pertc = pertc + 1;
            
        % else (if the next event is a mutation) then add that to the
        % event list
        else
            run_events(eventc,1) = muts(mutc,5);
            event_time = muts(mutc,5);
            run_events(eventc,2) = 2;  % use 2 to signify a mutation event
            eventc = eventc + 1;
            mutc = mutc + 1;
        end
        
    % else if there are only mutations left
    elseif (mutc <= nmuts)
        
        % if the next event is a mutation then add it to the event list
        run_events(eventc,1) = muts(mutc,5);
        event_time = muts(mutc,5);
        run_events(eventc,2) = 2;  % use 2 to signify a mutation event
        eventc = eventc + 1;
        mutc = mutc + 1;
        
    % else if there are only perturbations left
    elseif (pertc <= pcounter)
        
        % if the next event is a perturbation then add it to the event list
        run_events(eventc,1) = perturbations(pertc,1);
        event_time = perturbations(pertc,1);
        run_events(eventc,2) = 1;  % use 1 to signify a perturbation event
        eventc = eventc + 1;
        pertc = pertc + 1;
        
    end
end

nevents = eventc - 1;
if (nevents ~= (pcounter+nmuts))
    error('event counter error');
end

% create a cumulative sum of all the mutation impacts (for each T) that
% have occurred up until the present time in the run. This is initialised
% with a value of zero for all T because no mutations have occurred at the
% time the run starts
Tvec = [Tmin:0.1:Tmax];
mut_effect_on_dT = zeros(size(Tvec));

% fprintf('\n\n%d mutations scheduled ,for the following times: ', nmuts);
% if (nmuts > 0)
%     fprintf('%.1f ', (muts(:,5)/1e3));
% end
