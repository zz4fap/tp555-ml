clear all;close all;clc;

%% Target function.
% Generate a synthetic dataset from a quadratic function
M = 1000;

% Generate random x values between -5 and 5
x = 10*( rand(M, 1) - 0.5  );

% Define the function and the true parameters
% y = a_0 + a_1*x + a_2*x^2
a_0 = 1;
a_1 = -2;
a_2 = 0.5;

% Define target
y = a_0 + a_1*x + a_2*x.^2;

% Add some noise
y = y + 0.5*randn(M, 1);

figure;
plot(x, y, '.');




rng(12041981)
xt = 10*( rand(M, 1) - 0.5  );

% Define the function and the true parameters
% y = a_0 + a_1*x + a_2*x^2
a_0 = 1;
a_1 = -2;
a_2 = 0.5;

% Define target
yt = a_0 + a_1*xt + a_2*xt.^2;

% Add some noise
yt = yt + 0.5*randn(M, 1);


if(1)
    %% Closed-form solution.
    X = [ones(M, 1) x x.^2 x.^3 x.^4];
    
    a_opt = pinv(X.'*X)*X.'*y;
    
    yhat = a_opt(1) + a_opt(2)*x + a_opt(3)*x.^2 + a_opt(4)*x.^3 + a_opt(5)*x.^4;
    
    Joptimum = (1/M)*sum((y - yhat).^2);
    
    figure;
    plot(x, yhat, '.');
    
    %% Gradient-descent solution (Hyphothesis #1).
    alpha = 0.00002;
    
    % Initialize 'a' at a random location within the parameter's space.
    a(:,1) = [3;-4;2;4;5];
    
    yhat = a(1,1) + a(2,1)*x + a(3,1)*x.^2 + a(4,1)*x.^3 + a(5,1)*x.^4;
    
    Jgd(1) = (1/M)*sum((y - yhat).^2);
    
    error = 1;
    iter = 1;
    while(error > 0.001 && iter <= 100000)
        
        h = a(1,iter) + a(2,iter)*x + a(3,iter)*x.^2 + a(4,iter)*x.^3 + a(5,iter)*x.^4;
        
        update = -(2./M).*(y - h).'*X;
        
        a(:,iter+1) = a(:,iter) - alpha.*update.';
        
        yhat = a(1,iter+1) + a(2,iter+1)*x + a(3,iter+1)*x.^2 + a(4,iter+1)*x.^3 + a(5,iter+1)*x.^4;
        
        Jgd(iter+1) = (1/M).*sum((y - yhat).^2);
        
        error = abs(Jgd(iter)-Jgd(iter+1));
        
        iter = iter + 1;
        
    end
    
    figure;
    semilogy(1:iter,Jgd)
    
    figure;
    yhat = a(1,iter) + a(2,iter)*x + a(3,iter)*x.^2 + a(4,iter)*x.^3 + a(5,iter)*x.^4;
    plot(x, yhat, '.')
    
    fprintf(1,'----------------------------------------------------------\n')
    fprintf(1, 'Hyphothesis #1 (5 parameters) - J_e training: %1.2e\n', Jgd(iter));
    yhatt = a(1,iter) + a(2,iter)*xt + a(3,iter)*xt.^2 + a(4,iter)*xt.^3 + a(5,iter)*xt.^4;
    Joptimum = (1/M)*sum((yt - yhatt).^2);
    fprintf(1, 'Hyphothesis #1 (5 parameters) - J_e test: %1.2e\n', Joptimum);
    
    
end





if(1)
    %% Closed-form solution.
    X = [ones(M, 1) x x.^2 x.^3];
    
    a_opt = pinv(X.'*X)*X.'*y;
    
    yhat = a_opt(1) + a_opt(2)*x + a_opt(3)*x.^2 + a_opt(4)*x.^3;
    
    Joptimum = (1/M)*sum((y - yhat).^2);
    
    figure;
    plot(x, yhat, '.');
   
    %% Gradient-descent solution (Hyphothesis #2).
    alpha = 0.0004;
    
    % Initialize 'a' at a random location within the parameter's space.
    clear a Jgd
    a(:,1) = [3;-4;2;4];
    
    yhat = a(1,1) + a(2,1)*x + a(3,1)*x.^2 + a(4,1)*x.^3;
    
    Jgd(1) = (1/M)*sum((y - yhat).^2);
    
    error = 1;
    iter = 1;
    while(error > 0.001 && iter <= 100000)
        
        h = a(1,iter) + a(2,iter)*x + a(3,iter)*x.^2 + a(4,iter)*x.^3;
        
        update = -(2./M).*(y - h).'*X;
        
        a(:,iter+1) = a(:,iter) - alpha.*update.';
        
        yhat = a(1,iter+1) + a(2,iter+1)*x + a(3,iter+1)*x.^2 + a(4,iter+1)*x.^3;
        
        Jgd(iter+1) = (1/M).*sum((y - yhat).^2);
        
        error = abs(Jgd(iter)-Jgd(iter+1));
        
        iter = iter + 1;
        
    end
    
    figure;
    semilogy(1:iter,Jgd)
    
    figure;
    yhat = a(1,iter) + a(2,iter)*x + a(3,iter)*x.^2 + a(4,iter)*x.^3;
    plot(x, yhat, '.')
    
    
    fprintf(1,'----------------------------------------------------------\n')
    fprintf(1, 'Hyphothesis #2 (4 parameters) - J_e training: %1.2e\n', Jgd(iter));
    yhatt = a(1,iter) + a(2,iter)*xt + a(3,iter)*xt.^2+ a(4,iter)*xt.^3;
    Joptimum = (1/M)*sum((yt - yhatt).^2);
    fprintf(1, 'Hyphothesis #2 (4 parameters) - J_e test: %1.2e\n', Joptimum);
    
end













if(1)
    %% Closed-form solution.
    X = [ones(M, 1) x x.^2];
    
    a_opt = pinv(X.'*X)*X.'*y;
    
    yhat = a_opt(1) + a_opt(2)*x + a_opt(3)*x.^2;
    
    Joptimum = (1/M)*sum((y - yhat).^2);
    
    figure;
    plot(x, yhat, '.');
   
    %% Gradient-descent solution (Hyphothesis #1).
    alpha = 0.007;
    
    % Initialize 'a' at a random location within the parameter's space.
    clear a Jgd
    a(:,1) = [3;-4;2];
    
    yhat = a(1,1) + a(2,1)*x + a(3,1)*x.^2;
    
    Jgd(1) = (1/M)*sum((y - yhat).^2);
    
    error = 1;
    iter = 1;
    while(error > 0.001 && iter <= 100000)
        
        h = a(1,iter) + a(2,iter)*x + a(3,iter)*x.^2;
        
        update = -(2./M).*(y - h).'*X;
        
        a(:,iter+1) = a(:,iter) - alpha.*update.';
        
        yhat = a(1,iter+1) + a(2,iter+1)*x + a(3,iter+1)*x.^2;
        
        Jgd(iter+1) = (1/M).*sum((y - yhat).^2);
        
        error = abs(Jgd(iter)-Jgd(iter+1));
        
        iter = iter + 1;
        
    end
    
    figure;
    semilogy(1:iter,Jgd)
    
    figure;
    yhat = a(1,iter) + a(2,iter)*x + a(3,iter)*x.^2;
    plot(x, yhat, '.')
    
    
    fprintf(1,'----------------------------------------------------------\n')
    fprintf(1, 'Hyphothesis #3 (3 parameters) - J_e training: %1.2e\n', Jgd(iter));
    yhatt = a(1,iter) + a(2,iter)*xt + a(3,iter)*xt.^2;
    Joptimum = (1/M)*sum((yt - yhatt).^2);
    fprintf(1, 'Hyphothesis #3 (3 parameters) - J_e test: %1.2e\n', Joptimum);
    
    
end






if(1)
    %% Closed-form solution.
    X = [ones(M, 1) x];
    
    a_opt = pinv(X.'*X)*X.'*y;
    
    yhat = a_opt(1) + a_opt(2)*x;
    
    Joptimum = (1/M)*sum((y - yhat).^2);
    
    figure;
    plot(x, yhat, '.');
   
    %% Gradient-descent solution (Hyphothesis #1).
    alpha = 0.1;
    
    % Initialize 'a' at a random location within the parameter's space.
    clear a Jgd
    a(:,1) = [3;-4];
    
    yhat = a(1,1) + a(2,1)*x;
    
    Jgd(1) = (1/M)*sum((y - yhat).^2);
    
    error = 1;
    iter = 1;
    while(error > 0.001 && iter <= 100000)
        
        h = a(1,iter) + a(2,iter)*x;
        
        update = -(2./M).*(y - h).'*X;
        
        a(:,iter+1) = a(:,iter) - alpha.*update.';
        
        yhat = a(1,iter+1) + a(2,iter+1)*x;
        
        Jgd(iter+1) = (1/M).*sum((y - yhat).^2);
        
        error = abs(Jgd(iter)-Jgd(iter+1));
        
        iter = iter + 1;
        
    end
    
    figure;
    semilogy(1:iter,Jgd)
    
    figure;
    yhat = a(1,iter) + a(2,iter)*x;
    plot(x, yhat, '.')
    
    fprintf(1,'----------------------------------------------------------\n')
    fprintf(1, 'Hyphothesis #4 (2 parameters) - J_e training: %1.2e\n', Jgd(iter));
    yhatt = a(1,iter) + a(2,iter)*xt;
    Joptimum = (1/M)*sum((yt - yhatt).^2);
    fprintf(1, 'Hyphothesis #4 (2 parameters) - J_e testing: %1.2e\n', Joptimum);
    
    
end