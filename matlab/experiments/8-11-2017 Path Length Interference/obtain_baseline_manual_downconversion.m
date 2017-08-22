function [baseline] = obtain_baseline_manual_downconversion(frequency) 

    table_name = strcat('rf','0_1400f',int2str(frequency));
    file_name = strcat('baseline2/baseline_zero.mat');
    S = load(file_name);
    baseline = S.(table_name);
    
    %Downconvert the rf data
    baseline=downconvert(baseline, frequency);
end

