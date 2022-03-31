%% Investigation around Resonant N: Figure 4
% Special case of height = 1. 

k = 3;
cell_height = 1;
eta = 1/32;

mu_1_squared_estimate = 3*pi^2/(cell_height^2*(1 - 2*(2*k+1)^(-2)))

resonant_value = (2*k+1)*pi/sqrt(mu_1_squared_estimate) %really an estimate

boundary_perturb_func = 'sin';
perturb_freq = 6/cell_height;

side_lengths = [resonant_value - 0.2, ...
    resonant_value - 0.11, ...
    resonant_value, ...
    resonant_value + 0.1];
eig_ests = 4*pi^2*(side_lengths.^(-2) + cell_height^(-2));
lower_eigs = eig_ests*0.99;
upper_eigs = eig_ests*1.01;

doms = [polyshape];
r_list = [pde.EigenResults];
e_list = [pde.PDEModel];

for i = 1:length(side_lengths)
    doms(i) = build_perturbed_square(eta, 'cellHeight', cell_height,...
        'cellWidth', side_lengths(i),...
        'boundaryFunction', 'sin',  'frequency', perturb_freq);
    [r_temp, e_temp, m] = analyze_domain(doms(i), ...
        'Hmax_factor', 0.005, 'bc', 'dirichlet',...
        'min_eig', lower_eigs(i), 'max_eig', upper_eigs(i));
    r_list(i) = r_temp;
    e_list(i) = e_temp;
end

for i = 1:length(r_list)
    plot_eigenfunction(r_list(i), e_list(i), 'correctSign', true, 'showAxes', true)

    title(num2str(side_lengths(i)) + " by "+num2str(cell_height) + " Rectangle"+ ...
     ", Eigenvalue = " + num2str(r_list(i).Eigenvalues(1)) + ...
     ", Max Mesh Size = " + num2str(r_list(i).Mesh.MaxElementSize) + ...
     ", eta = "+ num2str(eta));
    xlim([-eta - 0.1, side_lengths(i) + 0.1])
    ylim([-0.2, cell_height + 0.2])
    
    print(gcf, 'plots/figure-4-resonance-height-1-panel-' + string(i) +'.eps', '-depsc','-opengl');
end

