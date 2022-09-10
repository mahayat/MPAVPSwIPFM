function [ts, taxis_ts] = load_ts(root_location, files, file_number, sampling_rate)
%%
file_location = strcat(root_location, files{file_number},'.mat');
load(file_location, 'ts');
taxis_ts = (0:length(ts)-1)'/sampling_rate;
end