%% Calculates the frequency/angularvelocity dependence graph
% Equation 7, 8 of http://images.remss.com/papers/rsspubs/Meissner_TGRS_2004_dielectric.pdf
% Graph should look like figure 3
% To test, enter the variables in the command window for the function and
% press play

%Angular velocity is in rad/s
function[y] = calculate_dielectric_values(material_index, temp, ang_vel_min, ang_vel_max, precision)
    x = ang_vel_min:precision:ang_vel_max; % Vector of angular velocities 
    f = x * ( 1 / (2 * pi)); % Convert angular velocities to frequencies
    
    % Finds values in the Material Dieletric Properties Table found in materials/MaterialData and return a graph
    load('../materials/MaterialData');
    a = MaterialData.MaterialDielectricProperties{material_index,:};
    
    p1 = (3.70886 * (10^4) - 8.2168 * 10 * T) / (4.21854 * 100 + temp);
    p2 = a(0) + a(1) * temp + a(2) * temp .^ 2
    p3 = (45 + T)/(a(3) + a(4) * T + a(5) * T .^ 2);
    p4 = a(6) + a(7) * T
    p5 = (45 + T)/( a(8) +a(9) * T + a(10) * T .^ 2);
    y = (p1 - p2) / ( 1 + 1i * f / p3) + (p2 - p4)/(1 + 1i * f / p5) + p4;
    
    plot(f,y);
end