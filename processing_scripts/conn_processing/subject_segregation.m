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
%     for this_subject_index = 1:length(this_subject_data.Z)
%        sensorimotor_hand_connectivity = this_roi_core_name(1:30);
%        visual_connectivity = this_roi_core_name(31:61);
%        sensorimotor_mouth_connectivity = this_roi_core_name(62:66);
%        auditory_connectivity = this_roi_core_name(67:79);
%        default_mode_connectivity = this_roi_core_name(
       
        
            
end

end
