%% Investigation around Resonant N: Figure 4 in Thesis

k = 3;
cell_height = pi;
eta = 1/8;

mu_1_squared_estimate = 3*pi^2/(cell_height^2*(1 - 2*(2*k+1)^(-2)))

resonant_value = (2*k+1)*pi/sqrt(mu_1_squared_estimate) %really an estimate

boundary_perturb_func = 'sin';
perturb_freq = 6/cell_height;

side_lengths = [resonant_value - 0.6, ...
    resonant_value - 0.35, ... %0.35 is the magic one
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
    subplot(2,2,i)
    
    if i == 2
        %For some reason, the indexing doesn't work for the resonant
        %eigenvalue. Perhaps this is due to a re-arranging of the modes
        %around such a resonant N... need to explore further.
        %Actually, that could make total sense - family of eigenfunctions is 
        %passing through a degenerate eigenvalue at such a point, and the 
        %eigenvalues reorder.
        
        %When approaching from below (i.e. when the hyperbola hasn't
        %conjugated), don't need to correct to index 2. But once it has
        %conjugated, you need to correct it. Maybe at these resonant values
        %the eigenvalue index is getting displaced (think back to the
        %spectral flow picture discussed a few months back - the curve has
        %engulfed an additional mode).
        
        plot_eigenfunction(r_list(i), e_list(i), 'correctSign', true, 'showAxes', true,...
            'modeIndex', 2)
    else
        plot_eigenfunction(r_list(i), e_list(i), 'correctSign', true, 'showAxes', true)
    end
    title(num2str(side_lengths(i)) + " by "+num2str(cell_height) + " Rectangle"+ ...
     ", Eigenvalue = " + num2str(r_list(i).Eigenvalues(1)) + ...
     ", Max Mesh Size = " + num2str(r_list(i).Mesh.MaxElementSize) + ...
     ", eta = "+ num2str(eta));
end

print(gcf, 'plots/figure-4-resonance-height-pi.png','-dpng','-r300');  




