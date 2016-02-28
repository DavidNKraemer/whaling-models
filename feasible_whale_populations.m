% This script identifies the feasible and sustainable region for whale
% populations. A whale population p is feasible if
%     p(t) >= 0
% and a whale population is sustainable if
%     p'(t) >= 0.

syms x y;
syms r1 r2 a1 a2 K1 K2;

assume(x >= 0);
assume(y >= 0);

assume([1e-4 < r1; r1 < 1], 'positive');
assume([1e-4 < r2; r2 < 1], 'positive');
assume([0 < a1; a1 < 1e-5], 'positive');
assume([0 < a2; a2 < 1e-5], 'positive');
assume([1e+4 < K1; K1 < 1e+6], 'positive');
assume([1e+4 < K2; K2 < 1e+6], 'positive');

% assume([a1 < r1; a1 < r2; a2 < r1; a2 < r2]);
% assume([r1 < K1; r1 < K2; r2 < K1; r2 < K2]);

inequal_x = (r1 - a1 * y)/r1 - x >= 0;
inequal_y = (r2 - a2 * x)/r2 - y >= 0;

solve([inequal_x, inequal_y], [x,y])