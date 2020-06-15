clc;clear all;close all;

%Parameter estimation of ODE models

beta_orig = 1; gamma = 1; K = sqrt(0.1); n=2; u_in1=1; u_in2=2; start = 0; step = 0.01; endv=200;

%run ODE45
tspan = [start:step:endv];
initial = [0 1];

[T X]=ode45(@(t,x)toggleswitch_param(t,x,beta_orig),tspan,initial);


%extract a certain number of values
nvalue = 300;
y = round(linspace(1,size(X,1),nvalue));
newX = zeros(size(y,2),2);
for i = 1:size(y,2)-1
    newX(i,:) = X(y(i),1:1:end);
end

noisyX = add_awgn2(newX,20);

x0 = 0;
p = fminsearch(@(p)mycost_ODE(p,noisyX),x0);
disp(p)
