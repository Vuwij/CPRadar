%This script plots the distance of the saline from the radar vs the amplitude
%of the peak 

figure

plot_counter = 1;


%Loop through 3 different dacmin values (0, 500, 1000)
for j = linspace(0,1000,3)
    %Loop through the 4 center frequencies
    for i = linspace(2,5,4)
        freq=int2str(i);
        dacmin=int2str(j);
        dacmax='1400';

        peaks_amp_vector=zeros(1,3);
        peaks_dist_vector=zeros(1,3);

        %Fill in the peaks_amp_vector and peaks_dist_vector with the
        %greatest peak values for each distance
        [peak_dist peak_amp] = obtain_greatest_peak('saline_only','15.5cm',freq,dacmin,dacmax);
        peaks_amp_vector(1)=peak_amp;
        peaks_dist_vector(1)=peak_dist;
        
        [peak_dist peak_amp] = obtain_greatest_peak('saline_only','21.6cm',freq,dacmin,dacmax);
        peaks_amp_vector(2)=peak_amp;
        peaks_dist_vector(2)=peak_dist;
        
        [peak_dist peak_amp] = obtain_greatest_peak('saline_only','29.6cm',freq,dacmin,dacmax);
        peaks_amp_vector(3)=peak_amp;
        peaks_dist_vector(3)=peak_dist;

        %Plot distance against the amplitude
        subplot(1,4,plot_counter);
        plot([15.5 21.6 29.6],peaks_amp_vector);
        title(strcat('Amplitude of Peak','dacmin',dacmin,'dacmax',dacmax))
        xlabel('Actual Distance from Radar (cm)');
        ylabel('Amplitude of Saline Peak');
        hold on;

    end
    %4 different plots for each dac setting
    plot_counter=plot_counter+1;
end

%Create the 4th plot with the default dac setting
for i = linspace(2,5,4)
    freq=int2str(i);
    dacmin='949';
    dacmax='1100';

    peaks_amp_vector=zeros(1,3);
    peaks_dist_vector=zeros(1,3);

    %Fill in the peaks_amp_vector and peaks_dist_vector with the
    %greatest peak values for each distance
    [peak_dist peak_amp] = obtain_greatest_peak('saline_only','15.5cm',freq,dacmin,dacmax);
    peaks_amp_vector(1)=peak_amp;
    peaks_dist_vector(1)=peak_dist;
    
    [peak_dist peak_amp] = obtain_greatest_peak('saline_only','21.6cm',freq,dacmin,dacmax);
    peaks_amp_vector(2)=peak_amp;
    peaks_dist_vector(2)=peak_dist;
    
    [peak_dist peak_amp] = obtain_greatest_peak('saline_only','29.6cm',freq,dacmin,dacmax);
    peaks_amp_vector(3)=peak_amp;
    peaks_dist_vector(3)=peak_dist;

    %Plot distance against the amplitude
    subplot(1,4,4);
    plot([15.5 21.6 29.6],peaks_amp_vector);
    title(strcat('Amplitude of Peak','dacmin',dacmin,'dacmax',dacmax))
    xlabel('Actual Distance from Radar (cm)');
    ylabel('Amplitude of Saline Peak');
    hold on
end

legend('5.832 GHz','7.29 GHz','8.748 GHz','10.206 GHz');
    
    


