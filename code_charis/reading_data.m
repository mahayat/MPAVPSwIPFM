clear; close all; clc;
%% Data Collected From: https://archive.physionet.org/cgi-bin/atm/ATM
%%
sampling_rate = 50;
ts_len_in_sec = 15*60;
samples_to_extract = ts_len_in_sec*sampling_rate;
truncation_starts_in_sec = [...
    14000  2000 16000 ...
    12000 16000 14000 ...
    10000  8000 14000 ...
    10000 16000 2000 16000];
print_full_ts = true;
%% Save Images of Time Series
for sub_num = 1:13
    data_folder = '/Users/mahayat/Desktop/charis_data/';
    file_name = strcat('charis', num2str(sub_num),'m.mat');
    file_location = strcat(data_folder, file_name);
    load(file_location);
    %%
    L = size(val,2);
    temp_taxis = (0:(L-1))/sampling_rate;
    figure(sub_num);
    for i = 1:size(val,1)
        %% For Printing Full Time Series
        if print_full_ts
            ts = val(i,:);
            taxis = temp_taxis;
        else
            %% For Printing Truncated Time Series
            start_index = truncation_starts_in_sec(sub_num)*sampling_rate;
            end_index = start_index-1+samples_to_extract;
            ts = val(i,start_index:end_index);
            taxis = temp_taxis(start_index:end_index);
        end
        %%
        subplot(3,1,i);
        plot(taxis, ts, 'LineWidth', 1.5);
        grid on;
        
        if (i == 1)
            ylabel('ABP (mmHg)', 'Interpreter', 'latex');
        elseif (i == 2)
            ylabel('ECG (mV)', 'Interpreter', 'latex');
        else
            ylabel('ICP (mmHg)', 'Interpreter', 'latex');
        end
        set(gca,'TickLabelInterpreter','latex');
    end
    xlabel('Time (s)', 'Interpreter', 'latex');
%     saveas(gcf, strcat('charis', num2str(sub_num), '.png'))
end
%%