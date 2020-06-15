function [MSE_A,MSE_B,RNMSE_A,RNMSE_B,master_data] = SBL2(A,dy,var,x_noisy,t)
    % % maximum value of the initial conditions 
%     model.x0_maxValue = 50;
    % % number of experiments generated
    model.experiment_num = 1;
    % % length of the simulation (sec)
%     model.t_f = 10;
    % % set the signal-to-noise ratio for each state variable
%     model.SNR = 20;
    % 
    % % generate the data
    % model = generateDataFromModel(model);
% 
%     [std, t,noisy_data,dy] = generatedata_random(model.SNR,10,1,1);

    model.dydt = dy;
    model.variance = var;


    %% generate dictionary
    % polyorder = 2;
    % [A,Phi,Y_Dict,monomes] = generateMAKDictionary(model,polyorder);
%     K = sqrt(0.1);
%     N=2;
%     A = zeros(length(noisy_data),8);
%     for i = 1:length(noisy_data)
%         [u1, u2] = toggleinput(t,i);
%         A(i,:) = [1/(1+(noisy_data(i,1)/K)^N) 1/(1+(noisy_data(i,2)/(K*(1+u1)))^N) 1/(1+(noisy_data(i,1)/(K*(1+u2)))^N) 1/(1+(noisy_data(i,2)/K)^N) noisy_data(i,1) noisy_data(i,2) noisy_data(i,1)^2 noisy_data(i,2)^2];
%     end
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
    tt=toc;
    %% reporting
    % turn on/off plots
    disp_plot = 0;

    % use manual tresholding
    zero_th = 1e-6;
    % select non zero dictionaries
    fit_res_diff = calc_zero_th(fit_res_diff,zero_th,disp_plot);
%     % report signal fit
%     signal_fit_error_diff = fit_report(fit_res_diff,disp_plot);

    Xi = cell2mat(fit_res_diff.sbl_param);
    
    X_realA = [0;1;0;0;-1;0;0;0];
    X_realB = [0;0;1;0;0;-1;0;0];
    RNMSE_A = norm(X_realA-Xi(:,1))/norm(X_realA);
    RNMSE_B = norm(X_realB-Xi(:,2))/norm(X_realB);
    
    MSE_A = mean((dy(:,1)-A*Xi(:,1)).^2);
    MSE_B = mean((dy(:,2)-A*Xi(:,2)).^2);
    
    datamatrix = {Xi,A,dy,t,x_noisy,tt};
    master_data = {datamatrix};
end