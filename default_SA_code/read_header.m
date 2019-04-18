% this script reads in the header of a saved task output file and checks
% that it makes sense
%--------------------------------------------------------------------------

hname = sprintf('results/%s/header.mat', savename);
if ~exist(hname, 'file')
    fprintf('  ERROR: NO HEADER (%s)\n\n', hname);
else
    load(hname);   % should read in svname, np, nr, nt
    if ~strcmp(svname, savename)
        fprintf('  ERROR: SIMULATION NAMES DO NOT AGREE (%s) (%s)\n\n', ...
            svname, savename);
    end;
    if (np ~= nplanets)
        fprintf('  ERROR: NUMBERS OF PLANETS DO NOT AGREE (%d) (%d)\n\n', ...
            np, nplanets);
    end;
    if (nr ~= nreruns)
        fprintf('  ERROR: NUMBERS OF RUNS DO NOT AGREE (%d) (%d)\n\n', ...
            nr, nreruns);
    end;
end;
