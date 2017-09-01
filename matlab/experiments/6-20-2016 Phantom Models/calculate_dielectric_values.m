%% Calculates the frequency/angularvelocity dependence graph
% Equation 7, 8 of http://images.remss.com/papers/rsspubs/Meissner_TGRS_2004_dielectric.pdf
% Graph should look like figure 3
% To test, enter the variables in the command window for the function and
% press play

% Material name is a string of the name found in materialdata
% tem = Temperature in K
% Angular velocity is in rad/s
function[e_ts] = calculate_dielectric_values(material_name, tem, ang_vel_min, ang_vel_max)
    e_0 = git8.85e12;
    
    tem = tem - 273.15
    x = linspace(ang_vel_min / 10e8, ang_vel_max / 10e8); % Vector of angular velocities 
    f = x / (2 * pi); % Convert angular velocities to frequencies
    
    % Finds values in the Material Dieletric Properties Table found in materials/MaterialData and return a graph
    load('../data/materials/MaterialData');
    
    m = MaterialDielectricProperties(material_name, :);
    % cond = MaterialProperties(material_name, :).Conductivity{1}; % 
    cond = 0;
    e_s = (3.70886e4 - 8.2168e1 * tem) / (4.21854e2 + tem);
    e_1 = m.a0 + m.a1 * tem + m.a2 * tem ^ 2;
    v_1 = (45 + tem) / (m.a3 + m.a4 * tem + m.a5 * tem ^ 2);
    e_inf = m.a6 + m.a7 * tem;
    v_2 = (45 + tem) / (m.a8 + m.a9 * tem + m.a10 * tem ^ 2);
    e_ts = (e_s - e_1) ./ ( 1 + 1i * f ./ v_1) + (e_1 - e_inf) ./ (1 + 1i * f ./ v_2) + e_inf - 1i * cond ./ (2 * pi * e_0 * f);
    
    %plot(log2(f),log2(real(e_ts)));
    %hold on;
    plot(log2(f),log2((imag(e_ts))));
    
end