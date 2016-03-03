syms x y;
syms r1 r2 K1 K2 a1 a2;

eqn1 = r1*x - r1 / K1 * x^2 - a1 * y * x;
eqn2 = r2*y - r2 / K2 * y^2 - a2 * x * y;

eqnsyms = [r1 r2 K1 K2 a1 a2];
floatsyms = [0.05 0.08 1.5e+5 4.0e+5 1e-8 1e-8];

pop = PopulationSimulator(1000, 1000, eqn1, eqn2, eqnsyms);
[growth_rates, growth_sensitivities] = pop.compute_maximal_combined_growth();
[region, region_sensitivities] = pop.compute_feasible_sustainable_region();

blue_whales = 12000;
fin_whales  =  6000;

blue = subs(region{1}(1), eqnsyms, floatsyms);
fin = subs(region{1}(2), eqnsyms, floatsyms);

double(blue_whales * (blue + fin_whales * fin)