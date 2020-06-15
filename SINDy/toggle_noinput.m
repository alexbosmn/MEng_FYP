function f = toggle_noinput(t,x)
    params.beta = 1;
    params.gamma = 1;
    K = sqrt(0.1);
    n=2;
    f = [params.beta./(1 + (x(2)/K)^n) - params.gamma.*x(1);
        params.beta./(1 + (x(1)/K)^n) - params.gamma.*x(2)];
end