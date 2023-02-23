clear; close all; clc; 
%% Paper Fig 12:   main.m -> plot_HR.m
%% Mean+10 NoCube
HR_ART_P1 = 1000./[698   759   812   726   694   794];
HR_ART_P2 = 1000./[905   868   918   810   796   894];
HR_ART_P3 = 1000./[867   900   921   835   757   840];
HR_ART_P4 = 1000./[727   794   813   738   620   663];

HR_VEN_P1 = 1000./[703   786   799   753   701   786]; 
HR_VEN_P2 = 1000./[901   868   920   802   786   886];
HR_VEN_P3 = 1000./[867   903   919   835   751   819];
HR_VEN_P4 = 1000./[736   799   819   722   611   668];
%%
subj_array = 1:6;

figure();

plot(subj_array, HR_ART_P1, 'rx--', 'LineWidth', 1.5); hold on;
plot(subj_array, HR_VEN_P1, 'ro--', 'LineWidth', 1.5);  

plot(subj_array, HR_ART_P2, 'gx-.', 'LineWidth', 1.5); 
plot(subj_array, HR_VEN_P2, 'go-.', 'LineWidth', 1.5); 

plot(subj_array, HR_ART_P3, 'bx:', 'LineWidth', 1.5); 
plot(subj_array, HR_VEN_P3, 'bo:', 'LineWidth', 1.5); 

plot(subj_array, HR_ART_P4, 'kx-', 'LineWidth', 1.5); 
plot(subj_array, HR_VEN_P4, 'ko-', 'LineWidth', 1.5); 

grid on;

legend(...
    'Pig-1 PAP', 'Pig-1 PVP', ...
    'Pig-2 PAP', 'Pig-2 PVP', ...
    'Pig-3 PAP', 'Pig-3 PVP', ...
    'Pig-4 PAP', 'Pig-4 PVP', ...
    'Interpreter', 'latex','FontSize', 14);

xticks(subj_array);
xticklabels({'MAC-1', 'MAC-2', 'MAC-3', 'PRO-1', 'PRO-2', 'PRO-3'});
ylabel(strcat('Heart Rate,', " ", '$\frac{1}{T}$', 'Hz'), 'Interpreter', 'latex');
set(gca,'TickLabelInterpreter','latex' ,'FontSize', 14);
%%







%%