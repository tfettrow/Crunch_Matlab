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
%  plot_asl_meanresults('subjects', {'1002' '1004'  '1009' '1010'  '1013' '1018' '1019' '1020' '1022'  '1026' '1027' '2002' '2007' '2008' '2012' '2013' '2015' '2018' '2020' '2021' '2022' '2023' '2025' '2026' '2033' '2034' '2037' '2038' '2039' '2042' '2052' '2059' '2027' '3006' '3007' '3008' '3010' '3021' '3023' '3024' '3025' '3026' '3028' '3029' '3036' '3039' '3040' '3042' '3043' '3046' '3047' '3051' '3053' '3058' '3059' '3063' '3066' '3068'},'group_names',{'ya','hoa','loa'},'group_ids',[1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3],'save_figures',1, 'no_labels', 0, 'save_scores',0, 'results_foldername', 'BasilCMD_calib_anat_scalib_pvcorr', 'pvcorr', 0)

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
    this_group_and_roi_vol_results = gm_perf_data(end,this_group_subjectindices);
    
    singleBoxPlot(this_group_and_roi_vol_results,'abscissa', this_group_index, 'EdgeColor',color_groups(this_group_index,:), 'MarkerColor',color_groups(this_group_index,:),'WiskColor',color_groups(this_group_index,:), 'MeanColor',color_groups(this_group_index,:))
    
end
xlim([ 0 length(this_group_index+1)])
xlim([0 length(group_names)+1])

ylabel('Perfusion (ml/100g/min)')
set(gca, 'XTick',1:length(group_names),'xticklabel', group_names,'TickLabelInterpreter','none','FontSize',8)
%     set(gca,'XTick',1:length(group_names),'xticklabel',{'YA','high-OA','low-OA'},'TickLabelInterpreter','none','FontSize',16)
title('AVG GM CBF','interpreter','latex','FontSize',16)
xtickangle(45)
% if no_labels
%     set(gcf, 'ToolBar', 'none');
%     set(gcf, 'MenuBar', 'none');
%     set(get(gca, 'xlabel'), 'visible', 'off');
%     set(get(gca, 'ylabel'), 'visible', 'off');
%     set(get(gca, 'title'), 'visible', 'off');
%     legend(gca, 'hide');
% end
if save_figures
    fig_title = strcat('group_GM_CBF');
    
    filename =  fullfile(project_path, 'figures', fig_title);
    saveas(gca, filename, 'tiff')
end


figure; hold on;
for this_group_index = 1 : length(group_names)
    this_group_subjectindices = find(group_ids==this_group_index);
    
    bar(this_group_subjectindices, gm_perf_data(end,this_group_subjectindices), 'FaceColor', color_groups(this_group_index,:)); hold on;
end

set(gca,'XTick',1:length(subjects),'xticklabel',subjects, 'fontsize',8,'TickLabelInterpreter','none')
xtickangle(45)
set(gcf, 'ToolBar', 'none');
set(gcf, 'MenuBar', 'none');
title('AVG GM CBF','interpreter','none', 'FontSize',16)
ylabel('AVG GM CBF (ml/100g/min)','interpreter','none')

if save_figures
    MaximizeFigureWindow
    fig_title = 'subjects_GM_CBF';
    filename =  fullfile(project_path, 'figures', fig_title);
    saveas(gca, filename, 'tiff')
    close 
end



figure; hold on;
for this_group_index = 1 : length(group_names)
    this_group_subjectindices = find(group_ids==this_group_index);
    this_group_and_roi_vol_results = wm_perf_data(end,this_group_subjectindices);
    
    singleBoxPlot(this_group_and_roi_vol_results,'abscissa', this_group_index, 'EdgeColor',color_groups(this_group_index,:), 'MarkerColor',color_groups(this_group_index,:),'WiskColor',color_groups(this_group_index,:), 'MeanColor',color_groups(this_group_index,:))
    
end
xlim([ 0 length(this_group_index+1)])
xlim([0 length(group_names)+1])

ylabel('Perfusion (ml/100g/min)')
set(gca, 'XTick',1:length(group_names),'xticklabel', group_names,'TickLabelInterpreter','none','FontSize',8)
%     set(gca,'XTick',1:length(group_names),'xticklabel',{'YA','high-OA','low-OA'},'TickLabelInterpreter','none','FontSize',16)
title('AVG WM CBF','interpreter','latex','FontSize',16)
xtickangle(45)
% if no_labels
%     set(gcf, 'ToolBar', 'none');
%     set(gcf, 'MenuBar', 'none');
%     set(get(gca, 'xlabel'), 'visible', 'off');
%     set(get(gca, 'ylabel'), 'visible', 'off');
%     set(get(gca, 'title'), 'visible', 'off');
%     legend(gca, 'hide');
% end
if save_figures
    fig_title = strcat('group_WM_CBF');
    
    filename =  fullfile(project_path, 'figures', fig_title);
    saveas(gca, filename, 'tiff')
end


figure; hold on;
for this_group_index = 1 : length(group_names)
    this_group_subjectindices = find(group_ids==this_group_index);
    
    bar(this_group_subjectindices, wm_perf_data(end,this_group_subjectindices), 'FaceColor', color_groups(this_group_index,:)); hold on;
end

set(gca,'XTick',1:length(subjects),'xticklabel',subjects, 'FontSize',8,'TickLabelInterpreter','none')
xtickangle(45)
set(gcf, 'ToolBar', 'none');
set(gcf, 'MenuBar', 'none');
title('AVG WM CBF','interpreter','none', 'FontSize',16)
ylabel('AVG WM CBF (ml/100g/min)','interpreter','none')

if save_figures
     MaximizeFigureWindow
    fig_title = 'subjects_WM_CBF';
    filename =  fullfile(project_path, 'figures', fig_title);
    saveas(gca, filename, 'tiff')
end



figure; hold on;
for this_group_index = 1 : length(group_names)
    this_group_subjectindices = find(group_ids==this_group_index);
    this_group_and_roi_vol_results = gm_perf_calib_data(end,this_group_subjectindices);
    
    singleBoxPlot(this_group_and_roi_vol_results,'abscissa', this_group_index, 'EdgeColor',color_groups(this_group_index,:), 'MarkerColor',color_groups(this_group_index,:),'WiskColor',color_groups(this_group_index,:), 'MeanColor',color_groups(this_group_index,:))
    
end
xlim([ 0 length(this_group_index+1)])
xlim([0 length(group_names)+1])

ylabel('Perfusion Calib (ml/100g/min)')
set(gca, 'XTick',1:length(group_names),'xticklabel', group_names,'TickLabelInterpreter','none','FontSize',8)
%     set(gca,'XTick',1:length(group_names),'xticklabel',{'YA','high-OA','low-OA'},'TickLabelInterpreter','none','FontSize',16)
title('AVG GM CALIB CBF','interpreter','latex','FontSize',16)
xtickangle(45)
% if no_labels
%     set(gcf, 'ToolBar', 'none');
%     set(gcf, 'MenuBar', 'none');
%     set(get(gca, 'xlabel'), 'visible', 'off');
%     set(get(gca, 'ylabel'), 'visible', 'off');
%     set(get(gca, 'title'), 'visible', 'off');
%     legend(gca, 'hide');
% end
if save_figures
    fig_title = strcat('group_GM_calib_CBF');
    
    filename =  fullfile(project_path, 'figures', fig_title);
    saveas(gca, filename, 'tiff')
end

figure; hold on;
for this_group_index = 1 : length(group_names)
    this_group_subjectindices = find(group_ids==this_group_index);
    
    bar(this_group_subjectindices, gm_perf_calib_data(end,this_group_subjectindices), 'FaceColor', color_groups(this_group_index,:)); hold on;
end

set(gca,'XTick',1:length(subjects),'xticklabel',subjects, 'FontSize',8,'TickLabelInterpreter','none')
xtickangle(45)
set(gcf, 'ToolBar', 'none');
set(gcf, 'MenuBar', 'none');
title('AVG GM CALIB CBF','interpreter','none', 'FontSize',16)
ylabel('AVG GM CALIB CBF (ml/100g/min)','interpreter','none')

if save_figures
    MaximizeFigureWindow
    fig_title = 'subjects_GM_CALIB_CBF';
    filename =  fullfile(project_path, 'figures', fig_title);
    saveas(gca, filename, 'tiff')
end


figure; hold on;
for this_group_index = 1 : length(group_names)
    this_group_subjectindices = find(group_ids==this_group_index);
    this_group_and_roi_vol_results = wm_perf_calib_data(end,this_group_subjectindices);
    
    singleBoxPlot(this_group_and_roi_vol_results,'abscissa', this_group_index, 'EdgeColor',color_groups(this_group_index,:), 'MarkerColor',color_groups(this_group_index,:),'WiskColor',color_groups(this_group_index,:), 'MeanColor',color_groups(this_group_index,:))
    
end
xlim([ 0 length(this_group_index+1)])
xlim([0 length(group_names)+1])

ylabel('Perfusion Calib (ml/100g/min)')
set(gca, 'XTick',1:length(group_names),'xticklabel', group_names,'TickLabelInterpreter','none','FontSize',8)
%     set(gca,'XTick',1:length(group_names),'xticklabel',{'YA','high-OA','low-OA'},'TickLabelInterpreter','none','FontSize',16)
title('AVG WM CALIB CBF','interpreter','latex','FontSize',16)
xtickangle(45)
% if no_labels
%     set(gcf, 'ToolBar', 'none');
%     set(gcf, 'MenuBar', 'none');
%     set(get(gca, 'xlabel'), 'visible', 'off');
%     set(get(gca, 'ylabel'), 'visible', 'off');
%     set(get(gca, 'title'), 'visible', 'off');
%     legend(gca, 'hide');
% end
if save_figures
    fig_title = strcat('group_WM_calib_CBF');
    
    filename =  fullfile(project_path, 'figures', fig_title);
    saveas(gca, filename, 'tiff')
end

figure; hold on;
for this_group_index = 1 : length(group_names)
    this_group_subjectindices = find(group_ids==this_group_index);
    
    bar(this_group_subjectindices, wm_perf_calib_data(end,this_group_subjectindices), 'FaceColor', color_groups(this_group_index,:)); hold on;
end

set(gca,'XTick',1:length(subjects),'xticklabel',subjects, 'FontSize',8,'TickLabelInterpreter','none')
xtickangle(45)
set(gcf, 'ToolBar', 'none');
set(gcf, 'MenuBar', 'none');
title('AVG WM CALIB CBF','interpreter','none', 'FontSize',16)
ylabel('AVG WM CALIB CBF (ml/100g/min)','interpreter','none')

if save_figures
    MaximizeFigureWindow
    fig_title = 'subjects_WM_CALIB_CBF';
    filename =  fullfile(project_path, 'figures', fig_title);
    saveas(gca, filename, 'tiff')
end
end



