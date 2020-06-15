function y=add_awgn2(x,SNR_dB)
    L=length(x);
    SNR = 10^(SNR_dB/10);
    Esym = sum(abs(x(:,1)).^2)/L;
    N_PSD = Esym/SNR;
    noise = sqrt(N_PSD);
    n = randn(1,L).*noise;
    y=zeros(size(x,1),size(x,2));
    for i=1:size(x,2)
        y(:,i)=x(:,i)+transpose(n);
    end
end