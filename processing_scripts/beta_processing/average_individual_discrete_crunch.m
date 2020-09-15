function average_individual_discrete_crunch(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'task_folder', '')
addParameter(parser, 'subjects', '')
addParameter(parser, 'group_names', '')
addParameter(parser, 'group_ids', '')
addParameter(parser, 'no_labels', 0)
addParameter(parser, 'Results_filename', 'CRUNCH_discrete.mat')
parse(parser, varargin{:})
subjects = parser.Results.subjects;
group_names = parser.Results.group_names;
group_ids = parser.Results.group_ids;
task_folder = parser.Results.task_folder;
no_labels = parser.Results.no_labels;
Results_filename = parser.Results.Results_filename;
data_path = pwd;

subject_color_matrix = distinguishable_colors(length(group_names));
results = [];
for this_subject_index = 1 : length(subjects)
   subj_results_dir = fullfile(data_path, subjects{this_subject_index}, 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain');
    this_subject_roiResults_path = fullfile(data_path, subjects{this_subject_index}, 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain', strcat(subjects{this_subject_index},'_fmri_redcap.csv'));
    
    fileID = fopen(this_subject_roiResults_path);
    
    data = textscan(fileID,'%s','delimiter',',','headerlines',0);
    data = reshape(data{:},length(data{1})/2,2);
    
    for this_beta = 3:length(data)
        split_condition_name = strsplit(data{this_beta,1},'_');
        if any(strcmp(task_folder, '05_MotorImagery'))
            ordered_conditions{this_beta-2} = split_condition_name{1};
            roi_names{this_beta-2} = strcat(split_condition_name{2},'_',split_condition_name{3});
            ordered_beta{this_beta-2} = data{this_beta,2};
        elseif any(strcmp(task_folder, '06_Nback'))
            ordered_conditions{this_beta-2} = strcat(split_condition_name{1},'_',split_condition_name{2});
            roi_names{this_beta-2} = strcat(split_condition_name{3},'_',split_condition_name{4});
            ordered_beta{this_beta-2} = data{this_beta,2};
        end
    end
    unique_rois = unique(roi_names);

    for this_roi_index = 1 : length(unique_rois)
        this_roi_indices = find(strcmp(roi_names, unique_rois{this_roi_index}));
        
        temp = ordered_beta(:,this_roi_indices)';
        for i_beta= 1:length(temp)
            beta_values(:,i_beta) = sscanf(temp{i_beta},'%f');
        end
        if any(strcmp(task_folder, '05_MotorImagery'))
            all_results(this_subject_index,:,this_roi_index) = [beta_values];
        elseif any(strcmp(task_folder, '06_Nback'))
            all_results(this_subject_index,:,this_roi_index) = [beta_values];
        end
    end       
 end
    
    % if any(strcmp(task_folder, '05_MotorImagery'))
    %     task='MotorImagery';
    % else any(strcmp(task_folder, '06_Nback'))
    %     task='Nback';
    % end
    %
    
    for this_group_index = 1 : length(group_names)
        this_group_subjectindices = find(group_ids==this_group_index);
        this_figure_number = 1;
        for this_roi_index = 1 : length(unique_rois)
            this_group_and_roi_results = all_results(this_group_subjectindices,:,this_roi_index);
            group_avg_results(this_group_index,:,this_roi_index) = mean(this_group_and_roi_results,1);
            
            if strcmp(Results_filename, 'CRUNCH_discrete.mat')
                number_of_levels = [0 : 3];
            end
            
            subplot(1, 4, this_figure_number); hold on;
            
            if any(strcmp(task_folder, '05_MotorImagery'))
                plot(number_of_levels, group_avg_results(this_group_index,:,this_roi_index),'-o', 'MarkerFaceColor', subject_color_matrix(this_group_index, :), 'MarkerEdgeColor', subject_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',3, 'Color', subject_color_matrix(this_group_index, :))
            elseif any(strcmp(task_folder, '06_Nback'))
                plot(number_of_levels, group_avg_results(this_group_index,1:4,this_roi_index),'--o', 'MarkerFaceColor', (subject_color_matrix(this_group_index, :)+.2)*.5, 'MarkerEdgeColor', (subject_color_matrix(this_group_index, :)+.2)*.5,'MarkerSize', 5, 'LineWidth',3, 'Color',(subject_color_matrix(this_group_index, :)+.2)*.5 )
                plot(number_of_levels, group_avg_results(this_group_index,5:8,this_roi_index),'-o', 'MarkerFaceColor', subject_color_matrix(this_group_index, :), 'MarkerEdgeColor', subject_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',3, 'Color', subject_color_matrix(this_group_index, :))
            end
            xticks([number_of_levels])
            xlim([-1 4])
            title([unique_rois(this_roi_index)],'interpreter','latex')
            this_figure_number = this_figure_number + 1;
            ylabel('beta value')
        end
    end
    allYLim = [];
    for this_subplot = 1 : this_figure_number  - 1
        subplot(1, 4, this_subplot);
        if this_subplot > 1
            ylabel([])
        end
        
        h = findobj(gca,'Type','line');
        thisYLim = get(gca, 'YLim');
        allYLim = [allYLim thisYLim];
        
        if no_labels
            set(get(gca, 'xlabel'), 'visible', 'off');
            set(get(gca, 'ylabel'), 'visible', 'off');
            set(get(gca, 'title'), 'visible', 'off');
            set(gca, 'xticklabel', '');
            set(gca, 'yticklabel', '');
            legend(gca, 'hide');
        end
    end
end
