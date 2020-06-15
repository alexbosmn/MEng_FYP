function dy = sparseGalerkin1(t,y,ahat)
% Copyright 2015, All Rights Reserved
% Code by Steven L. Brunton
% For Paper, "Discovering Governing Equations from Data: 
%        Sparse Identification of Nonlinear Dynamical Systems"
% by S. L. Brunton, J. L. Proctor, and J. N. Kutz
    K = sqrt(0.1);
    N=2;

    Theta = [1/(1+(y(1)/K)^N) 1/(1+(y(2)/K)^N) y(1) y(2) y(1)^2 y(2)^2 1/(1+(y(1)/K))];
    dy = (Theta*ahat)';
 
end