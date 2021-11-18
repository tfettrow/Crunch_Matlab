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
addParameter(parser, 'results_foldername', '')
addParameter(parser, 'pvcorr', 0)
parse(parser, varargin{:})
subjects = parser.Results.subjects;
group_names = parser.Results.group_names;
group_ids = parser.Results.group_ids;
save_figures = parser.Results.save_figures;
results_foldername = parser.Results.results_foldername;
pvcorr = parser.Results.pvcorr;

project_path = pwd;
unique_groups = unique(group_ids);
color_groups = distinguishable_colors(length(unique_groups));

if isempty(results_foldername)
   error('need to specify results folder name (see arguments)') 
end

for this_subject_index = 1:length(subjects)
    this_subject_id = subjects{this_subject_index};
    if pvcorr
        gm_perf_data(this_subject_index) = load(fullfile(project_path,this_subject_id,'Processed','MRI_files','07_ASL',results_foldername,'native_space','pvcorr','perfusion_gm_mean.txt'));
        wm_perf_data(this_subject_index) = load(fullfile(project_path,this_subject_id,'Processed','MRI_files','07_ASL',results_foldername,'native_space','pvcorr','perfusion_wm_wm_mean.txt'));
        gm_perf_calib_data(this_subject_index) = load(fullfile(project_path,this_subject_id,'Processed','MRI_files','07_ASL',results_foldername,'native_space','pvcorr','perfusion_calib_gm_mean.txt'));
        wm_perf_calib_data(this_subject_index) = load(fullfile(project_path,this_subject_id,'Processed','MRI_files','07_ASL',results_foldername,'native_space','pvcorr','perfusion_wm_calib_wm_mean.txt'));
    else
        gm_perf_data(this_subject_index) = load(fullfile(project_path,this_subject_id,'Processed','MRI_files','07_ASL',results_foldername,'native_space','perfusion_gm_mean.txt'));
        wm_perf_data(this_subject_index) = load(fullfile(project_path,this_subject_id,'Processed','MRI_files','07_ASL',results_foldername,'native_space','perfusion_wm_mean.txt'));
        gm_perf_calib_data(this_subject_index) = load(fullfile(project_path,this_subject_id,'Processed','MRI_files','07_ASL',results_foldername,'native_space','perfusion_calib_gm_mean.txt'));
        wm_perf_calib_data(this_subject_index) = load(fullfile(project_path,this_subject_id,'Processed','MRI_files','07_ASL',results_foldername,'native_space','perfusion_calib_wm_mean.txt'));
    end
end

figure; hold on;
for this_group_index = 1 : length(group_names)
    this_group_subjectindices = find(group_ids==this_group_index);
    
    bar(this_group_subjectindices, gm_perf_data(end,this_group_subjectindices), 'FaceColor', color_groups(this_group_index,:)); hold on;
end

title('AVG GM CBF','interpreter','none', 'FontSize',18)
ylabel('AVG GM CBF (?)','interpreter','none')
set(gca,'XTick',1:length(subjects),'xticklabel',subjects,'TickLabelInterpreter','none')
xtickangle(45)
set(gcf, 'ToolBar', 'none');
set(gcf, 'MenuBar', 'none');

if save_figures
    fig_title = 'subjects_GM_CBF';
    filename =  fullfile(project_path, 'figures', fig_title);
    saveas(gca, filename, 'tiff')
end


figure; hold on;
for this_group_index = 1 : length(group_names)
    this_group_subjectindices = find(group_ids==this_group_index);
    
    bar(this_group_subjectindices, wm_perf_data(end,this_group_subjectindices), 'FaceColor', color_groups(this_group_index,:)); hold on;
end

title('AVG WM CBF','interpreter','none', 'FontSize',18)
ylabel('AVG WM CBF (?)','interpreter','none')
set(gca,'XTick',1:length(subjects),'xticklabel',subjects,'TickLabelInterpreter','none')
xtickangle(45)
set(gcf, 'ToolBar', 'none');
set(gcf, 'MenuBar', 'none');

if save_figures
    fig_title = 'subjects_WM_CBF';
    filename =  fullfile(project_path, 'figures', fig_title);
    saveas(gca, filename, 'tiff')
end


figure; hold on;
for this_group_index = 1 : length(group_names)
    this_group_subjectindices = find(group_ids==this_group_index);
    
    bar(this_group_subjectindices, gm_perf_calib_data(end,this_group_subjectindices), 'FaceColor', color_groups(this_group_index,:)); hold on;
end

title('AVG GM CALIB CBF','interpreter','none', 'FontSize',18)
ylabel('AVG GM CALIB CBF (?)','interpreter','none')
set(gca,'XTick',1:length(subjects),'xticklabel',subjects,'TickLabelInterpreter','none')
xtickangle(45)
set(gcf, 'ToolBar', 'none');
set(gcf, 'MenuBar', 'none');

if save_figures
    fig_title = 'subjects_GM_CALIB_CBF';
    filename =  fullfile(project_path, 'figures', fig_title);
    saveas(gca, filename, 'tiff')
end


figure; hold on;
for this_group_index = 1 : length(group_names)
    this_group_subjectindices = find(group_ids==this_group_index);
    
    bar(this_group_subjectindices, wm_perf_calib_data(end,this_group_subjectindices), 'FaceColor', color_groups(this_group_index,:)); hold on;
end

title('AVG WM CALIB CBF','interpreter','none', 'FontSize',18)
ylabel('AVG WM CALIB CBF (?)','interpreter','none')
set(gca,'XTick',1:length(subjects),'xticklabel',subjects,'TickLabelInterpreter','none')
xtickangle(45)
set(gcf, 'ToolBar', 'none');
set(gcf, 'MenuBar', 'none');

if save_figures
    fig_title = 'subjects_WM_CALIB_CBF';
    filename =  fullfile(project_path, 'figures', fig_title);
    saveas(gca, filename, 'tiff')
end


end



