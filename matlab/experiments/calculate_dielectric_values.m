%% Calculates the frequency/angularvelocity dependence graph 
function[y] = calculate_dielectric_values(material_index, ang_vel_min, ang_vel_max, precision)
    % Convert angular velocity to frequency
    
    % Finds values in the Material Dieletric Properties Table found in materials/MaterialData and return a graph
    load('../materials/MaterialData');
    
    x = ang_vel_min:precision:ang_vel_max; % X values
    % y = x^2 for example
end