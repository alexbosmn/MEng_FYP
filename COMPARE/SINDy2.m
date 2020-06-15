function [MSE_A, MSE_B, RNMSE_A, RNMSE_B,master_data] = SINDy2(Theta,dx,t,x_noisy)

    %% compute sparse regression: sequential least squares
        n=2;
        n_iter=10;
        lambda = 0.1; %sparsification knob
        Xi = zeros(8,2);
        tic
        Xi = sparsifyDynamics(Theta,dx,lambda,n,n_iter);
        tt = toc;

        %% error
        X_realA = [0;1;0;0;-1;0;0;0];
        X_realB = [0;0;1;0;0;-1;0;0];
        
        RNMSE_A = norm(X_realA-Xi(:,1))/norm(X_realA);
        RNMSE_B = norm(X_realB-Xi(:,2))/norm(X_realB);
        
        MSE_A = mean((dx(:,1)-Theta*Xi(:,1)).^2);
        MSE_B = mean((dx(:,2)-Theta*Xi(:,2)).^2);
        
        %save data into matrix that has all values
        datamatrix = {Xi,Theta,dx,t,x_noisy,tt};
        master_data = {datamatrix};
end