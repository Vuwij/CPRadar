function [data] = obtain_data(height,mode,frequency)

    table_name = strcat(mode,'0_1400f',int2str(frequency));
    file_name = strcat('metal_plate_45mm_2/',int2str(height),'mm_1');
    S = load(file_name);
    data = S.(table_name);

end

