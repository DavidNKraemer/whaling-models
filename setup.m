syms x y;
syms v1 v2 v3 v4 v5 v6;

eqn1 = v1 - (2 * v1) / v3 * x - v5 * y - v6 * y;
eqn2 = v2 - (2 * v2) / v4 * y - v5 * x - v6 * x;
eqnsyms = [x y v1 v2 v3 v4 v5 v6];

pop = PopulationSimulator(1000, 1000, eqn1, eqn2, eqnsyms);
pop.simulate()
