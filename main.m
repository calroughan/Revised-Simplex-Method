% This is the main script which calls the constraint builder,
% revised simplex method, and demand change functions.

% 4 / 6 / 2019

% Input data
phi = [45 60 50 50 55 65 40 30 30];
d = [1952 722 60 284 855 0 1078 225 617 0];
G = [1000 430 400 1085 387 640 1750 800 885];
K = [500 600 500 800 600 1000 300 200 800 300 850];



%%% Question 2 %%%

[A2, c2, b2] = constraint_function(phi, d, G, K, 2);

% Dimensions
[m2, n2] = size(A2);

% Solve
[result2,z2,x2,~,~,~] = fullrsm(m2,n2,c2.',A2,b2.');



%%% Question 3 %%%

[A3, c3, b3] = constraint_function(phi, d, G, K, 3);

% Dimensions
[m3, n3] = size(A3);

% Solve
[result3,z3,x3,~,~,~] = fullrsm(m3,n3,c3.',A3,b3.');



%%% Question 4 %%%

[A4, c4, b4] = constraint_function(phi, d, G, K, 4);

% Dimensions
[m4, n4] = size(A4);

% Solve
[result4,z4,x4,~,basicvars4,Binv4] = fullrsm(m4,n4,c4.',A4,b4.');

% Objective cost changes
[updated_costs4] = change_demand(m4, Binv4, b4, d, c4, basicvars4, z4);



%%% Question 5 %%%

[A5, c5, b5] = constraint_function(phi, d, G, K, 5);

% Dimensions
[m5, n5] = size(A5);

% Solve
[result5,z5,x5,~,basicvars5,Binv5] = fullrsm(m5,n5,c5.',A5,b5.');

% Objective cost changes
[updated_costs5] = change_demand(m5, Binv5, b5, d, c5, basicvars5, z5);



%%% Question 6 %%%

[A6, c6, b6] = constraint_function(phi, d, G, K, 6);

% Dimensions
[m6, n6] = size(A6);

% Solve
[result6,z6,x6,~,basicvars6,Binv6] = fullrsm(m6,n6,c6.',A6,b6.');

% Objective cost changes
[updated_costs6] = change_demand(m6, Binv6, b6, d, c6, basicvars6, z6);