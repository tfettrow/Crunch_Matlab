%% this script is intended to be run from the study folder 
% 1) arguments include subject
% 2) go into this subject folder and read the (date)_subjectid.csv
% 3) then go into raw/vr folder and read the .txts... need a check to
% confirm the .txts match the .csv above (need better naming scheme here)
% 4) read the .txts and store the condition info in a condition cell structure.. the cell strucutre
% should include a) trial_type b) difficulty c) posture
% 5) then read in the data and store in data_cell_structure ??
% (time_stamp,boat_angle,joystick_value,head_angle)
% 6) then go into raw/emg folder and read in c3d....

% things to fix
% 1) zero pad single digit trial numbers (unity)
% 2) include trial conditions (posture, type, and difficulty) in saved file name from unity
% 3) make start and stop sync pulses different.. one short and one long
% 4) create a save_subject_info function.. use that to name the files

function import_boat_data(varargin)
% parser = inputParser;
% parser.KeepUnmatched = true;
% % setup defaults in case no arguments specified
% addParameter(parser, 'subjects', '')
% parse(parser, varargin{:})
current_path = pwd;

path_split = strsplit(current_path, filesep);
subject_code = path_split{end};

formatOut = 'yyyy-mm-dd';

trial_info_file = dir((strcat('*',subject_code,'.csv')));
collection_date = datestr(trial_info_file.date,formatOut);
collection_date = erase(collection_date,"-");
if size(trial_info_file,1) > 1
    error('something wrong with settings file'); 
end

csv_condition_data = readtable(trial_info_file.name);

subject_settings = SettingsCustodian('subject_settings.txt');
trials_completed = subject_settings.settings_struct.trial_completion;

conditions_cell.posture={};
conditions_cell.type={};
conditions_cell.difficulty={};
mkdir('processed');

% go into emg folder
% load the (should be only 1 txt file for whole collection) txt file 

% read the txt (% 20210829_1001_AG.txt)
emg_export_files = dir(fullfile('raw','emg',strcat('*',subject_code,'*','.txt')));

emg_sync_pulse = [];
all_time_emg = [];
% sampling_rate_emg = [];
raw_emg_trajectories = [];
for emg_export_file_index = 1:length(emg_export_files)
    %     emg_data_file = emg_export_files
    this_emg_export_files = emg_export_files(emg_export_file_index);
    emg_data = readtable([this_emg_export_files.folder,filesep,this_emg_export_files.name]);
    
    emg_mapping = subject_settings.settings_struct.emg_mapping;
    
    emg_data_headers = emg_data.Properties.VariableNames;
    
    for this_emg_channel = 1:length(emg_mapping)
        emg_relevant_indices(this_emg_channel) = find(contains(emg_data_headers,emg_mapping{this_emg_channel,1}));
    end
    
    emg_sync_pulse = [emg_sync_pulse; table2array(emg_data(:,2))];
    if ~isempty(all_time_emg)
        all_time_emg = [all_time_emg; table2array(emg_data(:,1)) + all_time_emg(end)];
    else
        all_time_emg = [all_time_emg; table2array(emg_data(:,1))];
    end
    sampling_rate_emg = length(all_time_emg)/all_time_emg(end);
    raw_emg_trajectories = [raw_emg_trajectories; table2array(emg_data(:,emg_relevant_indices))];
end


% define filters
% initial low pass filter
filter_order_low = 4;
% cutoff_frequency_low = subject_settings.get('emg_cutoff_frequency_low', 1);
cutoff_frequency_low = 1;
[b_low, a_low] = butter(filter_order_low, cutoff_frequency_low/(sampling_rate_emg/2), 'low');

% high pass filter at 20 hz to get rid of DC offset
filter_order_high = 4;
cutoff_frequency_high = 20; % in Hz
[b_high, a_high] = butter(filter_order_high, cutoff_frequency_high/(sampling_rate_emg/2), 'high');

emg_trajectories_preRect_low = nanfiltfilt(b_low, a_low, raw_emg_trajectories);
emg_trajectories_preRect_high = nanfiltfilt(b_high, a_high, emg_trajectories_preRect_low);

% low pass filter below 10 Hz -- aggressive smoothing after rectification
filter_order_final = 4;
cutoff_frequency_final = 6; % in Hz
[b_final, a_final] = butter(filter_order_final, cutoff_frequency_final/(sampling_rate_emg/2), 'low');

% rectify, then filter
emg_trajectories_rectified = abs(emg_trajectories_preRect_high);
all_emg_trajectories = nanfiltfilt(b_final, a_final, emg_trajectories_rectified);


emg_sync_pulse_triggers = find(diff(emg_sync_pulse)>100);


% need to find the stretches in between triggers that are 30 seconds long..
% should be the same number as trials_completed ... need to implement
% something in subject_settings that excludes triggers around a certain
% time (or a gui that requires manual deletion)

start_indices = [];
end_indices = [];
ignore_triggers = subject_settings.settings_struct.ignore_triggers;
figure; hold on;
    plot(all_time_emg,emg_sync_pulse)

for this_trigger = 2:length(emg_sync_pulse_triggers)
    this_trigger_diff = round(all_time_emg(emg_sync_pulse_triggers(this_trigger)) - all_time_emg(emg_sync_pulse_triggers(this_trigger-1)));
    if this_trigger_diff == 30
        start_indices = [start_indices; emg_sync_pulse_triggers(this_trigger-1)];
        end_indices = [end_indices; emg_sync_pulse_triggers(this_trigger)];
        if ignore_triggers(length(start_indices)) % ignoring the start_indices that overlap with ignore_triggers
            plot(all_time_emg(emg_sync_pulse_triggers(this_trigger-1)),emg_sync_pulse(emg_sync_pulse_triggers(this_trigger-1)), '*','MarkerSize',8, 'MarkerEdgeColor','r');
        else
            plot(all_time_emg(emg_sync_pulse_triggers(this_trigger-1)),emg_sync_pulse(emg_sync_pulse_triggers(this_trigger-1)), '*','MarkerSize',8, 'MarkerEdgeColor','g');
        end
    end
end
start_indices(find(ignore_triggers)) = []; % ignoring the start_indices that overlap with ignore_triggers
end_indices(find(ignore_triggers)) = [];

trial_indices = find(trials_completed);
for i_trial = 1:sum(trials_completed)
    this_trial_index = trial_indices(i_trial);
    emg_trajectories = all_emg_trajectories(start_indices(this_trial_index):end_indices(this_trial_index)); 
    time_emg = all_time_emg(start_indices(this_trial_index):end_indices(this_trial_index));
    
    emg_data_filename = strcat(collection_date,'_',subject_code,'_',num2str(this_trial_index),'_EMGdata','.mat');
    save(fullfile('processed',emg_data_filename),'emg_trajectories','time_emg','sampling_rate_emg')
    disp(['saving', ' ',emg_data_filename])
end



% read the vr behave data and store in processed folder
for i_trial = 1:size(csv_condition_data,1)
    if trials_completed(i_trial)
        conditions_cell.posture(end+1) = cellstr(csv_condition_data.experimental_conditions1(i_trial));
        conditions_cell.type(end+1) = cellstr(csv_condition_data.experimental_conditions2(i_trial));
        conditions_cell.difficulty(end+1) = {csv_condition_data.experimental_conditions3(i_trial)};
        
        % read the txt
        vr_data_file = dir(fullfile('raw','vr',strcat('*',subject_code,'_',num2str(i_trial),'.txt')));
        vr_data = readtable([vr_data_file.folder,filesep,vr_data_file.name]);
%         vr_data.boat_angle;
        
        vr_data_file = strsplit(vr_data_file.name,'.');
        save(fullfile('processed',strcat(vr_data_file{1},'_VRdata','.mat')),'vr_data')
        disp(['saving', ' ',strcat(vr_data_file{1},'_VRdata','.mat')])
    end
end

save(fullfile('processed','conditions_cell.mat'),'conditions_cell')




end
