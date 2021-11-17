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

function plot_asl_meanresults(varargin)
% plot_fsl_histogram('subject','1002','roi_settings_filename','ROI_settings_MiMRedcap_CAT12_NewAcc.txt'
% WARNING: currently setup to require each group run seperately

parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'subjects', '')
addParameter(parser, 'group_names', '')
addParameter(parser, 'group_ids', '')
addParameter(parser, 'save_figures', 1)
parse(parser, varargin{:})
subjects = parser.Results.subjects;
group_names = parser.Results.group_names;
group_ids = parser.Results.group_ids;
save_figures = parser.Results.save_figures;

project_path = pwd;
unique_groups = unique(group_ids);
color_groups = distinguishable_colors(length(unique_groups));



for this_subject_index = 1:length(subjects)
    this_subject_id = subjects{this_subject_index};
    hist_data(:,this_subject_index) = load(fullfile(project_path,this_subject_id,'Processed','MRI_files','08_DWI',strcat('subj_',this_subject_id,'_',roi_network_cell{this_roi_index},'_histcount.csv')));
end

figure; hold on;
for this_group_index = 1 : length(group_names)
    this_group_subjectindices = find(group_ids==this_group_index);
    
    bar(this_group_subjectindices, hist_data(end,this_group_subjectindices), 'FaceColor', color_groups(this_group_index,:)); hold on;
    
end
    
title('AVG CBF','interpreter','none', 'FontSize',18)
ylabel('AVG CBF (?)','interpreter','none')
set(gca,'XTick',1:length(subjects),'xticklabel',subjects,'TickLabelInterpreter','none')
xtickangle(45)
set(gcf, 'ToolBar', 'none');
set(gcf, 'MenuBar', 'none');

if save_figures
    fig_title = strcat('subjects_','_',roi_network_cell{this_roi_index},'_DTIhistogram');
    filename =  fullfile(project_path, 'figures', fig_title);
    saveas(gca, filename, 'tiff')
end
end



