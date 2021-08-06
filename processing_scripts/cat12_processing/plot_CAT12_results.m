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
addParameter(parser, 'roi_type', '')
addParameter(parser, 'data_type', 'intensity')
addParameter(parser, 'save_figures', 0)
addParameter(parser, 'save_scores', 0)
parse(parser, varargin{:})
subjects = parser.Results.subjects;
task_folder = parser.Results.task_folder;
group_names = parser.Results.group_names;
group_ids = parser.Results.group_ids;
no_labels = parser.Results.no_labels;
roi_type = parser.Results.roi_type;
data_type = parser.Results.data_type;
save_figures = parser.Results.save_figures;
save_scores = parser.Results.save_scores;

% close all;
project_path = pwd;
group_color_matrix = distinguishable_colors(length(group_names));

for this_subject_index = 1 : length(subjects)
    subj_results_dir = fullfile(project_path, subjects{this_subject_index}, 'Processed', 'MRI_files', task_folder,'CAT12_Analysis'); 
    
    if strcmp(roi_type, 'subject')
        if strcmp(data_type, 'intensity')
            gmv_results_dir = fullfile(subj_results_dir, 'mri', strcat('subj_',subjects{this_subject_index},'_gmv_roi_intensities.csv'));
        elseif strcmp(data_type, 'volume')
            gmv_results_dir = fullfile(subj_results_dir, 'mri', strcat('subj_',subjects{this_subject_index},'_gmv_roi_volumes.csv'));
        end
    elseif strcmp(roi_type, 'mni')
        if strcmp(data_type, 'intensity')
            gmv_results_dir = fullfile(subj_results_dir, 'mri', strcat('mni_',subjects{this_subject_index},'_gmv_roi_intensities.csv'));
        elseif strcmp(data_type, 'volume')
            gmv_results_dir = fullfile(subj_results_dir, 'mri', strcat('mni_',subjects{this_subject_index},'_gmv_roi_volumes.csv'));
        end
    end
    
    
    % read tiv info
    this_subject_tiv_file = spm_select('FPList', strcat(subj_results_dir,filesep), strcat('^','TIV.txt','$'));
    volume_data = load(this_subject_tiv_file);
    tiv_data(this_subject_index) = volume_data(1);
    
    fileID = fopen(gmv_results_dir);
    
    data = textscan(fileID,'%s','delimiter',',','headerlines',0);
    fclose(gmv_results_dir);
    data_reshaped = reshape(data{:},length(data{1})/2,2);
    for this_beta = 3:length(data_reshaped)
        split_condition_name = strsplit(data_reshaped{this_beta,1},'_');
        % WARNING: reading roi names and overwriting (per subject) may be
        % an issue if different subjs have different roi results files...
        % need to write a buffer for this..
        roi_names{this_beta-2} = data_reshaped{this_beta,1};
        vol_results(this_subject_index,this_beta-2) = str2num(data_reshaped{this_beta,2});
        vol_results_corrected(this_subject_index,this_beta-2) = str2num(data_reshaped{this_beta,2})/tiv_data(this_subject_index);   
    end

end

for this_roi_index = 1: length(roi_names)
%     subplot(1, 3, this_roi_index); hold on;
    figure; hold on;
    for this_group_index = 1 : length(group_names)
        this_group_subjectindices = find(group_ids==this_group_index);
        this_group_and_roi_vol_results = vol_results(this_group_subjectindices,this_roi_index);
        
        singleBoxPlot(this_group_and_roi_vol_results,'abscissa', this_group_index, 'EdgeColor',group_color_matrix(this_group_index,:), 'MarkerColor',group_color_matrix(this_group_index,:),'WiskColor',group_color_matrix(this_group_index,:), 'MeanColor',group_color_matrix(this_group_index,:))
          
    end
    xlim([ 0 length(this_group_index+1)])
    title([roi_names(this_roi_index)],'interpreter','latex')
    xlim([0 length(group_names)+1])
    
    if strcmp(data_type, 'intensity')
        ylabel('Avg Intensity')
    elseif strcmp(data_type, 'volume')
        ylabel('Volume (ml)')
    end
    
    set(gca,'XTick',1:length(group_names),'xticklabel',{'YA','high-OA','low-OA'},'TickLabelInterpreter','none','FontSize',16)
    xtickangle(45)
    if no_labels
        set(gcf, 'ToolBar', 'none');
        set(gcf, 'MenuBar', 'none');
        set(get(gca, 'xlabel'), 'visible', 'off');
        set(get(gca, 'ylabel'), 'visible', 'off');
        set(get(gca, 'title'), 'visible', 'off');
        legend(gca, 'hide');
    end
    if save_figures
        if strcmp(data_type, 'intensity')
            fig_title = strcat(roi_names{this_roi_index},'_gmv_intensity');
        elseif strcmp(data_type, 'volume')
            fig_title = strcat(roi_names{this_roi_index},'_gmv_volume');
        end
        
        filename =  fullfile(project_path, 'figures', fig_title);
        saveas(gca, filename, 'tiff')
    end
end

    for this_roi_index = 1: length(roi_names)
        %     subplot(1, 3, this_roi_index); hold on;
        figure; hold on;
        for this_group_index = 1 : length(group_names)
            this_group_subjectindices = find(group_ids==this_group_index);
            this_group_and_roi_vol_results_corrected = vol_results_corrected(this_group_subjectindices,this_roi_index);
            
            singleBoxPlot(this_group_and_roi_vol_results_corrected,'abscissa', this_group_index, 'EdgeColor',group_color_matrix(this_group_index,:), 'MarkerColor',group_color_matrix(this_group_index,:),'WiskColor',group_color_matrix(this_group_index,:), 'MeanColor',group_color_matrix(this_group_index,:))
        end
        
        xlim([ 0 length(this_group_index+1)])
        title([roi_names(this_roi_index)],'interpreter','latex')
        xlim([0 length(group_names)+1])
        
        if strcmp(data_type, 'intensity')
            ylabel('Avg Intensity / TIV')
        elseif strcmp(data_type, 'volume')
             ylabel('Volume / TIV')
        end
        
        set(gca,'XTick',1:length(group_names),'xticklabel',{'YA','high-OA','low-OA'},'TickLabelInterpreter','none','FontSize',16)
        xtickangle(45)
        if no_labels
            set(gcf, 'ToolBar', 'none');
            set(gcf, 'MenuBar', 'none');
            set(get(gca, 'xlabel'), 'visible', 'off');
            set(get(gca, 'ylabel'), 'visible', 'off');
            set(get(gca, 'title'), 'visible', 'off');
            legend(gca, 'hide');
        end
        if save_figures
            if strcmp(data_type, 'intensity')
                fig_title = strcat(roi_names{this_roi_index},'_gmv_intensity_corrected');
            elseif strcmp(data_type, 'volume')
                fig_title = strcat(roi_names{this_roi_index},'_gmv_volume_corrected');
            end
            
            filename =  fullfile(project_path, 'figures', fig_title);
            saveas(gca, filename, 'tiff')
        end
    end


    if save_scores
        subject_table = array2table(subjects');
        subject_table.Properties.VariableNames = {'subject_ids'};
        
        vol_cell_table = array2table(vol_results);
        vol_cell_table.Properties.VariableNames = roi_names;
        vol_results_table = [subject_table, vol_cell_table];
        if strcmp(data_type, 'intensity')
            writetable(vol_results_table,fullfile(project_path,'spreadsheet_data','gmv_intensity_score.csv'))
        elseif strcmp(data_type, 'volume')
            writetable(vol_results_table,fullfile(project_path,'spreadsheet_data','gmv_volume_score.csv'))
        end
        
        volTIVcorreted_cell_table = array2table(vol_results_corrected);
        volTIVcorreted_cell_table.Properties.VariableNames = roi_names;
        volTIVcorrected_results_table = [subject_table, volTIVcorreted_cell_table];
        if strcmp(data_type, 'intensity')
            writetable(volTIVcorrected_results_table,fullfile(project_path,'spreadsheet_data','gmv_intensityTIVcorrected_score.csv'))
        elseif strcmp(data_type, 'volume')
            writetable(volTIVcorrected_results_table,fullfile(project_path,'spreadsheet_data','gmv_volumeTIVcorrected_score.csv'))
        end
    end

end