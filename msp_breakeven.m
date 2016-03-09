% This script takes forever...
% To run in the background, type
% $ nohup matlab -nojvm mwp_breakeven_data.m
% in a terminal
n = 32;
tmax = 150;
xmax = 150000;
ymax = 400000;
data = zeros(n);

for i = 1:n
    x0 = xmax * i / n;
    for j = 1:n
        y0 = ymax * j / n;
        [tspan, net_profit] = minimum_whale_policy(tmax, x0, y0);
        idx = find(net_profit > 0, 1);
        data(i,j) = tspan(idx);
    end
end

save('data/mwp_breakeven_data.mat','data');
