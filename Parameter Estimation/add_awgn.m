function y=add_awgn(x,SNR_dB)
    rng('default')
    L=length(x);
    SNR = 10^(SNR_dB/10);
    Esym = sum(abs(x).^2)/L;
    N_PSD = Esym/SNR;
    noise = sqrt(N_PSD);
    n = noise*randn(1,L);
    y=x+n;
end