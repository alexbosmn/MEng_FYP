function dFdt = repressilator_param(t,x,alpha,delta,gamma)

    k = 0.116;
    n=2;
    K = 1600;
    a_0 = 5*10^-4;
    start = 0;
    endv = 72000; 
    step = 10;
    
    dFdt = [alpha./(1+(x(6)./K).^n) + a_0 - delta.*x(1);
        k.*x(1) - gamma.*x(2);
        alpha./(1+(x(2)./K).^n) + a_0 - delta.*x(3);
        k.*x(3) - gamma.*x(4);
        alpha./(1+(x(4)./K).^n) + a_0 - delta.*x(5);
        k.*x(5) - gamma.*x(6)];
end