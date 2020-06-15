function dFdt = toggleswitch_params(t,x,beta,gamma)

K = sqrt(0.1);
n=2;

if t<=50
    u1 = 0;
    u2 = 0;
elseif 50< t && t <75
    u1 = 1;
    u2 = 0;
elseif 75<=t && t <150
            u1 = 0;
            u2 = 0;
elseif 150<=t && t <=175
                u1 = 0;
                u2 = 1;
elseif t>175
                    u1 = 0;
                    u2 = 0;

end
%     u1 = sin(0.03*t);
%     u2 = -sin(0.03*t);
%x(1) = A
%x(2)=B
dFdt = [beta./(1 + (x(2)/(K*(1+u1)))^n) - gamma.*x(1);
    beta./(1 + (x(1)/(K*(1+u2)))^n) - gamma.*x(2)];
end


