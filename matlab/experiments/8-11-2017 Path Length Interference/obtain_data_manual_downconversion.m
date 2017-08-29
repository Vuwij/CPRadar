function [data] = obtain_data_manual_downconversion(height, frequency)
    
    table_name = strcat('rf','0_1400f',int2str(frequency));
    file_name = strcat('metal_plate_45mm/',int2str(height), 'mm_1');
    S = load(file_name);
    data = S.(table_name);
    
    %Downconvert the rf data
    data=hilbert_downconvert(data, frequency);
end
