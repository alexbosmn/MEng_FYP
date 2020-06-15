clc;clear all;close all;

%Parameter estimation of ODE models

beta_orig = 1; gamma_orig =1; K = sqrt(0.1); n=2; u_in1=1; u_in2=2; start = 0; step = 0.01; endv=200;

%run ODE45
tspan = [start:step:endv];
initial = [0 1];

[T X]=ode45(@(t,x)toggleswitch_params(t,x,beta_orig,gamma_orig),tspan,initial);


%extract a certain number of values
nvalue = 300;
y = round(linspace(1,size(X,1),nvalue));
newX = zeros(size(y,2),2);
for i = 1:size(y,2)-1
    newX(i,:) = X(y(i),1:1:end);
end

noisyX = add_awgn2(newX,20);

x0 = [1 1];
p = fminsearch(@(p)mycost_ODE2(p,noisyX),x0);
%sprintf('beta = %5.2f, gamma = %5.2f',p(1),p(2))

plot(linspace(0,200,nvalue),noisyX,'LineWidth',2)
hold on
plot(linspace(0,200,nvalue),toggle_func2(p(1),p(2)),'LineWidth',4)
ax = gca;
ax.FontSize = 16; 
legend('Measured A','Measured B', 'Model prediction of A','Model prediction of B')
ylabel('Protein Concentration [nM]','FontSize',18)
xlabel('Time [min]','FontSize',18)
