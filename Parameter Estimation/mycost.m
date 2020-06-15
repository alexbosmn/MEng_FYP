function cost = mycost(regressor,current_parameters,measured_data)
      cost = 0.5 * norm(measured_data - regressor*current_parameters)^2;
end