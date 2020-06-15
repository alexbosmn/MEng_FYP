clear all
close all
clc

% Repressilator

% x(1) = m_a
% x(2) = A
% x(3) = m_b
% x(4) = B
% x(5) = m_c
% x(6) = C

%define parameters
alpha = 800;
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

plot(tspan/60,X(:,2),'LineWidth',4)
hold on
plot(tspan/60,X(:,4),'LineWidth',4)
plot(tspan/60,X(:,6),'LineWidth',4)
legend('A', 'B','C')
ax = gca;
ax.FontSize = 16;
xlabel('Time [min]','FontSize',18)
ylabel('Protein concentration [nM]','FontSize',18)


% sample values
nvalue = 1000;
y = round(linspace(1,size(X,1),nvalue));
y = unique(y);
%assert(nvalue>)
newX = zeros(size(y,2),3);
for i = 1:size(y,2)-1
    newX(i,:) = X(y(i),2:2:end);
end

figure
plot(linspace(start,endv,nvalue)/60,newX,'LineWidth',4)
xlabel('Time (min)','FontSize',18)
ylabel('Protein concentration (nM)','FontSize',18)
ax = gca;
ax.FontSize = 16; 

noisyX = awgn(newX,20,'measured');
hold on
plot(linspace(start,endv,nvalue)/60,noisyX)
legend('A','B','C','noisy A','noisy B','noisy C')
title('Repressilator, SNR = 20dB')

noise = noisyX-newX;

