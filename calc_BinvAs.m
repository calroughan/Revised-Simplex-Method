function BinvAs = calc_BinvAs(m, phase1, A, Binv, s)
% This function calculates BinvAs.

% Cal Roughan 
% 30 / 4 / 2019

% Input: 
%   m         = number of constraints 
%   phase1    = boolean, phase1 = true if Phase 1, or false otherwise 
%   A         = mxn constraint matrix 
%   Binv      = mxm basis inverse matrix 
%   s         = index of entering variable 

% Output: 
%   BinvAs    = mx1 vector of Binv*As 

% Calculate constraint matrix that includes artificial variables for
% BinvAs
if phase1 == 1
    A = [A, eye(m)];
end
    
% Compute BinvAs
BinvAs = Binv * A(:, s);

end