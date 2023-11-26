%% Approximating hyperbolas under reasonable eta, Figure 6

cell_height = 1;
eta = 0.01;
boundary_perturb_func = 'sin';
perturb_freq = 6/cell_height;

N = 4.7741;

eig_ests = 4*pi^2*(N.^(-2) + cell_height^(-2));
lower_eig = eig_ests.*0.99;
upper_eig = eig_ests.*1.01;

dom = polyshape;

Hmax_factor = 0.0006;

%% Load Eigenfunctions

% dom = build_perturbed_square(eta, 'cellHeight', cell_height,...
%    'cellWidth', N,...
%    'boundaryFunction', boundary_perturb_func,...
%    'frequency', perturb_freq);
%[r_temp, e_temp, m] = analyze_domain(dom, ...
%   'Hmax_factor', Hmax_factor, 'bc', 'dirichlet',...
%   'min_eig', lower_eig, 'max_eig', upper_eig);
% save("r_fig6.mat", 'r_temp')
% save("e_fig6.mat", 'e_temp')

r_temp = load("r_fig6.mat").r_temp
e_temp = load("e_fig6.mat").e_temp


%% Plot Eigenfunctions


mu = r_temp.Eigenvalues(1);

%Plot Whole Domain
figure
plot_eigenfunction(r_temp, e_temp, ...
    'correctSign', true, 'showAxes', true,...
    'modeIndex', 1)
daspect([1 2.5/N 2]) %2.5 chosen arbitrarily, happens to give nice plots
ylim([-0.2, cell_height + 0.2])
xlim([-2*eta - 0.2, N+0.2])
title(num2str(N) + " by "+num2str(cell_height) + " Rectangle"+ ...
 ", Eigenvalue = " + num2str(mu) + ...
 ", Max Mesh Size = " + num2str(r_temp.Mesh.MaxElementSize) + ...
 ", eta = "+ num2str(eta));


%Plot Domain Around Center
figure
plot_eigenfunction(r_temp, e_temp, ...
    'correctSign', true, 'showAxes', true,...
    'modeIndex', 1)
ylim([cell_height/2 - 0.05, cell_height/2 + 0.05])
xlim([N/2-0.1, N/2+0.1])
title(num2str(N) + " by "+num2str(cell_height) + " Rectangle"+ ...
 ", Eigenvalue = " + num2str(mu) + ...
 ", Max Mesh Size = " + num2str(r_temp.Mesh.MaxElementSize) + ...
 ", eta = "+ num2str(eta));

%Plot approximate hyperbola
[hyperbola, x_c, y_c] = get_approximating_hyperbola(eta, N, mu);
hold on
fimplicit(hyperbola,'--r','LineWidth',2)
hold off




% print(gcf, 'plots/figure-5-1.png','-dpng','-r300');
% print(gcf, 'plots/figure-5-1a.eps', '-depscs','-image');
% manually adjust and save each plot
