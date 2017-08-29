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
width_fig = 10;
height_fig = 8; 

%% Define settings which will be kept constant
% which object to look at (metal screw or chicken)
folder = 'screw-3mm-1.5cm'; %'chicken5x4x1cm';;

c = 3*10^8; % speed of light
% estimates of permittivity in saline
eps_lo = 55; % lower bound
eps_hi = 85; % upper bound
% DAC settings which minimize signal clipping
dacmin = '0';
dacmax = '1400';
mode = 'bb';

switch mode
    case 'bb'
        N = 186; % length of baseband data, change to 1520 for 'rf'
        fs = 2.916*10^9; % sampling rate of baseband data (number obtained from Xethru forum)        
    case 'rf'
        N = 1520; % length of rf data
        fs = 23.328*10^9; % sampling rate of rf data         
end;

freq_array = {'2','3','4','5'}; % frequencies to look at
% 2: 5.82 GHz
% 3: 7.29 GHz
% 4: 8.748 GHz
% 5: 10.206 GHz

depth_saline = 0.272; % distance between radar and saline surface (in cm)
height_array = [-0.01,-0.02,-0.03,-0.05,-0.08,-0.1]; % depth of object below surface (in m)

peak_ampl = zeros(length(freq_array),length(height_array)); % array to store peak amplitude for each distance and frequency
peak_loc = zeros(length(freq_array),length(height_array)); % array to store peak location for each distance and frequency

for i = 1:length(freq_array)
    frequency = freq_array{i};
    
    %% First, look at TX-RX data
    folder_tx = 'baseline';
    height_tx = 'zero';
    x_tx = zeros(N,5);
    for fts = 1:5
    x_tx = obtain_data(folder_tx, height_tx, frequency, dacmin, dacmax, mode, 1);
    end;
    x_tx = mean(x_tx,2);
        
    %% Range calibration based on baseline for each frequency
    % uncalibrated range and time vectors
    t_vec = 0:1/fs:(N-1)/fs;
    r_vec = c/2 * t_vec;

    %% Find peak location in baseline TX-RX data (1st FTS) and calibrate range zero
    [mx ind_zero] = max(abs(x_tx(:,1)));

    t_min = t_vec(2) - t_vec(1);
    t_vec = t_vec - (ind_zero-1)*t_min;
    %r_vec_cm = r_vec * 100;    
    
    %% Define saline baseline signal with object at max depth from surface: '-10cm' (average over 5 fts)
    maxdepth = '-10cm';
    x_bl = zeros(N,5);
    for fts = 1:5
    x_bl(:,fts) = obtain_data(folder, maxdepth, frequency, dacmin, dacmax, mode, fts);
    end;
    x_bl = mean(x_bl,2);
    
    nbins = N; % number of bins of the baseline signal to subtract (use ~18 if subtracting TX baseline)
    bl = [x_bl(1:nbins) ;zeros(N-nbins,1)];
       
    %% Now gather data with object in saline at different depths
    for j = 1:length(height_array)
        height = sprintf('%dcm',height_array(j)*100);
        data = zeros(N,5);
    for fts = 1:5
        data(:,fts) = obtain_data(folder, height, frequency, dacmin, dacmax, mode, fts);
    end;
    % take the average of the data
    data = mean(data,2);
    % Saline baseline subtraction
    data2 = data - bl;
    
    % compute the time at which we expect to see the object
    t_saline = (2*depth_saline)/c;
    v_lo = c/sqrt(eps_lo);
    v_hi = c/sqrt(eps_hi);
    t_obj_lo = t_saline + 2*(-1*height_array(j))/v_lo;
    t_obj_hi = t_saline + 2*(-1*height_array(j))/v_hi;
        
    % plot amplitude against range before any processing
    figure
    subplot(2,1,1)
    title(sprintf('Signal Amp. vs. Time Delay for %s at a Distance of %s from Saline Surface, f_c = %s',folder,char(height),frequency))
    hold all;
    plot(t_vec*10^9,abs(bl),'LineWidth',1.5);
    plot(t_vec*10^9,abs(data),'LineWidth',1.5);
    % plot where we expect to see signals
    plot(t_saline*10^9*ones(1,2),[min(abs(bl)) max(abs(bl))],'LineWidth',1.5)
    xlim([-1 15])
    legend('Baseline Signal','Original Signal','Calculated Delay of Saline')
    grid on;
    xlabel('Delay (ns)')
    ylabel('Signal Amplitude')
    set(gcf,'Units','inches','Position',[3 3 width_fig height_fig]);
    subplot(2,1,2)
    title(sprintf('Signal Amp. vs. Time Delay for %s at a Distance of %s from Saline Surface, f_c = %s',folder,char(height),frequency))
    hold all;
    plot(t_vec*10^9,abs(data2),'LineWidth',1.5);    
    % plot where we expect to see signals
    plot(t_saline*10^9*ones(1,2),[min(abs(data2)) max(abs(data2))],'LineWidth',1.5);
    plot(t_obj_lo*10^9*ones(1,2),[min(abs(data2)) max(abs(data2))],'LineWidth',1.5);
    plot(t_obj_hi*10^9*ones(1,2),[min(abs(data2)) max(abs(data2))],'LineWidth',1.5);
    xlim([-1 15])
    legend('Baseline Subtracted Signal','Calculated Delay of Saline','Estimated Lower Bound on Delay of Object','Estimated Upper Bound on Delay of Object')
    grid on;
    xlabel('Delay (ns)')
    ylabel('Signal Amplitude')
    set(gcf,'Units','inches','Position',[3 3 width_fig height_fig]);
    savefig(sprintf('maxdepth_subtract_%s_depth%s_fc%s.fig',folder,char(height),frequency));
    close;
    
    end; % end height loop 
end; % end frequency loop
