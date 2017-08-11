function [peak_dist peak_amp] = obtain_greatest_peak(folder, height, frequency, dacmin, dacmax)
% This function returns the location and amplitude of the greatest peak
% after subtracting a baseline and calibrating the 0 of the signal as the
% location of the first greatest peak
% This script uses the average of the 5 fast time sequences taken
% WHEN YOU CALL THIS FUNCTION, MAKE SURE THAT YOU SET THE BASELINE AND
% PADDING ACCORDINGLY
%% Choosing a setting
%You need to be in the '7-11-2017 Protocol1' folder

%Specify whether to plot the baseband or rf data
mode = 'bb';
%% Load the data and obtain the average of all 5 fast time signals, 
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

t_vec = 0:1/fs:(N-1)/fs;
r_vec = c/2 * t_vec;
r_vec_cm = r_vec * 100;
%% Find peak location in baseline data and calibrate range zero
[m ind] = max(abs(baseline));

r_min = r_vec(2) - r_vec(1);
r_vec = r_vec - (ind-1)*r_min;
r_vec_cm = r_vec * 100;
%% Obtain the difference signal and plot it
diff = data-baseline;
%% Getting the distance at which the peak occurs
[x y] = max(abs(diff));
peak_dist=r_vec_cm(y);
peak_amp=x;



