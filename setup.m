syms x y;
syms r1 r2 K1 K2 a1 a2;

eqn1 = r1*x - r1 / K1 * x^2 - a1 * y * x;
eqn2 = r2*y - r2 / K2 * y^2 - a2 * x * y;
r = eqn1 + eqn2;

eqnsyms = [r1 r2 K1 K2 a1 a2];
floatsyms = [0.05 0.08 1.5e+5 4.0e+5 1e-8 1e-8];

pop = PopulationSimulator(1000, 1000, eqn1, eqn2, eqnsyms);
[growth_rates, growth_sensitivities] = pop.compute_maximal_combined_growth();

floatrates = double(subs(growth_rates, eqnsyms, floatsyms));
floateqn1 = double(subs(eqn1, [x y eqnsyms], [floatrates.' floatsyms]));
floateqn2 = double(subs(eqn2, [x y eqnsyms], [floatrates.' floatsyms]));
floatr = double(subs(r, [x y eqnsyms], [floatrates.' floatsyms]));


[region, region_sensitivities] = pop.compute_feasible_sustainable_region();

floatregion1 = double(subs(region{1}, eqnsyms, floatsyms));
floatregion2 = double(subs(region{2}, eqnsyms, floatsyms));
floatregion3 = double(subs(region{3}, eqnsyms, floatsyms));




blue_whales = 12000;
fin_whales  =  6000;

blue = subs(region{1}(1), eqnsyms, floatsyms);
fin = subs(region{1}(2), eqnsyms, floatsyms);



double(blue_whales * blue + fin_whales * fin);

for i = 1:6
    fprintf('\n%s:\n',char(eqnsyms(i)));
    fprintf('%f\n',double(growth_sensitivities{i}(floatsyms(i))));
end