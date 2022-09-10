function all_pulses = get_all_pulse(x_tilda, loc)
all_pulses = [];
N = length(loc)-1; % Number of Pulses

pulse_start = loc(1:N);
pulse_end = loc(2:N+1)-1;

sample_dist = pulse_end-pulse_start;
pulse_max_dist = round(mean(sample_dist))+100;
%%
for i = 1:N
    dist = pulse_end(i)-pulse_start(i);
    if dist < pulse_max_dist
        single_pulse = NaN(1, pulse_max_dist);
        single_pulse(1:dist) = x_tilda(pulse_start(i):pulse_end(i)-1);
        all_pulses = [all_pulses; single_pulse];
    end
end
mean_pulse = mean(all_pulses);
%%
% figure(1);
% for i = 1:size(all_pulses, 1)
%     pulse = all_pulses(i,:);
%     pulse_axis = (0:length(pulse)-1)/sampling_rate;
%     plot(pulse_axis, pulse, 'b', 'LineWidth', 1.5);
%     hold on; grid on;
% end

% taxis_mean_pulse = (0:length(mean_pulse)-1)/sampling_rate;
% plot(pulse_axis, pulse, 'r', 'LineWidth', 1.5);
end