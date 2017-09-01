%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alison Cheeseman
% Script to plot bb data files from X4 radar and subtract baseline to detect
% presence of targets at known ranges
% Includes preliminary calibration of range axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear variables;
close all;
clc;

%% Define figure sizes
width_fig = 10;
height_fig = 6; 

%% Load data files
load('data/baseline.mat');
x_bl = frame;
load('data/aluminum_sheet_17.5cm_7.29GHz.mat');
x_17 = frame;
load('data/aluminum_sheet_66cm_7.29GHz.mat');
x_66 = frame;
clear frame;

%% Define constants
c = 299792458;
N = length(x_bl);
tau = 1.8*10^-9; % transmit pulse length in s (estimate)
fs = 2.916*10^9; % sampling rate of baseband data (number obtained from Xethru forum)

% uncalibrated range and time vectors
t_vec = 0:1/fs:(N-1)/fs;
r_vec = c/2 * t_vec;
r_vec_cm = r_vec * 100;

%% Plot data before subtraction and calibration
display('Figure 1: unprocessed signal amplitudes')
figure
subplot(2,2,1)
plot(r_vec_cm,abs(x_bl),'LineWidth',1.5);
grid on;
xlim([0 200]);
xlabel('Distance (cm)');
ylabel('Signal Amplitude')
legend('Baseline TX-RX');
subplot(2,2,2)
plot(r_vec_cm,abs(x_17),'LineWidth',1.5);
grid on;
xlim([0 200]);
xlabel('Distance (cm)');
ylabel('Signal Amplitude')
legend('Metal Surface at 17.5cm');
subplot(2,2,3)
plot(r_vec_cm,abs(x_66),'LineWidth',1.5);
grid on;
xlim([0 200]);
xlabel('Distance (cm)');
ylabel('Signal Amplitude')
legend('Metal Surface at 66cm');
subplot(2,2,4)
hold all;
plot(r_vec_cm,abs(x_bl),r_vec_cm,abs(x_17),r_vec_cm,abs(x_66),'LineWidth',1.5);
grid on;
xlim([0 200]);
xlabel('Distance (cm)');
ylabel('Signal Amplitude')
legend('Baseline TX-RX','Metal Surface at 17.5cm','Metal Surface at 66cm');
set(gcf,'Units','inches','Position',[3 3 width_fig height_fig]);

%% Find peak location in baseline data and calibrate range zero
[m ind] = max(abs(x_bl));

r_min = r_vec(2) - r_vec(1);
r_vec = r_vec - (ind-1)*r_min;
r_vec_cm = r_vec * 100;

%% Plot data after range calibration
display('Figure 2: signal amplitudes following range calibration')
figure
subplot(2,2,1)
plot(r_vec_cm,abs(x_bl),'LineWidth',1.5);
grid on;
xlim([0 200]);
xlabel('Distance (cm)');
ylabel('Signal Amplitude')
legend('Baseline TX-RX');
subplot(2,2,2)
plot(r_vec_cm,abs(x_17),'LineWidth',1.5);
grid on;
xlim([0 200]);
xlabel('Distance (cm)');
ylabel('Signal Amplitude')
legend('Metal Surface at 17.5cm');
subplot(2,2,3)
plot(r_vec_cm,abs(x_66),'LineWidth',1.5);
grid on;
xlim([0 200]);
xlabel('Distance (cm)');
ylabel('Signal Amplitude')
legend('Metal Surface at 66cm');
subplot(2,2,4)
hold all;
plot(r_vec_cm,abs(x_bl),r_vec_cm,abs(x_17),r_vec_cm,abs(x_66),'LineWidth',1.5);
grid on;
xlim([0 200]);
xlabel('Distance (cm)');
ylabel('Signal Amplitude')
legend('Baseline TX-RX','Metal Surface at 17.5cm','Metal Surface at 66cm');
set(gcf,'Units','inches','Position',[3 3 width_fig height_fig]);

%% Subtraction of baseline
% We only want to subtract the TX-RX signal, not reflection from further
% ranges, so take only the first 18 bins (determined by visual inspection) and pad with zeros

baseline = [x_bl(1:18); zeros(N-18,1)];

% subtract TX-RX from both signals
x_17 = x_17 - baseline;
x_66 = x_66 - baseline;

%% Plot resulting data
display('Figure 3: signal amplitudes following range calibration and TX-RX baseline subtraction' )
figure
subplot(2,1,1)
plot(r_vec_cm,abs(x_17),'LineWidth',1.5);
grid on;
xlim([0 200]);
xlabel('Distance (cm)');
ylabel('Signal Amplitude')
legend('Metal Surface at 17.5cm');
subplot(2,1,2)
hold all;
plot(r_vec_cm,abs(x_66),'LineWidth',1.5);
grid on;
xlim([0 200]);
xlabel('Distance (cm)');
ylabel('Signal Amplitude')
legend('Metal Surface at 66cm');
set(gcf,'Units','inches','Position',[3 3 width_fig height_fig]);

