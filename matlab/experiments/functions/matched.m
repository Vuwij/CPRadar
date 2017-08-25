function [s_rx_m] = matched(input_signal, s_tx, Fc)
    %test_signal = [zeros(1, 100), s_tx, zeros(1, 100)];
    %test_signal_n = awgn(test_signal, 5);
    
    [acor,lag] = xcorr(s_tx,input_signal);
    [~, minpoint] = min(abs(lag));
    lag = -fliplr(lag(1:minpoint));
    acor = fliplr(acor(1:minpoint));
    
    acor = [zeros(1,int32(length(s_tx)/2+2)), acor];
    acor = acor(1:end-int32(length(s_tx)/2+2));
    s_rx_m = downconvert(acor, 3);
    
%     plot(abs(s_rx_m));
%     hold on;
%     plot(acor);
%     plot(s_tx);
%     plot(input_signal);
    
end