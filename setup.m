syms x y;
syms r1 r2 K1 K2 a1 a2;
fr1 = 0.05; fr2 = 0.08; fK1 = 1.5e+5; fK2 = 4.0e+5; fa1 = 1e-8; fa2 = 1e-8;

eqn1 = r1*x - r1 / K1 * x^2 - a1 * y * x;
eqn2 = r2*y - r2 / K2 * y^2 - a2 * x * y;
r = eqn1 + eqn2;

eqnsyms = [r1 r2 K1 K2 a1 a2];
floatsyms = [0.05 0.08 1.5e+5 4.0e+5 1e-8 1e-8];


pop = PopulationSimulator(1000, 1000, eqn1, eqn2, eqnsyms);

ind = IndustrySimulator(1000, 1000, eqn1, eqn2, eqnsyms);

% [a, b] = pop.compute_maximal_combined_growth();
% 
% xsub = subs(a{1}(1), eqnsyms, floatsyms);
% ysub = subs(a{1}(2), eqnsyms, floatsyms);
% 
% for i = 1:4

%    fprintf('\n\nNext.\n\n');
%    for j = 1:6 
%        disp(eqnsyms(j));
%        disp(double(subs(b{i}{j},[x y eqnsyms(j)], [xsub ysub floatsyms(j)])));
%    end
% end

