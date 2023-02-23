function [ts_trunc, taxis_ts_trunc] = load_ts_trunc(ts, taxis_ts, file_number, ...
    sampling_rate, discard_before_this_time, discard_after_this_time)
%% Both `ts_trunc` and `taxis_ts_trunc` are column vectors
start_sample = sampling_rate*discard_before_this_time{file_number}+1;

if isnan(discard_after_this_time{file_number})
    ts_trunc = ts(start_sample:end);
    taxis_ts_trunc = taxis_ts(start_sample:end);
else
    end_sample = sampling_rate*discard_after_this_time{file_number};
    ts_trunc = ts(start_sample:end_sample);
    taxis_ts_trunc = taxis_ts(start_sample:end_sample);
end
end