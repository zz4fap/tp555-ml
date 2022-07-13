clear all;close all;clc

rng(01012019);

fontSize = 14;

% Initial parameters.
a_int = [-20;-20];

M = 100000;

% Training set.
x1t = randn(M, 1);

x2t = 10*randn(M, 1) + 10;

yt = x1t + x2t;

% Prediction set.
rng(12041988);

Mp = M/10;
x1p = randn(Mp, 1);

x2p = 10*randn(Mp, 1) + 10;

yp = x1p + x2p;

% Parameter space.
a1 = -44:1/1:48;

a2 = -44:1/1:48;

[A1,A2] = meshgrid(a1,a2);


non_scaled = 0;
standardization = 0;
minmaxscaling = 1;

target_standardization = 0;
target_minmaxscaling = 0;


if(non_scaled==1)
    clear a Jgd x1 x2 y x1pp x2pp ypp Jgdpp
    
    x1 = x1t;
    x2 = x2t;
    y = yt;
    
    J = zeros(length(A1),length(A2));
    for iter1=1:1:length(a1) 
        for iter2=1:1:length(a2)
            yhat = A1(iter1, iter2)*x1 + A2(iter1, iter2)*x2;           
            J(iter1, iter2) = (1/length(y)).*sum((y - yhat).^2);
        end
    end
    
    figure1 = figure('rend','painters','pos',[10 10 800 700]);
    surf(A1, A2, J)
    xlabel('a_1', 'FontSize', fontSize)
    ylabel('a_2', 'FontSize', fontSize)
    zlabel('J_e', 'FontSize', fontSize)
    title('Superficie de Erro', 'FontSize', fontSize)
    
    %% Closed-form solution.
    
    X = [x1 x2];
    
    a_opt_noscale = pinv(X.'*X)*X.'*y;
    
    yhat = a_opt_noscale(1)*x1 + a_opt_noscale(2)*x2;
    
    Joptimum = (1/M)*sum((y - yhat).^2);
    
    %% Gradient-descent solution.
    alpha = 0.002;
    
    % Initialize 'a' at a random location within the parameter's space.
    a(:,1) = a_int;
    
    yhat = a(1,1)*x1 + a(2,1)*x2;
    
    Jgd(1) = (1/M)*sum((y - yhat).^2);
    
    yhatp = a(1,1)*x1p + a(2,1)*x2p;
    
    Jgdpp(1) = (1/Mp).*sum((yp - yhatp).^2);
    
    error = 1;
    iter = 1;
    while(error > 0.001 && iter <= 10000)
        
        h = a(1,iter)*x1 + a(2,iter)*x2;
        
        update = -(2./M).*(y - h).'*X;
        
        a(:,iter+1) = a(:,iter) - alpha.*update.';
        
        yhat = a(1,iter+1)*x1 + a(2,iter+1)*x2;
        
        Jgd(iter+1) = (1/M).*sum((y - yhat).^2);
        
        yhatp = a(1,iter+1)*x1p + a(2,iter+1)*x2p;
        
        Jgdpp(iter+1) = (1/Mp).*sum((yp - yhatp).^2);
        
        error = abs(Jgd(iter)-Jgd(iter+1));
        
        iter = iter + 1;
        
    end
    
    a_noscale = a(:, iter);
    
    figure2 = figure('rend','painters','pos',[10 10 800 700]);
    subplot(2,1,1);
    contour(A1, A2, J, 'ShowText','on')
    xlabel('a_1', 'FontSize', fontSize)
    ylabel('a_2', 'FontSize', fontSize)
    zlabel('J_e', 'FontSize', fontSize)
    title('Contorno da Superficie de Erro', 'FontSize', fontSize, 'Interpreter', 'latex')
    hold on
    plot(a_opt_noscale(1), a_opt_noscale(2), 'r*', 'MarkerSize', 10, 'LineWidth',1);
    plot(a(1,:), a(2,:), 'kx', 'MarkerSize', 10, 'LineWidth',1);
    hold off;
    
    subplot(2,1,2);
    semilogy(0:1:iter-1, Jgd, 'LineWidth',1)
    hold on
    semilogy(0:20:iter-1, Jgdpp(1:20:end), 'x', 'LineWidth',1)
    xlabel('Iteracao', 'FontSize', fontSize)
    ylabel('J_e', 'FontSize', fontSize)
    strTitle = sprintf('Iteracoes vs. Erro - $\\alpha = %1.0e$', alpha);
    title(strTitle, 'FontSize', fontSize, 'Interpreter', 'latex')
    lgd = legend('Erro de Treinamento','Erro de Teste');
    lgd.FontSize = 14;
    xlim([0 iter-1])
    grid on
    hold off
end










if(standardization==1)
    clear a Jgd x1 x2 y x1pp x2pp ypp Jgdpp
    
    x1 = x1t;
    x2 = x2t;
    y = yt;
    
    x1_mean = mean(x1);
    x1_std = std(x1);
    x1 = (x1 - x1_mean) ./ (x1_std);
    
    x2_mean = mean(x2);
    x2_std = std(x2);
    x2 = (x2 - x2_mean) ./ (x2_std);
    
    if(target_standardization==1)
        y_mean = mean(y);
        y_std = std(y);
        y = (y - y_mean) ./ (y_std);
    end
    
    x1pp = (x1p - x1_mean) ./ x1_std;
    x2pp = (x2p - x2_mean) ./ x2_std;
    if(target_standardization==1)
        ypp = (yp - y_mean) ./ (y_std);
    else
        ypp = yp;
    end
    
    fdee_figure1 = figure('rend', 'painters', 'pos', [10 10 800 700]);
    subplot(2,1,1)
    h1 = histogram(x1t);
    h1.Normalization = 'pdf';
    h1.NumBins = 50;
    grid on
    hold on
    h2 = histogram(x2t);
    h2.Normalization = 'pdf';
    h2.NumBins = 100;
    legend('x1','x2')
    title('Sem escalonamento')
    
    subplot(2,1,2)
    h1 = histogram(x1);
    h1.Normalization = 'pdf';
    h1.NumBins = 50;
    grid on
    hold on
    h2 = histogram(x2);
    h2.Normalization = 'pdf';
    h2.NumBins = 100;
    legend('x1','x2')
    title('Padronização')
    
    J = zeros(length(A1),length(A2));
    for iter1=1:1:length(a1)
        
        for iter2=1:1:length(a2)
            
            yhat = A1(iter1, iter2)*x1 + A2(iter1, iter2)*x2;
            
            J(iter1, iter2) = (1/length(y)).*sum((y - yhat).^2);
            
        end
        
    end
    
    figure1 = figure('rend','painters','pos',[10 10 800 700]);
    surf(A1, A2, J)
    xlabel('a_1', 'FontSize', fontSize)
    ylabel('a_2', 'FontSize', fontSize)
    zlabel('J_e', 'FontSize', fontSize)
    title('Superficie de Erro', 'FontSize', fontSize)
    
    %% Closed-form solution.
    
    X = [x1 x2];
    
    a_opt_std = pinv(X.'*X)*X.'*y;
    
    yhat = a_opt_std(1)*x1 + a_opt_std(2)*x2;
    
    Joptimum = (1/M)*sum((y - yhat).^2);
    
    %% Gradient-descent solution.
    alpha = 0.5;
    
    % Initialize 'a' at a random location within the parameter's space.
    a(:,1) = a_int;
    
    yhat = a(1,1)*x1 + a(2,1)*x2;
    
    Jgd(1) = (1/M)*sum((y - yhat).^2);
    
    yhatp = a(1,1)*x1pp + a(2,1)*x2pp;
    
    Jgdpp(1) = (1/Mp).*sum((ypp - yhatp).^2);
    
    error = 1;
    iter = 1;
    while(error > 0.001 && iter <= 10000)
        
        h = a(1,iter)*x1 + a(2,iter)*x2;
        
        update = -(2./M).*(y - h).'*X;
        
        a(:,iter+1) = a(:,iter) - alpha.*update.';
        
        yhat = a(1,iter+1)*x1 + a(2,iter+1)*x2;
        
        Jgd(iter+1) = (1/M).*sum((y - yhat).^2);
        
        yhatp = a(1,iter+1)*x1pp + a(2,iter+1)*x2pp;
        
        Jgdpp(iter+1) = (1/Mp).*sum((ypp - yhatp).^2);
        
        error = abs(Jgd(iter)-Jgd(iter+1));
        
        iter = iter + 1;
        
    end
    
    a_std = a(:, iter);
    
    figure2 = figure('rend','painters','pos',[10 10 800 700]);
    subplot(2,1,1);
    contour(A1, A2, J, 'ShowText','on')
    xlabel('a_1', 'FontSize', fontSize)
    ylabel('a_2', 'FontSize', fontSize)
    zlabel('J_e', 'FontSize', fontSize)
    title('Contorno da Superficie de Erro', 'FontSize', fontSize, 'Interpreter', 'latex')
    hold on
    plot(a_opt_std(1), a_opt_std(2), 'r*', 'MarkerSize', 10, 'LineWidth',1);
    plot(a(1,:), a(2,:), 'kx', 'MarkerSize', 10, 'LineWidth',1);
    hold off;

    subplot(2,1,2);
    semilogy(0:1:iter-1, Jgd, 'LineWidth',1)
    hold on
    semilogy(0:1:iter-1, Jgdpp(1:1:end), 'x', 'LineWidth',1)
    xlabel('Iteracao', 'FontSize', fontSize)
    ylabel('J_e', 'FontSize', fontSize)
    strTitle = sprintf('Iteracoes vs. Erro - $\\alpha = %1.0e$', alpha);
    title(strTitle, 'FontSize', fontSize, 'Interpreter', 'latex')
    lgd = legend('Erro de Treinamento','Erro de Teste');
    lgd.FontSize = 14;
    xlim([0 iter-1])
    grid on
    hold off    
end

















if(minmaxscaling==1)
    clear a Jgd x1 x2 y x1pp x2pp ypp Jgdpp
    
    x1 = x1t;
    x2 = x2t;
    y = yt;
    
    x1_min = min(x1);
    x1_max = max(x1);
    x1 = (x1 - x1_min) ./ (x1_max - x1_min);
    
    x2_min = min(x2);
    x2_max = max(x2);
    x2 = (x2 - x2_min) ./ (x2_max - x2_min);
    
    if(target_minmaxscaling==1)
        y_min = min(y);
        y_max = max(y);
        y = (y - y_min) ./ (y_max - y_min);
    end
    
    x1pp = (x1p - x1_min) ./ (x1_max - x1_min);
    x2pp = (x2p - x2_min) ./ (x2_max - x2_min);
    if(target_minmaxscaling==1)
        ypp = (yp - y_min) ./ (y_max - y_min);
    else
        ypp = yp;
    end
    
    
    fdee_figure1 = figure('rend', 'painters', 'pos', [10 10 800 700]);
    subplot(2,1,1)
    h1 = histogram(x1t);
    h1.Normalization = 'pdf';
    h1.NumBins = 50;
    grid on
    hold on
    h2 = histogram(x2t);
    h2.Normalization = 'pdf';
    h2.NumBins = 100;
    legend('x1','x2')
    title('Sem escalonamento')
    
    subplot(2,1,2)
    h1 = histogram(x1);
    h1.Normalization = 'pdf';
    h1.NumBins = 100;
    grid on
    hold on
    h2 = histogram(x2);
    h2.Normalization = 'pdf';
    h2.NumBins = 100;
    legend('x1','x2')
    title('Normalização Min-Max')    
    
    J = zeros(length(A1),length(A2));
    for iter1=1:1:length(a1)
        
        for iter2=1:1:length(a2)
            
            yhat = A1(iter1, iter2)*x1 + A2(iter1, iter2)*x2;
            
            J(iter1, iter2) = (1/length(y)).*sum((y - yhat).^2);
            
        end
        
    end
    
    figure1 = figure('rend','painters','pos',[10 10 800 700]);
    surf(A1, A2, J)
    xlabel('a_1', 'FontSize', fontSize)
    ylabel('a_2', 'FontSize', fontSize)
    zlabel('J_e', 'FontSize', fontSize)
    title('Superficie de Erro', 'FontSize', fontSize)
    
    %% Closed-form solution.
    
    X = [x1 x2];
    
    a_opt_minmax = pinv(X.'*X)*X.'*y;
    
    yhat = a_opt_minmax(1)*x1 + a_opt_minmax(2)*x2;
    
    Joptimum = (1/M)*sum((y - yhat).^2);
    
    %% Gradient-descent solution.
    alpha = 0.9;
    % Initialize 'a' at a random location within the parameter's space.
    a(:,1) = a_int;
    
    yhat = a(1,1)*x1 + a(2,1)*x2;
    
    Jgd(1) = (1/M)*sum((y - yhat).^2);
    
    yhatp = a(1,1)*x1pp + a(2,1)*x2pp;
    
    Jgdpp(1) = (1/Mp).*sum((ypp - yhatp).^2);
    
    error = 1;
    iter = 1;
    while(error > 0.001 && iter <= 10000)
        
        h = a(1,iter)*x1 + a(2,iter)*x2;
        
        update = -(2./M).*(y - h).'*X;
        
        a(:,iter+1) = a(:,iter) - alpha.*update.';
        
        yhat = a(1,iter+1)*x1 + a(2,iter+1)*x2;
        
        Jgd(iter+1) = (1/M).*sum((y - yhat).^2);
        
        yhatp = a(1,iter+1)*x1pp + a(2,iter+1)*x2pp;
        
        Jgdpp(iter+1) = (1/Mp).*sum((ypp - yhatp).^2);
        
        error = abs(Jgd(iter)-Jgd(iter+1));
        
        iter = iter + 1;
        
    end
    
    a_minmax = a(:, iter);
    
    figure2 = figure('rend','painters','pos',[10 10 800 700]);
    subplot(2,1,1);
    contour(A1, A2, J, 'ShowText','on')
    xlabel('a_1', 'FontSize', fontSize)
    ylabel('a_2', 'FontSize', fontSize)
    zlabel('J_e', 'FontSize', fontSize)
    title('Contorno da Superficie de Erro', 'FontSize', fontSize, 'Interpreter', 'latex')
    hold on
    plot(a_opt_minmax(1), a_opt_minmax(2), 'r*', 'MarkerSize', 10, 'LineWidth',1);
    plot(a(1,:), a(2,:), 'kx', 'MarkerSize', 10, 'LineWidth',1);
    hold off;
    
    subplot(2,1,2);
    semilogy(0:1:iter-1, Jgd, 'LineWidth',1)
    hold on
    semilogy(0:10:iter-1, Jgdpp(1:10:end), 'x', 'LineWidth',1)
    xlabel('Iteracao', 'FontSize', fontSize)
    ylabel('J_e', 'FontSize', fontSize)
    strTitle = sprintf('Iteracoes vs. Erro - $\\alpha = %1.0e$', alpha);
    title(strTitle, 'FontSize', fontSize, 'Interpreter', 'latex')
    lgd = legend('Erro de Treinamento','Erro de Teste');
    lgd.FontSize = 14;
    xlim([0 iter-1])
    grid on
    hold off
end