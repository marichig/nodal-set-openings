%% Gradient Ascent/Descent to Resonance Control, Fig 5
% Choose N s.t. sin (\mu_1 N) is approx 1. 
% Seed with an N value (directly below),
% and final N will be printed when the algorithm converges.

N = 36.0762;
eta = 0.5;
sin_vals = 0;
boundary_perturb_func = 'sin';
perturb_freq = 6;
lr = 0.05;
tolerance = 0.00000001;

figure
while abs(abs(sin_vals) - 1) > tolerance
disp("N")
N
mu_1_estimates = sqrt(4*pi^2/(N + eta)^2 + 3*pi^2);
eig_ests = 4*pi^2*(N.^(-2) + 1);
lower_eigs = eig_ests*0.999;
upper_eigs = eig_ests*1.00001;


Hmax_factors = 0.0003;


doms = build_perturbed_square(eta, 'cellHeight', 1,...
    'cellWidth', N,...
    'boundaryFunction', boundary_perturb_func,...
    'frequency', perturb_freq);
[r_temp, e_temp, m] = analyze_domain(doms, ...
    'Hmax_factor', Hmax_factors, 'bc', 'dirichlet',...
    'min_eig', lower_eigs, 'max_eig', upper_eigs);
r_list = r_temp;
e_list = e_temp;

relevant_mode_indices = 1;

plot_eigenfunction(r_list, e_list, ...
'correctSign', true, 'showAxes', true,...
        'modeIndex', relevant_mode_indices)

true_eigvals = r_list.Eigenvalues(relevant_mode_indices);
true_mu_1 = sqrt(true_eigvals - pi^2);
disp("Value of cos(mu_1*N/2):")
cos_vals = cos(true_mu_1*N/2)
disp("Value of sin(mu_1*N):")
sin_vals = sin(true_mu_1*N)


%gradient movement to get sin_val = 1.
if abs(abs(sin_vals) - 1) > tolerance
   if sin_vals > 0 %ascend
       N = N + lr*(true_mu_1*cos(true_mu_1*N));
   else
       N = N - lr*(true_mu_1*cos(true_mu_1*N));
   end
end

end

disp("Final N:")
N













