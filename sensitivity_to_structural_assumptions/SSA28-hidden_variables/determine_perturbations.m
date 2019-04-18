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
% <<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>
% perturb H1, H2 and H3, not just T
% (:,1) = time
% (:,2) = perturbation to T
% (:,3) = perturbation to H1
% (:,4) = perturbation to H2
% (:,5) = perturbation to H3
perturbations = double(zeros([pcounter 5]));

max_perturbation = 0.0;

% for each major perturbation
for ppp = 1:bpcounter
    ptime = rand * max_duration;    % equal prob to occur at any time
    % <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>
    magnitudeT = normrnd(bigp_mean, bigp_std);     % degrees C
    % increase the magnitudes by a factor of 2 for H1, H2 and H3 because
    % their ranges are larger
    magnitudeH1 = normrnd(2*bigp_mean, 2*bigp_std);     % degrees C
    magnitudeH2 = normrnd(2*bigp_mean, 2*bigp_std);     % degrees C
    magnitudeH3 = normrnd(2*bigp_mean, 2*bigp_std);     % degrees C
    signT = round(rand)*2 - 1;  % randomly an increase or a decrease
    signH1 = round(rand)*2 - 1;  % randomly an increase or a decrease
    signH2 = round(rand)*2 - 1;  % randomly an increase or a decrease
    signH3 = round(rand)*2 - 1;  % randomly an increase or a decrease
    perturbations(ppp, 1) = ptime;              % store time...
    perturbations(ppp, 2) = magnitudeT * signT;    % ...and impact
    perturbations(ppp, 3) = magnitudeH1 * signH1;    % ...and impact    
    perturbations(ppp, 4) = magnitudeH2 * signH2;    % ...and impact        
    perturbations(ppp, 5) = magnitudeH3 * signH3;    % ...and impact  
    % keep track of the size of the largest perturbation in this run
    if (magnitudeT > abs(max_perturbation))
        max_perturbation = perturbations(ppp, 2);
    end;
end;

% for each moderate perturbation
for ppp = (bpcounter+1):(bpcounter+mpcounter)
    ptime = rand * max_duration;    % equal prob to occur at any time
    magnitudeT = normrnd(midp_mean, midp_std);     % degrees C
    % <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>
    % increase the magnitudes by a factor of 2 for H1, H2 and H3 because
    % their ranges are larger
    magnitudeH1 = normrnd(2*midp_mean, 2*midp_std);     % degrees C
    magnitudeH2 = normrnd(2*midp_mean, 2*midp_std);     % degrees C
    magnitudeH3 = normrnd(2*midp_mean, 2*midp_std);     % degrees C
    signT = round(rand)*2 - 1;  % randomly an increase or a decrease
    signH1 = round(rand)*2 - 1;  % randomly an increase or a decrease
    signH2 = round(rand)*2 - 1;  % randomly an increase or a decrease
    signH3 = round(rand)*2 - 1;  % randomly an increase or a decrease
    perturbations(ppp, 1) = ptime;              % store time...
    perturbations(ppp, 2) = magnitudeT * signT;    % ...and impact
    perturbations(ppp, 3) = magnitudeH1 * signH1;    % ...and impact    
    perturbations(ppp, 4) = magnitudeH2 * signH2;    % ...and impact        
    perturbations(ppp, 5) = magnitudeH3 * signH3;    % ...and impact  
    % keep track of the size of the largest perturbation in this run
    if (magnitudeT > abs(max_perturbation))
        max_perturbation = perturbations(ppp, 2);
    end;
end;

% for each little perturbation
for ppp = (bpcounter+mpcounter+1):pcounter
    ptime = rand * max_duration;    % equal prob to occur at any time
    % <<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>>>>>>>
    magnitudeT = normrnd(littlep_mean, littlep_std);     % degrees C
    % increase the magnitudes by a factor of 2 for H1, H2 and H3 because
    % their ranges are larger
    magnitudeH1 = normrnd(2*littlep_mean, 2*littlep_std);     % degrees C
    magnitudeH2 = normrnd(2*littlep_mean, 2*littlep_std);     % degrees C
    magnitudeH3 = normrnd(2*littlep_mean, 2*littlep_std);     % degrees C
    signT = round(rand)*2 - 1;  % randomly an increase or a decrease
    signH1 = round(rand)*2 - 1;  % randomly an increase or a decrease
    signH2 = round(rand)*2 - 1;  % randomly an increase or a decrease
    signH3 = round(rand)*2 - 1;  % randomly an increase or a decrease
    perturbations(ppp, 1) = ptime;              % store time...
    perturbations(ppp, 2) = magnitudeT * signT;    % ...and impact
    perturbations(ppp, 3) = magnitudeH1 * signH1;    % ...and impact    
    perturbations(ppp, 4) = magnitudeH2 * signH2;    % ...and impact        
    perturbations(ppp, 5) = magnitudeH3 * signH3;    % ...and impact  
    % keep track of the size of the largest perturbation in this run
    if (magnitudeT > abs(max_perturbation))
        max_perturbation = perturbations(ppp, 2);
    end;
end;

% sort the perturbations into chronological order
perturbations = sortrows(perturbations,1);
