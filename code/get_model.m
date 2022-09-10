% function [y_hat, y, y_test, taxis, rt, loc, T] = get_model(...
%     root_location, files, file_number, manual_offset, sampling_rate, ...
%     min_dist, discard_before_this_time, discard_after_this_time, ...
%     ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio)
function [y_hat, y, y_test, taxis, all_pulses, pt_tilda, R2, T] = get_model(...
    root_location, files, file_number, manual_offset, sampling_rate, ...
    min_dist, discard_before_this_time, discard_after_this_time, ...
    ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio)
% function [x_tilda_temp, taxis_temp] = get_model(...
%     root_location, files, file_number, manual_offset, sampling_rate, ...
%     min_dist, discard_before_this_time, discard_after_this_time, ...
%     ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio)
%% Plot Limits
xlim_axis = 100+[0 20];
ylim_axis = 0.4+[0 0.4]; % Pig-1 MAC-1

xlim_faxis = [0 2.5];
ylim_faxis = [0 0.0001];
%% Extract the signal (y_temp) to model
[ts, taxis_ts] = load_ts(root_location, files, file_number, sampling_rate);
[ts_trunc, taxis_temp] = load_ts_trunc(ts, taxis_ts, file_number,...
    sampling_rate, discard_before_this_time, discard_after_this_time);
% taxis_temp: does not start at 0s
y_temp = lowpass(ts_trunc, ulim, sampling_rate);
y_temp = y_temp + manual_offset; % --> This is the signal to model
% disp(length(y_temp)/sampling_rate/60)
%% Untruncated and Truncated Signal
if do_plot
    figure();
    
    subplot(211);
    plot(taxis_ts, ts, 'b', 'LineWidth', 1.5); grid on;
    legend('$y_{ut}(t)$', 'Interpreter', 'latex');
    ylabel('(mmHg)', 'Interpreter', 'latex');
    %     xlim(xlim_axis);
    set(gca,'TickLabelInterpreter','latex'); grid on;
    
    subplot(212);
    plot(taxis_temp, ts_trunc, 'r', 'LineWidth', 1.5); grid on;
    legend('$y_r(t)$', 'Interpreter', 'latex');
    ylabel('(mmHg)', 'Interpreter', 'latex');
    %     xlim(xlim_axis);
    set(gca,'TickLabelInterpreter','latex');
end
%% Untruncated and Truncated Signal: Frequency Domain
if do_plot
    figure();
    [X_ts, ~, f_ts] = getFFT(ts, sampling_rate);
    [X_ts_trunc, ~, f_ts_trunc] = getFFT(ts_trunc, sampling_rate);
    
    plot(f_ts, X_ts, 'b', 'LineWidth', 1.5); hold on;
    plot(f_ts_trunc, X_ts_trunc, 'r--', 'LineWidth', 1.5); grid on;
    legend('$Y_{ut}(t)$', '$Y_r(t)$', 'Interpreter', 'latex');
    
    xlabel('Frequency (Hz)', 'Interpreter', 'latex');
    ylabel('(mmHg)', 'Interpreter', 'latex');
    xlim(xlim_faxis); ylim(ylim_faxis);
    set(gca,'TickLabelInterpreter','latex');
end
%%
nsamples = length(y_temp);
nsamples_test = round(ratio*nsamples);
nsamples_train = nsamples-nsamples_test;

y_temp_copy = y_temp;
y_temp = y_temp_copy(1:nsamples_train);
y_test = y_temp_copy((nsamples_train+1):end);
%% Get: y(t), \tau(t), \tilde{y}(t)
taxis_temp = taxis_temp(1:nsamples_train);
taxis_temp = taxis_temp-taxis_temp(1); % taxis_temp: starts at 0s

sep_samples = sampling_rate*min_dist(file_number);
tau_temp_nonzmean = movmean(y_temp, mov_avg_len*sampling_rate);
tau_temp = tau_temp_nonzmean - mean(tau_temp_nonzmean);
y_tilde_temp = y_temp - tau_temp;
%% Truncated Signal
if do_plot
    figure();
    subplot(311);
    plot(taxis_temp, ts_trunc(1:nsamples_train), ...
        'b', 'LineWidth', 1.5); grid on;
    legend('$y_r(t)$', 'Interpreter', 'latex');
    ylabel('(mmHg)', 'Interpreter', 'latex');
    set(gca,'TickLabelInterpreter','latex');
    xlim(xlim_axis);
    ylim(ylim_axis); % Pig-1 MAC-1
    
    subplot(312);
    plot(taxis_temp, y_temp, 'b', 'LineWidth', 1.5); grid on;
    legend('$y(t)$', 'Interpreter', 'latex');
    ylabel('(mmHg)', 'Interpreter', 'latex');
    set(gca,'TickLabelInterpreter','latex');
    xlim(xlim_axis);
    ylim(ylim_axis); % Pig-1 MAC-1
    
    subplot(313);
    plot(taxis_temp, tau_temp, 'b', 'LineWidth', 1.5); grid on;
    legend('$\tau(t)$', 'Interpreter', 'latex');
    xlabel('Time (s)', 'Interpreter', 'latex');
    ylabel('(mmHg)', 'Interpreter', 'latex');
    set(gca,'TickLabelInterpreter','latex');
    xlim(xlim_axis);
    ylim([-0.2 0.2]); % Pig-1 MAC-1
end
%% Get: y_{LF}(t), y_{HF}(t)
y_HF_temp = highpass(y_tilde_temp, llim, sampling_rate);
y_LF_temp = y_tilde_temp - y_HF_temp;
%% Get: Envelope Detection on y_{HF}(t)
[env_u_temp, env_l_temp] = envelope(y_HF_temp, sep_samples, 'peak');
%% Get: Onset Detection on \tilde{x}(t)
alpha = (mean(env_u_temp)-mean(env_l_temp))/2;
beta_plus_gamma = mean(y_LF_temp)/alpha;
rt_temp = (y_LF_temp/beta_plus_gamma)-alpha;
x_tilda_temp = y_HF_temp./(alpha+rt_temp);

if is_man_onset_detec
    [~, ~, loc_temp] = manual_onset(x_tilda_temp, sampling_rate);
    loc_temp = loc_temp';
else
    [~, loc_temp] = findpeaks(-x_tilda_temp, 'MinPeakDistance', sep_samples);
end
%% Discard Segments Before/After Onset Detection
start_loc = loc_temp(2);
end_loc = loc_temp(end-1);

y = y_temp(start_loc:end_loc);
y_tilde = y_tilde_temp(start_loc:end_loc);
y_LF = y_LF_temp(start_loc:end_loc);
y_HF = y_HF_temp(start_loc:end_loc);
taxis = taxis_temp(start_loc:end_loc)-taxis_temp(start_loc);

tau = tau_temp(start_loc:end_loc);
env_u = env_u_temp(start_loc:end_loc);
env_l = env_l_temp(start_loc:end_loc);
x_tilda = x_tilda_temp(start_loc:end_loc);
rt = rt_temp(start_loc:end_loc);

loc = loc_temp(2:end-1)-start_loc+1; 
%% Plot: \tilde{y}(t), y_{HF}(t) and y_{LF}(t)
if do_plot
    figure();
    
    subplot(311);
    plot(taxis, y_tilde, 'b', 'LineWidth', 1.5); grid on;
    xlim(xlim_axis);
    ylim(ylim_axis); % Pig-1 MAC-1
    
    legend('$\tilde{y}(t)$', 'Interpreter', 'latex');
    ylabel('(mmHg)', 'Interpreter', 'latex');
    set(gca,'TickLabelInterpreter','latex');
    
    subplot(312);
    plot(taxis, y_HF, 'b', 'LineWidth', 1.5); grid on;
    xlim(xlim_axis);
    ylim([-0.2 0.2]); % Pig-1 MAC-1
    
    legend('$y_{HF}(t)$', 'Interpreter', 'latex');
    ylabel('(mmHg)', 'Interpreter', 'latex');
    set(gca,'TickLabelInterpreter','latex');
    
    subplot(313);
    plot(taxis, y_LF, 'b', 'LineWidth', 1.5); grid on;
    xlim(xlim_axis);
    ylim(ylim_axis); % Pig-1 MAC-1
    
    legend('$y_{LF}(t)$', 'Interpreter', 'latex');
    xlabel('Time (s)', 'Interpreter', 'latex');
    ylabel('(mmHg)', 'Interpreter', 'latex');
    set(gca,'TickLabelInterpreter','latex');
end
%% Plot: Envelope Detection on y_{HF}(t) and Onset Detection on \tilde{x}(t)
if do_plot
    figure();
    
    subplot(211);
    plot(taxis, y_HF, 'b', 'LineWidth', 1.5); hold on;
    plot(taxis, env_u, 'r', 'LineWidth', 1.5);
    plot(taxis, env_l, 'k', 'LineWidth', 1.5);
    xlim(xlim_axis); grid on; 
    ylim([-0.2 0.2]); % Pig-1 MAC-1
    legend('$y_{HF}(t)$', '$e_{u}(t)$', '$e_{l}(t)$', ...
        'Interpreter', 'latex');
    ylabel('(mmHg)', 'Interpreter', 'latex');
    set(gca,'TickLabelInterpreter','latex');
    
    subplot(212);
    plot(taxis, x_tilda, 'b', 'LineWidth', 1.5); hold on;
    plot(taxis(loc), x_tilda(loc), 'r*', 'LineWidth', 1.5);
    xlim(xlim_axis); grid on;
    legend('$\tilde{x}(t)$', '$\{t_k\}$', ...
        'Interpreter', 'latex');
    ylabel('(mmHg)', 'Interpreter', 'latex');
    xlabel('Time (s)', 'Interpreter', 'latex');
    set(gca,'TickLabelInterpreter','latex');
end
%% Find: \tilde{p}(t) --> Most Important Step
% **(Important Functions)** --> 'get_all_pulses' and 'search_min_loc_unit_pulse'
[all_pulses, mean_pulse] = get_all_pulses(x_tilda, loc);
pt_tilda = search_min_loc_unit_pulse(mean_pulse, sep_samples);
[pt, T] = align_pulse(pt_tilda); % T is in samples. T/sampling_rate is real 'period'
gamma = trapz(pt)/sampling_rate;
%% Plot: (All*) Pulses, Mean Pulse, Accepted Pulse \tilde{p}(t)
if do_plot
    figure();
    for i = 1:size(all_pulses,1)
        sample_pulse = all_pulses(i,:);
        taxis_sample_pulse = (0:length(sample_pulse)-1)/sampling_rate;
        
        plot(taxis_sample_pulse, sample_pulse, 'Color', [.7 .7 .7], 'LineWidth', 1.5);
        hold on;
    end
    taxis_mean_pulse = (0:length(mean_pulse)-1)/sampling_rate;
    plot(taxis_mean_pulse, mean_pulse, 'r', 'LineWidth', 1.5);
    
    taxis_pt_tilda = (0:length(pt_tilda)-1)/sampling_rate;
    plot(taxis_pt_tilda, pt_tilda, 'k-.', 'LineWidth', 1.5);
    
    legend('Pulses', 'Interpreter', 'latex');
    xlim([0 1]); ylim([-2 2]); grid on;
    ylabel('(mmHg)', 'Interpreter', 'latex');
    xlabel('Time (s)', 'Interpreter', 'latex');
    set(gca,'TickLabelInterpreter','latex');
end
%% Plot: Aligned Pulse p(t)
if do_plot
    figure();
    taxis_pt = (0:length(pt)-1)/sampling_rate;
    plot(taxis_pt, pt, 'b', 'LineWidth', 1.5);
    xlim([0 1]); ylim([-1 1.5]); grid on;
    ylabel('(mmHg)', 'Interpreter', 'latex');
    xlabel('Time (s)', 'Interpreter', 'latex');
    set(gca,'TickLabelInterpreter','latex');
end
%% Final Results: R^2 Value
x_hat = get_x_hat(pt, loc, sampling_rate);
x_hat = lowpass(x_hat, ulim, sampling_rate);

y_LF_hat = beta_plus_gamma*(alpha+rt);
y_HF_hat = (alpha+rt).*(x_hat-gamma);
y_hat = tau + y_LF_hat + y_HF_hat;
R2 = R2_cal(y, y_hat);
%% Plot: \tilde{x} and \hat{x}
if do_plot
    figure();
    plot(taxis, x_tilda, 'b', 'LineWidth', 1.5); hold on;
    plot(taxis, x_hat, 'r--', 'LineWidth', 1.5); grid on;
    xlim(xlim_axis);
    legend('$\tilde{x}(t)$', '$\hat{x}(t)$', 'Interpreter', 'latex');
    ylabel('(mmHg)', 'Interpreter', 'latex');
    xlabel('Time (s)', 'Interpreter', 'latex');
    set(gca,'TickLabelInterpreter','latex');
end
%% Plot: y(t) and \hat{y}(t)
if do_plot
    figure();
    plot(taxis, y, 'b', 'LineWidth', 1.5); hold on;
    plot(taxis, y_hat, 'r--', 'LineWidth', 1.5); grid on;
    xlim(xlim_axis);
    legend('$y(t)$', '$\hat{y}(t)$', 'Interpreter', 'latex');
    ylabel('(mmHg)', 'Interpreter', 'latex');
    xlabel('Time (s)', 'Interpreter', 'latex');
    set(gca,'TickLabelInterpreter','latex');
end
%% Plot: y_{LF}(t) and r(t)
if do_plot
    figure();
    subplot(211);
    plot(taxis, y_LF, 'b', 'LineWidth', 1.5); grid on; xlim(xlim_axis);
    legend('$y_{LF}(t)$', 'Interpreter', 'latex');
    ylabel('(mmHg)', 'Interpreter', 'latex');
    xlabel('Time (s)', 'Interpreter', 'latex');
    set(gca,'TickLabelInterpreter','latex');
    
    subplot(212);
    plot(taxis, rt, 'b', 'LineWidth', 1.5); grid on; xlim(xlim_axis);
    legend('$r(t)$', 'Interpreter', 'latex');
    ylabel('(mmHg)', 'Interpreter', 'latex');
    xlabel('Time (s)', 'Interpreter', 'latex');
    set(gca,'TickLabelInterpreter','latex');
end
end
