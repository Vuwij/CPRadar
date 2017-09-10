function [baseline] = obtain_data(mode,frequency)
    table_name = strcat(mode,'0_1400f',int2str(frequency));
    file_name = strcat('point_target/xcm.mat');
    S = load(file_name);
    baseline = S.(table_name);
end

