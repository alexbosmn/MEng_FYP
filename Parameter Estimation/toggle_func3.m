function X = toggle_func3(beta,gamma,datapoints)
    K = sqrt(0.1); n=2; u_in1=1; u_in2=2; start = 0; endv=200;

    %run ODE45
    tspan = linspace(start,endv,datapoints);
    initial = [0 1];
    [T X]=ode45(@(t,x)toggleswitch_params(t,x,beta,gamma),tspan,initial);
end