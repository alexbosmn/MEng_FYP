function dy = sparseGalerkin2(t,y,ahat)
% Copyright 2015, All Rights Reserved
% Code by Steven L. Brunton
% For Paper, "Discovering Governing Equations from Data: 
%        Sparse Identification of Nonlinear Dynamical Systems"
% by S. L. Brunton, J. L. Proctor, and J. N. Kutz
    K = sqrt(0.1);
    N=2;
    
        if t<=50
        u1 = 0;
        u2 = 0;
    elseif 50< t && t <75
        u1 = 1;
        u2 = 0;
    elseif 75<=t && t <150
        u1 = 0;
        u2 = 0;
    elseif 150<=t && t <175
        u1 = 0;
        u2 = 1;
    elseif t>=175
        u1 = 0;
        u2 = 0;
    end
%     u1 = sin(0.03*t);
%     u2 = -sin(0.03*t);
    
    Theta = [1/(1+(y(1)/K)^N) 1/(1+(y(2)/(K*(1+u1)))^N) 1/(1+(y(1)/(K*(1+u2)))^N) 1/(1+(y(2)/K)^N) y(1) y(2) y(1)^2 y(2)^2 1/(1+(y(1)/K))];
    dy = (Theta*ahat)';
 
end