function [noisy_data,data, time] = generatedata_toggle1(num_data_points, noise_level,beta_orig,gamma_orig)

    K = sqrt(0.1); n=2; u_in1=1; u_in2=2; start = 0; step = 0.01; endv=200;

    %run ODE45
    tspan = [start:step:endv];
    initial = [0 1];

    [T X]=ode45(@(t,x)toggleswitch_params(t,x,beta_orig,gamma_orig),tspan,initial);
    
    
    %extract a certain number of values 
    y = round(linspace(1,size(X,1),num_data_points));
    newX = zeros(size(y,2),2);
    for i = 1:size(y,2)-1
        newX(i,:) = X(y(i),1:1:end);
    end
    data = newX;
    
    noisy_data = add_awgn2(newX,noise_level);
    time = linspace(start,endv,num_data_points);
end 
