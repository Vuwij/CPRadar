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
dacMIN = 0;
dacMAX = 1400;
freq = 3;
variableName = strcat(dataType, num2str(dacMIN), '_', num2str(dacMAX), 'f', num2str(freq));
x = linspace(0.0, 9.9, 186);

% Put the data in a struct
for i = -10:0
    fileName = strcat(folder, '/', num2str(i), 'cm.mat');
    objdata(i + 11) = load(fileName, variableName);
end

% Show the mean and average of the baseline
baseline = load(strcat(folder, '/', '-10cm.mat'), variableName);
% baseline = load(strcat('zero/baseline.mat'), variableName);
baseline = baseline.(variableName);
[width, length] = size(baseline);

baseline_mean = mean(baseline);
baseline_var = var(baseline);

%% Plot the original graphs
figure(1);
for i = 1:11
   p = objdata(i).(variableName);
   plot(x, abs(mean(p)));
   hold on;
end
legend('show')
hold off;

%% Height of peak vs depth of chicken

for d = 5:10
    figure(2);
    depthc = -10:1:0;
    heightc = -10:1:0;
    for i = 1:11
        p = objdata(i).(variableName);
        heightc(i) = abs(mean(p(:, d)));
    end
    plot(depthc, heightc);
    hold on;
end
xlabel('Depth of chicken (cm)');
ylabel('Amplitude');
xstr = string(x);
legend(xstr(5), xstr(6), xstr(7), xstr(8), xstr(9), xstr(10));


%% Subtract the one with another
figure(3);
p1 = objdata(1).(variableName);
p2 = objdata(2).(variableName);
p3 = objdata(3).(variableName);
p4 = objdata(4).(variableName);
p5 = objdata(5).(variableName);
p6 = objdata(6).(variableName);
p7 = objdata(7).(variableName);
p8 = objdata(8).(variableName);
p9 = objdata(9).(variableName);
p10 = objdata(10).(variableName);
plot(x, abs(mean(p1)) - abs(baseline(5, :)), 'Marker', 'o');
hold on;
plot(x, abs(mean(p2)) - abs(baseline(5, :)));
plot(x, abs(mean(p3)) - abs(baseline(5, :)));
plot(x, abs(mean(p4)) - abs(baseline(5, :)));
plot(x, abs(mean(p5)) - abs(baseline(5, :)));
plot(x, abs(mean(p6)) - abs(baseline(5, :)));
plot(x, abs(mean(p7)) - abs(baseline(5, :)));
plot(x, abs(mean(p8)) - abs(baseline(5, :)));
plot(x, abs(mean(p9)) - abs(baseline(5, :)));
plot(x, abs(mean(p10)) - abs(baseline(5, :)));
legend('-10cm','-9cm','-8cm','-7cm','-6cm','-5cm','-4cm','-3cm','-2cm','-1cm');
xlim([0.2, 0.8]);

% Draw the change in cm with a single point
figure(3);

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
