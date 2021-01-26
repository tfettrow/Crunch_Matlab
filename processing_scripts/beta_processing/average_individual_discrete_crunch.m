function average_individual_discrete_crunch(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'task_folder', '')
addParameter(parser, 'subjects', '')
addParameter(parser, 'group_names', '')
addParameter(parser, 'group_ids', '')
addParameter(parser, 'no_labels', 1)
addParameter(parser, 'output_filename', '')
addParameter(parser, 'beta_filename_extension', '')
addParameter(parser, 'plot_groups_together',0)
addParameter(parser, 'separate_by_crunch_type',1)
parse(parser, varargin{:})
subjects = parser.Results.subjects;
group_names = parser.Results.group_names;
group_ids = parser.Results.group_ids;
task_folder = parser.Results.task_folder;
no_labels = parser.Results.no_labels;
output_filename = parser.Results.output_filename;
beta_filename_extension = parser.Results.beta_filename_extension;
plot_groups_together = parser.Results.plot_groups_together;
separate_by_crunch_type = parser.Results.separate_by_crunch_type;
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

for this_group_index = 1 : length(group_names)
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
    subject_ids_table = cellstr(subjects');
    subject_table = table(subject_ids_table(this_group_subjectindices));
    subject_table = renamevars(subject_table,'Var1','Subject');
    
    % makes logic easier below..
    this_group_crunch_results = cell2mat(this_group_crunch_results);

    % write the table to xlsx
    split_output_filename = strsplit(output_filename,'.');
    filename = strcat('crunch_summary_statistics_',task,'_',split_output_filename{1},'_',group_names{this_group_index},'.xlsx');
    %     ROI_total={num2str(length(this_group_subjectindices)+1),'1',strcat('=sum(b2,b',num2str(length(this_group_subjectindices)),')')};
    if exist(filename)
        delete(filename)
    end
    this_figure_number = 1;
    for this_roi_index = 1 : length(unique_rois)
        this_group_and_roi_beta_results = beta_results(this_group_subjectindices,:,this_roi_index);
        
        if any(strcmp(task_folder, '05_MotorImagery'))
            % populating and renaming the new crunch column
%             summary_stats.crunch = table(this_group_crunch_results(:,this_roi_index));
%             summary_stats = renamevars(summary_stats,'crunch',unique_rois(this_roi_index));
            crunch_table = table(this_group_crunch_results(:,this_roi_index));
            crunch_table = renamevars(crunch_table,'Var1',unique_rois{this_roi_index});
        elseif any(strcmp(task_folder, '06_Nback'))
            % populating and renaming the new crunch column
            crunch_table = table(this_group_crunch_results(:,[this_roi_index this_roi_index+length(unique_rois)]));
            crunch_table = renamevars(crunch_table,'Var1',unique_rois{this_roi_index});
        end
        
        summary_stats = [subject_table crunch_table]
        T2=splitvars(summary_stats);
        writetable(T2,filename) %,'Sheet',this_group_index)
        %     xlswrite('crunch_summary_statistics.xlsx', ROI_total)
        
       
        number_of_levels = [0 : 3];
        
        if any(strcmp(task_folder, '05_MotorImagery'))
%             cruncher_indices = find(strcmp(this_group_crunch_results(:,this_roi_index), 'early_crunch') | strcmp(this_group_crunch_results(:,this_roi_index),'late_crunch'));
            cruncher_indices = find(this_group_crunch_results(:,this_roi_index) == 1 | this_group_crunch_results(:,this_roi_index) == 2);
            figure(this_group_index);
            subplot(length(unique_rois), 3, this_figure_number); hold on;
            if ~isempty(cruncher_indices)
                for this_cruncher_index = 1 : length(cruncher_indices)
                    plot(number_of_levels, this_group_and_roi_beta_results(cruncher_indices(this_cruncher_index),:),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(cruncher_indices(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(cruncher_indices(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(cruncher_indices(this_cruncher_index), :))
                end
                if length(cruncher_indices)>1
                    p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(cruncher_indices,:)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :))
                    p1.Color(4) = 0.25;
                end
                figure(this_group_index);
                xticks([number_of_levels])
                xlim([-1 4])
                title('crunchers')
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
        elseif any(strcmp(task_folder, '06_Nback'))
            %             cruncher_indices_1500 = find(strcmp(this_group_crunch_results(:,this_roi_index), 'early_crunch') | strcmp(this_group_crunch_results(:,this_roi_index),'late_crunch'));
            %             cruncher_indices_500 = find(strcmp(this_group_crunch_results(:,this_roi_index+4), 'early_crunch') | strcmp(this_group_crunch_results(:,this_roi_index),'late_crunch'));
            cruncher_indices_1500 =  find(this_group_crunch_results(:,this_roi_index) == 1 | this_group_crunch_results(:,this_roi_index) == 2);
            cruncher_indices_500 = find(this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 1 | this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 2);

            if ~isempty(cruncher_indices_1500)
                figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                for this_cruncher_index = 1 : length(cruncher_indices_1500)
                    plot(number_of_levels, this_group_and_roi_beta_results(cruncher_indices_1500(this_cruncher_index),1:4),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(cruncher_indices_1500(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(cruncher_indices_1500(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(cruncher_indices_1500(this_cruncher_index), :))
                end
                if length(cruncher_indices_1500)>1
                    figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(cruncher_indices_1500,1:4)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :))
                    p1.Color(4) = 0.25;
                end
                figure(this_group_index*2-1);
                xticks([number_of_levels])
                xlim([-1 4])
                title('crunchers')
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
            if ~isempty(cruncher_indices_500)
                figure(this_group_index*2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                for this_cruncher_index = 1 : length(cruncher_indices_500)
                    plot(number_of_levels, this_group_and_roi_beta_results(cruncher_indices_500(this_cruncher_index),5:8),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(cruncher_indices_500(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(cruncher_indices_500(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(cruncher_indices_500(this_cruncher_index), :))
                end
                
                if length(cruncher_indices_500)>1
                    figure(this_group_index*2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(cruncher_indices_500,5:8)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :))
                    p1.Color(4) = 0.25;
                end
                figure(this_group_index*2);
                xticks([number_of_levels])
                xlim([-1 4])
                title('crunchers')
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
        
        %increasing
        if any(strcmp(task_folder, '05_MotorImagery'))
%             nocruncher_increasing_indices = find(strcmp(this_group_crunch_results(:,this_roi_index), 'increasing'));
            nocruncher_increasing_indices = find(this_group_crunch_results(:,this_roi_index) == 3);
            if ~isempty(nocruncher_increasing_indices)
                figure(this_group_index);
                subplot(length(unique_rois), 3, this_figure_number); hold on;
                for this_cruncher_index = 1 : length(nocruncher_increasing_indices)
                    plot(number_of_levels, this_group_and_roi_beta_results(nocruncher_increasing_indices(this_cruncher_index),:),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(nocruncher_increasing_indices(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(nocruncher_increasing_indices(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(nocruncher_increasing_indices(this_cruncher_index), :))
                end
                if length(nocruncher_increasing_indices)>1
                    p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_increasing_indices,:)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :))
                    p1.Color(4) = 0.25;
                end
                figure(this_group_index);
                xticks([number_of_levels])
                xlim([-1 4])
                title('No crunchers (increasing)')
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
        elseif any(strcmp(task_folder, '06_Nback'))
            %             nocruncher_increasing_indices_1500 = find(strcmp(this_group_crunch_results(:,this_roi_index), 'increasing'));
            %             nocruncher_increasing_indices_500 = find(strcmp(this_group_crunch_results(:,this_roi_index+4), 'increasing'));
            nocruncher_increasing_indices_1500 = find(this_group_crunch_results(:,this_roi_index) == 3);
            nocruncher_increasing_indices_500 = find(this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 3);
            if ~isempty(nocruncher_increasing_indices_1500)
                figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                for this_cruncher_index = 1 : length(nocruncher_increasing_indices_1500)
                    plot(number_of_levels, this_group_and_roi_beta_results(nocruncher_increasing_indices_1500(this_cruncher_index),1:4),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(nocruncher_increasing_indices_1500(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(nocruncher_increasing_indices_1500(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(nocruncher_increasing_indices_1500(this_cruncher_index), :))
                end
                if length(nocruncher_increasing_indices_1500)>1
                    figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_increasing_indices_1500,1:4)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :))
                    p1.Color(4) = 0.25;
                end
                figure(this_group_index*2-1);
                xticks([number_of_levels])
                xlim([-1 4])
                title('No crunchers (increasing)')
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
            if ~isempty(nocruncher_increasing_indices_500)
                figure(this_group_index*2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                for this_cruncher_index = 1 : length(nocruncher_increasing_indices_500)
                    plot(number_of_levels, this_group_and_roi_beta_results(nocruncher_increasing_indices_500(this_cruncher_index),5:8),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(nocruncher_increasing_indices_500(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(nocruncher_increasing_indices_500(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(nocruncher_increasing_indices_500(this_cruncher_index), :))
                end
                if length(nocruncher_increasing_indices_500)>1
                    figure(this_group_index*2); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_increasing_indices_500,5:8)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :))
                    p1.Color(4) = 0.25;
                end
                
                figure(this_group_index*2);
                xticks([number_of_levels])
                xlim([-1 4])
                title('No crunchers (increasing)')
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
        
        
        %decreasing
        if any(strcmp(task_folder, '05_MotorImagery'))
            %             nocruncher_decreasing_indices = find(strcmp(this_group_crunch_results(:,this_roi_index), 'decreasing'));
            nocruncher_decreasing_indices = find(this_group_crunch_results(:,this_roi_index) == 0);
            if ~isempty(nocruncher_decreasing_indices)
                figure(this_group_index);
                subplot(length(unique_rois), 3, this_figure_number); hold on;
                for this_cruncher_index = 1 : length(nocruncher_decreasing_indices)
                    plot(number_of_levels, this_group_and_roi_beta_results(nocruncher_decreasing_indices(this_cruncher_index),:),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(nocruncher_decreasing_indices(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(nocruncher_decreasing_indices(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(nocruncher_decreasing_indices(this_cruncher_index), :))
                end
                if length(nocruncher_decreasing_indices)>1
                    p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_decreasing_indices,:)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :))
                    p1.Color(4) = 0.25;
                end
                figure(this_group_index);
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
        elseif any(strcmp(task_folder, '06_Nback'))
            %             nocruncher_decreasing_indices_1500 = find(strcmp(this_group_crunch_results(:,this_roi_index), 'decreasing'));
            %             nocruncher_decreasing_indices_500 = find(strcmp(this_group_crunch_results(:,this_roi_index+4), 'decreasing'));
            nocruncher_decreasing_indices_1500 = find(this_group_crunch_results(:,this_roi_index) == 0);
            nocruncher_decreasing_indices_500 = find(this_group_crunch_results(:,this_roi_index+length(unique_rois)) == 0);
            if ~isempty(nocruncher_decreasing_indices_1500)
                figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                for this_cruncher_index = 1 : length(nocruncher_decreasing_indices_1500)
                    plot(number_of_levels, this_group_and_roi_beta_results(nocruncher_decreasing_indices_1500(this_cruncher_index),1:4),'-o', 'MarkerFaceColor', this_group_subject_color_matrix(nocruncher_decreasing_indices_1500(this_cruncher_index), :), 'MarkerEdgeColor', this_group_subject_color_matrix(nocruncher_decreasing_indices_1500(this_cruncher_index), :),'MarkerSize', 5, 'LineWidth',1, 'Color',this_group_subject_color_matrix(nocruncher_decreasing_indices_1500(this_cruncher_index), :))
                end
                if length(nocruncher_decreasing_indices_1500)>1
                    figure(this_group_index*2-1); subplot(length(unique_rois), 3, this_figure_number); hold on;
                    p1 = plot(number_of_levels, mean(this_group_and_roi_beta_results(nocruncher_decreasing_indices_1500,1:4)), '-', 'MarkerFaceColor', group_color_matrix(this_group_index, :), 'MarkerEdgeColor', group_color_matrix(this_group_index, :),'MarkerSize', 5, 'LineWidth',7.5, 'Color', group_color_matrix(this_group_index, :))
                    p1.Color(4) = 0.25;
                end
                figure(this_group_index*2-1);
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
        % end
        
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
                saveas(gca, filename, 'tiff')
            elseif any(strcmp(task_folder, '06_Nback'))
                figure(this_group_index*2-1);
                if ~no_labels
                    suptitle(strcat(group_names{this_group_index},{' '},task, {' '}, 'isi-1500'))
                end
                filename = strcat('figures',filesep,group_names{this_group_index},'_',task,'isi-1500_CRseparated');
                saveas(gca, filename, 'tiff')

                figure(this_group_index*2);
                if ~no_labels
                    suptitle(strcat(group_names{this_group_index},{' '},task, {' '}, 'isi-500'))
                end
                filename = strcat('figures',filesep,group_names{this_group_index},'_',task,'isi-500_CRseparated');
                saveas(gca, filename, 'tiff')
            end
        else
            if ~no_labels
                suptitle(strcat('All Groups ',{' '}, task))
            end
        end
    end
end
end
