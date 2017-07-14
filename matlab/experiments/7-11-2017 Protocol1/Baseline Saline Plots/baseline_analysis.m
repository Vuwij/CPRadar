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

%% Define settings which will be kept constant
c = 3*10^8; % speed of light
fs = 2.916*10^9; % sampling rate of baseband data (number obtained from Xethru forum)

dacmin = '0';
dacmax = '1400';
mode = 'bb';
N = 186; % length of baseband data, change to 1520 for 'rf'

% and define arrays to store data
freq_array = {'3','4'}; % frequencies to look at
% 2: 5.82 GHz
% 3: 7.29 GHz
% 4: 8.748 GHz
% 5: 10.206 GHz

height_array = {'15.5cm','21.6cm','29.6cm'}; % measured depths of saline surface

peak_ampl = zeros(length(freq_array),length(height_array)); % array to store peak amplitude for each distance
peak_loc = zeros(length(freq_array),length(height_array)); % array to store peak amplitude for each distance

for i = 1:length(freq_array)
    frequency = freq_array{i};
    %% First, look at TX-RX data
    % Choose which data set to load
    folder = 'baseline';
    height = 'zero';
    x_tx = zeros(N,5);
    for fts = 1:5
        x_tx(:,fts) = obtain_data(folder, height, frequency, dacmin, dacmax, mode, fts);
    end;
    % Plot amplitude and phase for all 5 fast time samples as a comparison
    figure
    subplot(2,1,1)
    title(sprintf('Baseline Signal Amplitude for f_c = %s',frequency))
    hold all;
    for fts = 1:5
        plot(abs(x_tx(:,fts)));
    end;
    grid on;
    legend('FTS 1','FTS 2','FTS 3','FTS 4','FTS 5')
    xlabel('Bin Number')
    ylabel('Signal Amplitude')
    subplot(2,1,2)
    title(sprintf('Baseline Signal Phase for f_c = %s',frequency))
    hold all;
    for fts = 1:5
        plot(angle(x_tx(:,fts)));
    end;
    grid on;
    legend('FTS 1','FTS 2','FTS 3','FTS 4','FTS 5')
    xlabel('Bin Number')
    ylabel('Signal Phase')
    
    %% Range calibration based on baseline for each frequency
    % uncalibrated range and time vectors
    t_vec = 0:1/fs:(N-1)/fs;
    r_vec = c/2 * t_vec;

    %% Find peak location in baseline TX-RX data (1st FTS) and calibrate range zero
    [mx ind] = max(abs(x_tx(:,1)));

    r_min = r_vec(2) - r_vec(1);
    r_vec = r_vec - (ind-1)*r_min;
    r_vec_cm = r_vec * 100;
    
    %% Define the baseline signal for given frequency
    %We only want to subtract the TX-RX signal, not reflection from further
    % ranges, so take only the first 20 bins (determined by visual inspection) and pad with zeros
    bl_tx = [x_tx(1:20,1); zeros(N-20,1)];
    
    %% Now look at saline data at 3 different heights: 15.5 cm, 21.6 cm and 29.6 cm
    % Start with a single frequency, 7.29 GHZ (default value)
    % Choose which data set to load
    folder = 'saline_only';
    for j = 1:length(height_array)
        height = height_array{j};
        x_saline = zeros(N,5);
    for fts = 1:5
        x_saline(:,fts) = obtain_data(folder, height, frequency, dacmin, dacmax, mode, fts);
    end;
    
    % plot amplitude of each fts against range before any processing
    figure
    title(sprintf('Unprocessed Signal Amplitude vs. Range for Saline at a Distance of %s, f_c = %s',char(height),frequency))
    hold all;
    for fts = 1:5
        plot(r_vec_cm,abs(x_saline(:,fts)));
    end;
    xlim([-20 180])
    grid on;
    legend('FTS 1','FTS 2','FTS 3','FTS 4','FTS 5')
    xlabel('Range (cm)')
    ylabel('Signal Amplitude')
    
    % baseline subtraction
    for fts = 1:5
        x_saline_sub(:,fts) = x_saline(:,fts) - bl_tx;
    end;
    % plot amplitude of each fts against range after baseline subtraction
    figure
    title(sprintf('Baseline Subtracted Signal Amplitude vs. Range for Saline at a Distance of %s, f_c = %s',char(height),frequency))
    hold all;
    for fts = 1:5
        plot(r_vec_cm,abs(x_saline_sub(:,fts)));
    end;
    xlim([-20 180])
    grid on;
    legend('FTS 1','FTS 2','FTS 3','FTS 4','FTS 5')
    xlabel('Range (cm)')
    ylabel('Signal Amplitude')
    
     % Find the average peak amplitude and peak loc.
    m = 0;
    r = 0;
    for fts = 1:5
        [mx ind] = max(abs(x_saline_sub(:,fts)));
        m = m + 1/5 * mx;
        r = r + 1/5 * r_vec_cm(ind);
    end;
    peak_ampl(i,j) = m;
    peak_loc(i,j) = r;
    end; % end height loop
    
end; % end frequency loop

% Plot avg peak amplitude & peak loc. vs. measured distance
figure
subplot(2,1,1)
plot([15.5,21.6,29.6],peak_ampl,'-o','LineWidth',1.5)
grid on;
xlabel('Measured Distance (cm)')
ylabel('Average Peak Amplitude')
legend('5.832 GHz','7.29 GHz','8.748 GHz','10.206 GHz','location','best')
subplot(2,1,2)
plot([15.5,21.6,29.6],peak_loc,'-o','LineWidth',1.5)
grid on;
xlabel('Measured Distance (cm)')
ylabel('Average Peak Location (cm)')
legend('5.832 GHz','7.29 GHz','8.748 GHz','10.206 GHz','location','best')

return;