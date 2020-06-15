clear all; close all;
addpath('./utils');
count_datapoints = 1;
count_noise = 1;
count_iter= 1;
rng(22689);

xaxis = [10:1:100]; %number of datapoints
yaxis = [0:2:60]; %noise levels
n_generations = 1;
n_iter = 10; %this is from changing the number of iterations in least squares but we came to the conclusion that it didn't have an effect on the error
master_data = cell(n_generations,length(yaxis),length(xaxis));
RNMSE=zeros(length(yaxis),length(xaxis),n_generations);


for generation = 1:n_generations
    for noise = yaxis
        for num_data_points = xaxis
        %% generate data
        [t,x_noisy,dx] = generatedata_random(noise,num_data_points,1,1);
        
        %% create dictionary 

        K = sqrt(0.1); N=2;

        Theta = zeros(length(x_noisy),8);
        for i = 1:length(x_noisy)
            [u1, u2] = toggleinput(t,i);
            Theta(i,:) = [1/(1+(x_noisy(i,1)/K)^N) 1/(1+(x_noisy(i,2)/(K*(1+u1)))^N) 1/(1+(x_noisy(i,1)/(K*(1+u2)))^N) 1/(1+(x_noisy(i,2)/K)^N) x_noisy(i,1) x_noisy(i,2) x_noisy(i,1)^2 x_noisy(i,2)^2];
        end
%         m=size(Theta,2);

        %% compute sparse regression: sequential least squares
        n=2;
        lambda = 0.1; %sparsification knob
        Xi = zeros(8,2);
        Xi = sparsifyDynamics(Theta,dx,lambda,n,n_iter);

        %% error
        X_real =[0 0; 1 0; 0 1; 0 0;-1 0; 0 -1; 0 0;0 0]; %what the output of Xi should be
        RNMSE(count_noise,count_datapoints,count_iter) = norm(X_real-Xi)/norm(X_real); %calculates the error
        
        %save data into matrix that has all values
        datamatrix = {Xi,Theta,dx,t,x_noisy};
        master_data(count_iter,count_noise,count_datapoints) = {datamatrix};
        
        %increases the count for number of datapoints to have a matrix that
        %is the number of datapoints x SNR x number of generations
        if count_datapoints < size(xaxis,2)
            count_datapoints = count_datapoints+1;
        else
            count_datapoints = 1;
        end
        

        %
            %% FIGURE 1: TOGGLE SWITCH
            start = 0; step = 0.01; endv=200;
            tspan = [start:step:endv];
            initial = [0 1];
            [tA,xA]=ode45(@(t,x)toggleswitch_params(t,x,1,1),tspan,initial); %true model
            [tB,xB]=ode45(@(t,x)sparseGalerkin2(t,x,Xi),tspan,initial); %approx
        
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
        end
        if count_noise < size(yaxis,2)
            count_noise = count_noise+1;
        else count_noise = 1;
        end
    end
    count_iter=count_iter+1;
end

mean_RNMSE = mean(RNMSE,3);

