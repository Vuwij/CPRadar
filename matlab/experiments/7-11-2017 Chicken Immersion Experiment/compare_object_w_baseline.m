%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alison Cheeseman
% Processing of X4 radar data from Experiment 1
% Detection of static objects at various depths within saline solution
% Look at baseline data (TX-RX and saline surface) and compare results from
% each frequency and DAC setting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear variables;
close all;
clc;

%% Define desired figure size
width_fig = 12;
height_fig = 10; 

%% Define settings which will be kept constant
% which object to look at (metal screw or chicken)
folder = 'chicken5x4x1cm'; %'chicken5x4x1cm'; 

c = 3*10^8; % speed of light
dacmin = '949';
dacmax = '1100';
mode = 'bb';

switch mode
    case 'bb'
        N = 186; % length of baseband data
        fs = 2.916*10^9; % sampling rate of baseband data (number obtained from Xethru forum)  
        nbins = 18; % for subtracting TX baseline
    case 'rf'
        N = 1520; % length of rf data
        fs = 23.328*10^9; % sampling rate of rf data   
        nbins = 18*8; % for subtracting TX baseline
end;

freq_array = {'2','3','4','5'}; % frequencies to look at
% 2: 5.82 GHz
% 3: 7.29 GHz
% 4: 8.748 GHz
% 5: 10.206 GHz

depth_saline = 27.2; % distance between radar and saline surface (in cm)
height_array = [-1,-2,-5,-10]; % depth of object below surface (in cm)

peak_ampl = zeros(length(freq_array),length(height_array)); % array to store peak amplitude for each distance and frequency
peak_loc = zeros(length(freq_array),length(height_array)); % array to store peak location for each distance and frequency

for i = 1:length(freq_array)
    frequency = freq_array{i};
    
    %% First, look at TX-RX data
    folder_tx = 'zero';
    height_tx = 'baseline';
    x_tx = zeros(N,5);
    for fts = 1:5
    x_tx = obtain_data(folder_tx, height_tx, frequency, dacmin, dacmax, mode, 1);
    end;
    x_tx = mean(x_tx,2);
    % tx baseline
    bl = [x_tx(1:nbins) ;zeros(N-nbins,1)];
        
    %% Range calibration based on baseline for each frequency
    % uncalibrated range and time vectors
    t_vec = 0:1/fs:(N-1)/fs;
    r_vec = c/2 * t_vec;

    %% Find peak location in baseline TX-RX data (1st FTS) and calibrate range zero
    [mx ind_zero] = max(abs(x_tx(:,1)));

    t_min = t_vec(2) - t_vec(1);
    t_vec = t_vec - (ind_zero-1)*t_min;
    
    %% Define saline baseline signals at four different depths: 27.2cm
    saline_height_array = [27.2,15.5,21.6,29.6];
    saline = zeros(N,5,4);
    for fts = 1:5
    saline(:,fts,1) = obtain_data(folder, 'baseline', frequency, dacmin, dacmax, mode, fts);
    saline(:,fts,1) = saline(:,fts,1) - bl;
    end;
    for j = 2:4
        saline_height = sprintf('%.1fcm',saline_height_array(j));
        for fts = 1:5
        saline(:,fts,j) = obtain_data('saline_only', saline_height, frequency, dacmin, dacmax, mode, fts);
        saline(:,fts,j) = saline(:,fts,j) - bl;
        end;
    end; 

    %% Now gather data with object in saline at different depths
    data = zeros(N,5,length(height_array));
    for j = 1:length(height_array)
        height = sprintf('%dcm',height_array(j));
        for fts = 1:5
            data(:,fts,j) = obtain_data(folder, height, frequency, dacmin, dacmax, mode, fts);
            data(:,fts,j) = data(:,fts,j) - bl;
        end;
        %data(:,j) = mean(data(:,:,j),2);
    end;
    % plot signal amplitude 
    figure
    subplot(3,2,1)
    plot(t_vec*10^9,abs(saline(:,:,1)),'LineWidth',1.5);
    title(sprintf('Saline at distance of 27.1 cm from the radar, f_c = %s',frequency))
    legend('FTS 1','FTS 2','FTS 3','FTS 4','FTS 5');
    xlim([-1 6])
    grid on;
    xlabel('Delay (ns)')
    ylabel('Signal Amplitude')
    yax = get(gca,'ylim');
    ylim(yax*1.5);
    subplot(3,2,2)
    title(sprintf('%s at -1 cm within the saline, f_c = %s',folder,frequency))
    hold all;
    plot(t_vec*10^9,abs(data(:,:,1)),'LineWidth',1.5);   
    legend('FTS 1','FTS 2','FTS 3','FTS 4','FTS 5');
    xlim([-1 6])
    ylim(yax*1.5);
    grid on;
    xlabel('Delay (ns)')
    ylabel('Signal Amplitude')
    subplot(3,2,3)
    title(sprintf('%s at -2 cm within the saline, f_c = %s',folder,frequency))
    hold all;
    plot(t_vec*10^9,abs(data(:,:,2)),'LineWidth',1.5);   
    legend('FTS 1','FTS 2','FTS 3','FTS 4','FTS 5');
    xlim([-1 6])
    ylim(yax);
    ylim(yax*1.5);
    grid on;
    xlabel('Delay (ns)')
    ylabel('Signal Amplitude')
    subplot(3,2,4)
    title(sprintf('%s at -5 cm within the saline, f_c = %s',folder,frequency))
    hold all;
    plot(t_vec*10^9,abs(data(:,:,3)),'LineWidth',1.5);   
    legend('FTS 1','FTS 2','FTS 3','FTS 4','FTS 5');
    xlim([-1 6])
    ylim(yax);
    ylim(yax*1.5);
    grid on;
    xlabel('Delay (ns)')
    ylabel('Signal Amplitude')
    subplot(3,2,5)
    title(sprintf('%s at -10 cm within the saline, f_c = %s',folder,frequency))
    hold all;
    plot(t_vec*10^9,abs(data(:,:,3)),'LineWidth',1.5);   
    legend('FTS 1','FTS 2','FTS 3','FTS 4','FTS 5');
    xlim([-1 6])
    ylim(yax);
    ylim(yax*1.5);
    grid on;
    xlabel('Delay (ns)')
    ylabel('Signal Amplitude')
    subplot(3,2,6)
    title(sprintf('Overlay of Average Signals, f_c = %s',frequency))
    hold all;
    plot(t_vec*10^9,abs(mean(saline(:,:,1),2)),'LineWidth',1.5); 
    plot(t_vec*10^9,abs(squeeze(mean(data,2))),'LineWidth',1.5);  
    legend('Saline','-1 cm','-2cm','-5 cm','-10 cm');
    xlim([-1 6])
    ylim(yax);
    ylim(yax*1.5);
    grid on;
    xlabel('Delay (ns)')
    ylabel('Signal Amplitude')
    set(gcf,'Units','inches','Position',[1 1 width_fig height_fig]);
    savefig(sprintf('Compare_signals_%s_fc%s.fig',folder,frequency));
end;

return;