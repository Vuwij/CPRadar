% obtain_data(267, 'rf', 3)
function [bb_data] = cosine_filter(rf_data, Fc)

    if Fc==3
        Fc=7.29e9;
    end
    if Fc==4
        Fc=8.748e9;
    end
    
    N=length(rf_data);
    Fs=23.328e9;
    
    %Obtain time domain t axis
    t = (1/Fs)*(1:N);
    
    c = cos(2*pi*Fc*t);
    rf_data2 = rf_data .* c;
    
    lpFilt = designfilt('lowpassiir', 'PassbandFrequency', 1.5e9, ...
                    'StopbandFrequency', 2.0e9, 'PassbandRipple', 0.5, ...
                    'StopbandAttenuation', 60, 'SampleRate', ...
                    Fs, 'DesignMethod', 'butter');
    
    bb_data = filtfilt(lpFilt, rf_data2);
    
end

