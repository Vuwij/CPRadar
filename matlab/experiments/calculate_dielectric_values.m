%% Calculates the frequency/angularvelocity dependence graph
% Equation 7, 8 of http://images.remss.com/papers/rsspubs/Meissner_TGRS_2004_dielectric.pdf
% Graph should look like figure 3
% To test, enter the variables in the command window for the function and
% press play

function[y] = calculate_dielectric_values(material_index, ang_vel_min, ang_vel_max, precision)
    % Convert angular velocity to frequency
    
    % Finds values in the Material Dieletric Properties Table found in materials/MaterialData and return a graph
    load('../materials/MaterialData');
    
    x = ang_vel_min:precision:ang_vel_max; % X values
    % y = x^2 for example
end