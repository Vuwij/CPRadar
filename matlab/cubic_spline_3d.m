function [sample_spline] = cubic_spline_3d(sample)
    [slowTime, fastTime] = size(sample);
    sample_spline = zeros(slowTime*4-3, fastTime*4-3);
    
    % Spline on the x axis first
    x = 0:1:fastTime;
    xx = 0:.25:fastTime;
    for i=1:slowTime
        sample_spline(i,:) = spline(x,sample(i,:),xx);
    end
end
