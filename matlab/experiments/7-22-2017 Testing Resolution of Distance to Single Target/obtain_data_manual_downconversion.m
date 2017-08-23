function [data] = obtain_data_manual_downconversion(height, frequency)
    
    table_name = strcat('rf','0_1400f',int2str(frequency));
    file_name = strcat('metal_plate_45mm_2/',int2str(height),'mm');
    S = load(file_name);
    data = S.(table_name);
    
    %Downconvert the rf data
    data=downconvert(data, frequency);
end

