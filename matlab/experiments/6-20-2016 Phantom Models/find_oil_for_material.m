function [oil] = find_oil_for_material(materialName)
    [p_inf, p_del, t_const, a, con] = get_material(materialName);
    [e_w] = create_material(p_inf, p_del, t_const, a, con);
    freq = logspace(8,11);
    oil = find_optimum_oil(freq, real(e_w), 1e9, 1e10);
    legend(strcat('Dielectric for ', materialName), strcat('Oil (', num2str(oil), '%)')); 
    oil = oil / 100;
end