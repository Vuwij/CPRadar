function [data] = obtain_data(folder, height, frequency, dacmin, dacmax, mode, fts)
%Returns a vector of the data obtained from the experiment

%Load the data
table_name = strcat(mode,dacmin,'_',dacmax,'f',frequency);
S = load(strcat(folder,'/',height,'.mat'));
data = S.(table_name);
data = data(fts,:);
data=data';

end

