function [baseline] = obtain_baseline_manual_downconversion(frequency)
    
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
    file_name = strcat('baseline2/baseline_zero.mat');
    S = load(file_name);
    baseline = S.(table_name);
    
    %Downconvert the rf data
    baseline=dwnConv(baseline');
end

