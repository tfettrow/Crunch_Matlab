function average_individual_discrete_crunch(varargin)
%%This function plots the average crunch curves. Please see the example input command to run the function
%Example command:
%average_individual_discrete_crunch('subjects',{'1002','1004','1007','1009','1010','1011','1013','1020','1022','1024','1027','2002','2007','2008','2012','2013','2015','2017','2018','2020','2021','2022','2023','2025','2026','2033','2034','2037','2042','2052'},'group_names',{'YA','OA'},'group_ids',[1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],'task_folder','05_MotorImagery','output_filename','CRUNCH_discete_roi_newacc.mat','beta_filename_extension','_fmri_roi_betas_newacc')
%change one of the plot_* commads to 1 to plot the specified graphs
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'task_folder', '')
addParameter(parser, 'subjects', '')
addParameter(parser, 'group_names', '')
addParameter(parser, 'group_ids', '')
addParameter(parser, 'no_labels', 0)
addParameter(parser, 'save_figures', 1)
addParameter(parser, 'plot_subjects', 0)
addParameter(parser, 'plot_percents', 0)
addParameter(parser, 'plot_averages', 0)
addParameter(parser, 'output_filename', '')
addParameter(parser, 'beta_filename_extension', '')
addParameter(parser, 'plot_groups_together',0)
addParameter(parser, 'no_crunch_separate',1)
parse(parser, varargin{:})
subjects = parser.Results.subjects;
group_names = parser.Results.group_names;
group_ids = parser.Results.group_ids;
task_folder = parser.Results.task_folder;
no_labels = parser.Results.no_labels;
plot_subjects = parser.Results.plot_subjects;
plot_percents = parser.Results.plot_percents;
plot_averages = parser.Results.plot_averages;
output_filename = parser.Results.output_filename;
save_figures = parser.Results.save_figures;
beta_filename_extension = parser.Results.beta_filename_extension;
plot_groups_together = parser.Results.plot_groups_together;
no_crunch_separate = parser.Results.no_crunch_separate;
data_path = pwd;

% need to distinguish based on subgropus if separate_by_crunch_type
% group_color_matrix = distinguishable_colors(length(group_names));
group_color_matrix = ones(length(group_names),1) *[17 17 17]/255;
% group_color_matrix(:,4) = .5*ones(size(group_color_matrix,1),1);

cr_results = {};
for this_subject_index = 1 : length(subjects)
    subj_results_dir = fullfile(data_path, subjects{this_subject_index}, 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain');
    this_subject_roiResults_path = fullfile(data_path, subjects{this_subject_index}, 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain', strcat(subjects{this_subject_index},beta_filename_extension,'.csv'));
    
    % grab crunch data
    if any(strcmp(task_folder, '05_MotorImagery'))
        task='MotorImagery';
        load(char(strcat(subj_results_dir,filesep,strcat(subjects{this_subject_index},'_',task,'_',output_filename))));
        cr_results = [cr_results; cr];
    elseif any(strcmp(task_folder, '06_Nback'))
        task='Nback';
        load(char(strcat(subj_results_dir,filesep,strcat(subjects{this_subject_index},'_',task,'_',output_filename))));
        cr_results = [cr_results; cr_1500 cr_500];
    end
    
    fileID = fopen(this_subject_roiResults_path);
    
    data = textscan(fileID,'%s','delimiter',',','headerlines',0);
    data = reshape(data{:},length(data{1})/2,2);
    for this_beta = 3:length(data)
        split_condition_name = strsplit(data{this_beta,1},'_');
        if any(strcmp(task_folder, '05_MotorImagery'))
            
            % loading and grabbing data
            ordered_conditions{this_beta-2} = split_condition_name{1};
            ordered_beta{this_beta-2} = data{this_beta,2};
            for this_roi_part = 2:length(split_condition_name)
                if this_roi_part == 2
                    roi_names{this_beta-2} = split_condition_name{this_roi_part};
                else
                    roi_names{this_beta-2} = strcat(roi_names{this_beta-2}, '_', split_condition_name{this_roi_part});
                end
            end
        elseif any(strcmp(task_folder, '06_Nback'))
            task='Nback';
            % loading and grabbing data
            ordered_conditions{this_beta-2} = strcat(split_condition_name{1},'_',split_condition_name{2});
            ordered_beta{this_beta-2} = data{this_beta,2};
            for this_roi_part = 3:length(split_condition_name)
                if this_roi_part == 3
                    roi_names{this_beta-2} = split_condition_name{this_roi_part};
                else
                    roi_names{this_beta-2} = strcat(roi_names{this_beta-2}, '_', split_condition_name{this_roi_part});
                end
            end
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
            beta_results(this_subject_index,:,this_roi_index) = [beta_values];
        elseif any(strcmp(task_folder, '06_Nback'))
            beta_results(this_subject_index,:,this_roi_index) = [beta_values];
        end
    end
end
%% plot individual subjects
if plot_subjects
    for this_group_index = 1 : length(group_names)
        close all;
        this_group_subjectindices = find(group_ids==this_group_index);
        this_group_subject_color_matrix = distinguishable_colors(length(this_group_subjectindices));
        if ~plot_groups_together
            if any(strcmp(task_folder, '05_MotorImagery'))
                figure; subplot(length(unique_rois), 3, 1);
            elseif any(strcmp(task_folder, '06_Nback'))
                figure; subplot(length(unique_rois), 3, 1);
                figure; subplot(length(unique_rois), 3, 1);
            end
        end
        %     summary_stats = [];
        % stuff for crunch tables
        this_group_crunch_results = cr_results(this_group_subjectindices,:,:);
        
        % makes logic easier below..
        this_group_crunch_results = cell2mat(this_group_crunch_results);
        
        this_figure_number = 1;
        for this_roi_index = 1 : length(unique_rois)
            this_group_and_roi_beta_results = beta_results(this_group_subjectindices,:,this_roi_index);
            
            number_of_levels = [0 : 3];
            
            if any(strcmp(task_folder, '05_MotorImagery'))
                cruncher_indices = find(this_group_crunch_results(:,this_roi_index) == 1 | this_group_crunch_results(:,this_roi_index) == 2);
                figure(this_group_index);
                subplot(length(unique_rois), 3, this_figure_number); hold on;
                if ~isempty(cruncher_indices)
                    for this_cruncher_index = 1 : length(cruncher_indices)
                        plot(number_of_levels, this_group_and_roi_beta_results(cruncher_indices(this_cruncher_index),:),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(cruncher_indices(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(cruncher_indices(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(cruncher_indices(this_cruncher_index), :))
                    end
                    if length(cruncher_indices)>1
                        p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(cruncher_indices,:)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.25;
                    end
                    figure(this_group_index);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('crunchers')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
            elseif any(strcmp(task_folder, '06_Nback'))
                cruncher_indices_1500 =  find(this_group_crunch_results(:,this_roi_index) == 1 | this_group_crunch_results(:,this_roi_index) == 2);
                cruncher_indices_500 = find(this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 1 | this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 2);
                
                if ~isempty(cruncher_indices_1500)
                    figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    for this_cruncher_index = 1 : length(cruncher_indices_1500)
                        plot(number_of_levels, this_group_and_roi_beta_results(cruncher_indices_1500(this_cruncher_index),1:4),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(cruncher_indices_1500(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(cruncher_indices_1500(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(cruncher_indices_1500(this_cruncher_index), :))
                    end
                    if length(cruncher_indices_1500)>1
                        figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                        p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(cruncher_indices_1500,1:4)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.25;
                    end
                    figure(this_group_index*2-1);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('crunchers')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
                if ~isempty(cruncher_indices_500)
                    figure(this_group_index*2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    for this_cruncher_index = 1 : length(cruncher_indices_500)
                        plot(number_of_levels, this_group_and_roi_beta_results(cruncher_indices_500(this_cruncher_index),5:8),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(cruncher_indices_500(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(cruncher_indices_500(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(cruncher_indices_500(this_cruncher_index), :))
                    end
                    
                    if length(cruncher_indices_500)>1
                        figure(this_group_index*2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                        p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(cruncher_indices_500,5:8)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.25;
                    end
                    figure(this_group_index*2);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('crunchers')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
                
            end
            
            % on to the next subplot
            this_figure_number = this_figure_number + 1;
            
            %increasing
            if any(strcmp(task_folder, '05_MotorImagery'))
                nocruncher_increasing_indices = find(this_group_crunch_results(:,this_roi_index) == 3);
                if ~isempty(nocruncher_increasing_indices)
                    figure(this_group_index);
                    subplot(length(unique_rois), 3, this_figure_number); hold on;
                    for this_cruncher_index = 1 : length(nocruncher_increasing_indices)
                        plot(number_of_levels, this_group_and_roi_beta_results(nocruncher_increasing_indices(this_cruncher_index),:),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(nocruncher_increasing_indices(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(nocruncher_increasing_indices(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(nocruncher_increasing_indices(this_cruncher_index), :))
                    end
                    if length(nocruncher_increasing_indices)>1
                        p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_increasing_indices,:)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.25;
                    end
                    figure(this_group_index);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('No crunchers (increasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
            elseif any(strcmp(task_folder, '06_Nback'))
                nocruncher_increasing_indices_1500 = find(this_group_crunch_results(:,this_roi_index) == 3);
                nocruncher_increasing_indices_500 = find(this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 3);
                if ~isempty(nocruncher_increasing_indices_1500)
                    figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    for this_cruncher_index = 1 : length(nocruncher_increasing_indices_1500)
                        plot(number_of_levels, this_group_and_roi_beta_results(nocruncher_increasing_indices_1500(this_cruncher_index),1:4),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(nocruncher_increasing_indices_1500(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(nocruncher_increasing_indices_1500(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(nocruncher_increasing_indices_1500(this_cruncher_index), :))
                    end
                    if length(nocruncher_increasing_indices_1500)>1
                        figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                        p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_increasing_indices_1500,1:4)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.25;
                    end
                    figure(this_group_index*2-1);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('No crunchers (increasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
                if ~isempty(nocruncher_increasing_indices_500)
                    figure(this_group_index*2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    for this_cruncher_index = 1 : length(nocruncher_increasing_indices_500)
                        plot(number_of_levels, this_group_and_roi_beta_results(nocruncher_increasing_indices_500(this_cruncher_index),5:8),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(nocruncher_increasing_indices_500(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(nocruncher_increasing_indices_500(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(nocruncher_increasing_indices_500(this_cruncher_index), :))
                    end
                    if length(nocruncher_increasing_indices_500)>1
                        figure(this_group_index*2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                        p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_increasing_indices_500,5:8)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.25;
                    end
                    
                    figure(this_group_index*2);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('No crunchers (increasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
            end
            % on to the next subplot
            this_figure_number = this_figure_number + 1;
            
            
            %decreasing
            if any(strcmp(task_folder, '05_MotorImagery'))
                nocruncher_decreasing_indices = find(this_group_crunch_results(:,this_roi_index) == 0);
                if ~isempty(nocruncher_decreasing_indices)
                    figure(this_group_index);
                    subplot(length(unique_rois), 3, this_figure_number); hold on;
                    for this_cruncher_index = 1 : length(nocruncher_decreasing_indices)
                        plot(number_of_levels, this_group_and_roi_beta_results(nocruncher_decreasing_indices(this_cruncher_index),:),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(nocruncher_decreasing_indices(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(nocruncher_decreasing_indices(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(nocruncher_decreasing_indices(this_cruncher_index), :))
                    end
                    if length(nocruncher_decreasing_indices)>1
                        p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_decreasing_indices,:)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.25;
                    end
                    figure(this_group_index);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('No crunchers (decreasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
            elseif any(strcmp(task_folder, '06_Nback'))
                nocruncher_decreasing_indices_1500 = find(this_group_crunch_results(:,this_roi_index) == 0);
                nocruncher_decreasing_indices_500 = find(this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 0);
                if ~isempty(nocruncher_decreasing_indices_1500)
                    figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    for this_cruncher_index = 1 : length(nocruncher_decreasing_indices_1500)
                        plot(number_of_levels, this_group_and_roi_beta_results(nocruncher_decreasing_indices_1500(this_cruncher_index),1:4),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(nocruncher_decreasing_indices_1500(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(nocruncher_decreasing_indices_1500(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(nocruncher_decreasing_indices_1500(this_cruncher_index), :))
                    end
                    if length(nocruncher_decreasing_indices_1500)>1
                        figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                        p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_decreasing_indices_1500,1:4)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.25;
                    end
                    figure(this_group_index*2-1);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('No crunchers (decreasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
                
                if ~isempty(nocruncher_decreasing_indices_500)
                    figure(this_group_index*2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    for this_cruncher_index = 1 : length(nocruncher_decreasing_indices_500)
                        plot(number_of_levels, this_group_and_roi_beta_results(nocruncher_decreasing_indices_500(this_cruncher_index),5:8),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(nocruncher_decreasing_indices_500(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(nocruncher_decreasing_indices_500(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(nocruncher_decreasing_indices_500(this_cruncher_index), :))
                    end
                    
                    if length(nocruncher_decreasing_indices_500)>1
                        figure(this_group_index*2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                        p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_decreasing_indices_500,5:8)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :))
                        p1.Color(4) = 0.25;
                    end
                    figure(this_group_index*2);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('No crunchers (decreasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        %                     set(get(gca, 'xaxis'), 'visible', 'off');
                        %                     set(get(gca, 'yaxis'), 'visible', 'off');
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        %         set(gca, 'xticklabel', '');
                        %         set(gca, 'yticklabel', '');
                        %         set(gca, 'position', [0 0 1 1]);
                        legend(gca, 'hide');
                    end
                    
                end
            end
            
            % on to the next subplot
            this_figure_number = this_figure_number + 1;
            
            % % TO DO: iron out potential bugs with plot_groups_together..
            % probably not functioning atm
            if ~plot_groups_together
                if ~no_labels
                    suptitle(group_names{this_group_index})
                end
                if any(strcmp(task_folder, '05_MotorImagery'))
                    figure(this_group_index);
                    if ~no_labels
                        suptitle(strcat(group_names{this_group_index},{' '},task))
                    end
                    filename = strcat('figures',filesep,group_names{this_group_index},'_',task,'_CRseparated');
                    if save_figures
                        saveas(gca, filename, 'tiff')
                    end
                elseif any(strcmp(task_folder, '06_Nback'))
                    figure(this_group_index*2-1);
                    if ~no_labels
                        suptitle(strcat(group_names{this_group_index},{' '},task, {' '}, 'isi-1500'))
                    end
                    filename = strcat('figures',filesep,group_names{this_group_index},'_',task,'isi-1500_CRseparated');
                    if save_figures
                        saveas(gca, filename, 'tiff')
                    end
                    figure(this_group_index*2);
                    if ~no_labels
                        suptitle(strcat(group_names{this_group_index},{' '},task, {' '}, 'isi-500'))
                    end
                    filename = strcat('figures',filesep,group_names{this_group_index},'_',task,'isi-500_CRseparated');
                    if save_figures
                        saveas(gca, filename, 'tiff')
                    end
                end
            else
                if ~no_labels
                    suptitle(strcat('All Groups ',{' '}, task))
                end
            end
        end
    end
end

%% Plot only average line and SEM
if plot_averages
    close all;
    for this_group_index = 1 : length(group_names)
        this_group_subjectindices = find(group_ids==this_group_index);
        
        if any(strcmp(task_folder, '05_MotorImagery'))
            figure; subplot(length(unique_rois), 3, 1);
        elseif any(strcmp(task_folder, '06_Nback'))
            figure; subplot(length(unique_rois), 3, 1);
            figure; subplot(length(unique_rois), 3, 1);
        end
        
        this_group_crunch_results = cr_results(this_group_subjectindices,:,:);
        
        this_group_crunch_results = cell2mat(this_group_crunch_results);
        
        this_figure_number = 1;
        for this_roi_index = 1 : length(unique_rois)
            this_group_and_roi_beta_results = beta_results(this_group_subjectindices,:,this_roi_index);
            
            number_of_levels = [0 : 3];
            
            if any(strcmp(task_folder, '05_MotorImagery'))
                cruncher_indices = find(this_group_crunch_results(:,this_roi_index) == 1 | this_group_crunch_results(:,this_roi_index) == 2);
                figure(this_group_index);
                subplot(length(unique_rois), 3, this_figure_number); hold on;
                if ~isempty(cruncher_indices)
                    if length(cruncher_indices)>1
                        p1 = errorbar(number_of_levels, mean(this_group_and_roi_beta_results(cruncher_indices,:)),std(this_group_and_roi_beta_results(cruncher_indices,:))./sqrt(length(cruncher_indices)), '-s', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    figure(this_group_index);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('crunchers')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
            elseif any(strcmp(task_folder, '06_Nback'))
                cruncher_indices_1500 =  find(this_group_crunch_results(:,this_roi_index) == 1 | this_group_crunch_results(:,this_roi_index) == 2);
                cruncher_indices_500 = find(this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 1 | this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 2);
                
                if ~isempty(cruncher_indices_1500)
                    figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    if length(cruncher_indices_1500)>1
                        figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                        p1 = errorbar(number_of_levels, mean(this_group_and_roi_beta_results(cruncher_indices_1500,1:4)),std(this_group_and_roi_beta_results(cruncher_indices_1500,1:4))./sqrt(length(cruncher_indices_1500)), '-s', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    figure(this_group_index*2-1);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('crunchers')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
                if ~isempty(cruncher_indices_500)
                    figure(this_group_index*2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    
                    if length(cruncher_indices_500)>1
                        figure(this_group_index*2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                        p1 = errorbar(number_of_levels, mean(this_group_and_roi_beta_results(cruncher_indices_500,5:8)),std(this_group_and_roi_beta_results(cruncher_indices_500,5:8))./sqrt(length(cruncher_indices_500)), '-s', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    figure(this_group_index*2);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('crunchers')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
                
            end
            
            % on to the next subplot
            this_figure_number = this_figure_number + 1;
            
            %increasing
            if any(strcmp(task_folder, '05_MotorImagery'))
                nocruncher_increasing_indices = find(this_group_crunch_results(:,this_roi_index) == 3);
                if ~isempty(nocruncher_increasing_indices)
                    figure(this_group_index);
                    subplot(length(unique_rois), 3, this_figure_number); hold on;
                    if length(nocruncher_increasing_indices)>1
                        p1 = errorbar(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_increasing_indices,:)),std(this_group_and_roi_beta_results(nocruncher_increasing_indices,:))./sqrt(length(nocruncher_increasing_indices)), '-s', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    figure(this_group_index);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('No crunchers (increasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
            elseif any(strcmp(task_folder, '06_Nback'))
                nocruncher_increasing_indices_1500 = find(this_group_crunch_results(:,this_roi_index) == 3);
                nocruncher_increasing_indices_500 = find(this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 3);
                if ~isempty(nocruncher_increasing_indices_1500)
                    figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    if length(nocruncher_increasing_indices_1500)>1
                        figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                        p1 = errorbar(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_increasing_indices_1500,1:4)),std(this_group_and_roi_beta_results(nocruncher_increasing_indices_1500,1:4))./sqrt(length(nocruncher_increasing_indices_1500)), '-s', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    figure(this_group_index*2-1);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('No crunchers (increasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
                if ~isempty(nocruncher_increasing_indices_500)
                    figure(this_group_index*2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    if length(nocruncher_increasing_indices_500)>1
                        figure(this_group_index*2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                        p1 = errorbar(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_increasing_indices_500,5:8)),std(this_group_and_roi_beta_results(nocruncher_increasing_indices_500,5:8))./sqrt(length(nocruncher_increasing_indices_500)), '-s', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    
                    figure(this_group_index*2);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('No crunchers (increasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
            end
            
            % on to the next subplot
            this_figure_number = this_figure_number + 1;
            
            
            %decreasing
            if any(strcmp(task_folder, '05_MotorImagery'))
                nocruncher_decreasing_indices = find(this_group_crunch_results(:,this_roi_index) == 0);
                if ~isempty(nocruncher_decreasing_indices)
                    figure(this_group_index);
                    subplot(length(unique_rois), 3, this_figure_number); hold on;
                    if length(nocruncher_decreasing_indices)>1
                        p1 = errorbar(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_decreasing_indices,:)), std(this_group_and_roi_beta_results(nocruncher_decreasing_indices,:))./sqrt(length(nocruncher_decreasing_indices)), '-s', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    figure(this_group_index);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('No crunchers (decreasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
            elseif any(strcmp(task_folder, '06_Nback'))
                nocruncher_decreasing_indices_1500 = find(this_group_crunch_results(:,this_roi_index) == 0);
                nocruncher_decreasing_indices_500 = find(this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 0);
                if ~isempty(nocruncher_decreasing_indices_1500)
                    figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    if length(nocruncher_decreasing_indices_1500)>1
                        figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                        p1 = errorbar(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_decreasing_indices_1500,1:4)), std(this_group_and_roi_beta_results(nocruncher_decreasing_indices_1500,1:4))./sqrt(length(nocruncher_decreasing_indices_1500)), '-s', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    figure(this_group_index*2-1);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('No crunchers (decreasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
                
                if ~isempty(nocruncher_decreasing_indices_500)
                    figure(this_group_index*2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    
                    if length(nocruncher_decreasing_indices_500)>1
                        figure(this_group_index*2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                        p1 = errorbar(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_decreasing_indices_500,5:8)), std(this_group_and_roi_beta_results(nocruncher_decreasing_indices_500,5:8))./sqrt(length(nocruncher_decreasing_indices_500)), '-s', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', group_color_matrix(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    figure(this_group_index*2);
                    xticks([number_of_levels])
                    xlim([-1 4])
                    title('No crunchers (decreasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                    
                end
            end
            
            % on to the next subplot
            this_figure_number = this_figure_number + 1;
            
            % % TO DO: iron out potential bugs with plot_groups_together..
            % probably not functioning atm
            if ~plot_groups_together
                if ~no_labels
                    suptitle(group_names{this_group_index})
                end
                if any(strcmp(task_folder, '05_MotorImagery'))
                    figure(this_group_index);
                    if ~no_labels
                        suptitle(strcat(group_names{this_group_index},{' '},task))
                    end
                    filename = strcat('figures',filesep,group_names{this_group_index},'_',task,'_CRseparated');
                    if save_figures
                        saveas(gca, filename, 'tiff')
                    end
                elseif any(strcmp(task_folder, '06_Nback'))
                    figure(this_group_index*2-1);
                    if ~no_labels
                        suptitle(strcat(group_names{this_group_index},{' '},task, {' '}, 'isi-1500'))
                    end
                    filename = strcat('figures',filesep,group_names{this_group_index},'_',task,'isi-1500_CRseparated');
                    if save_figures
                        saveas(gca, filename, 'tiff')
                    end
                    figure(this_group_index*2);
                    if ~no_labels
                        suptitle(strcat(group_names{this_group_index},{' '},task, {' '}, 'isi-500'))
                    end
                    filename = strcat('figures',filesep,group_names{this_group_index},'_',task,'isi-500_CRseparated');
                    if save_figures
                        saveas(gca, filename, 'tiff')
                    end
                end
            else
                if ~no_labels
                    suptitle(strcat('All Groups ',{' '}, task))
                end
            end
        end
    end
end

%% plot percent of crunchers no crunchers for each age
if plot_percents
    close all
    for this_group_index = 1 : length(group_names)
        this_group_subjectindices = find(group_ids==this_group_index);
        
        if any(strcmp(task_folder, '05_MotorImagery'))
            figure; subplot(1, 3, 1);
        elseif any(strcmp(task_folder, '06_Nback'))
            figure; subplot(1, 3, 1);
            figure; subplot(1, 3, 1);
        end
        this_group_crunch_results = cr_results(this_group_subjectindices,:,:);
        %         subject_ids_table = cellstr(subjects');
        %         subject_table = table(subject_ids_table(this_group_subjectindices));
        %         subject_table = renamevars(subject_table,'Var1','Subject');
        %
        % makes logic easier below..
        this_group_crunch_results = cell2mat(this_group_crunch_results);
        
        % write the table to xlsx
        %         split_output_filename = strsplit(output_filename,'.');
        
        this_figure_number = 1;
        for this_roi_index = 1 : length(unique_rois)
            this_group_and_roi_beta_results = beta_results(this_group_subjectindices,:,this_roi_index);
            
            if any(strcmp(task_folder, '05_MotorImagery'))
                cruncher_indices = find(this_group_crunch_results(:,this_roi_index) == 1 | this_group_crunch_results(:,this_roi_index) == 2);
                nocruncher_increasing_indices = find(this_group_crunch_results(:,this_roi_index) == 3);
                nocruncher_decreasing_indices = find(this_group_crunch_results(:,this_roi_index) == 0);
                
                cruncher_percent = length(cruncher_indices) / size(this_group_crunch_results,1) * 100;
                nocruncher_increasing_percent = length(nocruncher_increasing_indices) / size(this_group_crunch_results,1) * 100;
                nocruncher_decreasing_percent = length(nocruncher_decreasing_indices) / size(this_group_crunch_results,1) * 100;
                
                figure(this_group_index);
                subplot(1, 3, this_figure_number); hold on;
                bar(1, cruncher_percent,'facecolor','g')
                bar(2, nocruncher_increasing_percent, 'facecolor', 'cyan')
                bar(3, nocruncher_decreasing_percent, 'facecolor', 'magenta')
                
                xticks([1 2 3])
                xticklabels({'crunchers', 'increasers', 'decreasers'})
                xtickangle(45)
                xlim([0 4])
                ylim([0 100])
                title('MI Percent Breakdown')
                ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                if no_labels
                    set(get(gca, 'xlabel'), 'visible', 'off');
                    set(get(gca, 'ylabel'), 'visible', 'off');
                    set(get(gca, 'title'), 'visible', 'off');
                    legend(gca, 'hide');
                end
                set(gcf,'position',[10 -80 1650 850]);
            elseif any(strcmp(task_folder, '06_Nback'))
                cruncher_indices_1500 = find(this_group_crunch_results(:,this_roi_index) == 1 | this_group_crunch_results(:,this_roi_index) == 2);
                cruncher_indices_500 = find(this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 1 | this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 2);
                nocruncher_increasing_indices_1500 = find(this_group_crunch_results(:,this_roi_index) == 3);
                nocruncher_increasing_indices_500 = find(this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 3);
                nocruncher_decreasing_indices_1500 = find(this_group_crunch_results(:,this_roi_index) == 0);
                nocruncher_decreasing_indices_500 = find(this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 0);
                
                cruncher_percent_1500 = length(cruncher_indices_1500) / size(this_group_crunch_results,1) * 100;
                cruncher_percent_500 = length(cruncher_indices_500) / size(this_group_crunch_results,1) * 100;
                nocruncher_increasing_percent_1500 = length(nocruncher_increasing_indices_1500) / size(this_group_crunch_results,1) * 100;
                nocruncher_increasing_percent_500 = length(nocruncher_increasing_indices_500) / size(this_group_crunch_results,1) * 100;
                nocruncher_decreasing_percent_1500 = length(nocruncher_decreasing_indices_1500) / size(this_group_crunch_results,1) * 100;
                nocruncher_decreasing_percent_500 = length(nocruncher_decreasing_indices_500) / size(this_group_crunch_results,1) * 100;
                
                figure(this_group_index*2-1)
                subplot(1, 3, this_figure_number); hold on;
                bar(1, cruncher_percent_1500,'facecolor','g')
                bar(2, nocruncher_increasing_percent_1500, 'facecolor', 'cyan')
                bar(3, nocruncher_decreasing_percent_1500, 'facecolor', 'magenta')
                
                xticks([1 2 3])
                xticklabels({'crunchers', 'increasers', 'decreasers'})
                xtickangle(45)
                xlim([0 4])
                ylim([0 100])
                title('NB1500 Percent Breakdown')
                ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                if no_labels
                    set(get(gca, 'xlabel'), 'visible', 'off');
                    set(get(gca, 'ylabel'), 'visible', 'off');
                    set(get(gca, 'title'), 'visible', 'off');
                    legend(gca, 'hide');
                end
                set(gcf,'position',[10 -80 1650 850]);
                
                figure(this_group_index*2)
                subplot(1, 3, this_figure_number); hold on;
                bar(1, cruncher_percent_500,'facecolor','g')
                bar(2, nocruncher_increasing_percent_500, 'facecolor', 'cyan')
                bar(3, nocruncher_decreasing_percent_500, 'facecolor', 'magenta')
                
                xticks([1 2 3])
                xticklabels({'crunchers', 'increasers', 'decreasers'})
                xtickangle(45)
                xlim([0 4])
                ylim([0 100])
                title('NB500 Percent Breakdown')
                ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                if no_labels
                    set(get(gca, 'xlabel'), 'visible', 'off');
                    set(get(gca, 'ylabel'), 'visible', 'off');
                    set(get(gca, 'title'), 'visible', 'off');
                    legend(gca, 'hide');
                end
                set(gcf,'position',[10 -80 1650 850]);
            end
            
            this_figure_number = this_figure_number + 1;
            if ~no_labels
                suptitle(group_names{this_group_index})
            end
            if any(strcmp(task_folder, '05_MotorImagery'))
                figure(this_group_index);
                if ~no_labels
                    suptitle(strcat(group_names{this_group_index},{' '}, 'Percent Breakdown',{' '},task))
                end
                filename = strcat('figures',filesep,group_names{this_group_index},'_','percent_breakdown',task,'_CRseparated',date);
                if save_figures
                    saveas(gca, filename, 'png')
                end
            elseif any(strcmp(task_folder, '06_Nback'))
                figure(this_group_index*2-1);
                if ~no_labels
                    suptitle(strcat(group_names{this_group_index},{' '},task, {' '}, 'Percent Breakdown',{' '}, 'isi-1500'))
                end
                filename = strcat('figures',filesep,group_names{this_group_index},'_','percent_breakdown',task,'isi-1500_CRseparated',date);
                if save_figures
                    saveas(gca, filename, 'png')
                end
                figure(this_group_index*2);
                if ~no_labels
                    suptitle(strcat(group_names{this_group_index},{' '},task, {' '}, 'Percent Breakdown',{' '}, 'isi-500'))
                end
                filename = strcat('figures',filesep,group_names{this_group_index},'_','percent_breakdown',task,'isi-500_CRseparated',date);
                if save_figures
                    saveas(gca, filename, 'png')
                end
            end
        end
    end
end

%% Plot group averages together
if (plot_groups_together)
    close all;
    cmat = [0 0 0; 1 0 0; 0 0 1];
    for this_group_index = 1 : length(group_names)
        this_group_subjectindices = find(group_ids==this_group_index);
        if any(strcmp(task_folder, '05_MotorImagery'))
            h1 = figure(1); subplot(length(unique_rois), 3, 1); hold on;
        elseif any(strcmp(task_folder, '06_Nback'))
            h1 = figure(1); subplot(length(unique_rois), 3, 1); hold on;
            h2 = figure(2); subplot(length(unique_rois), 3, 1); hold on;
        end
        this_group_crunch_results = cr_results(this_group_subjectindices,:,:);
        
        this_group_crunch_results = cell2mat(this_group_crunch_results);
        
        this_figure_number = 1;
        for this_roi_index = 1 : length(unique_rois)
            this_group_and_roi_beta_results = beta_results(this_group_subjectindices,:,this_roi_index);
            
            for lll=1:length(group_names)
               number_of_levels(lll,:)=[(0:3)+(lll-1)*.15]; 
            end
            
            if any(strcmp(task_folder, '05_MotorImagery'))
                cruncher_indices = find(this_group_crunch_results(:,this_roi_index) == 1 | this_group_crunch_results(:,this_roi_index) == 2);
                if ~isempty(cruncher_indices)
                    figure(h1);subplot(length(unique_rois), 3, this_figure_number); hold on;
                    if length(cruncher_indices)>1
                        p1 = errorbar(number_of_levels(this_group_index,:), mean(this_group_and_roi_beta_results(cruncher_indices,:)),std(this_group_and_roi_beta_results(cruncher_indices,:))./sqrt(length(cruncher_indices)), '-s', 'MarkerFaceColor', cmat(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', cmat(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    xticks([number_of_levels(1,:)])
                    xlim([-1 4])
                    title('crunchers')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
            elseif any(strcmp(task_folder, '06_Nback'))
                cruncher_indices_1500 =  find(this_group_crunch_results(:,this_roi_index) == 1 | this_group_crunch_results(:,this_roi_index) == 2);
                cruncher_indices_500 = find(this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 1 | this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 2);
                if ~isempty(cruncher_indices_1500)
                    figure(h1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    if length(cruncher_indices_1500)>1
                        p1 = errorbar(number_of_levels(this_group_index,:), mean(this_group_and_roi_beta_results(cruncher_indices_1500,1:4)),std(this_group_and_roi_beta_results(cruncher_indices_1500,1:4))./sqrt(length(cruncher_indices_1500)), '-s','MarkerFaceColor', cmat(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', cmat(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    figure(h1);
                    xticks([number_of_levels(1,:)])
                    xlim([-1 4])
                    title('crunchers')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
                if ~isempty(cruncher_indices_500)
                    figure(h2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    if length(cruncher_indices_500)>1
                        p1 = errorbar(number_of_levels(this_group_index,:), mean(this_group_and_roi_beta_results(cruncher_indices_500,5:8)),std(this_group_and_roi_beta_results(cruncher_indices_500,5:8))./sqrt(length(cruncher_indices_500)), '-s','MarkerFaceColor', cmat(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', cmat(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    figure(h2);
                    xticks([number_of_levels(1,:)])
                    xlim([-1 4])
                    title('crunchers')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
                
            end
            
            % on to the next subplot
            this_figure_number = this_figure_number + 1;
            
            %increasing
            if any(strcmp(task_folder, '05_MotorImagery'))
                nocruncher_increasing_indices = find(this_group_crunch_results(:,this_roi_index) == 3);
                if ~isempty(nocruncher_increasing_indices)
                    figure(h1);subplot(length(unique_rois), 3, this_figure_number); hold on;
                    if length(nocruncher_increasing_indices)>1
                        p1 = errorbar(number_of_levels(this_group_index,:), mean(this_group_and_roi_beta_results(nocruncher_increasing_indices,:)),std(this_group_and_roi_beta_results(nocruncher_increasing_indices,:))./sqrt(length(nocruncher_increasing_indices)), '-s','MarkerFaceColor', cmat(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', cmat(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    xticks([number_of_levels(1,:)])
                    xlim([-1 4])
                    title('No crunchers (increasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
            elseif any(strcmp(task_folder, '06_Nback'))
                nocruncher_increasing_indices_1500 = find(this_group_crunch_results(:,this_roi_index) == 3);
                nocruncher_increasing_indices_500 = find(this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 3);
                if ~isempty(nocruncher_increasing_indices_1500)
                    figure(h1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    if length(nocruncher_increasing_indices_1500)>1
                        p1 = errorbar(number_of_levels(this_group_index,:), mean(this_group_and_roi_beta_results(nocruncher_increasing_indices_1500,1:4)),std(this_group_and_roi_beta_results(nocruncher_increasing_indices_1500,1:4))./sqrt(length(nocruncher_increasing_indices_1500)), '-s','MarkerFaceColor', cmat(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', cmat(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    figure(h1);
                    xticks([number_of_levels(1,:)])
                    xlim([-1 4])
                    title('No crunchers (increasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
                if ~isempty(nocruncher_increasing_indices_500)
                    figure(h2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    if length(nocruncher_increasing_indices_500)>1
                        p1 = errorbar(number_of_levels(this_group_index,:), mean(this_group_and_roi_beta_results(nocruncher_increasing_indices_500,5:8)),std(this_group_and_roi_beta_results(nocruncher_increasing_indices_500,5:8))./sqrt(length(nocruncher_increasing_indices_500)), '-s','MarkerFaceColor', cmat(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', cmat(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    figure(h2);
                    xticks([number_of_levels(1,:)])
                    xlim([-1 4])
                    title('No crunchers (increasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
            end
            
            % on to the next subplot
            this_figure_number = this_figure_number + 1;
            
            
            %decreasing
            if any(strcmp(task_folder, '05_MotorImagery'))
                nocruncher_decreasing_indices = find(this_group_crunch_results(:,this_roi_index) == 0);
                if ~isempty(nocruncher_decreasing_indices)
                    figure(h1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    if length(nocruncher_decreasing_indices)>1
                        p1 = errorbar(number_of_levels(this_group_index,:), mean(this_group_and_roi_beta_results(nocruncher_decreasing_indices,:)), std(this_group_and_roi_beta_results(nocruncher_decreasing_indices,:))./sqrt(length(nocruncher_decreasing_indices)), '-s','MarkerFaceColor', cmat(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', cmat(this_group_index, :));
                        p1.Color(4) = 0.6; 
                    end
                    xticks([number_of_levels(1,:)])
                    xlim([-1 4])
                    title('No crunchers (decreasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
            elseif any(strcmp(task_folder, '06_Nback'))
                nocruncher_decreasing_indices_1500 = find(this_group_crunch_results(:,this_roi_index) == 0);
                nocruncher_decreasing_indices_500 = find(this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 0);
                if ~isempty(nocruncher_decreasing_indices_1500)
                    figure(h1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    if length(nocruncher_decreasing_indices_1500)>1
                        p1 = errorbar(number_of_levels(this_group_index,:), mean(this_group_and_roi_beta_results(nocruncher_decreasing_indices_1500,1:4)), std(this_group_and_roi_beta_results(nocruncher_decreasing_indices_1500,1:4))./sqrt(length(nocruncher_decreasing_indices_1500)), '-s','MarkerFaceColor', cmat(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', cmat(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    figure(h1);
                    xticks([number_of_levels(1,:)])
                    xlim([-1 4])
                    title('No crunchers (decreasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
                if ~isempty(nocruncher_decreasing_indices_500)
                    figure(h2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    if length(nocruncher_decreasing_indices_500)>1
                        p1 = errorbar(number_of_levels(this_group_index,:), mean(this_group_and_roi_beta_results(nocruncher_decreasing_indices_500,5:8)), std(this_group_and_roi_beta_results(nocruncher_decreasing_indices_500,5:8))./sqrt(length(nocruncher_decreasing_indices_500)), '-s','MarkerFaceColor', cmat(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', cmat(this_group_index, :));
                        p1.Color(4) = 0.6;
                    end
                    figure(h2);
                    xticks([number_of_levels(1,:)])
                    xlim([-1 4])
                    title('No crunchers (decreasing)')
                    ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                    if no_labels
                        set(get(gca, 'xlabel'), 'visible', 'off');
                        set(get(gca, 'ylabel'), 'visible', 'off');
                        set(get(gca, 'title'), 'visible', 'off');
                        legend(gca, 'hide');
                    end
                end
                
            end
            
            % on to the next subplot
            this_figure_number = this_figure_number + 1;
        end

    end
    if any(strcmp(task_folder, '05_MotorImagery'))
        set(h1,'position',[0 -80 1650 850]);
        figure(h1);
        filename = strcat(data_path,'/figures',filesep,'All_Groups_',task,beta_filename_extension,'_CRseparated_nolabels',date);
        if ~no_labels
            suptitle(strcat('All Groups ',{' '}, task))
            filename = strcat(data_path,'/figures',filesep,'All_Groups_',task,beta_filename_extension,date,'_CRseparated',date);
        end
        if save_figures
            saveas(gca, filename, 'png')
        end
    elseif any(strcmp(task_folder, '06_Nback'))
        set(h1,'position',[10 -80 1650 850]);
        set(h2,'position',[10 -80 1650 850]);
        figure(h1);
        filename = strcat(data_path,'/figures',filesep,'All_Groups_',task,beta_filename_extension,date,'isi-1500_CRseparated_nolabels',date);
        if ~no_labels
            suptitle(strcat('All Groups ',{' '}, task))
            filename = strcat(data_path,'/figures',filesep,'All_Groups_',task,beta_filename_extension,date,'isi-1500_CRseparated',date);
        end
        if save_figures
            saveas(gca, filename, 'png')
        end
        figure(h2);
        filename = strcat(data_path,'/figures',filesep,'All_Groups_',task,beta_filename_extension,date,'isi-500_CRseparated_nolabels',date);
        if ~no_labels
            suptitle(strcat('All Groups ',{' '}, task))
            filename = strcat(data_path,'/figures',filesep,'All_Groups_',task,beta_filename_extension,date,'isi-500_CRseparated',date);
        end
        if save_figures
            saveas(gca, filename, 'png')
        end
    end
end
%% Plot averages together with no group separation
if (no_crunch_separate)
    close all;
    cmat = [0 0 0; 1 0 0;0 0 1];
    if any(strcmp(task_folder, '05_MotorImagery'))
        h1 = figure(1); subplot(length(unique_rois), 3, 1); hold on;
    elseif any(strcmp(task_folder, '06_Nback'))
        h1 = figure(1); subplot(length(unique_rois), 3, 1); hold on;
        h2 = figure(2); subplot(length(unique_rois), 3, 1); hold on;
    end
    for this_group_index = 1 : length(group_names)
        this_group_subjectindices = find(group_ids==this_group_index);
        for this_roi_index = 1 : length(unique_rois)
            this_group_and_roi_beta_results = beta_results(this_group_subjectindices,:,this_roi_index);
            
            for lll=1:length(group_names)
               number_of_levels(lll,:)=[(0:3)+(lll-1)*.15]; 
            end
            
            if any(strcmp(task_folder, '05_MotorImagery'))
                figure(h1);subplot(length(unique_rois), 1, this_roi_index); hold on;
                p1 = errorbar(number_of_levels(this_group_index,:), mean(this_group_and_roi_beta_results),std(this_group_and_roi_beta_results)./sqrt(length(this_group_and_roi_beta_results)), '-s', 'MarkerFaceColor', cmat(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', cmat(this_group_index, :));
                p1.Color(4) = 0.6;
                xticks([number_of_levels(1,:)])
                xlim([-1 4])
                ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                hold on;
                if no_labels
                    set(get(gca, 'xlabel'), 'visible', 'off');
                    set(get(gca, 'ylabel'), 'visible', 'off');
                    set(get(gca, 'title'), 'visible', 'off');
                    legend(gca, 'hide');
                end
            elseif any(strcmp(task_folder, '06_Nback'))
                figure(h1); subplot(length(unique_rois), 1, this_roi_index); hold on;
                p1 = errorbar(number_of_levels(this_group_index,:), mean(this_group_and_roi_beta_results(:,1:4)),std(this_group_and_roi_beta_results(:,1:4))./sqrt(length(this_group_and_roi_beta_results(:,1:4))), '-s','MarkerFaceColor', cmat(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', cmat(this_group_index, :));
                p1.Color(4) = 0.6;
                figure(h1); hold on;
                xticks([number_of_levels(1,:)])
                xlim([-1 4])
                ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                if no_labels
                    set(get(gca, 'xlabel'), 'visible', 'off');
                    set(get(gca, 'ylabel'), 'visible', 'off');
                    set(get(gca, 'title'), 'visible', 'off');
                    legend(gca, 'hide');
                end
                figure(h2); subplot(length(unique_rois), 1, this_roi_index); hold on;
                p1 = errorbar(number_of_levels(this_group_index,:), mean(this_group_and_roi_beta_results(:,5:8)),std(this_group_and_roi_beta_results(:,5:8))./sqrt(length(this_group_and_roi_beta_results(:,5:8))), '-s','MarkerFaceColor', cmat(this_group_index, :),'MarkerSize', 10, 'LineWidth',2.5, 'Color', cmat(this_group_index, :));
                p1.Color(4) = 0.6;
                figure(h2); hold on;
                xticks([number_of_levels(1,:)])
                xlim([-1 4])
                ylabel([unique_rois(this_roi_index)],'interpreter','latex')
                if no_labels
                    set(get(gca, 'xlabel'), 'visible', 'off');
                    set(get(gca, 'ylabel'), 'visible', 'off');
                    set(get(gca, 'title'), 'visible', 'off');
                    legend(gca, 'hide');
                end
            end
        end
        
    end
    if any(strcmp(task_folder, '05_MotorImagery'))
        set(h1,'position',[10 -80 385 850]);
        figure(h1);
        filename = strcat(data_path,'/figures',filesep,'All_Groups_',task,beta_filename_extension,'_nolabels',date);
        if ~no_labels
            suptitle(strcat('All Groups ',{' '}, task))
            filename = strcat(data_path,'/figures',filesep,'All_Groups_',task,beta_filename_extension,date);
        end
        if save_figures
            saveas(gca, filename, 'png')
        end
    elseif any(strcmp(task_folder, '06_Nback'))
        set(h1,'position',[10 -80 385 850]);
        set(h2,'position',[10 -80 385 850]);
        figure(h1);
        filename = strcat(data_path,'/figures',filesep,'All_Groups_',task,beta_filename_extension,'isi-1500_nolabels',date);
        if ~no_labels
            suptitle(strcat('All Groups_1500isi ',{' '}, task))
            filename = strcat(data_path,'/figures',filesep,'All_Groups_',task,beta_filename_extension,'isi-1500',date);
        end
        if save_figures
            saveas(gca, filename, 'png')
        end
        figure(h2);
        filename = strcat(data_path,'/figures',filesep,'All_Groups_',task,beta_filename_extension,'isi-500_nolabels',date);
        if ~no_labels
            suptitle(strcat('All Groups_500isi ',{' '}, task))
            filename = strcat(data_path,'/figures',filesep,'All_Groups_',task,beta_filename_extension,'isi-500',date);
        end
        if save_figures
            saveas(gca, filename, 'png')
        end
    end
end
