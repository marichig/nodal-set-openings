%% Effect of Symmetry on Nodal Set Opening: Figure 2

eta = 0.04;
cell_width = 5/sqrt(3);
cell_height = 1;

square_cos = build_perturbed_square(eta, 'cellWidth', cell_width);
square_sin = build_perturbed_square(eta, 'cellWidth', cell_width, 'boundaryFunction','sin');

square_hat_even = build_perturbed_square(eta, 'cellWidth', cell_width, 'boundaryFunction', 'hat', 'hatSpecs',[2, 0.25, 0.05, -1, 0.75, 0.05, -1]);
square_hat_odd = build_perturbed_square(eta, 'cellWidth', cell_width, 'boundaryFunction', 'hat', 'hatSpecs',[2, 0.25, 0.05, -1, 0.95, 0.05, -1]);

square_hemi_even = build_perturbed_square(eta, 'cellWidth', cell_width, 'boundaryFunction', 'hemisphere', 'hemisphereSpecs', [2, 0.25, 0.05, -1, 0.75, 0.05, -1]);
square_hemi_odd = build_perturbed_square(eta, 'cellWidth', cell_width, 'boundaryFunction', 'hemisphere', 'hemisphereSpecs', [2, 0.25, 0.05, -1, 0.95, 0.05, -1]);

titles = ["Sinusoid, symmetric", "Sinusoid, asymmetric", "Hat function, symmetric", "Hat function, asymmetric" "Bump function, symmetric", "Bump function, asymmetric"];
file_names=["-sin-sym","-sin-asym","-hat-sym","-hat-asym","-bump-sym","-bump-asym"];

squares = [square_cos, square_sin, square_hat_even, square_hat_odd, square_hemi_even, square_hemi_odd];

eig_est = 4*pi^2*(cell_width^(-2) + cell_height^(-2));
lower_eig = eig_est*0.99;
upper_eig = eig_est*1.01;


for i = 1:length(squares)
    [r,e,m] = analyze_domain(squares(i), 'Hmax_factor', 0.004, 'max_eig', upper_eig, 'min_eig', lower_eig, 'bc', 'dirichlet');
    figure('Renderer', 'painters', 'Position', [10 10 1200 600])
    plot_eigenfunction(r, e, 'correctSign', true, 'showAxes', true)
 
    
    title(titles(i));
    fontsize(32, "points")
    xlim([-eta - 0.1, cell_width + 0.05])
    ylim([-0.1, cell_height + 0.1])
    %daspect([1 sqrt(3) 2])
    print(gcf, 'plots/figure-3' + file_names(i) + '.eps', '-depsc2','-image', '-r135');   
end