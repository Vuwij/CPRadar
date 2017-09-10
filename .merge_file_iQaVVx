% Create Material
% Creates an arbitrary material based on multiple cole-cole dispersions
function [e_w] = create_material(p_inf, p_del, t_const, a, con)
    p_free = 8.85e-12;     % Permittivity of free space
    
    freq = logspace(8,11);
    
    e_w = zeros(1, length(freq));
    for i = 1 : length(freq)
        e_w(i) = p_inf;
        for m = 1 : length(p_del)
            w = freq(i) * (2 * pi); % Frequency to Angular Frequency
            e_w(i) = e_w(i) + p_del(m) / (1 + (1i * w * t_const(m)) ^ (1 - a(m))) + con(m) / (1i * w * p_free);
        end
    end
    
%     semilogx(freq, real(e_w));
%     title('Frequency Response of Dielectric Constant');
%     xlabel('f/GHz');
%     ylabel('Permittivity (e)');
end