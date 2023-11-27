%% Calculate and print Opening Size Distance.
% 
% Uses precomputed (r,e) files from figure_5.m

distances = zeros(4,1);

load("r_1.mat")
load("e_1.mat")

eigenfunction = r_temp.Eigenvectors(:,1);
mesh = e_temp.Mesh;
side_lengths = 4.7741;

upper_branch = get_zero_set(2.3, 0.54, 2.35, 0.5,...
                    mesh, eigenfunction, 0.0001, 0.0001, 3.0e-4);
                
lower_branch = get_zero_set(2.35, 0.5, 2.4, 0.46,...
                    mesh, eigenfunction, 0.0001, 0.0001, 3.0e-4); 

scatter(upper_branch(:, 1), upper_branch(:,2))
scatter(lower_branch(:, 1), lower_branch(:,2))
D = pdist2(upper_branch(:,1:2), lower_branch(:,1:2));
disp("Min distance is:")
disp(min(min(D)))
distances(1) = min(min(D));
[r,c] = find(D == min(min(D)));
disp("Extremal points are:")
disp(upper_branch(r(1), 1:2))
disp(lower_branch(c(1), 1:2))
                
                
load("r_2.mat")
load("e_2.mat")

eigenfunction = r_temp.Eigenvectors(:,1);
mesh = e_temp.Mesh;               
side_lengths = 10.0400;

upper_branch = get_zero_set(4.98, 0.54, 5.02, 0.5,...
                    mesh, eigenfunction, 0.0001, 0.0001, 7e-5);
                
lower_branch = get_zero_set(4.94, 0.5, 4.98, 0.46,...
                    mesh, eigenfunction, 0.0001, 0.0001, 7e-5); 

scatter(upper_branch(:, 1), upper_branch(:,2))
scatter(lower_branch(:, 1), lower_branch(:,2))
D = pdist2(upper_branch(:,1:2), lower_branch(:,1:2));
disp("Min distance is:")
disp(min(min(D)))
distances(2) = min(min(D));
[r,c] = find(D == min(min(D)));
disp("Extremal points are:")
disp(upper_branch(r(1), 1:2))
disp(lower_branch(c(1), 1:2))
                
                
load("r_3.mat")
load("e_3.mat")

eigenfunction = r_temp.Eigenvectors(:,1);
mesh = e_temp.Mesh;                
side_lengths = 18.7350;

upper_branch = get_zero_set(9.26, 0.54, 9.33, 0.5,...
                    mesh, eigenfunction, 0.0001, 0.0001, 3e-5);
                
lower_branch = get_zero_set(9.34, 0.5, 9.38, 0.46,...
                    mesh, eigenfunction, 0.0001, 0.0001, 3e-5); 

scatter(upper_branch(:, 1), upper_branch(:,2))
scatter(lower_branch(:, 1), lower_branch(:,2))
D = pdist2(upper_branch(:,1:2), lower_branch(:,1:2));
disp("Min distance is:")
disp(min(min(D)))
distances(3) = min(min(D));
[r,c] = find(D == min(min(D)));
disp("Extremal points are:")
disp(upper_branch(r(1), 1:2))
disp(lower_branch(c(1), 1:2))
                
load("r_4.mat")
load("e_4.mat")

eigenfunction = r_temp.Eigenvectors(:,2);
mesh = e_temp.Mesh;
side_lengths = 36.0785;

upper_branch = get_zero_set(18, 0.54, 18.05, 0.5,...
                    mesh, eigenfunction, 0.0001, 0.0001, 3e-5);
                
lower_branch = get_zero_set(17.95, 0.5, 18.0, 0.46,...
                    mesh, eigenfunction, 0.0001, 0.0001, 3e-5); 

scatter(upper_branch(:, 1), upper_branch(:,2))
scatter(lower_branch(:, 1), lower_branch(:,2))
                
D = pdist2(upper_branch(:,1:2), lower_branch(:,1:2));
disp("Min distance is:")
disp(min(min(D)))
distances(4) = min(min(D));
[r,c] = find(D == min(min(D)));
disp("Extremal points are:")
disp(upper_branch(r(1), 1:2))
disp(lower_branch(c(1), 1:2))

distances
                