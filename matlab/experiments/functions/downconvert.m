function [bb_data] = downconvert(rf_data, Fc)

    if Fc==3
        Fc=7.29e9;
    end
    if Fc==4
        Fc=8.748e9;
    end

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
    
%     figure
%     plot(t,rf_data);
%     hold on;
    bb_data = dwnConv(rf_data');
    bb_data = bb_data';
    
end