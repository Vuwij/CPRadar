% obtain_data(267, 'rf', 3)
function [bb_data] = hilbert_downconvert(rf_data, Fc)

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
    
    %Obtaining the baseband signal
    hilbertTransform = imag(hilbert(rf_data));
    basebandImag = (hilbertTransform.* cos(2 * pi *Fc*t))-(rf_data.*sin(2 * pi *Fc * t));
    basebandReal = (rf_data.* cos(2 * pi * Fc * t)) + (hilbertTransform.* sin(2 * pi * Fc * t));
    bb_data=basebandReal+1i*basebandImag;
    
%     t=(1/11.664e9)*(1:N/2);
%     plot(t,abs(bb_data'));
   
%     lpFilt = designfilt('lowpassiir', 'PassbandFrequency', 1.5e9, ...
%                     'StopbandFrequency', 2.0e9, 'PassbandRipple', 0.5, ...
%                     'StopbandAttenuation', 60, 'SampleRate', ...
%                     Fs, 'DesignMethod', 'butter');
%     
%     bb_data = filtfilt(lpFilt, bb_data);    

end

