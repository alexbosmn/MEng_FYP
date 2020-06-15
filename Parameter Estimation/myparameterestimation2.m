function [params]=myparameterestimation2(datapoints,x0,beta_orig,gamma_orig)
    i=0;
    for noiselevel = [0:5:80]
        i = i+1;
        [noisy_data,data,~]=generatedata_toggle1(datapoints,noiselevel,beta_orig,gamma_orig);
        p(i,:) = fminsearch(@(p)mycost_ODE3(p,noisy_data,datapoints),x0);
        %sprintf('beta = %5.2f, gamma = %5.2f',p(1),p(2))
%         figure
%         plot(time,data)
%         hold on
%         plot(time,toggle_func3(p(1),p(2),datapoints))
%         hold off
        residual_error(i,:) = mean(data - toggle_func3(p(i,1),p(i,2),datapoints));
        error(i,:) = mean(abs(residual_error(i,:)),2);
        params = {p,error};
    end 
    figure
    plot(log10([0:5:80]),log10(error),'LineWidth',4)
    %yline(0.001,'r','0.001')
    %bar(error)
    xlabel('log_{10}(SNR [dB])','FontSize',18)
    ylabel('log_{10}(Error)','FontSize',18)
    ax = gca;
    ax.FontSize = 16;

end 
