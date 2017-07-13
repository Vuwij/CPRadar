%This script plots the depth of the chicken in the saline vs the amplitude
%of the peak as well as the depth of the chicken in the saline vs the
%location of the peak
peaks_dist_vectpr=zeros(1,11);
for i = linspace(-10,0,11)
    height = strcat(int2str(i),'cm');
    [peak_dist peak_amp] = obtain_greatest_peak('chicken5x4x1cm',height,'2','0','1400');
    peak_dist_vector(i+11)=peak_dist;
    peak_amp_vector(i+11)=peak_amp;
end

figure
subplot(2,1,1);
plot(linspace(-10,0,11),peak_dist_vector);
title('Location of Peak')
subplot(2,1,2);
plot(linspace(-10,0,11),peak_amp_vector);
title('Amplitude of Peak')