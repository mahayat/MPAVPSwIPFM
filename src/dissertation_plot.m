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
art_files = {
    'LVS_P1_BB_MAC1_ART', 'LVS_P1_BB_MAC2_ART', 'LVS_P1_BB_MAC3_ART', 'LVS_P1_BB_PRO1_ART', 'LVS_P1_BB_PRO2_ART', 'LVS_P1_BB_PRO3_ART', ...
    'LVS_P2_BB_MAC1_ART', 'LVS_P2_BB_MAC2_ART', 'LVS_P2_BB_MAC3_ART', 'LVS_P2_BB_PRO1_ART', 'LVS_P2_BB_PRO2_ART', 'LVS_P2_BB_PRO3_ART', ...
    'LVS_P3_BB_MAC1_ART', 'LVS_P3_BB_MAC2_ART', 'LVS_P3_BB_MAC3_ART', 'LVS_P3_BB_PRO1_ART', 'LVS_P3_BB_PRO2_ART', 'LVS_P3_BB_PRO3_ART', ...
    'LVS_P4_BB_MAC1_ART', 'LVS_P4_BB_MAC2_ART', 'LVS_P4_BB_MAC3_ART', 'LVS_P4_BB_PRO1_ART', 'LVS_P4_BB_PRO2_ART', 'LVS_P4_BB_PRO3_ART'};
manual_offset = 0; is_man_onset_detec = true;
%% Files of VEN Signals
ven_files = {
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
%% PVP and PAP Signal Plot for Dissertation Presentation
tic;
all_R2 = [];
for file_number = 8 %1:(num_pigs*num_states) % file_number = 8 -> Pig-2 MAC-2
    do_plot = false; % <- change when needed
    
    [~, pap_y, ~, pap_taxis, ~, ~, ~, ~] = get_model(...
        root_location, art_files, file_number, manual_offset, sampling_rate, ...
        min_dist, discard_before_this_time, discard_after_this_time, ...
        ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
    
    [~, pvp_y, ~, pvp_taxis, ~, ~, ~, ~] = get_model(...
        root_location, ven_files, file_number, manual_offset, sampling_rate, ...
        min_dist, discard_before_this_time, discard_after_this_time, ...
        ulim, llim, mov_avg_len, do_plot, is_man_onset_detec, ratio);
end
toc;
%% Plot Limits
xlim_axis = 100+[0 20];
ylim_axis = 0.35+[0 0.4];

xlim_faxis = [0 2.5];
ylim_faxis = [0 0.0001];

font_size = 14;
line_width = 1.5;
%%
figure();
subplot(211);
plot(pap_taxis, pap_y, 'b', 'LineWidth', line_width); grid on; xlim(xlim_axis);
legend('PAP Signal', 'Interpreter', 'latex','FontSize', font_size);
ylabel('(Volt)', 'Interpreter', 'latex');
% xlabel('Time (s)', 'Interpreter', 'latex');
set(gca,'TickLabelInterpreter','latex','FontSize', font_size);

subplot(212);
plot(pvp_taxis, pvp_y, 'b', 'LineWidth', line_width); grid on; xlim(xlim_axis);
legend('PVP Signal', 'Interpreter', 'latex','FontSize', font_size);
ylabel('(Volt)', 'Interpreter', 'latex');
xlabel('Time (s)', 'Interpreter', 'latex');
set(gca,'TickLabelInterpreter','latex','FontSize', font_size);




