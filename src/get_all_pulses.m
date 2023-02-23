function [all_pulses, mean_pulse] = get_all_pulses(x_tilda, loc)
% x_tilda starts at one onset point and ends at another onset
all_pulses = [];
N = length(loc)-1; % Number of Pulses

pulse_starts = loc(1:N);
pulse_ends = loc(2:N+1)-1;

sample_dist = pulse_ends-pulse_starts+1;

mean_pulse_dist = round(mean(sample_dist));
mean_pulse_std = round(std(sample_dist));
median_pulse_dist = round(median(sample_dist));

% disp([mean_pulse_dist, mean_pulse_std, median_pulse_dist])
%% Method-1
% pulse_max_dist = mean_pulse_dist+100;
% for i = 1:N
%     dist = pulse_ends(i)-pulse_starts(i)+1;
%     if ((dist < pulse_max_dist)) && (x_tilda(pulse_starts(i)) > -1) && (x_tilda(pulse_ends(i)-1) > -1)
%         single_pulse = NaN(1, pulse_max_dist);
%
%         single_pulse(1:dist) = x_tilda(pulse_starts(i):pulse_ends(i));
%         all_pulses = [all_pulses; single_pulse];
%     end
% end
% mean_pulse = mean(all_pulses, 'omitnan');
% mean_pulse = mean_pulse(~isnan(mean_pulse));
%% Method-2
pulse_max_dist = median_pulse_dist+10;
for i = 1:N
    dist = pulse_ends(i)-pulse_starts(i)+1;
    temp_pulse = x_tilda(pulse_starts(i):pulse_ends(i));
    if (dist <= pulse_max_dist)
        single_pulse = NaN(1, pulse_max_dist);
        single_pulse(1:dist) = temp_pulse;
        all_pulses = [all_pulses; single_pulse];
    end
end
mean_pulse = mean(all_pulses, 'omitnan');
mean_pulse = mean_pulse(~isnan(mean_pulse));
end