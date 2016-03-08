function [profits] = minimum_whale_policy_sensitivity( years, x0, y0 )
run('setup.m');

tspan = 0:1:years;

bx = @(x) max(0, x - 1/2 * fK1);
by = @(y) max(0, y - 1/2 * fK2);

init = [x0 y0];
px = 12000;
py = 6000;

f = @(t, pops) double([subs(eqn1 - bx(pops(1)), [x y eqnsyms], [pops(1) pops(2) floatsyms]); subs(eqn2 - by(pops(2)), [x y eqnsyms], [pops(1) pops(2) floatsyms])]);

levels = [0.9 1. 1.1];

[time, populations] = ode45(f, tspan, init);

profit = @(pops, level) (px * level) * bx(pops(:,1)) + py * by(pops(:,2));
profits = zeros(3,1);

for i = 1:3
    fprintf('Price of blue:\t%f\n', px * levels(i));
    profits(i) = sum(profit(populations, levels(i)));
    fprintf('Profit:\t\t%f\n', profits(i));
end

end
