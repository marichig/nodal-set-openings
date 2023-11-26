%% Orientation of opening in Figure 2 - Table

eta = 0.04;
N = 5/sqrt(3);
cell_height = 1;

%% Get eigenvalues
[square_sin, sin_perturb] = build_perturbed_square(eta, 'cellWidth', N, ...
    'boundaryFunction','sin');
[square_hat_odd, hat_perturb] = build_perturbed_square(eta, 'cellWidth', N, ...
    'boundaryFunction', 'hat', 'hatSpecs',[2, 0.25, 0.05, -1, 0.95, 0.05, -1]);
[square_hemi_odd, hemi_perturb] = build_perturbed_square(eta, 'cellWidth', N, ...
    'boundaryFunction', 'hemisphere', 'hemisphereSpecs', [2, 0.25, 0.05, -1, 0.95, 0.05, -1]);

squares = [square_sin, square_hat_odd, square_hemi_odd];
side_perturbations = {sin_perturb, hat_perturb, hemi_perturb};

eig_est = 4*pi^2*(N^(-2) + cell_height^(-2));
lower_eig = eig_est*0.99;
upper_eig = eig_est*1.01;
r = [pde.EigenResults];
e = [pde.PDEModel];

mu = zeros(3,1);
for i = 1:length(squares)
    [r(i),e(i),m] = analyze_domain(squares(i), 'Hmax_factor', 0.004, 'max_eig', upper_eig, 'min_eig', lower_eig, 'bc', 'dirichlet');
    mu(i) = r(i).Eigenvalues(1);
end

%% Calculate v2'(N/2)/v1(N/2)
ratio = zeros(3,1);
v1_integral = zeros(3,1);
v2_integral = zeros(3,1);
v1N2 = zeros(3,1);
v2primeN2 = zeros(3,1);
ymax = cell_height; ymin = 0;
y_mesh = 0.:0.001:1;
y_mesh = transpose(y_mesh);

for i= 1:3
    perturbation = cell2mat(side_perturbations(i));
    % boundary integrals
    v1_integral(i) = trapz(perturbation(:,1).*sin(pi*y_mesh).*sin(2*pi*y_mesh), y_mesh);
    v2_integral(i) = trapz(perturbation(:,1).*sin(2*pi*y_mesh).*sin(2*pi*y_mesh), y_mesh);
    
    % boundary condition
    v1naught = (4*pi*eta)./N*v1_integral(i);
    v2naught = (4*pi*eta)./N*v2_integral(i);
    
    % calculate needed values: v_2'(N/2), v_1(N/2)
    mu_1_squared = mu(i) - pi^2;
    mu_1 = sqrt(mu_1_squared);
    mu_2 = sqrt(mu(i) - 4*pi^2);
    
    v1N2(i) = v1naught*(cos(mu_1*N/2) - cos(mu_1*N)/sin(mu_1*N)*sin(mu_1*N/2));
    if i==1
        v2primeN2(i) = 2*pi/N * cos(pi);
    else
        v2primeN2(i) = mu_2*v2naught*(-sin(mu_2*N/2) - cos(mu_2*N)/sin(mu_2*N)*cos(mu_2*N/2));
    end
    
    % below sign determines orientation
    ratio(i) = v2primeN2(i)/v1N2(i);
end

table = [mu v2primeN2 v1N2]