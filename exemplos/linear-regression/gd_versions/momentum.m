clear all;close all;clc

alpha = 0.01;

mu = 0.9;


v(1,:) = [0,0];
for i=1:1:100
    
    
    gradient = [randn(), randn()];
    v(i+1,:) = mu*v(i) - alpha*gradient;
    
   
    
end

plot(v(:,1), v(:,2), '.')