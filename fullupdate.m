function [varstatus,basicvars,cB,Binv,xB] = fullupdate(m,c,s,r,BinvAs,phase1,varstatus,basicvars,cB,Binv,xB) 
% Updates the basis representation. 

% Cal Roughan 
% 30 / 4 / 2019

% Input: 
%   m         = number of constraints 
%   c         = If Phase 1: (m+n)x1 cost vector 
%             = Else if Phase 2: mx1 cost vector
%   s         = index of entering variable 
%   r         = position in the basis of the leaving variable 
%   BinvAs    = mx1 Binv*As vector 
%   phase1    = boolean, phase1 = true if Phase 1, or false otherwise 
%   varstatus = 1xn vector, varstatus(i) = position in basis of variable i, 
%               or 0 if variable i is nonbasic 
%   basicvars = 1xm vector of indices of basic variables 
%   cB        = mx1 basic cost vector 
%   Binv      = mxm basis inverse matrix 
%   xB        = mx1 basic variable vector 

% Output: 
%   varstatus = 1xn updated varstatus vector 
%   basicvars = 1xm updated basicvars vector 
%   cB        = mx1 updated basic cost vector 
%   Binv       = mxm updated basis inverse matrix 
%   xB        = mx1 updated basic variable vector

% Find n
n = size(varstatus, 2);

% Define matrix
matrix = [xB Binv BinvAs];

% Divide r row by its value in BinvAs
matrix(r, :) = matrix(r, :) / BinvAs(r);

% Manipulate rows: GJ Pivot
for i = 1:size(basicvars, 2)
    if i ~= r
        matrix(i, :) = matrix(i, :) -1 * BinvAs(i) * matrix(r, :);
    end
end

% Updated xB
xB = matrix(:, 1);

% Strip first and last columns of matrix
matrix(:, 1) = [];
matrix(:, size(basicvars, 2) + 1) = [];

% Updated Binv
Binv = matrix;

% Update varstatus if the LV is not artificial
if basicvars(r) <= n
    varstatus(basicvars(r)) = 0;
end

% Update varstatus if the EV is not artificial
if s <= n
    varstatus(s) = r;
end

% Updated basicvars
basicvars(r) = s;

% Updated basic cost vector
c = [c; zeros(m, 1)];
cB = c(basicvars);
end