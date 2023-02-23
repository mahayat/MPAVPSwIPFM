function x_hat = get_x_hat(pt, loc, sampling_rate)
pt_taxis = (0:length(pt)-1)/sampling_rate;
pt_taxis_start = pt_taxis(1);
pt_taxis_end = pt_taxis(end);
x_hat = [];
N = length(loc)-1;
for i = 1:N
    temp_taxis = linspace(pt_taxis_start, pt_taxis_end, loc(i+1)-loc(i));
    temp_pt = spline(pt_taxis, pt, temp_taxis);
    x_hat = [x_hat; temp_pt'];
end
x_hat = [x_hat; x_hat(end)];
end