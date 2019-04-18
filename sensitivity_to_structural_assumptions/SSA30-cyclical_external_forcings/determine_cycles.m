% <<<<<<<<<<<<<<<<< SPECIAL THIS SA >>>>>>>>>>>>>>>>>>>>

% number of short period cycles
ncycles1 = floor(1.0+rand*4.0);

% number of long period cycles
ncycles2 = floor(1.0+rand*4.0);

ncycles = ncycles1 + ncycles2;

% short period (less than 1 My) cycles 
for iii = 1:ncycles1
    cperiods(iii) = rand*1000.0;     % 0 to 1My (1000 ky)
end

% long period (less than 1 My) cycles 
for iii = (ncycles1+1):ncycles
    cperiods(iii) = rand*500000.0;     % 0 to 500My (0.5 By)
end

% fill with NaNs
for iii = (ncycles+1):8
    cperiods(iii) = NaN;           % if no cycles then fill in with NaNs
end

% lastly, calculate amplitudes
for iii = 1:ncycles
    camplitudes(iii) = rand*(fsd/5);   % between 0 and (fsd/5) 
end    

% fill with NaNs
for iii = (ncycles+1):8
    camplitudes(iii) = NaN;           % if no cycles then fill in with NaNs
end