%% Creates a fourier transform
folder = '../data/frequency_sweeps/';
file = 'zero2';
sweeps(1) = load(strcat(folder, file, '-2.91ghz.mat'));
sweeps(2) = load(strcat(folder, file, '-4.365ghz.mat'));
sweeps(3) = load(strcat(folder, file, '-5.82ghz.mat'));
sweeps(4) = load(strcat(folder, file, '-7.275ghz.mat'));
sweeps(5) = load(strcat(folder, file, '-8.73ghz.mat'));
sweeps(6) = load(strcat(folder, file, '-10.185ghz.mat'));
sweeps(7) = load(strcat(folder, file, '-11.64ghz.mat'));
sweeps(8) = load(strcat(folder, file, '-13.095ghz.mat'));

hold on;
rf_data = sweeps(5).rf_data;

L = length(rf_data);
frameStart = -3.286840410510195e-06;
frameStop = 9.76722908020020;
Fs = 23.328e9;

binLength = (frameStop-frameStart)/(L-1);
rangeVec = ((0:L-1)*binLength + frameStart);
plot(rangeVec, real(rf_data).');
title('Downconverted Signal');
ylabel('Normalized amplitude');
xlabel('Range [m]');

%% Spectral Plot

figure;
hold on;
maxfreq = zeros(1,8);
for i=[3,4,5,6]
    hrfft = fft(sweeps(i).rf_data);
    hrfft = abs(hrfft/L);
    hrfft = hrfft(1:L/2+1);
    f = Fs*(0:(L/2))/L;
    plot(f,hrfft);
    [~, maxfreq(i)] = max(hrfft);
    maxfreq(i) = f(maxfreq(i));
end

hold off;
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%%
% Create a spectrum estimator to visualize the signal spectrum before
% up converting, after up converting, and after down converting.
window = hamming(floor(length(rf_data.')/10));
figure; pwelch(rf_data.',window,[],[],Fs,'centered')
title('Spectrum of baseband signal x')
hold on;

%% Downconvert signal
decfactor = 2;
dwnConv = dsp.DigitalDownConverter(...
  'SampleRate',23.328e9,...
  'DecimationFactor',decfactor,...
  'Bandwidth',1.5e9,...
  'PassbandRipple',0.05,...
  'StopbandAttenuation',60,...
  'StopbandFrequencySource', 'Property',...
  'StopbandFrequency',1.5e9,...
  'CenterFrequency',maxfreq(5));

xDown = dwnConv(rf_data.'); % down convert
window = hamming(floor(length(xDown)/10));
figure; pwelch(xDown,window,[],[],Fs,'centered')
title('Spectrum of down converted signal xDown')

%% Draw signal again
binLength = (frameStop-frameStart)/(L/decfactor-1);
rangeVec = ((0:L/decfactor-1)*binLength + frameStart);
ph = plot(rangeVec, abs(xDown).');
title('Downconverted Signal');
ylabel('Normalized amplitude');
xlabel('Range [m]');
