clear all
close all

%define parameters
beta = 1;
gamma = 1;
K = sqrt(0.1);
n=2;
u_in1=1;
u_in2=2;
start = 0;
step = 0.01;
endv=200;

tspan = [start:step:endv];
initial = [0 1];
[T X]=ode45(@(t,x)toggleswitch(t,x),tspan,initial);
plot(tspan,X,'LineWidth',4)
legend('A', 'B')
ax = gca;
ax.FontSize = 16; 
xlabel('Time [min]','FontSize',18)
ylabel('Protein Concentration [nM]','FontSize',18)


% nullclines without input
y1 = [0:0.01:10];
x1 = beta./gamma./(1+(y1./K).^n);
x2 = [0:0.01:10];
y2 = beta./gamma./(1+(x2./K).^n);

figure
plot(x1,y1,'r','LineWidth',2)
hold on
plot(x2,y2,'b','LineWidth',2)
axis([0 1 0 1])
xlabel('A','FontSize',14)
ylabel('B','FontSize',14)
% title('Nullclines without input')
ax = gca;
ax.FontSize = 16; 
legend('A nullcline','B nullcline')

%nullclines with input
x1_u = beta./(gamma.*(1+(y1./(K.*(1+u_in1))).^n));
y2_u = beta./(gamma.*(1+(x2./(K.*(1+u_in2))).^n));

figure
plot(x1_u,y1,'r','LineWidth',2)
hold on
plot(x2,y2,'b','LineWidth',2)
axis([0 1 0 1])
xlabel('A','FontSize',14)
ylabel('B','FontSize',14)
% title('Nullclines with input in dA/dt')
ax = gca;
ax.FontSize = 16; 
legend('A nullcline','B nullcline')

figure
plot(x1,y1,'r','LineWidth',2)
hold on
plot(x2,y2_u,'b','LineWidth',2)
axis([0 1 0 1])
xlabel('A','FontSize',14)
ylabel('B','FontSize',14)
% title('Nullclines with input in dB/dt')
ax = gca;
ax.FontSize = 16; 
legend('A nullcline','B nullcline')

%extract values
nvalue = 1000;
y = round(linspace(1,size(X,1),nvalue));
newX = zeros(size(y,2),2);
for i = 1:size(y,2)-1
    newX(i,:) = X(y(i),1:1:end);
end

noisyX = awgn(newX,30,'measured');

figure
plot(linspace(start,endv,nvalue),newX)
xlabel('Time (min)')
ylabel('Protein concentration (nM)')
hold on
plot(linspace(start,endv,nvalue),noisyX)
legend('A','B','noisy A','noisy B')
title('Toggle Switch, SNR = 30dB')

noise = noisyX-newX;


