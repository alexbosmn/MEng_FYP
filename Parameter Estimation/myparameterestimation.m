function [p,error]=myparameterestimation(noiselevel,x0,beta_orig,gamma_orig)
    i=0;
    for datapoints = [10:5:700]
        i = i+1;
        [data,time]=generatedata_toggle(datapoints,noiselevel,beta_orig,gamma_orig);
        p(i,:) = fminsearch(@(p)mycost_ODE3(p,data,datapoints),x0);
        %sprintf('beta = %5.2f, gamma = %5.2f',p(1),p(2))
%         figure
%         plot(time,data)
%         hold on
%         plot(time,toggle_func3(p(1),p(2),datapoints))
%         hold off
        residual_error(i,:) = mean(data - toggle_func3(p(i,1),p(i,2),datapoints));
        error(i,:) = mean(abs(residual_error(i,:)),2);
    end 
    figure
    plot(log10([10:5:700]),log10(error),'LineWidth',4)
    %yline(0.001,'r','0.001','LineWidth',4)
    %bar(error)
    xlabel('log(Number of datapoints)','FontSize',18)
    ylabel('log(Error)','FontSize',18)
    ax = gca;
    ax.FontSize = 16;
end 
