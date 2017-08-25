%This script plots the depth of the chicken in the saline vs the amplitude
%of the peak as well as the depth of the chicken in the saline vs the
%location of the peak

%Make sure you update obtain_greatest_peak with chicken at -10cm as the
%baseline
%DO NOT PAD THE FIRST 18 BINS OF THE BASELINE

figure

peaks_dist_vector=zeros(1,10);
peaks_amp_vector=zeros(1,10);

for freq = linspace(2,5,4)
    for i = linspace(-9,0,10)
            height = strcat(int2str(i),'cm');
            [peak_dist peak_amp] = obtain_greatest_peak_between('chicken5x4x1cm',height,int2str(freq),'949','1100',20,40);
            peaks_dist_vector(i+10)=peak_dist;
            peaks_amp_vector(i+10)=peak_amp;
    end
    
    subplot(2,1,1);
    plot(linspace(-9,0,10),peaks_dist_vector,'-o');
    hold on;
    title('Location of Peak')
    xlabel('cm above saline');
    ylabel('cm from radar')
    legend('5.832GHz','7.29GHz','8.748GHz','10.206GHz');
    subplot(2,1,2);
    plot(linspace(-9,0,10),peaks_amp_vector,'-o');
    hold on;
    title('Amplitude of Peak')
    xlabel('cm above saline');
end

legend('5.832GHz','7.29GHz','8.748GHz','10.206GHz');


