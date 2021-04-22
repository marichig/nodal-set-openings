function plot_results_interactive(eigensystem, model) % (r, e)
%% Investigate all modes from returned PDEModel objects
% Use keyboard to cycle through plots
    eigvectors = eigensystem.Eigenvectors;
    eigvals = eigensystem.Eigenvalues;
    figure;
    i = 1;
    while 1
        subplot(1,2,mod(i,2)+1)
        pdeplot(model, 'XYData', eigvectors(:,i), 'Contour','on', 'Levels', 1) % make param
        title(['Mode: ', num2str(i), ', and Eigenvalue: ', num2str(eigvals(i))])
        waitforbuttonpress;
        % 28 leftarrow
        value = double(get(gcf,'CurrentCharacter'));
        if value==28
            i = max([1 i-1]);
        elseif value==98 || value==101 %b for break or e for exit
            break
        else
            i = min([i+1 length(eigvectors)]);
        end
        
    end
end