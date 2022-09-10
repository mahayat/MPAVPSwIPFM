clear; close all; clc; 
%% ART
P1_ART_SDRR = [0.0087    0.0085    0.0092    0.0109    0.0272    0.0080];
P2_ART_SDRR = [0.0070    0.0072    0.0081    0.0198    0.0108    0.0078];
P3_ART_SDRR = [0.0074    0.0081    0.0164    0.0267    0.0184    0.0250];
P4_ART_SDRR = [0.0081    0.0104    0.0187    0.0549    0.0111    0.0102];

P1_ART_SDSD = [0.0065    0.0102    0.0127    0.0044    0.0037    0.0047];
P2_ART_SDSD = [0.0059    0.0075    0.0065    0.0078    0.0066    0.0080];
P3_ART_SDSD = [0.0073    0.0078    0.0170    0.0090    0.0077    0.0093];
P4_ART_SDSD = [0.0087    0.0128    0.0290    0.0055    0.0041    0.0059];

P1_ART_SD1 = [0.0046    0.0072    0.0090    0.0031    0.0026    0.0033];
P2_ART_SD1 = [0.0041    0.0053    0.0046    0.0055    0.0046    0.0057];
P3_ART_SD1 = [0.0051    0.0055    0.0120    0.0064    0.0054    0.0066];
P4_ART_SD1 = [0.0061    0.0090    0.0205    0.0039    0.0029    0.0042];

P1_ART_SD2 = [0.0114    0.0095    0.0094    0.0151    0.0384    0.0108];
P2_ART_SD2 = [0.0091    0.0087    0.0105    0.0275    0.0146    0.0095];
P3_ART_SD2 = [0.0090    0.0101    0.0198    0.0373    0.0255    0.0347];
P4_ART_SD2 = [0.0096    0.0117    0.0168    0.0776    0.0155    0.0138];
%% VEN
P1_VEN_SDRR = [0.0739    0.0451    0.0812    0.0871    0.0843    0.0859];
P2_VEN_SDRR = [0.0379    0.0357    0.0392    0.0326    0.0255    0.0276];
P3_VEN_SDRR = [0.0344    0.0356    0.0368    0.0514    0.0350    0.0426];
P4_VEN_SDRR = [0.0451    0.0915    0.1357    0.0905    0.1064    0.1048];

P1_VEN_SDSD = [0.1266    0.0726    0.0812    0.1491    0.1378    0.1483];
P2_VEN_SDSD = [0.0611    0.0592    0.0583    0.0440    0.0389    0.0450];
P3_VEN_SDSD = [0.0600    0.0593    0.0638    0.0730    0.0524    0.0572];
P4_VEN_SDSD = [0.0666    0.1490    0.2306    0.1209    0.1423    0.1475];

P1_VEN_SD1 = [0.0895    0.0513    0.0574    0.1054    0.0974    0.1049];
P2_VEN_SD1 = [0.0432    0.0419    0.0413    0.0311    0.0275    0.0318];
P3_VEN_SD1 = [0.0424    0.0420    0.0451    0.0516    0.0370    0.0404];
P4_VEN_SD1 = [0.0471    0.1053    0.1630    0.0855    0.1007    0.1043];

P1_VEN_SD2 = [0.0539    0.0378    0.0995    0.0637    0.0687    0.0612];
P2_VEN_SD2 = [0.0317    0.0283    0.0371    0.0340    0.0233    0.0227];
P3_VEN_SD2 = [0.0238    0.0278    0.0259    0.0512    0.0328    0.0446];
P4_VEN_SD2 = [0.0430    0.0752    0.1012    0.0952    0.1118    0.1053];
%%
subj_array = 1:6;

figure();

plot(subj_array, P1_ART_SDSD, 'rx--', 'LineWidth', 1.5); hold on;
plot(subj_array, P1_VEN_SDSD, 'ro--', 'LineWidth', 1.5); 

plot(subj_array, P2_ART_SDSD, 'gx-.', 'LineWidth', 1.5); 
plot(subj_array, P2_VEN_SDSD, 'go-.', 'LineWidth', 1.5); 

plot(subj_array, P3_ART_SDSD, 'bx:', 'LineWidth', 1.5); 
plot(subj_array, P3_VEN_SDSD, 'bo:', 'LineWidth', 1.5); 

plot(subj_array, P4_ART_SDSD, 'kx-', 'LineWidth', 1.5); 
plot(subj_array, P4_VEN_SDSD, 'ko-', 'LineWidth', 1.5); grid on;

legend(...
    'Pig-1 ART', 'Pig-1 VEN', ... 
    'Pig-2 ART', 'Pig-2 VEN', ... 
    'Pig-3 ART', 'Pig-3 VEN', ... 
    'Pig-4 ART', 'Pig-4 VEN', ... 
    'Interpreter', 'latex');

title('SDSD', 'Interpreter', 'latex');

xticks(subj_array);
xticklabels({'MAC-1', 'MAC-2', 'MAC-3', 'PRO-1', 'PRO-2', 'PRO-3'});
% ylabel(strcat('Heart Rate,', " ", '$\frac{1}{T}$', 'Hz'), 'Interpreter', 'latex');
set(gca,'TickLabelInterpreter','latex');
%%







%%