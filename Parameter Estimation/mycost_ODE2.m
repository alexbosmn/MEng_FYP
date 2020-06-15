function cost = mycost_ODE2(current_parameters,measured_data)
    beta = current_parameters(1);
    gamma = current_parameters(2);
    X = toggle_func2(beta,gamma);
    cost_a = 0.5 * norm(measured_data(:,1) - X(:,1))^2;
    cost_b = 0.5 * norm(measured_data(:,2) - X(:,2))^2;
    cost = cost_a + cost_b;
    %disp(cost)
end