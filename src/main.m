clear; close all; clc;
% All Signals are Column Vectors
%% Parameters
sampling_rate = 1000;

ulim = 15;
llim = 0.5;

pigs = {'Pig-1', 'Pig-2', 'Pig-3', 'Pig-4'};
states = {'MAC-1','MAC-2','MAC-3','PRO-1','PRO-2','PRO-3'};

num_pigs = length(pigs);
num_states = length(states);

mov_avg_len = 30;
root_location = "/Users/mahayat/Desktop/lv_data/";
%% LR Params
ratio = 0.3; % TestingData/TotalData
win_len = 10;
win_flim = 10;
%% Files of ART Signals
% files = {
%     'LVS_P1_BB_MAC1_ART', 'LVS_P1_BB_MAC2_ART', 'LVS_P1_BB_MAC3_ART', 'LVS_P1_BB_PRO1_ART', 'LVS_P1_BB_PRO2_ART', 'LVS_P1_BB_PRO3_ART', ...
%     'LVS_P2_BB_MAC1_ART', 'LVS_P2_BB_MAC2_ART', 'LVS_P2_BB_MAC3_ART', 'LVS_P2_BB_PRO1_ART', 'LVS_P2_BB_PRO2_ART', 'LVS_P2_BB_PRO3_ART', ...
%     'LVS_P3_BB_MAC1_ART', 'LVS_P3_BB_MAC2_ART', 'LVS_P3_BB_MAC3_ART', 'LVS_P3_BB_PRO1_ART', 'LVS_P3_BB_PRO2_ART', 'LVS_P3_BB_PRO3_ART', ...
%     'LVS_P4_BB_MAC1_ART', 'LVS_P4_BB_MAC2_ART', 'LVS_P4_BB_MAC3_ART', 'LVS_P4_BB_PRO1_ART', 'LVS_P4_BB_PRO2_ART', 'LVS_P4_BB_PRO3_ART'};
% manual_offset = 0; is_man_onset_detec = true;
%% Files of VEN Signals
files = {
    'LVS_P1_BB_MAC1_VEN', 'LVS_P1_BB_MAC2_VEN', 'LVS_P1_BB_MAC3_VEN', 'LVS_P1_BB_PRO1_VEN', 'LVS_P1_BB_PRO2_VEN', 'LVS_P1_BB_PRO3_VEN', ...
    'LVS_P2_BB_MAC1_VEN', 'LVS_P2_BB_MAC2_VEN', 'LVS_P2_BB_MAC3_VEN', 'LVS_P2_BB_PRO1_VEN', 'LVS_P2_BB_PRO2_VEN', 'LVS_P2_BB_PRO3_VEN', ...
    'LVS_P3_BB_MAC1_VEN', 'LVS_P3_BB_MAC2_VEN', 'LVS_P3_BB_MAC3_VEN', 'LVS_P3_BB_PRO1_VEN', 'LVS_P3_BB_PRO2_VEN', 'LVS_P3_BB_PRO3_VEN', ...
    'LVS_P4_BB_MAC1_VEN', 'LVS_P4_BB_MAC2_VEN', 'LVS_P4_BB_MAC3_VEN', 'LVS_P4_BB_PRO1_VEN', 'LVS_P4_BB_PRO2_VEN', 'LVS_P4_BB_PRO3_VEN'};
manual_offset = 1; is_man_onset_detec = false;
%% Min Dist for Peak Detection **(Important Parameter)**
min_dist = [...
    0.55,   0.65,   0.55,   0.55,   0.55,   0.65, ...
    0.65,   0.65,   0.65,   0.65,   0.60,   0.60, ...
    0.65,   0.65,   0.65,   0.65,   0.60,   0.60, ...
    0.55,   0.55,   0.60,   0.50,   0.50,   0.55];
% Explanation: 1./[0.5 0.55 0.6 0.65] = [2.00 1.82 1.67 1.54] 
%% Valid for ART-VEN-FA Signals
discard_before_this_time = {
    0,      400,    0,      0,      200,    0, ...
    200,    820,    0,      0,      0,      420, ...
    0,      0,      0,      0,      0,      0, ...
    0,      0,      0,      0,      0,      0};

discard_after_this_time = {
    NaN,    NaN,    145,    NaN,    NaN,    NaN, ...
    NaN,    NaN,    NaN,    NaN,    750,    NaN, ...
    NaN,    NaN,    NaN,    NaN,    NaN,    NaN, ...
    NaN,    NaN,    600,    NaN,    NaN,    NaN};
%% Signal DC Value Inspection
% mean_of_signal_to_model = [];
% for file_number = 1:(num_pigs*num_states)
%     [ts, taxis_ts] = load_ts(root_location, files, file_number, sampling_rate);
%     [ts_trunc, taxis_temp] = load_ts_trunc(ts, taxis_ts, file_number,...
%         sampling_rate, discard_before_this_time, discard_after_this_time);
%     y_temp = lowpass(ts_trunc, ulim, sampling_rate);
%     
%     mean_of_signal_to_model = [mean_of_signal_to_model, mean(y_temp)];
% end
% round(mean_of_signal_to_model', 2)
%% Plot a Single Subject
% % (Paper Fig. 2-6, 8)
% tic;
% all_R2 = [];
% for file_number = 8 %1:(num_pigs*num_states) % file_number = 8 -> Pig-2 MAC-2
%     do_plot = true; % <- change when needed
% 
%     [y_hat, y, y_test, taxis, all_pulses, pt_tilda, R2, T] = get_model(...
%         root_location, files, file_number, manual_offset, sampling_rate, ...
%         min_dist, discard_before_this_time, discard_after_this_time, ...
%         ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
%     all_R2 = [all_R2, R2];
% end
% round(all_R2',3)
% toc;
%% Other Plots: 1 (LaTeX),  7 (Google Draw), 9 (CHARIS)
%% Plot All Pulses with Mean Pulse
% % (Paper Fig 10: ART Pulses)
% % (Paper Fig 11: VEN Pulses)
% tic;
% do_plot = false;
% font_size = 14;
% figure();
% for file_number = 1:(num_pigs*num_states)
% 
%     [y, y_hat, y_test, taxis, all_pulses, pt_tilda, R2, T] = get_model(...
%         root_location, files, file_number, manual_offset, sampling_rate, ...
%         min_dist, discard_before_this_time, discard_after_this_time, ...
%         ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% 
%     subplot(num_pigs, num_states, file_number);
% 
%     for i = 1:size(all_pulses,1)
%         sample_pulse = all_pulses(i,:);
%         taxis_sample_pulse = (0:length(sample_pulse)-1)/sampling_rate;
% 
%         plot(taxis_sample_pulse, sample_pulse, ...
%             'Color', [.7 .7 .7], 'LineWidth', 1.5);
%         hold on;
%     end
% 
%     taxis_pt_tilda = (0:length(pt_tilda)-1)/sampling_rate;
%     plot(taxis_pt_tilda, pt_tilda, 'r', 'LineWidth', 1.5);
%     grid on;
% 
%     xlim([0 1]); ylim([-1 2]);
% 
%     if file_number > (num_pigs-1)*num_states
%         xlabel('Time (s)', 'Interpreter', 'latex');
%     end
% 
%     if file_number <= num_states
%         title(states{file_number}, 'Interpreter', 'latex');
%     end
% 
%     if mod(file_number,num_states)==1
%         row_num = ceil(file_number/num_states);
%         ylabel(pigs{row_num}, 'Interpreter', 'latex');
%     end
% 
%     set(gca,'TickLabelInterpreter','latex','FontSize', font_size);
% end
% toc;
%% Plot Mean Duration (these values are used in 'plot_HR.m')
% % (Paper Fig 12)
% tic;
% all_T = [];
% do_plot = false;
% for file_number = 1:(num_pigs*num_states)
%     [y, y_hat, y_test, taxis, all_pulses, pt_tilda, R2, T] = get_model(...
%         root_location, files, file_number, manual_offset, sampling_rate, ...
%         min_dist, discard_before_this_time, discard_after_this_time, ...
%         ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
%     all_T = [all_T, T];
% end
% all_T
% toc;
%% Using \theta(t) and m(t): (Rho values are used in 'plot_mt_rt_corr.m')
% % (Paper Fig 13)
% do_plot = false;
% all_rho = [];
%
% art_sig = false;
% ven_sig = ~art_sig;
%
% for file_number = 1:(num_pigs*num_states)
%     [y_hat, y, y_test, taxis, rt, loc, T] = get_model(...
%         root_location, files, file_number, manual_offset, sampling_rate, ...
%         min_dist, discard_before_this_time, discard_after_this_time, ...
%         ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
%     %%
%     K = (0:(length(loc)-1))';
%     tk = (loc-1)/sampling_rate;
%     theta_tk = K*(T/sampling_rate)-tk;
%     theta = spline(tk, theta_tk, taxis);
%     mt = [theta(1); diff(theta)];
%     %%
% %     disp('Sanity Check')
% %     disp(mean(mt))
% %     title_string = 'File No: ';
%     %%
%     rho = get_rho(rt, mt);
%     all_rho = [all_rho, rho];
%     %% Plot: m(t) and r(t)
% %     figure(2*file_number-1);
% %     subplot(311);
% %     plot(tk, theta_tk, 'bx', 'LineWidth', 1.5); hold on;
% %     plot(taxis, theta, 'r', 'LineWidth', 1.5); grid on;
% %     legend('$\theta(t_k)$', '$\theta(t)$', 'Interpreter', 'latex');
% %     xlim(100+[0 50]);
% %     title(strcat(title_string, num2str(file_number)));
% %
% %     subplot(312);
% %     plot(taxis, mt, 'b', 'LineWidth', 1.5); grid on;
% %     legend('$m(t)$', 'Interpreter', 'latex');
% %     xlim(100+[0 50]);
% %
% %     if ven_sig
% %         ylim(5e-4*[-1 1]);
% %     else
% %         ylim(5e-5*[-1 1]);
% %     end
% %     ylabel('Amplitude (mmHg)', 'Interpreter', 'latex');
% %
% %     subplot(313);
% %     plot(taxis, rt, 'r', 'LineWidth', 1.5); grid on;
% %     legend('$r(t)$', 'Interpreter', 'latex');
% %     xlim(100+[0 50]);
% %
% %     if ven_sig
% %         ylim(5e-4*[-1 1]);
% %     else
% %         ylim(5e-2*[-1 1]);
% %     end
% %     ylabel('Amplitude (mmHg)', 'Interpreter', 'latex');
% %     xlabel('Time (s)', 'Interpreter', 'latex');
% % %     saveas(gcf, strcat('file_', num2str(file_number), '_tdom', '.png'));
%     %% Plot: M(omega) and R(omega)
% %     [Mw, ~, Mw_faxis] = getFFT(mt, sampling_rate);
% %     [Rw, ~, Rw_faxis] = getFFT(rt, sampling_rate);
% %     %%%
% %     figure(2*file_number);
% %     subplot(211);
% %     plot(Mw_faxis, Mw, 'b', 'LineWidth', 1.5); grid on;
% %     legend('$M(\omega)$', 'Interpreter', 'latex');
% %     set(gca,'TickLabelInterpreter','latex');
% %     xlim([0 1.5]);
% %     if ven_sig
% %         ylim([0 1e-4]);
% %     else
% %         ylim([0 2.5e-5]);
% %     end
% %     ylabel('Amplitude (mmHg)', 'Interpreter', 'latex');
% %     title(strcat(title_string, num2str(file_number)));
% %
% %     subplot(212);
% %     plot(Rw_faxis, Rw, 'r', 'LineWidth', 1.5); grid on;
% %     legend('$R(\omega)$', 'Interpreter', 'latex');
% %     set(gca,'TickLabelInterpreter','latex');
% %     xlim([0 1.5]);
% %     if ven_sig
% %         ylim([0 1e-4]);
% %     else
% %         ylim([0 2.5e-3]);
% %     end
% %     ylabel('Amplitude (mmHg)', 'Interpreter', 'latex');
% %     xlabel('Frequency (Hz)', 'Interpreter', 'latex');
% % %     saveas(gcf, strcat('file_', num2str(file_number), '_fft', '.png'));
% end
%% LR : Change Output of 'get_model'
% tic; do_plot = false;
% % P1
% [ts_P1_MAC1, ~, ts_P1_MAC1_test, ~, ~, ~, ~, ~] = get_model(root_location, files,  1, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P1_MAC2, ~, ts_P1_MAC2_test, ~, ~, ~, ~, ~] = get_model(root_location, files,  2, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P1_MAC3, ~, ts_P1_MAC3_test, ~, ~, ~, ~, ~] = get_model(root_location, files,  3, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P1_PRO1, ~, ts_P1_PRO1_test, ~, ~, ~, ~, ~] = get_model(root_location, files,  4, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P1_PRO2, ~, ts_P1_PRO2_test, ~, ~, ~, ~, ~] = get_model(root_location, files,  5, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P1_PRO3, ~, ts_P1_PRO3_test, ~, ~, ~, ~, ~] = get_model(root_location, files,  6, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% % P2
% [ts_P2_MAC1, ~, ts_P2_MAC1_test, ~, ~, ~, ~, ~] = get_model(root_location, files,  7, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P2_MAC2, ~, ts_P2_MAC2_test, ~, ~, ~, ~, ~] = get_model(root_location, files,  8, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P2_MAC3, ~, ts_P2_MAC3_test, ~, ~, ~, ~, ~] = get_model(root_location, files,  9, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P2_PRO1, ~, ts_P2_PRO1_test, ~, ~, ~, ~, ~] = get_model(root_location, files, 10, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P2_PRO2, ~, ts_P2_PRO2_test, ~, ~, ~, ~, ~] = get_model(root_location, files, 11, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P2_PRO3, ~, ts_P2_PRO3_test, ~, ~, ~, ~, ~] = get_model(root_location, files, 12, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% % P3
% [ts_P3_MAC1, ~, ts_P3_MAC1_test, ~, ~, ~, ~, ~] = get_model(root_location, files, 13, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P3_MAC2, ~, ts_P3_MAC2_test, ~, ~, ~, ~, ~] = get_model(root_location, files, 14, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P3_MAC3, ~, ts_P3_MAC3_test, ~, ~, ~, ~, ~] = get_model(root_location, files, 15, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P3_PRO1, ~, ts_P3_PRO1_test, ~, ~, ~, ~, ~] = get_model(root_location, files, 16, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P3_PRO2, ~, ts_P3_PRO2_test, ~, ~, ~, ~, ~] = get_model(root_location, files, 17, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P3_PRO3, ~, ts_P3_PRO3_test, ~, ~, ~, ~, ~] = get_model(root_location, files, 18, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% % P4
% [ts_P4_MAC1, ~, ts_P4_MAC1_test, ~, ~, ~, ~, ~] = get_model(root_location, files, 19, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P4_MAC2, ~, ts_P4_MAC2_test, ~, ~, ~, ~, ~] = get_model(root_location, files, 20, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P4_MAC3, ~, ts_P4_MAC3_test, ~, ~, ~, ~, ~] = get_model(root_location, files, 21, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P4_PRO1, ~, ts_P4_PRO1_test, ~, ~, ~, ~, ~] = get_model(root_location, files, 22, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P4_PRO2, ~, ts_P4_PRO2_test, ~, ~, ~, ~, ~] = get_model(root_location, files, 23, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% [ts_P4_PRO3, ~, ts_P4_PRO3_test, ~, ~, ~, ~, ~] = get_model(root_location, files, 24, manual_offset, sampling_rate, min_dist, discard_before_this_time, discard_after_this_time, ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
% %% Training Data
% win_count = 70;
% 
% P1_MAC1 = get_freq_win(ts_P1_MAC1, sampling_rate, win_len, win_flim, win_count);
% P1_MAC2 = get_freq_win(ts_P1_MAC2, sampling_rate, win_len, win_flim, win_count);
% P1_MAC3 = get_freq_win(ts_P1_MAC3, sampling_rate, win_len, win_flim, win_count);
% P1_PRO1 = get_freq_win(ts_P1_PRO1, sampling_rate, win_len, win_flim, win_count);
% P1_PRO2 = get_freq_win(ts_P1_PRO2, sampling_rate, win_len, win_flim, win_count);
% P1_PRO3 = get_freq_win(ts_P1_PRO3, sampling_rate, win_len, win_flim, win_count);
% 
% P2_MAC1 = get_freq_win(ts_P2_MAC1, sampling_rate, win_len, win_flim, win_count);
% P2_MAC2 = get_freq_win(ts_P2_MAC2, sampling_rate, win_len, win_flim, win_count);
% P2_MAC3 = get_freq_win(ts_P2_MAC3, sampling_rate, win_len, win_flim, win_count);
% P2_PRO1 = get_freq_win(ts_P2_PRO1, sampling_rate, win_len, win_flim, win_count);
% P2_PRO2 = get_freq_win(ts_P2_PRO2, sampling_rate, win_len, win_flim, win_count);
% P2_PRO3 = get_freq_win(ts_P2_PRO3, sampling_rate, win_len, win_flim, win_count);
% 
% P3_MAC1 = get_freq_win(ts_P3_MAC1, sampling_rate, win_len, win_flim, win_count);
% P3_MAC2 = get_freq_win(ts_P3_MAC2, sampling_rate, win_len, win_flim, win_count);
% P3_MAC3 = get_freq_win(ts_P3_MAC3, sampling_rate, win_len, win_flim, win_count);
% P3_PRO1 = get_freq_win(ts_P3_PRO1, sampling_rate, win_len, win_flim, win_count);
% P3_PRO2 = get_freq_win(ts_P3_PRO2, sampling_rate, win_len, win_flim, win_count);
% P3_PRO3 = get_freq_win(ts_P3_PRO3, sampling_rate, win_len, win_flim, win_count);
% 
% P4_MAC1 = get_freq_win(ts_P4_MAC1, sampling_rate, win_len, win_flim, win_count);
% P4_MAC2 = get_freq_win(ts_P4_MAC2, sampling_rate, win_len, win_flim, win_count);
% P4_MAC3 = get_freq_win(ts_P4_MAC3, sampling_rate, win_len, win_flim, win_count);
% P4_PRO1 = get_freq_win(ts_P4_PRO1, sampling_rate, win_len, win_flim, win_count);
% P4_PRO2 = get_freq_win(ts_P4_PRO2, sampling_rate, win_len, win_flim, win_count);
% P4_PRO3 = get_freq_win(ts_P4_PRO3, sampling_rate, win_len, win_flim, win_count);
% %% Test Data
% win_count = 30; % `win_count` windows per subject
% 
% P1_MAC1_test = get_freq_win(ts_P1_MAC1_test, sampling_rate, win_len, win_flim, win_count);
% P1_MAC2_test = get_freq_win(ts_P1_MAC2_test, sampling_rate, win_len, win_flim, win_count);
% P1_MAC3_test = get_freq_win(ts_P1_MAC3_test, sampling_rate, win_len, win_flim, win_count);
% P1_PRO1_test = get_freq_win(ts_P1_PRO1_test, sampling_rate, win_len, win_flim, win_count);
% P1_PRO2_test = get_freq_win(ts_P1_PRO2_test, sampling_rate, win_len, win_flim, win_count);
% P1_PRO3_test = get_freq_win(ts_P1_PRO3_test, sampling_rate, win_len, win_flim, win_count);
% 
% P2_MAC1_test = get_freq_win(ts_P2_MAC1_test, sampling_rate, win_len, win_flim, win_count);
% P2_MAC2_test = get_freq_win(ts_P2_MAC2_test, sampling_rate, win_len, win_flim, win_count);
% P2_MAC3_test = get_freq_win(ts_P2_MAC3_test, sampling_rate, win_len, win_flim, win_count);
% P2_PRO1_test = get_freq_win(ts_P2_PRO1_test, sampling_rate, win_len, win_flim, win_count);
% P2_PRO2_test = get_freq_win(ts_P2_PRO2_test, sampling_rate, win_len, win_flim, win_count);
% P2_PRO3_test = get_freq_win(ts_P2_PRO3_test, sampling_rate, win_len, win_flim, win_count);
% 
% P3_MAC1_test = get_freq_win(ts_P3_MAC1_test, sampling_rate, win_len, win_flim, win_count);
% P3_MAC2_test = get_freq_win(ts_P3_MAC2_test, sampling_rate, win_len, win_flim, win_count);
% P3_MAC3_test = get_freq_win(ts_P3_MAC3_test, sampling_rate, win_len, win_flim, win_count);
% P3_PRO1_test = get_freq_win(ts_P3_PRO1_test, sampling_rate, win_len, win_flim, win_count);
% P3_PRO2_test = get_freq_win(ts_P3_PRO2_test, sampling_rate, win_len, win_flim, win_count);
% P3_PRO3_test = get_freq_win(ts_P3_PRO3_test, sampling_rate, win_len, win_flim, win_count);
% 
% P4_MAC1_test = get_freq_win(ts_P4_MAC1_test, sampling_rate, win_len, win_flim, win_count);
% P4_MAC2_test = get_freq_win(ts_P4_MAC2_test, sampling_rate, win_len, win_flim, win_count);
% P4_MAC3_test = get_freq_win(ts_P4_MAC3_test, sampling_rate, win_len, win_flim, win_count);
% P4_PRO1_test = get_freq_win(ts_P4_PRO1_test, sampling_rate, win_len, win_flim, win_count);
% P4_PRO2_test = get_freq_win(ts_P4_PRO2_test, sampling_rate, win_len, win_flim, win_count);
% P4_PRO3_test = get_freq_win(ts_P4_PRO3_test, sampling_rate, win_len, win_flim, win_count);
% %% Class-1
% MAC_train = [...
%     P1_MAC1; P1_MAC2; P1_MAC3;...
%     P2_MAC1; P2_MAC2; P2_MAC3;...
%     P3_MAC1; P3_MAC2; P3_MAC3;...
%     P4_MAC1; P4_MAC2; P4_MAC3];
% 
% MAC_test = [...
%     P1_MAC1_test; P1_MAC2_test; P1_MAC3_test;...
%     P2_MAC1_test; P2_MAC2_test; P2_MAC3_test;...
%     P3_MAC1_test; P3_MAC2_test; P3_MAC3_test;...
%     P4_MAC1_test; P4_MAC2_test; P4_MAC3_test];
% %% Class-2
% PRO_train = [...
%     P1_PRO1; P1_PRO2; P1_PRO3;...
%     P2_PRO1; P2_PRO2; P2_PRO3;...
%     P3_PRO1; P3_PRO2; P3_PRO3;...
%     P4_PRO1; P4_PRO2; P4_PRO3];
% 
% PRO_test = [...
%     P1_PRO1_test; P1_PRO2_test; P1_PRO3_test;...
%     P2_PRO1_test; P2_PRO2_test; P2_PRO3_test;...
%     P3_PRO1_test; P3_PRO2_test; P3_PRO3_test;...
%     P4_PRO1_test; P4_PRO2_test; P4_PRO3_test];
% %% Class Labels
% MAC_train_labels = ones(size(MAC_train,1),1);
% MAC_test_labels = ones(size(MAC_test,1),1);
% 
% PRO_train_labels = ones(size(PRO_train,1),1)+1;
% PRO_test_labels = ones(size(PRO_test,1),1)+1;
% %%
% X_train = [MAC_train; PRO_train];
% y_train = [MAC_train_labels; PRO_train_labels];
% 
% X_test = [MAC_test; PRO_test];
% y_test = [MAC_test_labels; PRO_test_labels];
% 
% toc;
% %%
% tic;
% B = mnrfit(X_train, y_train);
% 
% pihat_train = mnrval(B, X_train);
% pihat_test = mnrval(B, X_test);
% 
% [~, y_train_hat] = max(pihat_train, [], 2);
% [~, y_test_hat] = max(pihat_test, [], 2);
% 
% C_train = confusionmat(y_train, y_train_hat);
% C_test = confusionmat(y_test, y_test_hat);
% %%
% train_result = 100*C_train./sum(C_train, 2)
% test_result = 100*C_test./sum(C_test, 2)
% 
% acc_train = 100*sum(diag(C_train))/sum(C_train, 'all')
% acc_test = 100*sum(diag(C_test))/sum(C_test, 'all')
% 
% toc;
%%