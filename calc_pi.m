function pi = calc_pi(cB, Binv)
% This function calculates the duals vector.

% Cal Roughan 
% 30 / 4 / 2019

% Input: 
%   cB        = mx1 basic cost vector 
%   Binv      = mxm basis inverse matrix 

% Output: 
%   pi        = mx1 dual vector 

% Duals vector
pi = (cB.' * Binv).';
    
end