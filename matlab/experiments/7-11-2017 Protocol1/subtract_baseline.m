%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Script to visualize the collected radar data along with the corresponding
% baseline, as well as the baseline subtracted from the radar data
% This uses the average of the 5 fast time sequences taken
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear variables;
clc;
%% Choosing a setting

%You need to be in the '7-11-2017 Protocol1' folder

%Folder can be "saline_only" or "chicken5x4x1cm" or "screw-2mm-0.8cm" or "screw-3mm-1.2cm" or "screw-3mm-1.5cm"
folder = 'saline_only';
height = '15.5cm';
%Frequency can be...
    %2 (5.832 GHz)
    %3 (7.29 GHz))
    %4 (8.748 GHz)
    %5 (10.206 GHz)
frequency = '3';
%Specify the dacmin and dacmax values (default: dacmin = 949, dacmax = 1100)
dacmin = '0';
dacmax = '1400';
%Specify whether to plot the baseband or rf data"
mode = 'bb';
%% Set the baseline to be used and load the data
data = obtain_mean_data(folder, height, frequency, dacmin, dacmax, mode);
baseline=obtain_mean_data('zero','baseline',frequency,dacmin,dacmax,mode); 
%% Pad the baseline
%If the baseline used is the zero signal only use the first 18 bins of the
%baseline and set everything else as 0 (remove this line and pad as you see
%fit if you are using another baseline)
baseline = [baseline(1:18); zeros(length(baseline)-18,1)];
%% Uncalibrated range and time vectors
c = 299792458;
N=length(baseline);
fs = 2.916*10^9; % sampling rate of baseband data (number obtained from Xethru forum)
%Create a time vector
t_vec = 0:1/fs:(N-1)/fs;
%Create the corresponding range vector 
r_vec = c/2 * t_vec;
r_vec_cm = r_vec * 100;
%% Find peak location in baseline data and calibrate range zero
[m ind] = max(abs(baseline));

r_min = r_vec(2) - r_vec(1);
r_vec = r_vec - (ind-1)*r_min;
r_vec_cm = r_vec * 100;
%% Plot the data before subtracting and baseline on the same subfigure
figure
subplot(2,1,1)
plot(r_vec_cm,abs(data));
hold on;
plot(r_vec_cm,abs(baseline));
legend('Data', 'Baseline');
xlabel('cm');
%% Plot the data after subtracting on another subfigure 
diff=data-baseline;
subplot(2,1,2)
plot(r_vec_cm,abs(diff));
legend('abs(data-baseline)');
xlabel('cm');
%% Getting the distance at which the peak occurs
diff=data-baseline;
[x y] = max(abs(diff));




