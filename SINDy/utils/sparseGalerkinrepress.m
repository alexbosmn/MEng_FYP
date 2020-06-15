function dy = sparseGalerkinrepress(t,x,ahat)
% Copyright 2015, All Rights Reserved
% Code by Steven L. Brunton
% For Paper, "Discovering Governing Equations from Data: 
%        Sparse Identification of Nonlinear Dynamical Systems"
% by S. L. Brunton, J. L. Proctor, and J. N. Kutz

%yPool = poolData(y',length(y),polyorder,usesine);
K = 1600;
n=2;
Theta = [1/(1+(x(2)/K)^n) 1/(1+(x(4)/K)^n) 1/(1+(x(6)/K)^n) x(1) x(3) x(5) x(2) x(4) x(6)];
% K = sqrt(0.1);
% Theta = [1./(1+(t/K)) 1./(1+(t/K).^2) 1./(1+(t/K).^3) 1./(1+(t/K).^4) 1./(1+(t/K).^5) t t.^2 t.^3];
dy = (Theta*ahat)';