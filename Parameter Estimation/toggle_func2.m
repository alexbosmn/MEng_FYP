function X = toggle_func2(beta,gamma)
    K = sqrt(0.1); n=2; u_in1=1; u_in2=2; start = 0; step = 0.01; endv=200;

    %run ODE45
    tspan = linspace(0,200,300);
    initial = [0 1];
    [T X]=ode45(@(t,x)toggleswitch_params(t,x,beta,gamma),tspan,initial);
end
