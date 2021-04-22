%% Investigate Opening Size's Independence of N: Figure 5

%% Important Control: 
% want cos(mu_1 * N/2) to be comparable. mu_1 of course changes with N,
% though asymptotically tends to sqrt(3)*pi.

k = [5 10 20 40];
cell_height = 1;
eta = 0.5;
boundary_perturb_func = 'sin';
perturb_freq = 6/cell_height;

%We aim to right in-between the resonant values. I.e., at N s.t.
%|cos(mu_1*N/2)| = 1. The following estimate works for that:
% 1. Require mu_1*N = 2k*pi.
% 2. Solve for N and plug into asymptotic bounds for mu_1.
% Same was done in figure_4 files. Also use fact that eta < N to simplify
% the expressions.

mu_1_estimates = sqrt(3*pi^2./(cell_height^2*(1 - 2*(2*k).^(-2))));

%side_lengths = 2*k*pi./mu_1_estimates;
%cos(side_lengths.*mu_1_estimates/2);
%Side lengths are explored manually, in conjunction with the actual
%calculated eigenvalues, to ensure |cos(mu_1*N/2)| is close to 1. The above
%side lengths are used as a seed value, and then are tuned manually through
%a few iterations. The tuning looks like picking off the true eigenvalue mu
%from r_list(i). Eigenvalues(relevant_mode_indices(i)) (see below),
%explicitly calculating mu_1 = sqrt(mu - pi^2), and then tuning 
%cos(mu_1*(side_lengths(i)+epsilon)/2) for some epsilon. Took one
%iteration for most side lengths (two for the second) to find the right 
%length.

side_lengths = [5.7155 11.560 23.0896 46.2648];



eig_ests = 4*pi^2*(side_lengths.^(-2) + cell_height^(-2));
lower_eigs = eig_ests*0.999;
upper_eigs = eig_ests*1.001;

doms = [polyshape];
r_list = [pde.EigenResults];
e_list = [pde.PDEModel];

Hmax_factors = [0.002 0.001 0.0005 0.0003];

for i = 1:length(side_lengths)
    doms(i) = build_perturbed_square(eta, 'cellHeight', cell_height,...
        'cellWidth', side_lengths(i),...
        'boundaryFunction', boundary_perturb_func,...
        'frequency', perturb_freq);
    [r_temp, e_temp, m] = analyze_domain(doms(i), ...
        'Hmax_factor', Hmax_factors(i), 'bc', 'dirichlet',...
        'min_eig', lower_eigs(i), 'max_eig', upper_eigs(i));
    r_list(i) = r_temp;
    e_list(i) = e_temp;
end

relevant_mode_indices = [1 1 1 1]; 
%manually identified: gives the index of the 2-2 mode within each
%rectangles list of eigenmodes.
cos_vals = zeros(length(side_lengths), 1);
true_eigvals = zeros(length(side_lengths), 1);
for i = 1:length(side_lengths)
    figure
    subplot(1,2,1)
    plot_eigenfunction(r_list(i), e_list(i), ...
        'correctSign', true, 'showAxes', true,...
        'modeIndex', relevant_mode_indices(i))
    daspect([1 2.5/k(i) 2]) %2.5 chosen arbitrarily, happens to give nice plots
    ylim([-0.2, cell_height + 0.2])
    xlim([-2*eta - 0.2, side_lengths(i)+0.2])
    title(num2str(side_lengths(i)) + " by "+num2str(cell_height) + " Rectangle"+ ...
     ", Eigenvalue = " + num2str(r_list(i).Eigenvalues(relevant_mode_indices(i))) + ...
     ", Max Mesh Size = " + num2str(r_list(i).Mesh.MaxElementSize) + ...
     ", eta = "+ num2str(eta));
 
    subplot(1,2,2)
    plot_eigenfunction(r_list(i), e_list(i), ...
        'correctSign', true, 'showAxes', true,...
        'modeIndex', relevant_mode_indices(i))
    %daspect([1 2.5/k(i) 2]) %2.5 chosen arbitrarily, happens to give nice plots
    ylim([cell_height/2 - 0.05, cell_height/2 + 0.05])
    xlim([side_lengths(i)/2-0.1, side_lengths(i)/2+0.1])
    title(num2str(side_lengths(i)) + " by "+num2str(cell_height) + " Rectangle"+ ...
     ", Eigenvalue = " + num2str(r_list(i).Eigenvalues(relevant_mode_indices(i))) + ...
     ", Max Mesh Size = " + num2str(r_list(i).Mesh.MaxElementSize) + ...
     ", eta = "+ num2str(eta));
    disp("Value of cos(mu_1*N/2):")
    cos_vals(i) = cos((r_list(i).Eigenvalues(relevant_mode_indices(i)) - (pi/cell_height)^2)*side_lengths(i)/2)
    true_eigvals(i) = r_list(i).Eigenvalues(relevant_mode_indices(i));
end


%print(gcf, 'plots/figure-5-1.png','-dpng','-r300'); 
% manually adjust and save each plot
