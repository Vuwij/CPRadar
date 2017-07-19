function [p_inf, p_del, t_const, a, con] = get_material(materialName)
    load('materials/DielectricDatabase.mat');
    p_inf = DielectricDatabase{materialName,'ef'}; % Permittivity at infinite frequency

    p_del(1) = DielectricDatabase{materialName,'del1'};
    p_del(2) = DielectricDatabase{materialName,'del2'};
    p_del(3) = DielectricDatabase{materialName,'del3'};
    p_del(4) = DielectricDatabase{materialName,'del4'};

    t_const(1) = DielectricDatabase{materialName,'tau1'} * 1e-12;
    t_const(2) = DielectricDatabase{materialName,'tau2'} * 1e-9;
    t_const(3) = DielectricDatabase{materialName,'tau3'} * 1e-6;
    t_const(4) = DielectricDatabase{materialName,'tau4'} * 1e-3;

    a(1) = DielectricDatabase{materialName,'alf1'};
    a(2) = DielectricDatabase{materialName,'alf2'};
    a(3) = DielectricDatabase{materialName,'alf3'};
    a(4) = DielectricDatabase{materialName,'alf4'};

    con(1) = DielectricDatabase{materialName,'sig'};
    con(2) = DielectricDatabase{materialName,'sig'};
    con(3) = DielectricDatabase{materialName,'sig'};
    con(4) = DielectricDatabase{materialName,'sig'};
end