% This script is a proof-of-concept which shows how to numerically solve
% this two-species competition environment model using MATLAB.
% Specifically, this script uses the ode45 utility.

% The ODE model (LaTeX friendly)
% \begin{align*}
%     \frac{dx}{dt} &= r_1 x (1 - x/K_1) - \alpha_1 x y \\
%     \frac{dy}{dt} &= r_2 y (1 - y/K_2) - \alpha_2 x y
% \end{align*}
% 
% (Plaintext friendly)
%   x'(t) = r1 * x(t) * (1 - x(t) / K1) - a1 * x(t) * y(t)
%   y'(t) = r2 * y(t) * (1 - y(t) / K2) - a2 * x(t) * y(t)

r1 = 0.05;
r2 = 0.08;
K1 = 150000;
K2 = 400000;
a1 = 1e-8;
a2 = 1e-8;

x0 = 1e+4;
y0 = 1e+4;

f = @(t,x) [r1*x(1) * (1 - x(1) / K1) - a1 * x(1) * x(2); ...
    r2 * x(2) * (1 - x(2) / K2) - a2 * x(1) * x(2)];

[t, xa] = ode45(f, [0 100], [x0 y0]);

plot(t, xa(:,1)); hold on
plot(t, xa(:,2));
title('Whale Population');
xlabel('time'), ylabel('Population'); hold off

figure();

plot(t(2:end), diff(xa(:,1)) / xa(1:end-1,1)); hold on
plot(t(2:end), diff(xa(:,2)) / xa(1:end-1,2));
title('Change in Whale Population');
xlabel('time'), ylabel('Change in Population'); hold off

figure();

plot(t, xa(:,1) + xa(:,2)); hold on
title('Whale Population');
xlabel('time'), ylabel('Population'); hold off

figure();

plot(t(2:end), diff(xa(:,1) + xa(:,2)) / (xa(1:end-1,1) + xa(1:end-1,2))); hold on
title('Change in Whale Population');
xlabel('time'), ylabel('Change in Population'); hold off