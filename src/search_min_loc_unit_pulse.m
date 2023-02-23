function pt_tilda = search_min_loc_unit_pulse(mean_pulse, sep_samples)
[~, min_loc] = min(mean_pulse(sep_samples:end));
min_loc_from_start = sep_samples+min_loc-1;
pt_tilda = mean_pulse(1:min_loc_from_start);
end