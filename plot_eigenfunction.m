function plot_eigenfunction(eigenresults, model, varargin)
    %% Note: r --> eigenresults, e --> model
    defaultCorrectSign = true;
    defaultColorBar = 'off';
    defaultShowAxes = true;
    defaultModeIndex = 1;

    p = inputParser;
    addParameter(p, 'correctSign', defaultCorrectSign);
    addParameter(p, 'ColorBar', defaultColorBar);
    addParameter(p, 'showAxes', defaultShowAxes);
    addParameter(p, 'modeIndex', defaultModeIndex);
    parse(p, varargin{:})
   
    eigenfunction = eigenresults.Eigenvectors(:,p.Results.modeIndex);
    
    if p.Results.correctSign
        %doesn't quite work for the resonant mode
        cell_width = max(model.Mesh.Nodes(1,:)); %x dimension
        cell_height = max(model.Mesh.Nodes(2,:)); %y dimension

        %https://www.mathworks.com/help/pde/ug/pde.femesh.findnodes.html#d123e54123
        upper_left = findNodes(model.Mesh,'box',[0.125*cell_width 0.25*cell_width], [0.125*cell_height 0.25*cell_height]);
        eigfn_upper_left = eigenresults.Eigenvectors(upper_left);
        eigfn_sign = sign(eigfn_upper_left(1,:));
        %disp(eigfn_sign)
        if eigfn_sign > 0 
            %Flip in this case
            disp("Flipping")
            eigenfunction = -eigenfunction;
        end
    end

    pdeplot(model, 'XYData', eigenfunction, ...
        'Contour','on', 'Levels', [0,0],...
        'ColorBar', p.Results.ColorBar);
    if ~p.Results.showAxes
        set(gca,'Visible','off')
    end
end

