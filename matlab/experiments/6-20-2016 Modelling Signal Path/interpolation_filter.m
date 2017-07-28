% f = frequency values for R, for S_tx to interpolate
% R = the filter
function [S_rx, s_rx] = interpolation_filter(S_tx, S_tx_freq, R, R_freq)
    G = spline(R_freq, R, S_tx_freq);
    S_rx = G.*S_tx;
    if(S_tx_freq(1) < 0)
        S_rx(1:length(S_tx)/2) = 0;
        S_rx = S_rx * 2;
%         S_rx(1:length(S_tx)/2) = fliplr(S_rx(length(S_tx)/2+1:end));
    end
    
    title('Received Pulse Spectrum')
    xlabel('Frequency (GHz)')
    ylabel('Normalized Amplitude')
    
    % Obtain the time domain from the Spectrum
    s_rx = ifft(ifftshift(S_rx))*length(S_rx);
    clear s
