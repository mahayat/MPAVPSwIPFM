clear; close all; clc;
%% Paper Fig 13:   main.m -> plot_mt_rt_corr.m
%%
P1_ART_mt_rt = [-0.4130   -0.5274   -0.4208   -0.1928   -0.0411   -0.3259];
P2_ART_mt_rt = [-0.4855   -0.6439   -0.5240   -0.2534   -0.3944   -0.6818];
P3_ART_mt_rt = [-0.6578   -0.6269   -0.1184   -0.2645   -0.3138   -0.2949];
P4_ART_mt_rt = [-0.5502   -0.5953   -0.6574   -0.0450   -0.1631   -0.4100];

P1_VEN_mt_rt = [-0.1769   -0.0658    0.0340   -0.1206   -0.0592   -0.0281];
P2_VEN_mt_rt = [ 0.1222    0.0870    0.0321   -0.2988   -0.2311   -0.2418];
P3_VEN_mt_rt = [ 0.0057    0.0372    0.0419   -0.0108   -0.1015   -0.0540];
P4_VEN_mt_rt = [-0.0278    0.0458    0.0730   -0.1733   -0.3699   -0.4020];
%% ART Signal
subj_array = 1:6;

figure(1);

subplot(211);
subtitle('(a)');
plot(subj_array, P1_ART_mt_rt, 'rx--', 'LineWidth', 1.5); hold on;
plot(subj_array, P2_ART_mt_rt, 'gx-.', 'LineWidth', 1.5); 
plot(subj_array, P3_ART_mt_rt, 'bx:', 'LineWidth', 1.5); 
plot(subj_array, P4_ART_mt_rt, 'kx-', 'LineWidth', 1.5); 

yline(-0.35, '-.','color', 0.75*[1 1 1], 'linewidth', 2)
yline(-0.75, '-','color', 0.75*[1 1 1], 'linewidth', 2)
grid on; ylim([-1 1]);
legend(...
    'Pig-1 PAP', ... 
    'Pig-2 PAP', ... 
    'Pig-3 PAP', ... 
    'Pig-4 PAP', ... 
    'Interpreter', 'latex','FontSize', 12);

ylabel('$\rho_{m(t), r(t)}$', 'Interpreter', 'latex', 'fontsize', 14);

title('(a)','Interpreter', 'latex');
xticks(subj_array);
xticklabels({});
set(gca,'TickLabelInterpreter','latex','FontSize', 14);
%% VEN Signal
subplot(212);
plot(subj_array, P1_VEN_mt_rt, 'ro--', 'LineWidth', 1.5); hold on;
plot(subj_array, P2_VEN_mt_rt, 'go-.', 'LineWidth', 1.5); 
plot(subj_array, P3_VEN_mt_rt, 'bo:', 'LineWidth', 1.5); 
plot(subj_array, P4_VEN_mt_rt, 'ko-', 'LineWidth', 1.5); 

yline(0.25, '-.','color', 0.75*[1 1 1], 'linewidth', 2)
yline(-0.25, '-','color', 0.75*[1 1 1], 'linewidth', 2)
grid on; ylim([-1 1]);
legend(...
    'Pig-1 PVP', ... 
    'Pig-2 PVP', ... 
    'Pig-3 PVP', ... 
    'Pig-4 PVP', ... 
    'Interpreter', 'latex','FontSize', 12);

ylabel('$\rho_{m(t), r(t)}$', 'Interpreter', 'latex', 'fontsize', 14);

title('(b)','Interpreter', 'latex');
xticks(subj_array);
xticklabels({'MAC-1', 'MAC-2', 'MAC-3', 'PRO-1', 'PRO-2', 'PRO-3'});
set(gca,'TickLabelInterpreter','latex','FontSize', 14);
%%