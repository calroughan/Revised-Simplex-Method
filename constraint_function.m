function [A, c, b] = constraint_function(phi, d, G, K, question)
% This function builds the costs, constraints, and RHS vectors and matrices 
% into a standard computational form

% Inputs 
%   -   phi: Generator specific costs vector (1x9)
%   -   d: demands vector (1x10)
%   -   G: Maximum generation capacity vector (1x9)
%   -   K: Maximum arc flow vector (1x11)
%   -   question: Assignment question to tailor outputs to

% Outputs 
%   -   A: constraint matrix (mxn)
%   -   c: Costs vector (1xn)
%   -   b: RHS value vector 1xm)



% Define size vars
n_node = size(d, 2);
n_gen = size(G, 2);
n_arc = size(K, 2);

% Generator locations
A_generator = [1 1 1 0 0 0 0 0 0;
               0 0 0 1 0 0 0 0 0;
               0 0 0 0 1 0 0 0 0;
               0 0 0 0 0 1 0 0 0;
               0 0 0 0 0 0 0 0 0;
               0 0 0 0 0 0 1 0 0;
               0 0 0 0 0 0 0 0 0;
               0 0 0 0 0 0 0 1 0;
               0 0 0 0 0 0 0 0 0;
               0 0 0 0 0 0 0 0 1];

% Flow matrix
A_flows = [-1  0  0  0  0  0  0  0  0  0  0;
            1 -1 -1  0  0  0  0  0  0  0  0;
            0  1  0 -1  0  0  0  0  0  0  0;
            0  0  1  0 -1  0  0  0  0  0  0;
            0  0  0  1  1  1  0  0  0  0  0;
            0  0  0  0  0 -1 -1  1  0  0  0;
            0  0  0  0  0  0  1  0  1  0  0;
            0  0  0  0  0  0  0 -1 -1 -1  0;
            0  0  0  0  0  0  0  0  0  1  1;
            0  0  0  0  0  0  0  0  0  0 -1];
        
if(question>=2)
    
    % Costs
    c = [phi, zeros(1, 2*n_arc)];

    % RHS
    b = d;

    % Constraint matrix
    A = [A_generator, A_flows, -A_flows]; 

end        
        
if(question>=3)        
        
    % Costs
    c = [c, zeros(1, n_gen)];

    %RHS
    b = [b, G];

    % Constraint matrix
    A = [A, zeros(n_node, n_gen);
         eye(n_gen), zeros(n_gen, 2*n_arc), eye(n_gen)];        

end

if(question>=4)  

    % Costs
    c = [c, zeros(1, 2*n_arc)];

    % RHS
    b = [b, K, K];

    % Constraint matrix
    A = [A, [zeros(n_node, 2*n_arc); zeros(n_gen, 2*n_arc)];
         zeros(n_arc, n_gen), eye(n_arc), -eye(n_arc), zeros(n_arc, n_gen), eye(n_arc), zeros(n_arc);
         zeros(n_arc, n_gen), -eye(n_arc), eye(n_arc), zeros(n_arc, n_gen), zeros(n_arc), eye(n_arc)]; 

end

if(question>=5) 

    % Costs
    c = c;

    % RHS
    b = [b, 0, 0];

    % Constraint matrix
    Arc_const1 = [0, -1, 1, -1, 1, 0, 0, 0, 0, 0, 0, 0, 1, -1, 1, -1, 0, 0, 0, 0, 0, 0];
    Arc_const2 = [0, 0, 0, 0, 0, 0, 1, 1, -0.4, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0.4, 0, 0];

    A = [A;
         zeros(1, 9), Arc_const1, zeros(1, 31);
         zeros(1, 9), Arc_const2, zeros(1, 31)];

end

if(question>=6) 

    A_flows_U = [-1  0  0  0  0  0     0  0  0  0  0  0   ;
                  1 -1 -1  0  0  0     0  0  0  0  0  0   ;
                  0  1  0 -1  0  0     0  0  0  0  0  0   ;
                  0  0  1  0 -1  0     0  0  0  0  0  0   ;
                  0  0  0  1  1  0.95  0  0  0  0  0  0.85;
                  0  0  0  0  0 -1    -1  1  0  0  0 -1   ;
                  0  0  0  0  0  0     1  0  1  0  0  0   ;
                  0  0  0  0  0  0     0 -1 -1 -1  0  0   ;
                  0  0  0  0  0  0     0  0  0  1  1  0   ;
                  0  0  0  0  0  0     0  0  0  0 -1  0   ];

    A_flows_W = [ 1  0  0  0  0  0     0  0  0  0  0  0   ;
                 -1  1  1  0  0  0     0  0  0  0  0  0   ;
                  0 -1  0  1  0  0     0  0  0  0  0  0   ;
                  0  0 -1  0  1  0     0  0  0  0  0  0   ;
                  0  0  0 -1 -1 -1     0  0  0  0  0 -1   ;
                  0  0  0  0  0  0.95  1 -1  0  0  0  0.85;
                  0  0  0  0  0  0    -1  0 -1  0  0  0   ;
                  0  0  0  0  0  0     0  1  1  1  0  0   ;
                  0  0  0  0  0  0     0  0  0 -1 -1  0   ;
                  0  0  0  0  0  0     0  0  0  0  1  0   ];

    n_arc = size(A_flows_U, 2);

    % Costs
    c = [c, zeros(1, 4)];

    % RHS 
    K(6) = 500;
    b = [d, G, K, 500, K, 500, 0, 0];  

    % Constraint matrix
    Arc_const1 = [0, -1, 1, -1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, -1, 1, -1, 0, 0, 0, 0, 0, 0, 0];
    Arc_const2 = [0, 0, 0, 0, 0, 0, 1, 1, -0.4, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1, -1, 0.4, 0, 0, 0];

    A = [A_generator, A_flows_U, A_flows_W, zeros(n_node, 3*n_arc - n_arc + n_gen);
         eye(n_gen), zeros(n_gen, 2*n_arc), eye(n_gen), zeros(n_gen, 2*n_arc);  
         zeros(n_arc, n_gen), eye(n_arc), -eye(n_arc), zeros(n_arc, n_gen), eye(n_arc), zeros(n_arc);
         zeros(n_arc, n_gen), -eye(n_arc), eye(n_arc), zeros(n_arc, n_gen), zeros(n_arc), eye(n_arc);
         zeros(1, n_gen), Arc_const1, zeros(1, 3*n_arc - n_arc + n_gen);
         zeros(1, n_gen), Arc_const2, zeros(1, 3*n_arc - n_arc + n_gen)];

end


