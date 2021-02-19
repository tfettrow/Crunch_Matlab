function plot_CAT12_results(varargin)
% plot_CAT12_results('task_folder', '05_MotorImagery', 'subjects',
% plot_CAT12_results('task_folder', '02_T1', 'subjects', {'1002','1004','1007','1009','1010','1011','1013','1020','1022','1027','1024','2021','2015','2002','2018','2017','2012','2025','2020','2026','2023','2022','2007','2013','2008','2033','2034','2037','2052','2042','3004','3006','3007','3008'},'group_names',{'YA' 'hOA' 'lOA'},'group_ids',[1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3],'save_figures',0, 'no_labels', 0)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'task_folder', '')
addParameter(parser, 'subjects', '')
addParameter(parser, 'group_names', '')
addParameter(parser, 'group_ids', '')
addParameter(parser, 'no_labels', 0)
addParameter(parser, 'save_figures', 0)
addParameter(parser, 'save_scores', 0)
parse(parser, varargin{:})
subjects = parser.Results.subjects;
task_folder = parser.Results.task_folder;
group_names = parser.Results.group_names;
group_ids = parser.Results.group_ids;
no_labels = parser.Results.no_labels;
save_figures = parser.Results.save_figures;
save_scores = parser.Results.save_scores;

close all;
project_path = pwd;
group_color_matrix = distinguishable_colors(length(group_names));

for this_subject_index = 1 : length(subjects)
    subj_results_dir = fullfile(project_path, subjects{this_subject_index}, 'Processed', 'MRI_files', task_folder, 'CAT12_Analysis', 'mri', strcat(subjects{this_subject_index},'_struct_roi_vols.csv'));
    
    fileID = fopen(subj_results_dir);
    
    data = textscan(fileID,'%s','delimiter',',','headerlines',0);
    data = reshape(data{:},length(data{1})/2,2);
    for this_beta = 3:length(data)
        split_condition_name = strsplit(data{this_beta,1},'_');
        % WARNING: reading roi names and overwriting (per subject) may be
        % an issue if different subjs have different roi results files...
        % need to write a buffer for this..
        roi_names{this_beta-2} = data{this_beta,1};
        vol_results(this_subject_index,this_beta-2) = str2num(data{this_beta,2});
    end

end

for this_roi_index = 1: length(roi_names)
    subplot(1, 3, this_roi_index); hold on;
    for this_group_index = 1 : length(group_names)
        this_group_subjectindices = find(group_ids==this_group_index);
        this_group_and_roi_vol_results = vol_results(this_group_subjectindices,this_roi_index);

        
        singleBoxPlot(this_group_and_roi_vol_results,'abscissa', this_group_index, 'EdgeColor',group_color_matrix(this_group_index,:), 'MarkerColor',group_color_matrix(this_group_index,:),'WiskColor',group_color_matrix(this_group_index,:), 'MeanColor',group_color_matrix(:,this_group_index), 'EdgeLinewidth', 1, 'WiskLinewidth', 1, 'MeanLinewidth', 1 )
           
%         bar(this_group_index, mean(this_group_and_roi_vol_results),'facecolor',group_color_matrix(:,this_group_index))
%         errorbar(this_group_index, mean(this_group_and_roi_vol_results), std(this_group_and_roi_vol_results)/nnz(this_group_subjectindices), 'k'); hold on;
        
        %         boxplot(this_group_and_roi_vol_results, this_group_index);
    end
    xlim([ 0 length(this_group_index+1)])
    title([roi_names(this_roi_index)],'interpreter','latex')
    xlim([0 length(group_names)+1])
    ylim([0 1])
    ylabel('Grey Matter Volume/Intensity')
    set(gca,'XTick',1:length(group_names),'xticklabel',{'YA','high-OA','low-OA'},'TickLabelInterpreter','none')
    xtickangle(45)
    set(gcf, 'ToolBar', 'none');
    set(gcf, 'MenuBar', 'none');
    if no_labels
        set(get(gca, 'xlabel'), 'visible', 'off');
        set(get(gca, 'ylabel'), 'visible', 'off');
        set(get(gca, 'title'), 'visible', 'off');
        legend(gca, 'hide');
    end
    if save_figures
        fig_title = 'groups_roi_gmv';
        filename =  fullfile(project_path, 'figures', fig_title);
        saveas(gca, filename, 'tiff')
    end
end
if save_scores
   subject_table = array2table(subjects');
   subject_table.Properties.VariableNames = {'subject_ids'};
   
%    group_table = array2table(group_ids');
%    group_table.Properties.VariableNames = {'group_ids'};
   
   vol_cell_table = array2table(vol_results);
   vol_cell_table.Properties.VariableNames = roi_names;
   
%    vol_results_table = [subject_table, vol_cell_table, group_table];
   vol_results_table = [subject_table, vol_cell_table];
   
   writetable(vol_results_table,fullfile(project_path,'spreadsheet_data','vol_score.csv'))
end


end