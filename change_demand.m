function [updated_costs] = change_demand(m, Binv, b, d, c, basicvars, z)
% This function calculates the energy price at each node.

% Inputs 
%   -   m: rows of constraint matrix
%   -   Binv: Inverse of basis matrix (mxm)
%   -   b: RHS value (1xm)
%   -   d: demands vector (1x10)
%   -   c: costs vector (1xn)
%   -   basicvars: vector of indices of basic variables (1xm)
%   -   z: Original optimal value

% Outputs 
%   -   updated_costs: Change in costs associated with a change to RHS
%       variable (1x10)

delta = eye(m);
Binvb = Binv*b.';

% Loop through all nodes
for i = 1:size(d, 2)

    % Calculate
    xB = Binvb + Binv*delta(:, i);
    
    % Check if any xB's are negative
    if any(xB < 0)
        continue
    end
    
    % Calculate the basic costs
    cB = c(basicvars)*xB;
    updated_costs(i) = cB;
    
end

    % Subtract original cost
    updated_costs = updated_costs - z;
    
end