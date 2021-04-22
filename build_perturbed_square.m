function square = build_perturbed_square(varargin)
% See:
% https://www.mathworks.com/help/matlab/ref/polyshape.html
% https://www.mathworks.com/help/symbolic/triangularpulse.html

    defaultCellWidth = sqrt(5/3);
    defaultCellHeight = 1;
    defaultAmplitude = 0.01; %role of 'eta' in paper
    defaultFrequency = 6;
    defaultBoundaryFunction = 'cos';
    defaultHatSpecs = [1, 0.5, 0.05, 1];
    % TODO:
    % 1. Don't need number of hats in above, can infer by length of
    % argument
        %[# of hats, (relative position  amplitude  sign) for each hat]
    defaultHemisphereSpecs = [1, 0.5, 0.05, 1];
        %same format
        
    
    p = inputParser;
    addOptional(p, 'amplitude', defaultAmplitude);
    addOptional(p, 'frequency', defaultFrequency);
    addOptional(p, 'bothSides', false)
    addParameter(p, 'cellWidth', defaultCellWidth);
    addParameter(p, 'cellHeight', defaultCellHeight);
    addParameter(p, 'boundaryFunction', defaultBoundaryFunction);
    addParameter(p, 'hatSpecs', defaultHatSpecs);
    addParameter(p, 'hemisphereSpecs', defaultHemisphereSpecs);
    
    parse(p, varargin{:})
    
    xmin = 0;
    xmax = xmin + p.Results.cellWidth;
    ymin = 0;
    ymax = p.Results.cellHeight;
    
    t = 0.:0.001:p.Results.cellHeight;
    if strcmp(p.Results.boundaryFunction,'hat')
        hat = 0;
        for i = 2:3:(1+3*p.Results.hatSpecs(1))
            hat = hat + p.Results.hatSpecs(i+2)*triangularPulse(...
                (ymax-ymin)*p.Results.hatSpecs(i)-p.Results.hatSpecs(i+1), ...
                (ymax-ymin)*p.Results.hatSpecs(i),...
                (ymax-ymin)*p.Results.hatSpecs(i)+p.Results.hatSpecs(i+1), t);
        end
        x = xmin + p.Results.amplitude*hat;
        xmin_top = xmin +  p.Results.amplitude*hat(end);
        
        
    elseif strcmp(p.Results.boundaryFunction,'hemisphere')
        hemisphere = 0;
        for i = 2:3:(1+3*p.Results.hemisphereSpecs(1))
            a1 = (ymax-ymin)*p.Results.hemisphereSpecs(i)-p.Results.hemisphereSpecs(i+1);
            a2 = (ymax-ymin)*p.Results.hemisphereSpecs(i)+p.Results.hemisphereSpecs(i+1);
            
            side = p.Results.hemisphereSpecs(i+2)*(heaviside(t - a1)- heaviside(t - a2));
            hemisphere = hemisphere + side.*sin(pi*(t-a1)/(a2 - a1));
        end
        x = xmin + p.Results.amplitude*hemisphere;
        xmin_top = xmin +  p.Results.amplitude*hemisphere(end);
            
    elseif strcmp(p.Results.boundaryFunction,'cos')
        x = xmin - p.Results.amplitude + p.Results.amplitude*cos(p.Results.frequency*pi*t);
        xmin_top = xmin - p.Results.amplitude + p.Results.amplitude*cos(p.Results.frequency*pi*p.Results.cellHeight);
    elseif strcmp(p.Results.boundaryFunction,'sin')
        x = xmin - p.Results.amplitude + p.Results.amplitude*sin(p.Results.frequency*pi*t); 
        xmin_top = xmin + - p.Results.amplitude + p.Results.amplitude*sin(p.Results.frequency*pi*p.Results.cellHeight);
    end 
    y = t;
    left_curvy_side = [x ; y]';
    if p.Results.bothSides
        right_curvy_side = [-x ; flip(y)]' + [p.Results.cellWidth 0];
        P = [left_curvy_side ; right_curvy_side];
    else
        cell = [xmin_top ymax; xmax ymax; xmax ymin];
        P = [left_curvy_side ; cell];
    end
    
    square = polyshape(P);

end

