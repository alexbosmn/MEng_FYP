clear all; close all;clc;
NUM = 100;
a = 1;
b = 0.1;
SNR = 20;

x = [0:1:NUM-1];
%input function
y_g = a*sin(b*x);
%add noise
y_mes = transpose(add_awgn(y_g,SNR));

count = 0;
MAX = max(y_mes);
%populate the dictionnary
for i = 0.1:0.1:10
    count = count + 1;
    C(count,:) = [1 i i^2/2 i^3/factorial(3) i^4/factorial(4) i^5/factorial(5) i^6/factorial(6)];
end

x0=zeros(size(C,2),1);
options = optimset('MaxFunEvals',300*length(x0));
p=fminsearch(@(p)mycost(C,p,y_mes),x0,options);

plot(x,y_mes)
hold on
plot(x,C*p)

[p_lsqlin,resnorm] = lsqlin(C, y_mes,zeros(100,7), MAX*ones(100,1));

plot(x,C*p_lsqlin)
legend('measured data', 'model using my cost','model using LSQLIN')

function cost = mycost(regressor,current_parameters,measured_data)
      cost = 0.5 * norm(measured_data - regressor*current_parameters).^2;
      disp(cost)
end