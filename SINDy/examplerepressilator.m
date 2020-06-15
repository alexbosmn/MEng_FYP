clear all, close all, clc
addpath('./utils');

%% generate Data
polyorder = 5;
usesine = 0;
n = 6;
alpha = 800;
delta = 5.78*10^-3;
gamma = 1.16*10^-3;
start = 0;
endv = 72000; 
step = 10;
tspan = [start:step:endv];
initial = [10 1700 10 450 10 50];
[t x]=ode45(@(t,x)repressilator_param(t,x,alpha,delta,gamma),tspan,initial);

%% compute Derivative
for i=1:length(x)
    dx(i,:) = repressilator_param(0,x(i,:),alpha,delta,gamma);
end
dx = dx + eps*randn(size(dx));   % add noise

%% pool Data  (i.e., build library of nonlinear time series)
K = 1600;
n=2;

for i = 1:length(x)
    Theta(i,:) = [1/(1+(x(i,2)/K)^n) 1/(1+(x(i,4)/K)^n) 1/(1+(x(i,6)/K)^n) x(i,1) x(i,3) x(i,5) x(i,2) x(i,4) x(i,6)];
end


m = size(Theta,2);

%% compute Sparse regression: sequential least squares
lambda = 0.000001;      % lambda is our sparsification knob.
Xi = sparsifyDynamics(Theta,dx,lambda,n);


figure
plot(t,dx(:,2),'LineWidth',2.5)
hold on 
plot(t,dx(:,4),'LineWidth',2.5)
plot(t,dx(:,6),'LineWidth',2.5)
plot(t,Theta*Xi(:,2),'k--')
plot(t,Theta*Xi(:,4),'k--')
plot(t,Theta*Xi(:,6),'k--')
legend('True dP1/dt','True dP2/dt','True dP3/dt','Identified')
title('Comparison of identified differentiated data to true differentiated data')

%% FIGURE 1: TOGGLE SWITCH
[tA,xA]=ode45(@(t,x)repressilator_param(t,x,alpha,gamma,delta),tspan,initial); %true model
[tB,xB]=ode45(@(t,x)sparseGalerkinrepress(t,x,Xi),tspan,initial); %approx

figure
plot(tA,xA(:,2),'LineWidth',2)
hold on
plot(tA,xA(:,4),'LineWidth',2)
plot(tA,xA(:,6),'LineWidth',2)
plot(tB,xB(:,2),'k--','LineWidth',1.2)
plot(tB,xB(:,4),'k--','LineWidth',1.2)
plot(tB,xB(:,6),'k--','LineWidth',1.2)
legend('True P1','True P2','True P3','Identified')
%plot(tA,xA)
