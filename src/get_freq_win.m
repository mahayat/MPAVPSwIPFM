function all_freq_win = get_freq_win(ts, sampling_rate, win_len, win_flim, win_count)
% win_len --> win_len in seconds
L = length(ts);
n = win_len*sampling_rate;
fixed_win = true;
%% If this Block is Activated then Change the Function Definition 
% if fixed_win
%     win_count = 90;
% else
%     win_count = floor(L/n);
% end
%%
del_F = (1/win_len);
col_num = floor(win_flim/del_F);
all_freq_win = NaN(win_count, col_num);
%%
if fixed_win
    % Reference: https://github.com/mahayat/DL_LabView_Data/blob/main/code/helpers.py#L115
    offset = floor((L-n)/(win_count-1));
    for i = 1:win_count
        start_index = 1+(i-1)*offset;
        end_index = start_index+n-1;
        win_ts = ts(start_index:end_index);
        
        [win_ft, ~, ~] = getFFT(win_ts, sampling_rate);
        all_freq_win(i,:) = win_ft(1:col_num);
    end
else
    for i = 1:win_count
        start_index = 1+(i-1)*n;
        end_index = i*n;
        win_ts = ts(start_index:end_index);
        
        [win_ft, ~, ~] = getFFT(win_ts, sampling_rate);
        all_freq_win(i,:) = win_ft(1:col_num);
    end
end
end