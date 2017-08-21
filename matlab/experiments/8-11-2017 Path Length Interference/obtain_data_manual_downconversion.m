function [data] = obtain_data_manual_downconversion(height, frequency)
    
    if frequency==3
        Fc=7.29e9;
    end
    if frequency==4
        Fc=8.748e9;
    end
    
    %Create a downconverter with a decimation factor of 2
    dwnConv = dsp.DigitalDownConverter(...
      'SampleRate',23.328e9,...
      'DecimationFactor',2,...
      'Bandwidth',1.5e9,...
      'PassbandRipple',0.05,...
      'StopbandAttenuation',60,...
      'StopbandFrequencySource', 'Property',...
      'StopbandFrequency',1.5e9,...
      'CenterFrequency',Fc);

    table_name = strcat('rf','0_1400f',int2str(frequency));
    file_name = strcat('metal_plate_45mm/',int2str(height),'mm_1');
    S = load(file_name);
    data = S.(table_name);
    
    %Downconvert the rf data
    data=dwnConv(data');
end

