% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

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

wdir = strcat(project_path, filesep, project_name, filesep, 'results', filesep, 'firstlevel');
corr_net = 'SBC_01'; % WARNING: this may change

first_level_corr_folder = strcat(wdir, filesep, corr_net);

corr_file_dir = dir([strcat(first_level_corr_folder, filesep, 'ResultsROI_Subject*.mat')]);
clear roi_file_name_list;
[available_subject_file_name_list{1:length(corr_file_dir)}] = deal(corr_file_dir.name);

for i_subject = 1 : length(available_subject_file_name_list)
    this_subject_data = load(strcat(first_level_corr_folder, filesep, available_subject_file_name_list{i_subject}));

    average_total_conn(i_subject) = mean(nanmean(this_subject_data.Z));
end

figure;
bar(1:length(subjects), average_total_conn)
title('Total ROI Connectivity')
ylabel('Average Connectivity (?)')
set(gca,'xticklabel',subjects)
% set(gca,'ylabel', 'Average Connectivity between ROIs (?)')

if isempty(roi_settings)
   error('need an roi settings file for this analysis') 
end
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
    roi_core_name_cell{this_roi_index} = this_roi_settings_line{1};
    roi_network_cell{this_roi_index} = this_roi_settings_line{6};
end

unique_networks = unique(roi_network_cell);

for this_unique_network_index = 1:length(unique_networks)
    this_unique_network_occurences = contains(roi_network_cell, unique_networks(this_unique_network_index));
    this_unique_network_indices = find(this_unique_network_occurences);
    roi_pairs_this_unique_network = nchoosek(this_unique_network_indices,2);
    
    for this_roi_pair = 1:size(roi_pairs_this_unique_network,1)
        within_network_corr_cell{this_unique_network_index, this_roi_pair} = this_subject_data.Z(roi_pairs_this_unique_network(this_roi_pair,1), roi_pairs_this_unique_network(this_roi_pair,2));
    end
end
end
