function [r,minratio] = fullfindLV(m, n, xB, BinvAs, phase1, basicvars) 
% Returns the position in the basis of the leaving variable, 
% or returns 0 if no leaving variable exists 

% Cal Roughan 
% 30 / 4 / 2019

% Input: 
%   m,n       = number of constraints and variables 
%   xB        = mx1 basic variable vector 
%   BinvAs    = mx1 vector of Binv*As 
%   phase1    = boolean, phase1 = true if Phase 1, or false otherwise 
%   basicvars = 1xm vector of indices of basic variables 

% Output: 
%   r        = position in the basis of the leaving variable 
%   minratio = minimum ratio from ratio test

% Test if the Extended Leaving Variable Criterion can be invoked
if phase1 == 0 && sum(basicvars>n) ~= 0
    
    % NaN any values where BinvAs is 0 and choose the first artificial in
    % the basis.
    ELVC_temp = basicvars;
    ELVC_temp(BinvAs == 0) = NaN;
    r = find(ELVC_temp > n, 1);
    minratio = 0;
    
    if ~isempty(r)
        return
    end
end 


% Regular leaving criteria

% NaN negative values from further consideration
BinvAs(BinvAs <= 0) = NaN;

% Ratio test
[minratio, r] = min(xB ./ BinvAs);

% If no leaving variable is found, r = 0
if isnan(min(BinvAs)) || isnan(min(basicvars))
    r = 0;
    minratio = 0;
end

end