function [p,error]=myparameterestimation3(x0,beta_orig,gamma_orig)
    count_data=1;
    count_noise=1;
    error = zeros(length([10]),length([0]));
    for noiselevel = [0]
        for datapoints = [10:5:700]
            [noisy_data,data,~]=generatedata_toggle1(datapoints,noiselevel,beta_orig,gamma_orig);
            p(count_data,:) = fminsearch(@(p)mycost_ODE3(p,noisy_data,datapoints),x0);
            error(count_data,count_noise) = mean(abs(mean(data - toggle_func3(p(count_data,1),p(count_data,2),datapoints))));
%             error(count_data,count_noise) = mean(abs(residual_error(count_data,count_noise)),2);
%             params( = {p,error};
            if count_data<length([10:5:700])
                count_data = +1;
            else
                count_data=1;
            end
        end
    count_noise = count_noise+1; 
    end
%     figure
%     plot(log10([10:5:700]),log10(error),'LineWidth',4)
%     %yline(0.001,'r','0.001','LineWidth',4)
%     %bar(error)
%     xlabel('log(Number of datapoints)','FontSize',18)
%     ylabel('log(Error)','FontSize',18)
%     ax = gca;
%     ax.FontSize = 16;
end 