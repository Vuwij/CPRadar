function [data] = obtain_mean_data(folder, height, frequency, dacmin, dacmax, mode)
    %Returns a vector of the data obtained from the experiment -> the MEAN
    %of the 5 fast time sequences

    %Folder can be "saline_only" or "chicken5x4x1cm" or "screw-2mm-0.8cm" or "screw-3mm-1.2cm" or "screw-3mm-1.5cm"
    %mode can be "bb" or "rf"
    %dacmin and dacmax must be entered as strings

    %If you want to obtain the zero data, folder needs to be "zero" and height
    %needs to be "baseline"

    %Load the data
    table_name = strcat(mode,dacmin,'_',dacmax,'f',frequency);
    S = load(strcat(folder,'/',height,'.mat'));
    data = S.(table_name);
    data = mean(data);
    data=data'; %return a column vector

end