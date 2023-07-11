clear; close all; clc;
%%
manual_offset = 0;
sampling_rate = 50;
ts_len_in_sec = 15*60;
truncation_starts_in_sec = [...
    14000  2000 16000 ...
    12000 16000 14000 ...
    10000  8000 14000 ...
    10000 16000 2000 16000];
root_location = '/Users/mahayat/Library/CloudStorage/OneDrive-UniversityofArkansas/backup-mahayat-mac/charis_data/';
samples_to_extract = ts_len_in_sec*sampling_rate;
%%
min_dist = 0.45; % in sec
ulim = 15;
llim = 0.5;
mov_avg_len = 30; % in sec
do_plot = true;
is_man_onset_detec = false;
%%
all_rho = [];
font_size = 14;
do_plot = false;
for sub_num = 10%:length(truncation_starts_in_sec)
    
    file_name = strcat('charis', num2str(sub_num),'m.mat');
    file_location = strcat(root_location, file_name);
    load(file_location);
    
    start_index = truncation_starts_in_sec(sub_num)*sampling_rate;
    end_index = start_index-1+samples_to_extract;
    ts = val(1,start_index:end_index);
    
    [y_hat, y, taxis, all_pulses, pt_tilda, rho, T] = get_model_CHARIS(...
        ts', manual_offset, sampling_rate, min_dist, ...
        ulim, llim, mov_avg_len, do_plot, is_man_onset_detec);
    
    if do_plot
        figure(sub_num);
        plot(taxis, y/100, 'b', 'LineWidth', 1.5); hold on;
        plot(taxis, y_hat/100, 'r--', 'LineWidth', 1.5); grid on;
        xlim(340+[0 20]);
        legend('$y(t)$', '$\hat{y}(t)$', 'Interpreter', 'latex','FontSize', font_size);
        xlabel('Time (s)', 'Interpreter', 'latex');
        ylabel('Amplitude (mmHg)', 'Interpreter', 'latex');
        set(gca,'TickLabelInterpreter','latex','FontSize', font_size);
    end
    
    all_rho = [all_rho, rho];
end
round(all_rho', 3)
%%