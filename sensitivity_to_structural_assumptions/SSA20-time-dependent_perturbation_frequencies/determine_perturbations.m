% This script sets up the random perturbations in advance, for a
% particular rerun. The perturbations are instantaneous changes to the
% planet's surface temperature.

% Over billions of years, many external and internal factors are likely to
% lead to temporary perturbations to the planet's temperature. Examples
% include the impacts of comets and asteroids, distant supernovas, volcanic
% eruptions, sometimes leading to outpourings of large amounts of basalt,
% evolutionary innovations or delays between evolution of the ability to
% produce a substance and the ability to degrade it (cf. lignin).

% This is implemented by adding together three clases of perturbations: 
% (1) frequent minor ones (amplitude chosen randomly from a normal
%     distribution with mean 3 deg C and standard deviation 1.5 deg C)
% (2) occasional moderate ones (amplitude chosen randomly from a normal
%     distribution with mean 10 deg C and standard deviation 5 deg C), and
% (3) very infrequent major ones (amplitude chosen randomly from a normal
%     distribution with mean 20 deg C and standard deviation 10 deg C)
% If two perturbations of different magnitudes occur simultaneously, the
% smaller one is ignored.
% All perturbations are randomly eiher positive or negative.
%--------------------------------------------------------------------------

% use random numbers from a Poisson distribution to calculate the numbers
% of actual perturbations in each magnitude class. This is numerically
% identical to, but computationally far more efficient than, going through
% each time period one by one (there are 3 million ky) and calculating if
% there are any perturbations in that ky
bpcounter = poissrnd(lambda_big,1,1);
mpcounter = poissrnd(lambda_mid,1,1);
lpcounter = poissrnd(lambda_little,1,1);

pcounter = bpcounter + mpcounter + lpcounter;

% set up the array to hold the information about the perturbations
perturbations = double(zeros([pcounter 2]));

max_perturbation = 0.0;

% <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
% coefficient for calculations of times of perturbation events
k = 1.0/(2.0^8);

% for each major perturbation
for ppp = 1:bpcounter
    % <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
    % calculate the time at which the perturbation will occur, with much
    % greater probability to be near the beginning, declining probability
    % of being later
    ptime = (((rand+1.0)^(-8))-k) * (1.0+k) * max_duration;
    magnitude = normrnd(bigp_mean, bigp_std);     % degrees C
    sign = round(rand)*2 - 1;  % randomly an increase or a decrease
    perturbations(ppp, 1) = ptime;              % store time...
    perturbations(ppp, 2) = magnitude * sign;    % ...and impact
    % keep track of the size of the largest perturbation in this run
    if (magnitude > abs(max_perturbation))
        max_perturbation = perturbations(ppp, 2);
    end;
end;

% for each moderate perturbation
for ppp = (bpcounter+1):(bpcounter+mpcounter)
    % <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
    % calculate the time at which the perturbation will occur, with much
    % greater probability to be near the beginning, declining probability
    % of being later
    ptime = (((rand+1.0)^(-8))-k) * (1.0+k) * max_duration;
    magnitude = normrnd(midp_mean, midp_std);     % degrees C
    sign = round(rand)*2 - 1;  % randomly an increase or a decrease
    perturbations(ppp, 1) = ptime;              % store time...
    perturbations(ppp, 2) = magnitude * sign;    % ...and impact
    % keep track of the size of the largest perturbation in this run
    if (magnitude > abs(max_perturbation))
        max_perturbation = perturbations(ppp, 2);
    end;
end;

% for each little perturbation
for ppp = (bpcounter+mpcounter+1):pcounter
    % <<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
    % calculate the time at which the perturbation will occur, with much
    % greater probability to be near the beginning, declining probability
    % of being later
    ptime = (((rand+1.0)^(-8))-k) * (1.0+k) * max_duration;
    magnitude = normrnd(littlep_mean, littlep_std);     % degrees C
    sign = round(rand)*2 - 1;  % randomly an increase or a decrease
    perturbations(ppp, 1) = ptime;              % store time...
    perturbations(ppp, 2) = magnitude * sign;    % ...and impact
    % keep track of the size of the largest perturbation in this run
    if (magnitude > abs(max_perturbation))
        max_perturbation = perturbations(ppp, 2);
    end;
end;

% sort the perturbations into chronological order
perturbations = sortrows(perturbations,1);
