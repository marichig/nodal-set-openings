%% Finds all points (x,y) satisfying |v(x,y)| < tolerance, within some specified rectangle.

function zero_set = get_zero_set(x_upper_left, y_upper_left, x_bottom_right, y_bottom_right , mesh, eigenfunction, x_step, y_step, tolerance)
    %preallocate memory:
    max_array_length = ceil((x_bottom_right - x_upper_left)*(y_upper_left - y_bottom_right)/(x_step*y_step));
    zero_set = zeros(max_array_length, 3);
    i = 0;
    for x = x_upper_left:x_step:x_bottom_right
       for y =  y_upper_left:-1*y_step:y_bottom_right
           z = eigenfunction(findNodes(mesh, 'nearest', [x; y]));
           if abs(z) <= tolerance
               i = i+1;
               zero_set(i, :) = [x y z];
           end
       end
    end
    zero_set = zero_set(1:i, :);
end