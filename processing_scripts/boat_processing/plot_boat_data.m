%% this script is intended to be run from the study folder 
% 1) go into this subject processed folder and for each posture
% a) create a fig for each trial type (percept and control) and plot the
% boat angle and joystick value for each difficulty level

% TO DO:
% check for lenght of cells and number of files .. if not same then problem

function plot_boat_data(varargin)
% parser = inputParser;
% parser.KeepUnmatched = true;
% % setup defaults in case no arguments specified
% addParameter(parser, 'subjects', '')
% parse(parser, varargin{:})
current_path = pwd;

path_split = strsplit(current_path, filesep);
subject_code = path_split{end};

load(fullfile('processed','conditions_cell.mat'))

[~, unique_postures] = findgroups(conditions_cell.posture);

processed_data_files = dir(fullfile('processed',strcat('*',subject_code,'*','.mat')));

for this_posture = unique_postures
    this_posture_control_fig = figure;
    this_posture_percept_fig = figure;
    
    this_posture_indices = find(contains(conditions_cell.posture,this_posture));
    
    for this_processed_data_file_index = this_posture_indices
        load(fullfile('processed',processed_data_files(this_processed_data_file_index).name))
        
        trial_type = conditions_cell.type{this_processed_data_file_index};
        difficulty = conditions_cell.difficulty{this_processed_data_file_index};
        
        % if preprocessing is done properly should read EMG then VR .mat
        % file.. 
%         1) need to read in both for a given trial..
%         2) plot raw trial_boat_data, .. plot(trial_data.boat_angle)
%         trial_data.joystick_value and emg data (for each muscle)
%         3) calculate the psd for every signal, and plot
%         4) calculate the gain and phase of every signal wrt trial_data.boat_angle

        % need difficulty represented somehow
        if strcmp(trial_type,'percept')
            this_posture_percept_fig; hold on;
        else
            this_posture_control_fig; hold on;
        end
        if difficulty == 0 
            plot(trial_data.time_stamp,trial_data.boat_angle,'-g','LineWidth',3)
        elseif difficulty == 5
            plot(trial_data.time_stamp,trial_data.boat_angle,'-y','LineWidth',3)
        elseif difficulty == 10
            plot(trial_data.time_stamp,trial_data.boat_angle,'-b','LineWidth',3)
        else
            plot(trial_data.time_stamp,trial_data.boat_angle,'-r','LineWidth',3)
        end
    end
end
