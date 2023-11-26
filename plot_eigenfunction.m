function plot_eigenfunction(eigenresults, model, varargin)
    %% Note: r --> eigenresults, e --> model
    defaultCorrectSign = true;
    defaultColorBar = 'off';
    defaultShowAxes = true;
    defaultModeIndex = 1;

    p = inputParser;
    addParameter(p, 'correctSign', defaultCorrectSign);
    addParameter(p, 'manualSign', 1);
    addParameter(p, 'ColorBar', defaultColorBar);
    addParameter(p, 'showAxes', defaultShowAxes);
    addParameter(p, 'modeIndex', defaultModeIndex);
    parse(p, varargin{:})
   
    eigenfunction = eigenresults.Eigenvectors(:,p.Results.modeIndex);
    % normalization not worth it, introduces some numerical error that
    % shifts the plotted nodal set
    %eigenfunction = normalize(eigenfunction, "range",[-1 1]);
    %eigenfunction = normalize(eigenfunction, "center", "mean");

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

    if p.Results.manualSign < 0
        eigenfunction = -eigenfunction;
    end

    set(groot,'defaultLineLineWidth',1.75)
    pdeplot(model, 'XYData', eigenfunction, ...
        'Contour','on', 'Levels', [0,0],...
        'ColorBar', p.Results.ColorBar);
        %'ColorMap','autumn',...

    if strcmp(defaultColorBar, 'on')
        colorbar('Ticks',[-1.3,1.3],...
         'TickLabels',{'-','+'});
    end
    if ~p.Results.showAxes
        set(gca,'Visible','off')
    end
    fontsize(16, "points")
    % ensure 1-1 x-y aspect ratio
    daspect([1 1 1])
end

