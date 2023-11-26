%% Investigate Opening Size's Independence of N: Figure 5

cell_height = 1;
eta = 0.5;
boundary_perturb_func = 'sin';
perturb_freq = 6/cell_height;

side_lengths = [4.7741 10.0400 18.7350 36.0785];

eig_ests = 4*pi^2*(side_lengths.^(-2) + cell_height^(-2));
lower_eigs = eig_ests.*[0.99 0.999 0.999 0.999];
upper_eigs = eig_ests.*[1.01 1.001 1.001 1.00001];

doms = [polyshape];
r_list = [pde.EigenResults];
e_list = [pde.PDEModel];


Hmax_factors = [0.0006 0.0003 0.0002 0.0002];

%% Compute Eigenfunctions

for i = 1:4
    doms(i) = build_perturbed_square(eta, 'cellHeight', cell_height,...
        'cellWidth', side_lengths(i),...
        'boundaryFunction', boundary_perturb_func,...
        'frequency', perturb_freq);
    [r_temp, e_temp, m] = analyze_domain(doms(i), ...
        'Hmax_factor', Hmax_factors(i), 'bc', 'dirichlet',...
        'min_eig', lower_eigs(i), 'max_eig', upper_eigs(i));

    %% SAVE FILES 
    save("r_"+string(i)+".mat", 'r_temp')
    save("e_"+string(i)+".mat", 'e_temp')
    
    r_list(i) = r_temp;
    e_list(i) = e_temp;
end
