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
    %save("r_"+string(i)+".mat", 'r_temp')
    %save("e_"+string(i)+".mat", 'e_temp')
    
    r_list(i) = r_temp;
    e_list(i) = e_temp;
end


%% Plot Eigenfunctions
relevant_mode_indices = [1 1 1 1]; 
%manually identified: gives the index of the 2-2 mode within each
%rectangles list of eigenmodes.
sin_vals = zeros(length(side_lengths), 1);
true_mu_1 = zeros(length(side_lengths), 1);
true_eigvals = zeros(length(side_lengths), 1);
for i = 1:4

    %Plot Whole Domain
    figure
    plot_eigenfunction(r_list(i), e_list(i), ...
        'correctSign', true, 'showAxes', true,...
        'modeIndex', relevant_mode_indices(i))
    daspect([1 2.5/side_lengths(i) 2]) %2.5 chosen arbitrarily, happens to give nice plots
    ylim([-0.2, cell_height + 0.2])
    xlim([-2*eta - 0.2, side_lengths(i)+0.2])
    title(num2str(side_lengths(i)) + " by "+num2str(cell_height) + " Rectangle"+ ...
     ", Eigenvalue = " + num2str(r_list(i).Eigenvalues(relevant_mode_indices(i))) + ...
     ", Max Mesh Size = " + num2str(r_list(i).Mesh.MaxElementSize) + ...
     ", eta = "+ num2str(eta));
 

    %Plot Domain Around Center
    figure
    plot_eigenfunction(r_list(i), e_list(i), ...
        'correctSign', true, 'showAxes', true,...
        'modeIndex', relevant_mode_indices(i))
    ylim([cell_height/2 - 0.05, cell_height/2 + 0.05])
    xlim([side_lengths(i)/2-0.1, side_lengths(i)/2+0.1])
    title(num2str(side_lengths(i)) + " by "+num2str(cell_height) + " Rectangle"+ ...
     ", Eigenvalue = " + num2str(r_list(i).Eigenvalues(relevant_mode_indices(i))) + ...
     ", Max Mesh Size = " + num2str(r_list(i).Mesh.MaxElementSize) + ...
     ", eta = "+ num2str(eta));

    
    true_eigvals(i) = r_list(i).Eigenvalues(relevant_mode_indices(i));
    true_mu_1(i) = sqrt(true_eigvals(i) - pi^2);
    disp("Value of sin(mu_1*N):")
    sin_vals(i) = sin(true_mu_1(i).*side_lengths(i))
end


% print(gcf, 'plots/figure-5-1.png','-dpng','-r300');
% print(gcf, 'plots/figure-5-1a.eps', '-depsc','-opengl');
% manually adjust and save each plot
