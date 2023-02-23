function [all_t, ssf, loc] = manual_onset(x_tilda_temp, sampling_rate)
%% Inspired by:
% Paper: http://ecg.mit.edu/george/publications/abp-cinc-2003.pdf
% Code: https://physionet.org/content/cardiac-output/1.0.0/code/2analyze/wabp.m
%%
th_set_time = 8;
win_samples = 120;
lockout_samples = 500;
search_samples = 60;

warmup_sample = 500;
ratio = 0.01;
%%
ssf = [0; conv(diff(x_tilda_temp), ones(win_samples,1), 'same')];
th = mean(ssf(1:(th_set_time*sampling_rate)));
%%
lockout = 0;

loc = [];
all_t = [];

for t = warmup_sample:length(ssf)-search_samples
    lockout = lockout - 1;
    if (lockout < 1) && (ssf(t) > th)
        
        maxSSF = max(ssf(t:t+search_samples));
        minSSF = min(ssf(t-search_samples:t));
        
        if maxSSF > (minSSF + 1)
            
            onset    = ratio*maxSSF;
            tt       = t-search_samples:t;
            dssf     = ssf(tt) - ssf(tt-1);
            BeatTime = find(dssf < onset, 1,'last') + t - 25; %- (search_samples+1);
            
            loc = [loc, BeatTime];
            all_t = [all_t, t];
            
            lockout = lockout_samples;
        end
    end
end
end