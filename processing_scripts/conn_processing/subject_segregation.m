function subject_segregation(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'project_name', 'conn_project')
addParameter(parser, 'roi_settings', '')
% addParameter(parser, 'group_names', '')
% addParameter(parser, 'group_ids', '')
parse(parser, varargin{:})
project_name = parser.Results.project_name;
roi_settings = parser.Results.roi_settings;
% group_names = parser.Results.group_names;
% group_ids = parser.Results.group_ids;

load([project_name filesep 'subject_ids'])

project_path = pwd;

wdir = strcat(project_path, filesep, project_name, filesep, 'results', filesep, 'firstlevel');% 'C:/Users/Raphael/Desktop/These/conn_example/results/secondlevel';
corr_net = 'SBC_01'; % this may change

first_level_corr_folder = strcat(wdir, filesep, corr_net);

corr_file_dir = dir([strcat(first_level_corr_folder, filesep, 'ResultsROI_Subject*.mat')]);
clear roi_file_name_list;
[available_subject_file_name_list{1:length(corr_file_dir)}] = deal(corr_file_dir.name);

for i_subject = 1 : length(available_subject_file_name_list)
    this_subject_data = load(strcat(first_level_corr_folder, filesep, available_subject_file_name_list{i_subject}));

    average_total_conn(i_subject) = mean(nanmean(this_subject_data.Z));
end
%for i_subject = 1 : length(avail_subject_file_name_list)
    
    

figure;
bar(1:length(subjects), average_total_conn)
title('Total ROI Connectivity')
ylabel('Average Connectivity (?)')
set(gca,'xticklabel',subjects)
% set(gca,'ylabel', 'Average Connectivity between ROIs (?)')

if ~isempty(roi_settings)
    file_name = roi_settings;
    
    fileID = fopen(file_name, 'r');
    
    % read text to cell
    text_line = fgetl(fileID);
    text_cell = {};
    while ischar(text_line)
        text_cell = [text_cell; text_line]; %#ok<AGROW>
        text_line = fgetl(fileID);
    end
    fclose(fileID);
    
    % prune lines
    lines_to_prune = false(size(text_cell, 1), 1);
    for i_line = 1 : size(text_cell, 1)
        this_line = text_cell{i_line};
        
        % remove initial white space
        while ~isempty(this_line) && (this_line(1) == ' ' || double(this_line(1)) == 9)
            this_line(1) = [];
        end
        settings_cell{i_line} = this_line; %#ok<AGROW>
        
        % remove comments
        if length(this_line) > 1 && any(ismember(this_line, '#'))
            lines_to_prune(i_line) = true;
        end
        
        % flag lines consisting only of white space
        if all(ismember(this_line, ' ') | double(this_line) == 9)
            lines_to_prune(i_line) = true;
        end
        
    end
    settings_cell(lines_to_prune) = [];
    
    roi_dir = dir([strcat('rois', filesep,'*.nii')]);
    clear roi_file_name_list;
    [available_roi_file_name_list{1:length(roi_dir)}] = deal(roi_dir.name);
    
    for this_roi_index = 1:length(settings_cell)
        this_roi_settings_line = strsplit(settings_cell{this_roi_index}, ',');
        this_roi_core_name = this_roi_settings_line{1};
        this_roi_network = this_roi_settings_line{5};
        
        % TO DO: 
        % 1) determine the number of unique networks
        % 2) grab the correlation values for ROIs within each network
        % 3) Eq: (AvgWithinNetworkCorr - AvgBetweenNetworkCorr) /
        % AvgWithinNetworkCorr (see Cassady2020)
    end
    %identifying the networks within the subject data below -
    %troubleshooting best way to do that
    for this_subject_index = 1:length(this_subject_data.Z)
       sensorimotor_hand = this_subject_data.Z(1:30);
       visual = this_subject_data.Z(31:61);
       sensorimotor_mouth = this_subject_data.Z(62:66);
       auditory = this_subject_data.Z(67:79);
       default_mode = this_subject_data.Z(80:135);
       front_parietal_task_control = this_subject_data.Z(148:162);
       ventral_attention = this_subject_data.Z(163:171);
       cingulo_opercular_control = this_subject_data.Z(172:185);
       dorsal_attention = this_subject_data.Z(186:196);
       salience = this_subject_data.Z(197:212);
    end
    sensorimotor_hand1 = sensorimotor_hand(~isnan(sensorimotor_hand_connectivity));
    visual1 = visual(~isnan(visual_connectivity));
    sensorimotor_mouth1 = sensorimotor_mouth(~isnan(sensorimotor_mouth_connectivity));
    auditory1 = auditory(~isnan(auditory_connectivity));
    default_mode1 = default_mode(~isnan(default_mode_connectivity));
    fronto_parietal_task_control1 = fronto_parietal_task_control(~isnan(fronto_parietal_task_control));
    ventral_attention1 = ventral_attention(~isnan(ventral_attention));
    cingulo_opercular_control1 = cingulo-opercular_control(~isnan(cingulo-opercular_control));
    dorsal_attention1 = dorsal_attention(~isnan(dorsal_attention));
    salience1 = salience(~isnan(salience));
    
    mean_sensorimotor_hand_conn = mean(sensorimotor_hand_connectivity)
    mean_visual_conn = mean(visual_connectivity)
    mean_sensorimotor_mouth_conn = mean(sensorimotor_mouth_connectivity)
    mean_auditory_conn = mean(auditory_connectivity)
    mean_default_mode_conn = mean(default_mode_connectivity)
    mean_fronto_parietal_task_control_conn = mean(fronto_parietal_task_control)
    mean_ventral_attention_conn = mean(ventral_attention)
    mean_cingulo_opercular_control_conn = mean(cingulo_opercular_control)
    mean_dorsal_attention_conn = mean(dorsal_attention)
    mean_salience = mean(salience)   
       
       

       
        
            
end

end
