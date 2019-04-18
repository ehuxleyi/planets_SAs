
% This script randomly determines coefficient values for this SA, where the
% coefficients determine how, and how strongly, H1, H2 and H3 influence T,
% and vice-versa
%--------------------------------------------------------------------------

% <<<<<<<<<<<< SPECIAL FOR THIS SA (WHOLE SCRIPT) >>>>>>>>>>>

global k1 k2 k3 k4 k5 k6

sign = round(rand)*2 - 1;  % randomly an increase or a decrease
% choose the coefficient in such a way that the maximum possible impact
% that H1 can have on T is of size 300 (by producing a coefficient between
% -2 and +2 that will be multiplied by a value between -100 and +100)
k1 = sign * rand * 2.0;

sign = round(rand)*2 - 1;  % randomly an increase or a decrease
% choose the coefficient in such a way that the maximum possible impact
% that H2 can have on T is of size 300 (by producing a coefficient between
% -2 and +2 that will be multiplied by a value between -100 and +100)
k2 = sign * rand * 2.0;

sign = round(rand)*2 - 1;  % randomly an increase or a decrease
% choose the coefficient in such a way that the maximum possible impact
% that H3 can have on T is of size 300 (by producing a coefficient between
% -2 and +2 that will be multiplied by a value between -100 and +100)
k3 = sign * rand * 2.0;

sign = round(rand)*2 - 1;  % randomly an increase or a decrease
% choose the coefficient in such a way that the maximum possible impact
% that T can have on H1 is of size 300 (by producing a coefficient between
% -2 and +2 that will be multiplied by a value between -100 and +100)
k4 = sign * rand * 1.0;

sign = round(rand)*2 - 1;  % randomly an increase or a decrease
% choose the coefficient in such a way that the maximum possible impact
% that T can have on H2 is of size 300 (by producing a coefficient between
% -2 and +2 that will be multiplied by a value between -100 and +100)
k5 = sign * rand * 1.0;

sign = round(rand)*2 - 1;  % randomly an increase or a decrease
% choose the coefficient in such a way that the maximum possible impact
% that T can have on H3 is of size 300 (by producing a coefficient between
% -2 and +2 that will be multiplied by a value between -100 and +100)
k6 = sign * rand * 1.0;


