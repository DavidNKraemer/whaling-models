% Generate all plots

run(setup)

%% Generate a plot of the feasible/sustainable region
pop = PopulationSimulator(1000, 1000, eqn1, eqn2, eqnsyms);
[optimizing_populations, growth_sensitivities] = pop.compute_maximal_combined_growth();

floatrates = double(subs(optimizing_populations, eqnsyms, floatsyms));
floateqn1 = double(subs(eqn1, [x y eqnsyms], [floatrates.' floatsyms]));
floateqn2 = double(subs(eqn2, [x y eqnsyms], [floatrates.' floatsyms]));
floatr = double(subs(r, [x y eqnsyms], [floatrates.' floatsyms]));


[region, region_sensitivities] = pop.compute_feasible_sustainable_region();

floatregion1 = double(subs(region{1}, eqnsyms, floatsyms));
floatregion2 = double(subs(region{2}, eqnsyms, floatsyms));
floatregion3 = double(subs(region{3}, eqnsyms, floatsyms));

x0 = [floatregion2; 0];
t = 0:0.1:1;
asdf = zeros(11,2);
x1 = [0; floatregion3];
fdsa = zeros(11,2);
for i = 1:11
    asdf(i,:) = x0 + t(i) * (floatregion1 - x0); 
    fdsa(i,:) = x1 + t(i) * (floatregion1 - x1);
end
area(asdf(:,2), asdf(:,1)); hold on
area(fdsa(:,2), fdsa(:,1));

