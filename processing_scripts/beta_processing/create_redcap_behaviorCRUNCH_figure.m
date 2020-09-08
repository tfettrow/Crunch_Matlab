
% roi_results figure generation
clear,clc
% close all

task_folder={'05_MotorImagery'};  
% task_folder={'06_Nback'};  
subjects = {'1002', '1004', '1010', '1011','1013'}; % need to figure out how to pass cell from shell
% subjects =  {'2002','2007','2008','2012','2013','2015','2018','2020','2021','2022','2023','2025','2026'};

Results_filename='CRUNCH_secondorder_max.mat';

no_labels = 0;

data_path = pwd;
subject_color_matrix = distinguishable_colors(length(subjects));

headers={'subject_id', 'sppb_balance', 'sppb_speed', 'sppb_stand', 'sppb_total','400m'};
walking_data = xlsread(fullfile(data_path,'spreadsheet_data','walking_data','walking_data.xlsx'));
% headers={'subject_id','PainThreshold_Average','PainInventory_Average','Tactile_Mono','Tactile_Dual'};
% sensory_data = xlsread('sensory_data.xlsx');


for this_subject_index = 1 : length(subjects)
    subj_results_dir = fullfile(data_path, subjects{this_subject_index}, 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain');
    if any(strcmp(task_folder, '05_MotorImagery'))
        task='MotorImagery';
    else any(strcmp(task_folder, '06_Nback'))
        task='Nback';
    end
    
    % loading and grabbing data
    load(char(strcat(subj_results_dir,filesep,strcat(subjects{this_subject_index},'_',task,'_',Results_filename)))); 
    this_subject_row_walking_data = find(strcmp(string(walking_data(:,1)), subjects{this_subject_index}));
    this_subject_400m_data = walking_data(this_subject_row_walking_data,6);
       
    % plot
    this_figure_number = 1;
    for this_roi_index = 1 : length(unique_rois)       
        if any(strcmp(task_folder, '05_MotorImagery'))
            subplot(1, 4, this_figure_number); hold on;
            plot(this_subject_400m_data, crunchpoint_percent(this_roi_index), 'o', 'MarkerEdge', 'k', 'MarkerFace', 'r')
            this_figure_number = this_figure_number+1;
        else any(strcmp(task_folder, '06_Nback'))
            subplot(1, 4, this_figure_number);
            plot(this_subject_400m_data, crunchpoint_percent1(this_roi_index), 'o', 'MarkerEdge', 'k', 'MarkerFace', 'r')
            plot(this_subject_400m_data, crunchpoint_percent2(this_roi_index), 'o', 'MarkerEdge', 'k', 'MarkerFace', 'b')
            this_figure_number = this_figure_number+1;
        end
        title([unique_rois(this_roi_index)],'interpreter','latex')
    end
end