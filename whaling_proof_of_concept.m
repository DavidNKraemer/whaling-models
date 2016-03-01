% This script is a proof-of-concept which shows how to numerically solve
% this two-species competition environment model, with percentage-based
% whaling, using MATLAB
% Specifically, this script uses the ode45 utility.

% The ODE model (LaTeX friendly)
% \begin{align*}
%     \frac{dx}{dt} &= r_1 x (1 - x/K_1) - \alpha_1 x y - \beta_1 x \\
%     \frac{dy}{dt} &= r_2 y (1 - y/K_2) - \alpha_2 x y - \beta_2 y
% \end{align*}
% 
% (Plaintext friendly)
%   x'(t) = r1 * x(t) * (1 - x(t) / K1) - a1 * x(t) * y(t) - b1 * x(t)
%   y'(t) = r2 * y(t) * (1 - y(t) / K2) - a2 * x(t) * y(t) - b2 * y(t)

% whale competition parameters, specified by the experts
r1 = 0.05;
r2 = 0.08;
K1 = 150000;
K2 = 400000;
a1 = 1e-8;
a2 = 1e-8;

% initial whale populations
% x0 = 8e+3;
% y0 = 5.5e+4;
x0 = 15000;
y0 = 8000;

% percent of whale populations that are killed each year
b1 = 1;
b2 = 1;

% revenue from a killed whale
p1 = 12000;
p2 = 6000;

years = 500;

% ODE specified above
f = @(t,x) [r1*x(1) * (1 - x(1) / K1) - a1 * x(1) * x(2) - b1 * x(1); ...
    r2 * x(2) * (1 - x(2) / K2) - a2 * x(1) * x(2) - b2 * x(2)];

% f = @(t,x) [r1*x(1) * (1 - x(1) / K1) - a1 * x(1) * x(2) - b1; ...
%     r2 * x(2) * (1 - x(2) / K2) - a2 * x(1) * x(2) - b2];

[t, xa] = ode45(f, [0 years], [x0 y0]);

% profit function over time
profit = @(p, q) p(1) * q(:,1) + p(2) * q(:,2);

prices = [p1 p2];
quantities = [b1 * xa(:,1) b2 * xa(:,2)];

prof = profit(prices, quantities);

% Plots

figure(1);
plot(t, xa(:,1)); hold on
plot(t, xa(:,2));
title('Whale Population');
xlabel('Time (years)'), ylabel('Population'); legend('Blue','Fin'); hold off

figure(2);

plot(t, prof); hold on
title('Profit level'); 
ylabel('Profit ($)'); xlabel('Time (years)'); hold off

fprintf('Profit:\t%1.2f\n',sum(prof));
% fprintf('Profit:\t%1.2f\n', years * (b1 * p1 + b2 * p2));
