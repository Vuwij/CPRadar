%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jason Wang
% Script using SNR difference instead of subtracting baseline to detect
% presence of targets at known ranges
% Includes preliminary calibration of range axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear variables
close all

%% Signal to Noise over distance
% Compares the signal to noise for different DAC parameters for a single object

% Settings

folder = 'chicken5x4x1cm';
dataType = 'bb';
dacMIN = 949;
dacMAX = 1100;
freq = 4;
variableName = strcat(dataType, num2str(dacMIN), '_', num2str(dacMAX), 'f', num2str(freq));

% Put the data in a struct
for i = -10:0
    fileName = strcat(folder, '/', num2str(i), 'cm.mat');
    objdata(i + 11) = load(fileName, variableName);
end

% Show the mean and average of the baseline
baseline = load(strcat(folder, '/', 'baseline.mat'), variableName);
% baseline = load(strcat('zero/baseline.mat'), variableName);
baseline = baseline.(variableName);
[width, length] = size(baseline);

baseline_mean = mean(baseline);
baseline_var = var(baseline);

% Plot the original graphs
for i = 1:11
   p = objdata(i).(variableName);
   plot(abs(mean(p) - mean(baseline)));
   hold on;
end
legend('show')

%% Signal Noise Example

% Plot the SNR for a single point
plot_SNR(objdata(1).(variableName), baseline, 1);

%% Subtract the mean of the baseline
obj_mean = zeros(11, length);
obj_var = zeros(11, length );
for i = 1:11
    [obj_mean(i, :), obj_var(i, :)] = get_rician_param(objdata(i).(variableName), baseline);
    snr = abs(obj_mean(i, :))./obj_var(i, :);
    plot(snr);
    hold on;
end

%% Functions

% Calculate Rician Parameters
function [s, variance] = get_rician_param(signal, baseline)
    subsignal = signal - mean(baseline);
    [l, w] = size(subsignal);
    s = zeros(1, w);
    variance = zeros(1, w);
    warning off;
    for i = 1:w
        try % There was a problem with the Rician
            dist = fitdist(abs(subsignal(:, i)), 'Rician');
        catch
            % s(i) = mean(abs(subsignal(:, i)));
            % variance(i) = var(abs(subsignal(:, i)));
            continue;
        end
        s(i) = dist.s;
        variance(i) = dist.sigma;
    end
    warning on;
end

% Find the log-likelyhood ratio of random a point on the signal
function [llr] = log_LRT(baseline_var, s, var)
    % Draw it for a good look
    
    
end

function plot_SNR(signal, baseline, point)
    baseline_mean = mean(baseline(:, point));
    baseline_var = var(baseline(:, point));
    [s, sigma] = get_rician_param(signal(:, point), baseline(point));
    
    x = 0:sigma:s;
    basepdf = pdf('Rayleigh', x, sqrt(baseline_var));
    newpdf = pdf('Rician', x, s, sigma);
    plot(x, basepdf);
    hold on;
    plot(x, newpdf);
    hold off;
end
