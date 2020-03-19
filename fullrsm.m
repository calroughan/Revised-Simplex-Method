function [result,z,x,pi,basicvars,Binv] = fullrsm(m,n,c,A,b) 
% Solves a linear program using Gauss-Jordan updates 
% Assumes standard computational form 
% Performs a Phase I procedure starting from an artificial basis 

% Cal Roughan 
% 30 / 4 / 2019

% Input: 
%   m,n       = number of constraints and variables 
%   c         = nx1 cost vector 
%   A         = mxn constraint matrix 
%   b         = mx1 rhs vector 

% Output: 
%   result    = 1 if problem optimal, 0 if infeasible, -1 if unbounded 
%   z         = objective function value 
%   x         = nx1 solution vector 
%   pi        = mx1 dual vector 


basicvars = n+1:n+m;
phase1 = 1;

% index of vars if they are in the basis, 0 otherwise.
varstatus = zeros(1, n);

% Binv = I
Binv = eye(m);

% Compute xB
xB = Binv * b;

% Cost vectors
c_P2 = c;
cB(1:m, 1) = 1;
c = [zeros(n, 1); cB];

% Phase 1
while true

    % Duals vector
    pi = calc_pi(cB, Binv);

    [s,minrc] = fullfindEV(m, n, c, A, basicvars, pi, phase1);
    
    if s == 0 || sum(basicvars > n) == 0
        break
    end
    
    % Compute BinvAs
    BinvAs = calc_BinvAs(m, phase1, A, Binv, s);

    % Find the leaving variable
    [r,minratio] = fullfindLV(m, n, xB, BinvAs, phase1, basicvars);
            
    % Update the basis etc
    [varstatus,basicvars,cB,Binv,xB] = fullupdate(m, c, s, r, BinvAs, phase1, varstatus, basicvars, cB, Binv, xB);

end

% Calculate the solution vector: x
x = zeros(n+m, 1);
x(basicvars) = xB;

% Calculate the objective function value
z = c.' * x;

if z > 0
    result = 0;
    return
end

% Restore variables to original values for Phase 2
c = [c_P2; zeros(m, 1)];
cB = c(basicvars);
c = c_P2;
phase1 = 0;

% Phase 2
while true
    
    % Duals vector
    pi = calc_pi(cB, Binv);

    [s,minrc] = fullfindEV(m, n, c, A, basicvars, pi, phase1);

    if s == 0
        result = 1;
        break
    end

    % Compute BinvAs
    BinvAs = calc_BinvAs(m, phase1, A, Binv, s);

    % Find the leaving variable
    [r,minratio] = fullfindLV(m, n, xB, BinvAs, phase1, basicvars);
    
    % Test for unboundedness
    if r == 0
        result = -1;
        return
    end
        
    % Update the basis etc
    [varstatus,basicvars,cB,Binv,xB] = fullupdate(m, c, s, r, BinvAs, phase1, varstatus, basicvars, cB, Binv, xB);

end    

% Calculate the solution vector: x
x = zeros(n, 1);
x(basicvars) = xB;
x = x(1:n);

% Calculate the objective function value
z = c.' * x;

end