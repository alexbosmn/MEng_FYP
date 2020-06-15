function [RNMSE_A, RNMSE_B,master_data] = SINDy(Theta,dx,t,x_noisy)

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
 
        
        %save data into matrix that has all values
        datamatrix = {Xi,Theta,dx,t,x_noisy,tt};
        master_data = {datamatrix};
end