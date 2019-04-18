% script to (calculate and) print a summary of the results obtained from a
% large set of reruns of planets (i.e. a large 'batch' or simulation). The
% results that are calculated are those that are needed for the paper, in
% particular those that are needed for the table of sensitivity analysis
% results

% asssume that planet and run information has already been loaded
%load ('results/SA1_SR2_10000x50_26Aug2016/workspace_dump');

%fprintf('\n  SUMMARY OF RESULTS FROM SENSITIVITY ANALYSIS NUMBER 01\n\n');
fprintf('\n  SUMMARY OF RESULTS FROM THESE RUNS\n\n');

% planets
npl = length(planets);
fprintf('Total number of planets was %d\n', npl);
c1 = 0; c2 = 0;
for ii = 1:npl
    if (planets(ii).all_survived)
        c1 = c1 + 1;
    end;
    if (planets(ii).any_survived)
        c2 = c2 + 1;
    end;
end;
fprintf('Number of successful planets (some success) was %d\n', c2);
fprintf('Number of perfect planets (100%% success) was %d\n\n', c1);

% runs
nruns = length(runs);
fprintf('Total number of runs was %d\n', nruns);
c3 = 0;
for ii = 1:nruns
    if (runs(ii).result == 1)
        c3 = c3 + 1;
    end;
end;
fprintf('Number of successful runs was %d (= average of %d reruns per planet)\n\n', ...
    c3, round(c3/npl));

%% runs
% <<<<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
nruns = length(runs);
fprintf('Total number of runs was %d\n', nruns);
rcounts = zeros([8 1]);
for ii = 1:nruns
    if (runs(ii).result == 0)
        rcounts(1) = rcounts(1) + 1;
    elseif (runs(ii).result == -1)
        rcounts(2) = rcounts(2) + 1;
    elseif (runs(ii).result == 10)
        rcounts(3) = rcounts(3) + 1;
    elseif (runs(ii).result == 11)
        rcounts(4) = rcounts(4) + 1;
    elseif (runs(ii).result == 20)
        rcounts(5) = rcounts(5) + 1;
    elseif (runs(ii).result == 21)
        rcounts(6) = rcounts(6) + 1;
    elseif (runs(ii).result == 30)
        rcounts(7) = rcounts(7) + 1;
    elseif (runs(ii).result == 31)
        rcounts(8) = rcounts(8) + 1;
    elseif (runs(ii).result == 1)  % successful ones
    else
        fprintf('summary: shouldnt be able to get here (bad result value)\n\n')
    end
end
fprintf('%d out of %d runs stayed habitable (average of %.1f out of %d reruns per planet)\n', ...
    c3, nruns, (round(10*c3/npl)/10.0), (nruns/npl));
fprintf('%d out of %d runs went uninhabitable:\n', (nruns-c3), nruns);
fprintf('   %d because too hot\n',      rcounts(1));
fprintf('   %d because too cold\n',     rcounts(2));
fprintf('   %d because H1 too high\n',  rcounts(3));
fprintf('   %d because H1 too low\n',   rcounts(4));
fprintf('   %d because H2 too high\n',  rcounts(5));
fprintf('   %d because H2 too low\n',   rcounts(6));
fprintf('   %d because H3 too high\n',  rcounts(7));
fprintf('   %d because H4 too low\n\n', rcounts(8));

% <<<<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
% compare starting and end values of all variables, for first 10 runs
for runc = 1:100
    if ((runs(runc).Tinit == runs(runc).Tfinal) || ...
            (runs(runc).H1init == runs(runc).H1final) || ...
            (runs(runc).H2init == runs(runc).H2final) || ...
            (runs(runc).H3init == runs(runc).H3final))
        fprintf(' for run %d, some final values are identical to initial values\n', ...
            runc);
        if (runs(runc).Tinit == runs(runc).Tfinal)
            fprintf('   Tinit = %.3f and Tfinal = %.3f\n', ...
                runs(runc).Tinit, runs(runc).Tfinal);
        elseif (runs(runc).H1init == runs(runc).H1final)
            fprintf('   H1init = %.3f and H1final = %.3f\n', ...
                runs(runc).H1init, runs(runc).H1final);
            
        elseif (runs(runc).H2init == runs(runc).H2final)
            fprintf('   H2init = %.3f and H2final = %.3f\n', ...
                runs(runc).H2init, runs(runc).H2final);
            
        elseif (runs(runc).H3init == runs(runc).H3final)
            fprintf('   H3init = %.3f and H3final = %.3f\n', ...
                runs(runc).H3init, runs(runc).H3final);
        else
            error('logically impossible\n');
        end
    end
end

% <<<<<<<<<<<<<<<< SPECIAL FOR THIS SA >>>>>>>>>
% produce scatterplots of final H1, H2, H3 values
Tf = zeros([(nplanets*nreruns) 1]);
H1f = zeros([(nplanets*nreruns) 1]);
H2f = zeros([(nplanets*nreruns) 1]);
H3f = zeros([(nplanets*nreruns) 1]);
for runc = 1:(nplanets*nreruns)
    Tf(runc)  = runs(runc).Tfinal;
    H1f(runc) = runs(runc).H1final;
    H2f(runc) = runs(runc).H2final;
    H3f(runc) = runs(runc).H3final;
end
figure(200);
subplot(5,1,1);
histogram(Tf);   xlabel('final temperature values');
subplot(5,1,2);
histogram(Tf);   xlabel('final temperature values [-20 to 80]');  
xlim([-20 80]);
subplot(5,1,3);
histogram(H1f);   xlabel('final H1 values');
subplot(5,1,4);
histogram(H2f);   xlabel('final H2 values');
subplot(5,1,5);
histogram(H3f);   xlabel('final H3 values');

% the metric (of destiny or chance) is the number of habitable (successful
% at least once out of all of its reruns) planets, referred to as NHAB.
%
% There are three values of this that need to be compared:
%
% 1. NHAB1, the value of NHAB obtained in the simulation.
%
% 2. NHAB2, the value of NHAB expected according to 'destiny' (i.e.
%    according to H2 in the paper). If planets are either (a) pre-destined
%    to be successful, i.e. 100% chance of success from the outset, or (b)
%    pre-destined to fail, i.e. 0% chance of success from the outset, then
%    the fraction of all planets that are habitable should be the same as
%    the fraction of all runs that are habitable. NHAB2 is then equal to
%    the number of successful runs divided by the total number of runs.
%
% 3. NHAB3, the value of NHAB expected according to 'chance' (i.e.
%    according to H1 in the paper). If it is all completely down to chance,
%    i.e. if all runs of all planets have an equal chance of staying
%    habitable, then the probability of each run staying habitable (Pr)
%    should be equal to the number of successful runs divided by the total
%    number of runs (NHAB2, as it happens). The probability of an
%    indvidual planet being habitable at least once out of NR reruns (Pp)
%    is then equal to 1.0 minus the probability of it going sterile all NR
%    times. As an equation:
%    Pp = [1.0 - (1.0-Pr)^NR]
%    NHAB3 is then equal to Pp multiplied by the total number of planets
%    that were simulated.
%
% Although NHAB3 is the most likely value of NHAB if it is all down to
% chance, other values are also possible because the equivalent of
% 'dice-rolling' is going on. The probability of obtaining any individual
% value of NHAB can be calculated because it follows the binomial
% distribution. The probability of getting exactly k successes out of n
% trials, when each trial has a probability p of success, is therefore
% [n!/(k!*(n-k)!)] * p^k * (1-p)^(n-k)
% This can be calculated in order to see how improbable it is that NHAB1
% is obtained when the outcome of every run is pure chance.

nhab2 = round(npl*c3/nruns);
fprintf('  NHAB2 (expected acc. to "destiny") = %d\n', nhab2);

nhab1 = c2;
fprintf('  NHAB1 (from simulation) = %d\n', nhab1);

% calculate the overall probability of a run being habitable
Pr = c3 / nruns;
% calculate the probability of one or more out of a planet's multiple
% reruns being habitable, if only a matter of chance
Pp = 1.0 - ((1.0-Pr)^nreruns);
% calculate the most likely number of habitable planets, if all down to
% chance (this is going to be identical to Pp*nplanets in almost all cases)
nhab3 = floor(Pp*(npl+1));
fprintf('  NHAB3 (expected acc. to "chance") = %d\n', nhab3);


% summary statements
if ((nhab2 < nhab1) && (nhab1 < nhab3))
    fprintf('\nSAME OUTCOME AS STANDARD MODEL (nhab2 < nhab1 < nhab3)\n');
else
    fprintf('\n\nDIFFERENT OUTCOME FROM STANDARD MODEL: NOT (nhab2 < nhab1 < nhab3\n');
end;


% calculate the probability of nhab = nhab1 if it is all a matter of
% chance = [n!/(k!*(n-k)!)] * p^k * (1-p)^(n-k)
% pnhab1_chance = (factorial(npl)/(factorial(nhab1)*factorial(npl-nhab1)))...
%     * (Pp^nhab1) * ((1-Pp)^(npl-nhab1));
% numerical problems of doing all the full factorials, so try doing it by
% shorthand
% if (nhab1 < (npl/2))
%     num = 1;  den = 1;
%     for ii = (npl-nhab1+1) : npl
%         num = num * ii * (1-Pp);
%     end
%     num = num * (1-Pp) * (Pp^nhab1)
%     for ii = 1 : nhab1
%         den = den * ii;
%     end
%     den
%     res = num / den
% else
%     num = 1;  den = 1;
%     for ii = (nhab1+1) : npl
%         num = num * ii;
%     end
%     num
%     for ii = 1 : (npl-nhab1)
%         den = den * ii;
%     end
%     def
%     res = num / den
% end
% pnhab1_chance = res;

% calculate the probability of nhab = nhab1 if it is all a matter of
% chance. This can be calculated from the binomial distribution for the
% case of npl trials (planets) and Pp chance of success for each planet
pnhab1_chance = binopdf(nhab1,npl,Pp);
fprintf('\n  Probability of (NHAB=%d) if all down to chance is %8.2e\n\n',...
    nhab1, pnhab1_chance);

% finally, do a runstest and report the result
[h,p,stats] = runstest(allruns_durations);
if (h == 1)
    fprintf('runstest: run durations are NOT randomly distributed (H2 is rejected, p = %8.2e)\n\n', p);
else
    fprintf('\n******* UNEXPECTED RESULT *******\n');
    fprintf('runstest result: run durations may be randomly distributed (H2 is supported)\n\n');
end;
