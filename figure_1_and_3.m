%% Generate Plots for Figure 1 and 3

cell_height = 1;
cell_width = sqrt(5/3);
perturb_freq = 6/cell_height;
eta = 0.01;

eig_est = 4*pi^2*(cell_width^(-2) + cell_height^(-2));

symmetric_domain = build_perturbed_square(eta, 'cellWidth', cell_width,...
    'cellHeight', cell_height,...
    'boundaryFunction', 'cos');
                
asymmetric_domain = build_perturbed_square(eta, 'cellWidth', cell_width,...
    'cellHeight', cell_height,...
    'boundaryFunction', 'sin');

asymmetric_domain_2 = build_perturbed_square(eta,...
    'frequency', 5,...
    'cellWidth', cell_width,...
    'cellHeight', cell_height,...
    'boundaryFunction', 'cos');

lower_eig = eig_est*0.99;
upper_eig = eig_est*1.01;

[r_sym, e_sym, ~] = analyze_domain(symmetric_domain, 'Hmax_factor', 0.005, 'bc', 'dirichlet', 'min_eig', lower_eig, 'max_eig', upper_eig);
[r_asym, e_asym, ~] = analyze_domain(asymmetric_domain, 'Hmax_factor', 0.005, 'bc', 'dirichlet', 'min_eig', lower_eig, 'max_eig', upper_eig);
[r_asym_2, e_asym_2, ~] = analyze_domain(asymmetric_domain_2, 'Hmax_factor', 0.005, 'bc', 'dirichlet', 'min_eig', lower_eig, 'max_eig', upper_eig);


plot_eigenfunction(r_sym, e_sym, 'correctSign', true, 'showAxes', false)
print(gcf,'plots/figure-1-symmetric.eps', '-depsc','-opengl');     
figure
plot_eigenfunction(r_asym, e_asym, 'correctSign', true, 'showAxes', false)
print(gcf,'plots/figure-1-asymmetric.eps', '-depsc','-opengl');
figure
plot_eigenfunction(r_asym_2, e_asym_2, 'correctSign', true, 'showAxes', false)
print(gcf,'plots/figure-1-asymmetric_2.eps', '-depsc','-opengl');