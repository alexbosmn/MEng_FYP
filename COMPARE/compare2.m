clear all; close all;
addpath('./utils');
addpath('./core');
addpath('./YALMIP/extras');
addpath('./YALMIP')
addpath('./ToggleSwitch')
addpath('./YALMIP/operators')
addpath('./YALMIP/solvers')
addpath('./YALMIP/modules')

count_datapoints = 1;
count_noise = 1;
count_iter= 1;
rng(22689);

xaxis = [10:1:100]; %number of datapoints
yaxis = [1:2:20]; %noise levels
n_generations = 3;
n_iter = 10; %this is from changing the number of iterations in least squares but we came to the conclusion that it didn't have an effect on the error
master_data_SBL = cell(n_generations,length(yaxis),length(xaxis));
master_data_SINDy = cell(n_generations,length(yaxis),length(xaxis));
RNMSE_SINDyA=zeros(length(yaxis),length(xaxis),n_generations);
RNMSE_SINDyB=zeros(length(yaxis),length(xaxis),n_generations);
which = zeros(length(yaxis),length(xaxis),n_generations);


for generation = 1:n_generations
    for noise = yaxis
        for num_data_points = xaxis
        %% generate data
        [var,t,x_noisy,dx] = generatedata_random2(noise,num_data_points,1,1);
        
        %% create dictionary 

        K = sqrt(0.1); N=2;

        Theta = zeros(length(x_noisy),8);
        for i = 1:length(x_noisy)
            [u1, u2] = toggleinput2(t,i);
            Theta(i,:) = [1/(1+(x_noisy(i,1)/K)^N) 1/(1+(x_noisy(i,2)/(K*(1+u1)))^N) 1/(1+(x_noisy(i,1)/(K*(1+u2)))^N) 1/(1+(x_noisy(i,2)/K)^N) x_noisy(i,1) x_noisy(i,2) x_noisy(i,1)^2 x_noisy(i,2)^2];
        end
%         m=size(Theta,2);

        [MSE_SINDyAtemp,MSE_SINDyBtemp,RNMSE_SINDyAtemp,RNMSE_SINDyBtemp,master_data_SINDytemp] = SINDy2(Theta,dx,t,x_noisy);
        
        RNMSE_SINDyA(count_noise,count_datapoints,count_iter)=RNMSE_SINDyAtemp;
        RNMSE_SINDyB(count_noise,count_datapoints,count_iter)=RNMSE_SINDyBtemp;
        MSE_SINDyA(count_noise,count_datapoints,count_iter) = MSE_SINDyAtemp;
        MSE_SINDyB(count_noise,count_datapoints,count_iter) = MSE_SINDyBtemp;
        master_data_SINDy(count_iter,count_noise,count_datapoints) = {master_data_SINDytemp};
        
        [MSE_SBLAtemp,MSE_SBLBtemp,RNMSE_SBLAtemp,RNMSE_SBLBtemp,master_data_SBLtemp] = SBL2(Theta,dx,var,x_noisy,t);
        
        RNMSE_SBLA(count_noise,count_datapoints,count_iter)=RNMSE_SBLAtemp;
        RNMSE_SBLB(count_noise,count_datapoints,count_iter)=RNMSE_SBLBtemp;
        MSE_SBLA(count_noise,count_datapoints,count_iter) = MSE_SBLAtemp;
        MSE_SBLB(count_noise,count_datapoints,count_iter) = MSE_SBLBtemp;
        master_data_SBL(count_iter,count_noise,count_datapoints) = {master_data_SBLtemp};
        
        
            if count_datapoints < size(xaxis,2)
                count_datapoints = count_datapoints+1;
            else
                count_datapoints = 1;
            end
        end
        if count_noise < size(yaxis,2)
            count_noise = count_noise+1;
        else count_noise = 1;
        end
    end
    count_iter=count_iter+1;
end

mean_RNMSE_SINDyA = mean(RNMSE_SINDyA,3);
mean_RNMSE_SINDyB = mean(RNMSE_SINDyB,3);

mean_RNMSE_SBLA = mean(RNMSE_SBLA,3);
mean_RNMSE_SBLB = mean(RNMSE_SBLB,3);

% mean_MSE_SINDyA = mean(MSE_SINDyA,3);
% mean_MSE_SINDyB = mean(MSE_SINDyB,3);
% 
% mean_MSE_SBLA = mean(MSE_SBLA,3);
% mean_MSE_SBLB = mean(MSE_SBLB,3);


% figure; surf(xaxis,yaxis,mean_MSE_SBLA);zlabel('MSE A SBL'); ylabel('SNR (dB)'); xlabel('Number of datapoints');
% figure; surf(xaxis,yaxis,mean_MSE_SBLB);zlabel('MSE B SBL');ylabel('SNR (dB)'); xlabel('Number of datapoints');
% figure;surf(xaxis,yaxis,mean_MSE_SINDyA);zlabel('MSE A SINDy');ylabel('SNR (dB)'); xlabel('Number of datapoints');
% figure;surf(xaxis,yaxis,mean_MSE_SINDyB);zlabel('MSE B SINDy');ylabel('SNR (dB)'); xlabel('Number of datapoints');

save('Comparisontestdiff_initial.mat','MSE_SINDyA','MSE_SINDyB','MSE_SBLA','MSE_SBLB','RNMSE_SINDyA','RNMSE_SINDyB','RNMSE_SBLA','RNMSE_SBLB','master_data_SBL','master_data_SINDy','mean_RNMSE_SBLA','mean_RNMSE_SBLB','mean_RNMSE_SINDyA','mean_RNMSE_SINDyB');
