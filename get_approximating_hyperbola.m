function [hyperbola,x_c, y_c] = get_approximating_hyperbola(eta, N, mu)
%GET_APPROXIMATING_HYPERBOLA
%   Construct hyperbola approximating nodal set
    perturb_freq = 6;
    
    perturbation = @(y) sin(perturb_freq*pi*y);
    v1_integral = @(y) perturbation(y).*sin(pi*y).*sin(2*pi*y);
    v2_integral = @(y) perturbation(y).*sin(2*pi*y).*sin(2*pi*y);
    
    v1naught = (4*pi*eta)./N*integral(v1_integral,0,1);
    v2naught = (4*pi*eta)./N*integral(v2_integral,0,1);
    % issue is that v_2(0) approximation is == 0, so v2 approximation will
    % be identically 0
    % Use fact that v_2 ~ sin(2pi/N x), up to error eta/N
    
    mu_1_squared = mu - pi^2;
    mu_1 = sqrt(mu_1_squared);
    mu_2 = sqrt(mu - 4*pi^2);
    
    v1N2 = v1naught*(cos(mu_1*N/2) - cos(mu_1*N)/sin(mu_1*N)*sin(mu_1*N/2));
    v1primeN2 = mu_1*v1naught*(-sin(mu_1*N/2) - cos(mu_1*N)/sin(mu_1*N)*cos(mu_1*N/2)); % just about 0
    v2N2 = v2naught*(cos(mu_2*N/2) - cos(mu_2*N)/sin(mu_2*N)*sin(mu_2*N/2));
    v2primeN2 = 2*pi/N * cos(pi); 
    
    % D on pg 11
    alpha = -mu_1_squared*v1N2;
    beta = -pi^2*v1N2;
    gamma = -2*pi*v2primeN2;
    a = v1primeN2/2;
    b = -pi*v2N2;
    c = v1N2;
    
    % proof of Prop 2.3
    D = det([alpha gamma a ; gamma beta b ; a b c]);
    detH = det([alpha gamma ; gamma beta]);
    x_c = N/2 - 1/detH * det([a gamma ; b beta]);
    y_c = 1/2 - 1/detH * det([alpha a ; gamma b]);
    

    hyperbola = @(x,y) -alpha*(x-x_c)^2 - 2*gamma*(x-x_c)*(y-y_c)...
        - beta*(y-y_c)^2 + D/detH;

end

