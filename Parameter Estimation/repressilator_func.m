
function X = repressilator_func(alpha)
%define parameters

delta = 5.78*10^-3;
gamma = 1.16*10^-3;
k = 0.116;
n=2;
K = 1600;
a_0 = 5*10^-4;
start = 0;
endv = 72000; 
step = 10;

%define ODEs
f = @(t,x) [alpha./(1+(x(6)./K).^n) + a_0 - delta.*x(1);
    k.*x(1) - gamma.*x(2);
    alpha./(1+(x(2)./K).^n) + a_0 - delta.*x(3);
    k.*x(3) - gamma.*x(4);
    alpha./(1+(x(4)./K).^n) + a_0 - delta.*x(5);
    k.*x(5) - gamma.*x(6)];

tspan = [start:step:endv];
initial = [10 1700 10 450 10 50];
[T X]=ode15s(@(t,x)f(t,x),tspan,initial);



