%% Generate Figure 2
square1 = build_perturbed_square(1/8, 'cellWidth', 2, 'boundaryFunction', 'hat', 'hatSpecs', [2, 0.3, 0.05, -1, 0.8, 0.05, -1]);
square2 = build_perturbed_square(1/8, 'cellWidth', 2, 'boundaryFunction', 'hemisphere', 'hemisphereSpecs', [2, 0.3, 0.05, -1, 0.8, 0.05, -1]);
subplot(1,2,1)
plot(square1)
xlim([-0.3, 0.8])
title("Hat Perturbation")
subplot(1,2,2)
plot(square2)
xlim([-0.3, 0.8])
title("Bump Perturbation")

print(gcf,'plots/figure-2-hat-hemi-demo.png','-dpng','-r300'); 