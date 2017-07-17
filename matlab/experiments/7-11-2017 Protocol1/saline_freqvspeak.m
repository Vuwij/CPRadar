%This script plots the distance of the saline from the radar vs the amplitude
%of the peak 
% MAKE SURE THAT THE BASELINE IN obtain_greatest_peak.m IS SET TO 'zero/baseline' AND PAD IT WITH 0s
% BEYOND FIRST 18 BINS


figure

dacmin='949';
dacmax='1100';

peaks_amp_vector=zeros(1,4); %peak amplitude for each frequency

for dist = [15.5 21.6 29.6]
    for i = linspace(2,5,4)
            freq=int2str(i);
            [peak_dist peak_amp] = obtain_greatest_peak('saline_only',strcat(num2str(dist),'cm'),freq,dacmin,dacmax);
            peak_amp_vector(i-1)=peak_amp;  
    end
    plot([5.832 7.29 8.748 10.206],peak_amp_vector,'-o');
    hold on;
end
xlabel('Center Frequency')
ylabel('Saline Peak Amplitude')
legend('15.5cm','21.6cm','29.6cm');
hold off;


