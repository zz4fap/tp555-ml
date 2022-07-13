clear all;close all;clc;

%% Target function.
load('/home/zz4fap/work/tp555/tp555-machine-learning/misc/sythquad.csv');

x = sythquad(:,1);
y = sythquad(:,2);

M = length(x);

figure;
plot(x, y, '.');

%% Closed-form solution.
X = [ones(M, 1) x x.^2 x.^3 x.^4];

a_opt = pinv(X.'*X)*X.'*y;

yhat = a_opt(1) + a_opt(2)*x + a_opt(3)*x.^2 + a_opt(4)*x.^3 + a_opt(5)*x.^4;

Joptimum = (1/M)*sum((y - yhat).^2);

figure;
plot(x, yhat, '.')

%% Gradient-descent solution.
alpha = 0.00001;

% Initialize 'a' at a random location within the parameter's space.
a(:,1) = [1;1;1;1;1];

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
