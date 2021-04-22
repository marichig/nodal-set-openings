function [result, model, FEMatrices] = analyze_domain(domain, varargin)
    % taken from https://www.mathworks.com/help/pde/ug/2-d-geometry-from-polyshape.html
    % see also https://www.mathworks.com/help/pde/ug/pde.pdemodel.solvepdeeig.html
    % https://www.mathworks.com/help/pde/ug/eigenvalues-and-eigenmodes-of-a-square.html
    % https://www.mathworks.com/help/pde/ug/eigenvalues-and-eigenfunctions-for-the-l-shaped-membrane.html
    % FEMatrices: see https://www.mathworks.com/help/pde/ug/assemblefematrices.html
    
    defaultMaxEig = 10;
    defaultMinEig = -Inf;
    defaultHmax = -1;
    defaultHmin = -1;
    defaultBC = 'neumann';
    
    p = inputParser;
    addRequired(p, 'domain');
    addOptional(p, 'max_eig', defaultMaxEig);
    addOptional(p, 'min_eig', defaultMinEig);
    addParameter(p, 'Hmin_factor', defaultHmin);
    addParameter(p, 'Hmax_factor', defaultHmax);
    addParameter(p, 'bc', defaultBC);
    parse(p, domain, varargin{:})
    
    %%% Discretize domain
    tr = triangulation(domain);
    model = createpde;
    tnodes = tr.Points';
    telements = tr.ConnectivityList';
    geometryFromMesh(model,tnodes,telements);
    model.Mesh.MaxElementSize
    
    %% Use HMax factor to tune mesh resolution. Smaller val --> finer grid
    if p.Results.Hmax_factor == -1 && p.Results.Hmin_factor == -1
        generateMesh(model)
    elseif p.Results.Hmax_factor == -1
        generateMesh(model, 'Hmin', model.Mesh.MinElementSize*p.Results.Hmin_factor)
    elseif p.Results.Hmin_factor == -1
        generateMesh(model, 'Hmax', model.Mesh.MaxElementSize*p.Results.Hmax_factor)
    else 
        generateMesh(model, 'Hmax', model.Mesh.MaxElementSize*p.Results.Hmax_factor, 'Hmin', model.Mesh.MinElementSize*p.Results.Hmin_factor)
    end
    
    
    num_edges = model.Geometry.NumEdges;
    if p.Results.bc == "neumann"
        applyBoundaryCondition(model, p.Results.bc, 'Edge', [1:num_edges],'g',0,'q',0);
    else 
        applyBoundaryCondition(model, p.Results.bc, 'Edge', [1:num_edges],'h',1,'r',0); 
    end
    specifyCoefficients(model,'m',0, 'd',1, 'c',1, 'a',0, 'f',0);
    range = [p.Results.min_eig, p.Results.max_eig];
    result = solvepdeeig(model, range);
    FEMatrices = assembleFEMatrices(model);
    strcat("Number of Eigenvalues: ", num2str(length(result.Eigenvalues)), " less than ", num2str(p.Results.max_eig))
end