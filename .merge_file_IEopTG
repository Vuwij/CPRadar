function [gamma, e_w, fr] = multidielsweep(bodyLayer, bodyLayerMoving)
    layer_count = length(bodyLayer);
    fr = logspace(8,11);
    e_w = zeros(layer_count+2, 50);
    gamma = zeros(layer_count+1, 50);
    f_test = zeros(layer_count+1, 50);

    % Obtain frequency respones for all materials
    for i = 1:layer_count
        materialName = bodyLayer{i, 1};
        [p_inf, p_del, t_const, a, con] = get_material(materialName);
        e_w(i+1,:) = create_material(p_inf, p_del, t_const, a, con);

        semilogx(fr, real(e_w(i+1,:)));
        hold on;
    end
    hold off;
    title('Frequency Response of Dielectric Constant');
    xlabel('f/GHz');
    ylabel('Permittivity (e)');
    legend(bodyLayer{:, 1});

    % First and last material is air
    [p_inf, p_del, t_const, a, con] = get_material('Air');
    e_w(1,:) = create_material(p_inf, p_del, t_const, a, con);
    e_w(layer_count + 2,:) = e_w(1,:);

    % Getting p
    for i=1:layer_count+1
        f_test(i,:) = (1 - sqrt(e_w(i+1,:) ./ e_w(i,:))) ./ (1 + sqrt(e_w(i+1,:) ./ e_w(i,:)));
    end

    % Getting the refractive indexes and propogation constant (varies with frequency and layer)
    n = e_w .^(0.5);
    lambda = 3e8 ./ fr;
    k = zeros(layer_count+2, 50);
    for i = 1:length(n)
       k(:,i) = 2*pi*n(:, i) ./ lambda(i);
    end

    % Initialize del and p and then calculate gamma
    gamma(layer_count+1,:) = f_test(layer_count+1,:);
    l = bodyLayerMoving .* 1e-3; % Thickness of the layer
    for i = layer_count:-1:1
        exponent = exp(-2i*k(i,:).*l(i));
        gamma(i,:) = (f_test(i,:) + gamma(i+1,:).*exponent) ./ (1 + f_test(i,:).*gamma(i+1,:).*exponent);
    end