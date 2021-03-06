clear all; close all;
addpath('./utils');
%% generate data
polyorder = 1;  % search space up to fifth order polynomials
usesine = 0;    % no trig functions
n = 2;          % 2D system
params.beta = 1;
params.gamma = 1;
K = sqrt(0.1);
N=2;
n_iter=10;
start = 0; step = 0.01; endv=200;
tspan = [start:step:endv];
initial = [0 1];
%f = @(t,x)[params.beta./(1 + (x(2)/K)^N) - params.gamma.*x(1);
% params.beta./(1 + (x(1)/K)^N) - params.gamma.*x(2)];
[t x]=ode45(@(t,x)toggle_noinput(t,x),tspan,initial);

%% compute derivative
eps = 0.01;      % noise strength
for i=1:length(x)
    dx(i,:) = toggle_noinput(t(i,:),x(i,:))';
end
dx = dx + eps*randn(size(dx));   % add noise

%% pool data
%Theta = poolData(x,n,polyorder,usesine);

% Theta = [1./(1+(x/K)) 1./(1+(t/K).^2) 1./(1+(t/K).^3) 1./(1+(t/K).^4) 1./(1+(t/K).^5) t t.^2 t.^3];

% for i = 1:length(t)
% Theta(i,:) = [1/(1+(x(i,1)/K)^N) x(i,1)];
% end
K1 = sqrt(0.3);

for i = 1:length(x)
    Theta(i,:) = [1/(1+(x(i,1)/K)^N) 1/(1+(x(i,2)/K)^N) x(i,1) x(i,2) x(i,1)^2 x(i,2)^2 1/(1+(x(i,1)/K))];
end
% 1/(1+(x(i,1)/K))  1/(1+(x(i,1)/K)^3) 1/(1+(x(i,2)/K)) x(i,2)^4 1/(1+(x(i,1)/K1)) 1/(1+(x(i,1)/K1)^N) 1/(1+(x(i,1)/K1)^3) 1/(1+(x(i,2)/K1)) 1/(1+(x(i,2)/K1)^N) 1/(1+(x(i,2)/K1)^3)
m=size(Theta,2);

%% compute sparse regression: sequential least squares
lambda = 0.5; %sparsification knob
Xi = sparsifyDynamics(Theta,dx,lambda,n,n_iter)
%poolDataLIST({'x','y'}, Xi, n,polyorder,usesine);


%% plot fit
% figure
% title('x1 RHS fit')
% plot(t,dx(:,1))
% hold on
% plot(t,Theta*Xi(:,1))
%
% figure
% title('x2 RHS fit')
% plot(t,dx(:,2))
% hold on
% plot(t,Theta*Xi(:,2))
%
figure
title('whole fit')
plot(t,dx(:,1),'LineWidth',4)
hold on
plot(t,dx(:,2),'LineWidth',4)
plot(t,Theta*Xi(:,1),'LineWidth',2)
plot(t,Theta*Xi(:,2),'LineWidth',2)
legend('true x1','true x2','estimated x1','estimated x2')


%% FIGURE 1: TOGGLE SWITCH
[tA,xA]=ode45(@(t,x)toggle_noinput(t,x),tspan,initial); %true model
[tB,xB]=ode45(@(t,x)sparseGalerkin1(t,x,Xi),tspan,initial); %approx

% figure
% dtA = [0; diff(tA)];
% plot(xA(:,1),xA(:,2),'r','LineWidth',1.5);
% hold on
% dtB = [0; diff(tB)];
% plot(xB(:,1),xB(:,2),'k--','LineWidth',1.2);
% xlabel('x_1','FontSize',13)
% ylabel('x_2','FontSize',13)
% l1 = legend('True','Identified');

figure
plot(tA,xA(:,1),'r','LineWidth',1.5)
hold on
plot(tA,xA(:,2),'b-','LineWidth',1.5)
plot(tB(1:10:end),xB(1:10:end,1),'k--','LineWidth',1.2)
hold on
plot(tB(1:10:end),xB(1:10:end,2),'k--','LineWidth',1.2)
xlabel('Time')
ylabel('State, x_k')
legend('True x_1','True x_2','Identified')