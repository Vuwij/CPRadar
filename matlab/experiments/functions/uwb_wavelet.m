function [s_tx, S_tx, t, f] = uwb_wavelet(Fs, Bw, Fc)

    % Using the Xethru Ultra Wideband Pulse
    tc = gauspuls('cutoff',Fc,Bw/Fc,[],-60); 
    t = -tc : 1/Fs : tc; 
    s_tx = gauspuls(t,Fc,Bw/Fc); 
    
%     figure;
%     plot(t,s_tx)
%     title('Time plot of Gaussian Pulse')
%     xlabel('Time')
%     ylabel('Normalized Amplitude')

    n = length(t);
    f = Fs*(-n/2:n/2-1)/n;
    S_tx = fftshift(fft(s_tx))/n;
    
%     stem(f, abs(S_tx));
%     title('UWB Gaussian Pulse (Waveform)')
%     xlabel('Time (s)')
%     ylabel('Normalized Amplitude')