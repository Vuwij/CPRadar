function [error] = obtain_greatest_peak(folder, height, frequency, dacmin, dacmax)
%This function returns the location and amplitude of the greatest peak
%(with the TX signal subtracted)
%% Choosing a setting
%You need to be in the '7-11-2017 Protocol1' folder

%Specify whether to plot the baseband or rf data"
mode = 'bb';
%Specify which of the 5 fast time sequences
fts = 1;

%% Load the data
data = obtain_data(folder, height, frequency, dacmin, dacmax, mode, fts);
baseline=obtain_data('zero','baseline',frequency,dacmin,dacmax,mode,fts);
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

%% Getting the distance at which the peak occurs
[x y] = max(abs(data-baseline));
peak_dist=r_vec_cm(y);
%% Getting the error in the distance
error=abs(peak_dist-actual_dist);


end

