function [pt, T] = align_pulse(pt_tilda)
T = length(pt_tilda); % Here, T is in samples. T/sampling_rate is real 'period'
t = (0:length(pt_tilda)-1);
pt = (pt_tilda - (pt_tilda(end)-pt_tilda(1))*(t/T))';
end