function [sample_spline] = cubic_spline_3d(sample)
    [slowTime, fastTime] = size(sample);
    sample_spline = zeros(slowTime*4, fastTime*4);
    
    % Spline on the x axis first
    x = 0:1:fastTime-1;
    xx = 0:.25:fastTime-1;
    for i=1:slowTime
        sample_spline(:,i) = spline(x,sample(:,i),xx);
    end
    
    % Spline on the y axis
    y = 0:1:slowTime;
    yy = 0:.25:slowTime;
    for i=1:fastTime
        sample_spline(i,:) = spline(x,sample(i,:),xx);
    end
    
end
