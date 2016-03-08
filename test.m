n = 10;
tmax = 150;
xmax = 150000;
ymax = 400000;
data = zeros(n);

for i = 1:n
    x0 = xmax * i / n;
    for j = 1:n
        y0 = ymax * j / n;
        fprintf('Initial populations:\t%f\t%f\n',x0,y0);
        [tspan, net_profit] = minimum_whale_policy(tmax, x0, y0);
        idx = find(net_profit > 0, 1);
        disp(net_profit(idx-1:idx+1));
        fprintf('Break-even:\t\t%E\t(%d years)\n', net_profit(idx), tspan(idx));
        data(i,j) = tspan(idx);
    end
end
