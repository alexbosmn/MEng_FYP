%% clean up
clear variables
clc
close all

%% load model
% mak_network;
% 
% %% generate data from a MAK model
% model.Y = Y;
% model.M = M;
% % maximum value of the initial conditions 
model.x0_maxValue = 50;
% % number of experiments generated
model.experiment_num = 1;
% % length of the simulation (sec)
model.t_f = 10;
% % set the signal-to-noise ratio for each state variable
model.SNR = 0;
% 
% % generate the data
% model = generateDataFromModel(model);

[std, t,noisy_data,dy] = generatedata_random(model.SNR,100,1,1);

model.dydt = dy;
model.variance = std;


%% generate dictionary
% polyorder = 2;
% [A,Phi,Y_Dict,monomes] = generateMAKDictionary(model,polyorder);
K = sqrt(0.1);
N=2;
A = zeros(length(noisy_data),8);
for i = 1:length(noisy_data)
    [u1, u2] = toggleinput(t,i);
    A(i,:) = [1/(1+(noisy_data(i,1)/K)^N) 1/(1+(noisy_data(i,2)/(K*(1+u1)))^N) 1/(1+(noisy_data(i,1)/(K*(1+u2)))^N) 1/(1+(noisy_data(i,2)/K)^N) noisy_data(i,1) noisy_data(i,2) noisy_data(i,1)^2 noisy_data(i,2)^2];
end
% Phi = {};
% Phi{1} = {'no input first term A'};
% Phi{2} = {'input first term B'};
% Phi{3} = {'input first term A'};
% Phi{4} = {'no input first term B'};
% Phi{5} = {'A'};
% Phi{6} = {'B'};
% Phi{7} = {'A^2'};
% Phi{8} = {'B^2'};
%% build a linear regression struct, i.e. y = A*x
sbl_diff.A = A;
sbl_diff.y = model.dydt;
sbl_diff.name = 'diff';
sbl_diff.state_names = {'x1'};
sbl_diff.experiment_num = model.experiment_num;
sbl_diff.std = model.variance;

%% simulate ODEx and report them
% [Morig,param_idx] = generateOrigParamMtx(M,Y,Y_Dict);
% TODO use only selected dictionaries
% sbl_config.selected_dict = 1:size(A{1},2);

% estimate only the selected states
sbl_config.selected_states = 1:size(model.dydt,2);

%% generate nonnegconstraints
param_num = size(A,2);
% sbl_config.nonneg = generateNonNegConstraints(sbl_diff,sbl_config,monomes);

sbl_config.max_iter = 10;
sbl_config.mode = 'SMV';
%% run SBL
tic;
fit_res_diff = vec_sbl(sbl_diff,sbl_config);
toc;
%% reporting
% turn on/off plots
disp_plot = 0;

% use manual tresholding
zero_th = 1e-6;
% select non zero dictionaries
fit_res_diff = calc_zero_th(fit_res_diff,zero_th,disp_plot);
% report signal fit
signal_fit_error_diff = fit_report(fit_res_diff,disp_plot);

%% Print out models
% green - correct dict found (OK)
% red   - missing dict 
% black - false  dict 
% printOutModel(fit_res_diff,Morig,Phi,[])

%% simulate the reconstructed ODE
tspan = [0:0.01:200];
initial = [0 1];

[t_orig,x_orig] = ode15s(@(t,x)toggleswitch(t,x),tspan,initial);

[t_sbl,x_sbl] = ode15s(@(t,x)getdata(t,x,cell2mat(fit_res_diff.sbl_param)),tspan,initial);

figure
plot(t_orig,x_orig(:,1),'LineWidth',2)
hold on
plot(t_orig,x_orig(:,2),'LineWidth',2)
plot(t_sbl(1:10:end),x_sbl(1:10:end,1),'--','LineWidth',1.7)
hold on
plot(t_sbl(1:10:end),x_sbl(1:10:end,2),'--','LineWidth',1.7)
xlabel('Time (min)','FontSize',18)
ylabel('Protein concentration [nM]','FontSize',18)
legend('True A','True B','Estimated A','Estimated B')
ax = gca;
ax.FontSize = 16; 

% simulateSBLresults(Phi,fit_res_diff,model)