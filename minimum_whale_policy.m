function [tspan net_profit] = minimum_whale_policy( years, x0, y0 )
run('setup.m');

tspan = 0:1:years;

bx = @(x) max(0, x - 1/2 * fK1);
by = @(y) max(0, y - 1/2 * fK2);

init = [x0 y0];
px = 12000;
py = 6000;
greedy = [px py] * init.';

f = @(t, pops) double([subs(eqn1 - bx(pops(1)), [x y eqnsyms], [pops(1) pops(2) floatsyms]); subs(eqn2 - by(pops(2)), [x y eqnsyms], [pops(1) pops(2) floatsyms])]);

[time, populations] = ode45(f, tspan, init);

profit = @(pops) px * bx(pops(:,1)) + py * by(pops(:,2));

figure(1);
plot(time, populations);
figure(2);
plot(time, profit(populations));

sustainable = profit(populations);
net_profit = cumsum(sustainable) - greedy;



%fprintf('Greedy profit:\t%E\n', [px py] * init.');
%fprintf('MWP profit:\t\t%E\t(%d years)\n', sum(sustainable), years);
end
