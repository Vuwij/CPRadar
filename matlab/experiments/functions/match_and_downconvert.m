function [s_tx_m] = match_and_downconvert(input_signal, s_tx, center_freq)
    [acor,lag] = xcorr(s_tx,input_signal);
    % plot(input_signal);
    % hold on;
    % plot(s_tx);
    [~,I] = max(abs(acor));
    lagDiff = lag(I);

    % figure
    % plot(lag,fliplr(acor))
    a3 = gca;
    a3.XTick = sort([-3000:1000:3000 -lagDiff]);

    % Downconvert to baseband now
    decfactor = 2;
    dwnConv = dsp.DigitalDownConverter(...
      'SampleRate',23.328e9,...
      'DecimationFactor',decfactor,...
      'Bandwidth',1.5e9,...
      'PassbandRipple',0.05,...
      'StopbandAttenuation',60,...
      'StopbandFrequencySource', 'Property',...
      'StopbandFrequency',1.5e9,...
      'CenterFrequency',center_freq);
 
    acor = acor(1:3038);
    xDown = dwnConv(acor'); % down convert
    s_tx_m = xDown.';
end