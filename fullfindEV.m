function [s,minrc] = fullfindEV(m, n, c, A, basicvars, pi, phase1) 
% Returns the index of the entering variable and it's reduced cost, 
% or returns 0 if no entering variable exists.

% Cal Roughan 
% 30 / 4 / 2019

% Input: 
%   m,n       = number of constraints and variables 
%   c         = If Phase 1: (m+n)x1 cost vector 
%             = Else if Phase 2: mx1 cost vector
%   A         = mxn constraint matrix 
%   basicvars = 1xm vector of indices of basic variables 
%   pi        = mx1 dual vector 
%   phase1    = boolean, phase1 = true if Phase 1, or false otherwise 

% Output: 
%   s     = index of the entering variable 
%   minrc = reduced cost of the entering variable

% If in Phase 1 concatenate A with artificial contraints 
if phase1 == 1
    A = [A, eye(size(A, 1))];
end

% Reduced cost of all vars
cN = c.' - (pi.')*(A);

% NaN values that are not in the basis
cN(basicvars) = NaN;

% Find the minimum and the ratio
[minrc, s] = min(cN);

% If no entering variable exists:
if isnan(min(cN)) || minrc >= 0
    s = 0;
end

end
