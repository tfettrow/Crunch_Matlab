%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.

function plot_cat12_histogram(varargin)
% plot_fsl_histogram('subject','1002','roi_settings_filename','ROI_settings_MiMRedcap_CAT12_NewAcc.txt'
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'subjects', '')
addParameter(parser, 'group_name', '')
addParameter(parser, 'roi_type', '')
addParameter(parser, 'roi_settings_filename', '')
addParameter(parser, 'save_figures', 1)
parse(parser, varargin{:})
subjects = parser.Results.subjects;
roi_type = parser.Results.roi_type;
group_name = parser.Results.group_name;
roi_settings_filename = parser.Results.roi_settings_filename;
save_figures = parser.Results.save_figures;

project_path = pwd;

if isempty(roi_settings_filename)
    error('need an roi settings file for this analysis')
end
file_name = roi_settings_filename;

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

for this_roi_index = 1:length(settings_cell)
    this_roi_settings_line = strsplit(settings_cell{this_roi_index}, ',');
    roi_core_name_cell{this_roi_index} = this_roi_settings_line{1};
    roi_network_cell{this_roi_index} = strtrim(this_roi_settings_line{4});
    
    this_fig = 1;
    for this_subject_index = 1:length(subjects)
        this_subject_id = subjects{this_subject_index};

        if strcmp(roi_type, 'subject')
            loaded_data = load(fullfile(project_path,this_subject_id,'Processed','MRI_files','02_T1','CAT12_Analysis','mri',strcat('subj_',this_subject_id,'_',roi_network_cell{this_roi_index},'_histcount.csv')));
        elseif strcmp(roi_type, 'mni')
            loaded_data = load(fullfile(project_path,this_subject_id,'Processed','MRI_files','02_T1','CAT12_Analysis','mri',strcat('mni_',this_subject_id,'_',roi_network_cell{this_roi_index},'_histcount.csv')));
        end
        
        [p,n]=numSubplots(length(subjects));
        subplot(p(1),p(2),this_fig);
        x_labels = {'0-.1', '.1-.2', '.2-.3', '.3-.4', '.4-.5', '.5-.6', '.6-.7', '.7-.8', '.8-.9', '.9-1.0'};
        bar(loaded_data);
        xticklabels(x_labels)
        ylabel('voxel counts')
        title(this_subject_id)
        this_fig=this_fig+1;
    end
    
    if save_figures
        fig_title = strcat(group_name,'_',roi_network_cell{this_roi_index},'_histogram');
        filename =  fullfile(project_path, 'figures', fig_title);
        MaximizeFigureWindow
        saveas(gca, filename, 'tif')
    end
end



