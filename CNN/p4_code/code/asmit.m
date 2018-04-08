% Asmit Jain 
% Home Work No: 9
% Exercise No: 29.2 
% November 28, 2017 
% Solves numerically the IVP equation using ode45

dy= @(t,y)[y(2);y(3);(-(y(3).^2))+(3.*(y(2).^3))-(cos(y(1)).^2)+(exp(-t).*(sin(3.*t)))];  
[T, Y] = ode45(dy,[1 2.1],[1;2;0]); % Applying the ODE45
size(T); %defining the size of time
size(Y); %defining the size of Y
Y(1:10,:) % Values of the vector
x = Y(:,1);
plot(T,x) %Plots the graph
title('ODE to first order system'); % Adds title to the graph
xlabel('Time'); % Add x label
ylabel('Values of the vector y') % Add y label