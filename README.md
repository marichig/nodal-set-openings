# Nodal Set Openings on Perturbed Rectangular Domains

This repository contains MATLAB code used to explore the stability of nodal set crossings in Laplacian eigenfunctions on deformed rectangles.

## Description of Files:

1. [```build_perturbed_square```](build_perturbed_square.m): Function that returns a [```polyshape```](https://www.mathworks.com/help/matlab/ref/polyshape.html) describing the deformed rectangle. Specify via arguments the ```cellWidth``` and ```cellHeight``` of the near-rectangular domain. Perturbations may also be placed on both the left and right side of the domain by setting ```bothSides``` to be ```true```. Three types of domain perturbations are available, specified by parameter ```boundaryFunction```:
    1. Sinusoids: pass either ```'cos'``` or ```'sin'``` as the parameter for ```boundaryFunction```. Additional parameters specify the ```amplitude``` and ```frequency``` of the boundary perturbation.
    2. Hat functions: pass ```hat``` through ```boundaryFunction```. Specify the number of hats and the relative position, amplitude, and sign of each hat through argument ```hatSpecs.```
    3. Bumps (non-smooth) functions: pass ```hemisphere``` through ```boundaryFunction```, and as above specify the number of bumps and their relative position, amplitude, and sign through ```hemisphereSpecs.```

2. [```analyze_domain```](analyze_domain.m): Given a ```polyshape``` domain, solves the Helmhotz equation on that domain using MATLAB's PDE Solver within a specified eigenvalue range and returns the eigenfunctions lying in that range. Specify as inputs: 
    1. the domain to be analyzed; 
    2. the eigenvalue range (via ```max_eig``` and ```min_eig```, with defaults ```10``` and ```-Inf``` resp.); 
    3. the boundary condition via ```bc``` (default ```neumann```, any other string will apply Dirichlet boundary conditions instead);
    4. The granularity of the mesh via ```Hmax_factor``` and ```Hmin_factor```. Taking these lower will result in a finer mesh. It suffices to only tune ```Hmax_factor```, the other will adjust accordingly.

  The domain is discretized using [```generateMesh```](https://www.mathworks.com/help/pde/ug/pde.pdemodel.generatemesh.html), and analyzed using [```solvepdeeig```](https://www.mathworks.com/help/pde/ug/pde.pdemodel.solvepdeeig.html). The function returns a triple with the [```EigenResults```](https://www.mathworks.com/help/pde/ug/pde.eigenresults.html) containing lists of eigenvectors and eigenvalues within the specified range, the [```PDEModel```](https://www.mathworks.com/help/pde/ug/pde.pdemodel.html) object itself, and the actual [finite element matrices](https://www.mathworks.com/help/pde/ug/assemblefematrices.html) describing the domain mesh.
  
3. [```plot_eigenfunction```](plot_eigenfunction.m): A wrapper function that takes in the ```EigenResults``` and ```PDEModel``` objects and plots the eigenfunction. Parameters specify whether to show the Colorbar and plot axes, and whether to standardize the sign of the eigenfunction (such that the top-left-corner of the eigenfunction is positive).
4. [```plot_results_interactive```](plot_results_interactive.m): When multiple eigenfunctions are contained in the returned ```EigenResults```, this function lets you cycle through the plots to inspect them. Use the left-arrow key to move backwards, "b" or "e" to exit, and any other key to cycle forward.
5. [```N_selection_resonance_control```](N_selection_resonance_control.m): This script takes a seed aspect ratio and performs gradient ascent/descent to control for "resonance" (i.e. eigenvalue degeneracy). Outputs an aspect ratio that minimizes this effect.
6. [```get_zero_set```](get_zero_set.m): Finds the zero set (up to small error) of the eigenfunction contained within a specified box.
7. [```get_min_distance```](get_min_distance.m): Finds the zero sets of the two opposing branches on the nodal sets and calculates their minimum distance, for each aspect ratio in Figure 5.

The remaining files (```figure_1_3```,..., ```figure_5```) contain code to reproduce each of the figures shown in the thesis.
