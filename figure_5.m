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

%% Load Eigenfunctions
% Run figure_5_prep beforehand
r_list = [load("r_1.mat").r_temp ; load("r_2.mat").r_temp ; load("r_3.mat").r_temp ; load("r_4.mat").r_temp];
e_list = [load("e_1.mat").e_temp ; load("e_2.mat").e_temp ; load("e_3.mat").e_temp ; load("e_4.mat").e_temp];


%% Plot Eigenfunctions
relevant_mode_indices = [1 1 1 2]; 
%manually identified: gives the index of the 2-2 mode within each
%rectangles list of eigenmodes.
sin_vals = zeros(length(side_lengths), 1);
difference_to_unperturbed_eig = zeros(length(side_lengths), 1);
true_mu_1 = zeros(length(side_lengths), 1);
mesh_size = zeros(length(side_lengths),1);
true_eigvals = zeros(length(side_lengths), 1);
for i = 1:4

    N = side_lengths(i);
    mu = r_list(i).Eigenvalues(relevant_mode_indices(i));

    %Plot Whole Domain
    figure
    plot_eigenfunction(r_list(i), e_list(i), ...
        'correctSign', true, 'showAxes', true,...
        'modeIndex', relevant_mode_indices(i))
    daspect([1 2.5/side_lengths(i) 2]) %2.5 chosen arbitrarily, happens to give nice plots
    ylim([-0.2, cell_height + 0.2])
    xlim([-2*eta - 0.2, N+0.2])
    title(num2str("N = " +side_lengths(i)) + ...
     ", Eigenvalue = " + mu + ... 
     ", eta = "+ num2str(eta));
 
    print(gcf, 'plots/figure-5-'+string(i)+'a.eps', '-depsc2','-image');
    %Plot Domain Around Center
    figure
    plot_eigenfunction(r_list(i), e_list(i), ...
        'correctSign', true, 'showAxes', true,...
        'modeIndex', relevant_mode_indices(i))
    ylim([cell_height/2 - 0.05, cell_height/2 + 0.05])
    xlim([N/2-0.1, N/2+0.1])
    title(num2str("N = " +side_lengths(i)) + ...
     ", Eigenvalue = " + mu + ... 
     ", eta = "+ num2str(eta));

    
    true_eigvals(i) = mu;
    true_mu_1(i) = sqrt(true_eigvals(i) - pi^2);
    disp("Value of sin(mu_1*N):")
    sin_vals(i) = sin(true_mu_1(i).*N)

    mesh_size(i) = r_list(i).Mesh.MaxElementSize;
    difference_to_unperturbed_eig(i) = 4*pi^2*(1+1/side_lengths(i)^2) - true_eigvals(i);

    %Plot approximate hyperbola
    [hyperbola, x_c, y_c] = get_approximating_hyperbola(eta, N, mu);
    hold on
    fimplicit(hyperbola,'--r','LineWidth',2)
    hold off


   print(gcf, 'plots/figure-5-'+string(i)+'b.eps', '-depsc2','-image');
end

true_eigvals
sin_vals
mesh_size
difference_to_unperturbed_eig

% manually adjust and save each plot
