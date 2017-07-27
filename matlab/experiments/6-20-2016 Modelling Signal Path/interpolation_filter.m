% f = frequency values for R, for S_tx to interpolate
% R = the filter
function [S_rx, s_rx] = interpolation_filter(S_tx, S_tx_freq, R, R_freq)
    G = spline(R_freq, R, S_tx_freq);
    S_rx = G.*S_tx;
    title('Received Pulse Spectrum')
    xlabel('Frequency (GHz)')
    ylabel('Normalized Amplitude')

    % Obtain the time domain from the Spectrum
    s = S_rx ./ 2; 
    s = [s fliplr(s)];
    L = length(s);
    s = s * L;

    s_rx = ifft(s);
    s_rx = s_rx(2:end-1);
    clear s
