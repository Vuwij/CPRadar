function [bb_data] = downconvert(rf_data, Fc)

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
    
    %First obtain the frequency spectrum of the time domain rf data
    rf_data_fft=abs(fft(rf_data));
    rf_data_fft = rf_data_fft(1:N/2); %Discard Half of Points
    f = Fs*(0:N/2-1)/N; %Prepare freq data for plot
    
    %Obtaining the baseband signal
    hilbertTransform=imag(hilbert(rf_data));
    basebandImag = (hilbertTransform.* cos(2 * pi *Fc*t))-(rf_data.*sin(2 * pi *Fc * t));
    basebandReal = (rf_data.* cos(2 * pi * Fc * t)) + (hilbertTransform.* sin(2 * pi * Fc * t));
    bb_data=basebandReal+1i*basebandImag;
    
    figure
    plot(t,rf_data);
    hold on;
    plot(t,abs(bb_data));

    decfactor = 2;
    dwnConv = dsp.DigitalDownConverter(...
    'SampleRate',23.328e9,...
    'DecimationFactor',decfactor,...
    'Bandwidth',1.5e9,...
    'PassbandRipple',0.05,...
    'StopbandAttenuation',60,...
    'StopbandFrequencySource', 'Property',...
    'StopbandFrequency',1.5e9,...
    'CenterFrequency',Fc);
    
    figure
    plot(t,rf_data);
    hold on;
    t=(1/11.664e9)*(1:N/2);
    bb=dwnConv(rf_data');
    plot(t,abs(bb'));
   


end

