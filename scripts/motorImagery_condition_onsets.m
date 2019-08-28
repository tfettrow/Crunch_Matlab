condition_order_run1 = ["moderate"; "low"; "flat"; "hard"; "low"; "hard"; "low"; "moderate"];
condition_order_run2 = ["hard"; "moderate"; "flat"; "low"; "moderate"; "hard"; "low"; "flat"];


video_onset = [0; 36000; 72000; 108000; 144000; 180000; 216000; 252000];
static_onset = video_onset + 6000;
rest_onset = static_onset + 18000;


condition_timing_table_run1 = table(video_onset, static_onset, rest_onset, condition_order_run1);
condition_timing_table_run2 = table(video_onset, static_onset, rest_onset, condition_order_run2);


writetable(condition_timing_table_run1, 'MotorImagery_condition_onsets_run1.csv');
writetable(condition_timing_table_run2, 'MotorImagery_condition_onsets_run2.csv');