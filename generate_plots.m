% Generate all plots

run('setup.m')

% Plot style calibration
lw = 2; % linewidth
fs = 14; % fontsize
set(0,'DefaultAxesFontSize',fs)
cmap_string = 'gray';
area_color = [0.4 0.7 0.7]; % fill color

% Generate a plot of the feasible/sustainable region
pop = PopulationSimulator(1000, 1000, eqn1, eqn2, eqnsyms);
[optimizing_populations, growth_sensitivities] = pop.compute_maximal_combined_growth();
optimizing_populations = optimizing_populations{1};

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
figure(1);
area(asdf(:,1), asdf(:,2),'FaceColor',area_color, 'EdgeColor', 'none'); hold on
area(fdsa(:,1), fdsa(:,2),'FaceColor', area_color, 'EdgeColor', 'none');
plot(asdf(:,1), asdf(:,2),'k--','LineWidth',lw);
plot(fdsa(:,1), fdsa(:,2),'k--','LineWidth',lw);
axis([0 2e+5 0 5e+5]);
xlabel('Blue whales');
ylabel('Fin whales');

legend('Feasible and sustainable region'); hold off;

figure(2);

% Image plot of the combined growth rate
x = 0:1000:200000;
y = 0:1000:500000;

[X, Y] = meshgrid(x,y);

Z = max(0, fr1 * X .* (1 - X / fK1) + fr2 * Y .* (1 - Y / fK2) - (fa1+fa2) * X .* Y); 

image(x, y, Z, 'CDataMapping', 'scaled');
xlabel('Blue whales');
ylabel('Fin whales');
colormap(cmap_string);
%colormap(flipud(colormap));
colorbar();
set(gca,'YDir','normal')
set(gca, 'CLim', [0, 1.5e+4]);

figure(3);

data = importdata('data-test.mat');
xmax = fK1;
ymax = fK2;
n = 32;
xarr = xmax * [1:n] / n;
yarr = ymax * [1:n] / n;
image(xarr, yarr, data, 'CDataMapping', 'scaled'); hold on;
plot([0 fK1/2], [fK2/2 fK2/2],'k', 'LineWidth',lw+2); 
plot([fK1/2 fK1/2], [0 fK2/2],'k', 'LineWidth',lw+2); 
plot(fK1/2,fK2/2, '+', 'LineWidth', 4, 'MarkerSize', 12, 'MarkerEdgeColor','k','MarkerFaceColor','k');
xlabel('Blue whales');
ylabel('Fin whales');
%title('Years needed to break even with myopic whaling','FontSize',18);
colormap(cmap_string);
colormap(flipud(colormap));
colorbar();
set(gca, 'YDir', 'normal');


