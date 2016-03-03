syms x y;
syms r1 r2 K1 K2 a1 a2;

eqn1 = r1*x - r1 / K1 * x^2 - a1 * y * x;
eqn2 = r2*y - r2 / K2 * y^2 - a2 * x * y;
eqnsyms = [r1 r2 K1 K2 a1 a2];

pop = PopulationSimulator(1000, 1000, eqn1, eqn2, eqnsyms);
