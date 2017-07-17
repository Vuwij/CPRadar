%This script plots the errors in distance for each frequency band as a
%function of the DAC setting
% MAKE SURE THAT THE BASELINE IN obtain_greatest_peak.m IS SET TO 'zero/baseline' AND PAD IT WITH 0s
% BEYOND FIRST 18 BINS

figure
plot_counter=1;

%Loop through all distances
for dist=[29.6 21.6 15.5]
%Loop through all frequencies
    for k = linspace(2,5,4)
        errors=zeros(1,12); %vector to store the errors
        
        %Loop through the 11 different dacmin values
        for i = linspace(0,1000,11)
            greatest_peak = obtain_greatest_peak('saline_only',strcat(num2str(dist),'cm'),int2str(k),int2str(i),'1400');
            %Fill in the error vector
            errors(i/100 + 1) = abs(dist-greatest_peak(1));
        end
        %The 12th element of the error vector will contain the error for
        %the DEFAULT dac setting (dacmin=949, dacmax=1100)
        greatest_peak = obtain_greatest_peak('saline_only',strcat(num2str(dist),'cm'),int2str(k),'949','1100');
        errors(12) = abs(dist-greatest_peak(1));
        
        %Create the plot
        subplot(3,4,plot_counter);
        plot(errors,'-o');
        title(strcat(num2str(dist),'cm-',num2str(1.458*k+2.916),'GHz'));
        xlabel('DAC Setting')
        ylabel('Actual Dist - Loc of Greatest Peak');
        plot_counter=plot_counter+1;
    end
end
    

