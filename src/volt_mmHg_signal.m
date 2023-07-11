clear; close all; clc; 
%%
sampling_rate = 1000;
root_location = "/Users/mahayat/Desktop/lv_data/";
%% Files of ART Signals
files = {
    'LVS_P1_BB_MAC1_ART', 'LVS_P1_BB_MAC2_ART', 'LVS_P1_BB_MAC3_ART', 'LVS_P1_BB_PRO1_ART', 'LVS_P1_BB_PRO2_ART', 'LVS_P1_BB_PRO3_ART', ...
    'LVS_P2_BB_MAC1_ART', 'LVS_P2_BB_MAC2_ART', 'LVS_P2_BB_MAC3_ART', 'LVS_P2_BB_PRO1_ART', 'LVS_P2_BB_PRO2_ART', 'LVS_P2_BB_PRO3_ART', ...
    'LVS_P3_BB_MAC1_ART', 'LVS_P3_BB_MAC2_ART', 'LVS_P3_BB_MAC3_ART', 'LVS_P3_BB_PRO1_ART', 'LVS_P3_BB_PRO2_ART', 'LVS_P3_BB_PRO3_ART', ...
    'LVS_P4_BB_MAC1_ART', 'LVS_P4_BB_MAC2_ART', 'LVS_P4_BB_MAC3_ART', 'LVS_P4_BB_PRO1_ART', 'LVS_P4_BB_PRO2_ART', 'LVS_P4_BB_PRO3_ART'};
%% Files of VEN Signals
% files = {
%     'LVS_P1_BB_MAC1_VEN', 'LVS_P1_BB_MAC2_VEN', 'LVS_P1_BB_MAC3_VEN', 'LVS_P1_BB_PRO1_VEN', 'LVS_P1_BB_PRO2_VEN', 'LVS_P1_BB_PRO3_VEN', ...
%     'LVS_P2_BB_MAC1_VEN', 'LVS_P2_BB_MAC2_VEN', 'LVS_P2_BB_MAC3_VEN', 'LVS_P2_BB_PRO1_VEN', 'LVS_P2_BB_PRO2_VEN', 'LVS_P2_BB_PRO3_VEN', ...
%     'LVS_P3_BB_MAC1_VEN', 'LVS_P3_BB_MAC2_VEN', 'LVS_P3_BB_MAC3_VEN', 'LVS_P3_BB_PRO1_VEN', 'LVS_P3_BB_PRO2_VEN', 'LVS_P3_BB_PRO3_VEN', ...
%     'LVS_P4_BB_MAC1_VEN', 'LVS_P4_BB_MAC2_VEN', 'LVS_P4_BB_MAC3_VEN', 'LVS_P4_BB_PRO1_VEN', 'LVS_P4_BB_PRO2_VEN', 'LVS_P4_BB_PRO3_VEN'};
%%
file_number = 18;
[ts, taxis_ts] = load_ts(root_location, files, file_number, sampling_rate);
ts_int = fn_int(ts);
ts_ext = fn_ext(ts);
%%
xlim_axis = [100, 120];

figure(1);
subplot(211);
plot(taxis_ts, ts, 'b', 'LineWidth', 1.5); 
xlim(xlim_axis); grid on;
ylabel('(Volt)', 'Interpreter','latex');
set(gca,'TickLabelInterpreter','latex'); 

subplot(212);
plot(taxis_ts, ts_int, 'r', 'LineWidth', 1.5); 
hold on;
plot(taxis_ts, ts_ext, 'b', 'LineWidth', 1.5); 
grid on;

xlim(xlim_axis); xlabel('Time (s)', 'Interpreter','latex');
ylabel('(mmHg)', 'Interpreter','latex');
legend('Formula: Int.', 'Formula: Ext.', 'Interpreter','latex');
set(gca,'TickLabelInterpreter','latex'); 

saveas(gcf, 'mismatch_art.png');
%% Signal (V) = 0.0100*Pressure (mmHg) - 0.0177
function mmhg_signal = fn_ext(volt_signal)
    mmhg_signal = (1/0.0099)*(volt_signal + 0.0966);
end
%% Signal (V) = 0.0099*Pressure (mmHg) - 0.0966
function mmhg_signal = fn_int(volt_signal)
    mmhg_signal = (1/0.01)*(volt_signal + 0.0177);
end