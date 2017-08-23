function [bb_data] = downconvert2(rf_data,Fc)
%Downconversion without decimation using the method that the prof suggested
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
    
    %Frequency axis
    f = Fs*(0:N-1)/N; 
    
    rf_data=rf_data.*cos(2*pi*Fc*t);
    
    rf_data_fft=abs(fft(rf_data));
   
    
    figure;
    rf_data_fft=[rf_data_fft(1:254) zeros(1,length(rf_data_fft)-254)];
    plot(rf_data_fft);
    

    
    %Convert to digital domain by dividing frequency axis by the sampling
    %rate

    
    bb_data=ifft(rf_data_fft);

    plot(abs(bb_data));

end

