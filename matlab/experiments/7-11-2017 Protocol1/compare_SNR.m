%% Signal to Noise Comparator
% Compares the signal to noise for different DAC parameters for a single object

% Settings
clear
folder = 'screw-3mm-1.5cm';
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
% baseline = load(strcat(folder, '/', 'baseline.mat'), variableName);
baseline = load(strcat('zero/baseline.mat'), variableName);
baseline = baseline.(variableName);
[width, length] = size(baseline);

baseline_mean = mean(baseline);
baseline_var = var(baseline);

plot_SNR(objdata(1).(variableName), baseline, 1);

% Subtract the mean of the baseline
obj_mean = zeros(11, length);
obj_var = zeros(11, length );
for i = 1:11
    [obj_mean(i, :), obj_var(i, :)] = get_rician_param(objdata(i).(variableName), baseline);
    snr = abs(obj_mean(i, :))./obj_var(i, :);
    semilogy(snr);
    hold on;
%     for j = 1:length 
%         llr = log_LRT(baseline_var(i), obj_mean(i), obj_var(i))
%     end
end



%% Functions

% Calculate Rician Parameters
function [s, var] = get_rician_param(signal, baseline)
    subsignal = signal - mean(baseline);
    [l, w] = size(subsignal);
    s = zeros(1, w);
    var = zeros(1, w);
    warning off;
    for i = 1:w
        dist = fitdist(abs(subsignal(:, i)), 'Rician');
        s(i) = dist.s;
        var(i) = dist.sigma;
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
    
    x = 0:sigma/10:sigma*30;
    basepdf = pdf('Rayleigh', x, sqrt(baseline_var));
    newpdf = pdf('Rician', x, s, sigma);
    plot(x, basepdf);
    hold on;
    plot(x, newpdf);
    hold off;
end