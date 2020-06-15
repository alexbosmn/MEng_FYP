function [time, data_noisy, dx] = generatedata_random(noise,num_data_points,beta_orig,gamma_orig)
    K = sqrt(0.1); n=2; u_in1=1; u_in2=2; start = 0; step = 0.01; endv=200;
%     beta_orig = 1;
%     gamma_orig = 1;
%     num_data_points = ;

    %run ODE45
    tspan = [start:step:endv];
    initial = [0 1];

    [T X]=ode45(@(t,x)toggleswitch_params(t,x,beta_orig,gamma_orig),tspan,initial);


    % extract number of values rafndomly
    r = sort(randperm(size(T,1),num_data_points)); %generates a specified number of random numbers
    data = zeros(size(r,2),2);
    time = zeros(size(r,1));
    dx = zeros(length(r),2);
    %creates new data, time and dx vectors that have as index the random
    %numbers generated earlier
    for i = 1:length(r)
        data(i,:) = X(r(i),:);
        time(i) = T(r(i));
    end
    
    time = time';

    %transforms SNR into standard deviation
    SNR = noise;
    noiseStd = sqrt((norm(data)^2/length(data))/(10^(SNR/10)));
    
    data_noisy = data + noiseStd.*randn(size(data));
    
    for i = 1:length(data_noisy)
        dx(i,:) = toggleswitch_params(time(i),data_noisy(i,:),beta_orig,gamma_orig);
    end
        
end