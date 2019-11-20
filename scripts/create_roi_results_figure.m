% roi_results figure generation
clear,clc
close all
data_path = pwd;

handles.handle_plot = [];
directory_pieces = regexp(data_path,filesep,'split');
levels_back = 1; % assuming only working in ANTS folder atm
subject_level_directory = getfield( directory_pieces, {1:length(directory_pieces)-levels_back} );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% might need to do something like this to automate which directory
% we are in (spm vs ANTS)
        
%          while fileID == -1
%         subject_level_directory = getfield( directory_pieces, {1:length(directory_pieces)-levels_back} );
%         for i_path_element = 1:size(subject_level_directory,2)
%             subject_level_directory{i_path_element}(end+1) = '/';
%         end
%         subject_level_directory_string = cellfun(@string,subject_level_directory);
%         subject_level_directory_full = join(subject_level_directory_string,'');
%         
%         outlier_settings_file_path = fullfile(subject_level_directory_full, 'outlier_removal_settings.txt');
%           
%         fileID = fopen(outlier_settings_file_path, 'r');
%         levels_back = levels_back + 1;
%     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find each subject roi_results file
roi_results_file_list = dir('*roi_results.txt');

for this_subject_results_file = 1 : length(roi_results_file_list)
    this_subject_color = rand(1,3);
    
%     this_subject_results_file
   data = readtable(roi_results_file_list(this_subject_results_file).name);
%      data = readtable('1002_roi_results.txt');



roi_condition_name = data.Var1;
roi_beta_value = data.Var2;

if strcmp(subject_level_directory{end}, '05_MotorImagery')
    condition_order = {'flat', 'low', 'medium', 'hard'};
end
if strcmp(subject_level_directory{end}, '06_Nback')
    condition_order = {'zero', 'one', 'two', 'three'};
end
    
for this_roi = 1 : length(roi_condition_name)
    roi_condition_name_matrix(this_roi,:) = strsplit(roi_condition_name{this_roi},'_');    
end

% just preallocating
ordered_roi_beta_value = [];
ordered_roi_condition_name_matrix = [];
unique_rois = unique(roi_condition_name_matrix(:,2));
for this_unique_roi_index = 1 : length(unique_rois)
    indices_this_roi = find(contains(roi_condition_name_matrix(:, 2), unique_rois{this_unique_roi_index}));
    
    % order the matrix based on condition_order
    % Nback has more columns in roi_condition_name_matrix
    if strcmp(subject_level_directory{end}, '05_MotorImagery')
        [tf, idx] =ismember(condition_order, roi_condition_name_matrix(indices_this_roi, 3))
        this_cond_ordered_roi_beta_value = roi_beta_value(indices_this_roi(1) - 1 + idx);
        ordered_roi_beta_value = [ordered_roi_beta_value this_cond_ordered_roi_beta_value];
        ordered_roi_condition_name_matrix = [ordered_roi_condition_name_matrix; roi_condition_name_matrix(indices_this_roi(1) - 1 + idx, : )];
    end
    if strcmp(subject_level_directory{end}, '06_Nback')
        [tf, idx] =ismember(condition_order, roi_condition_name_matrix(indices_this_roi, 4));
        this_cond_ordered_roi_beta_value = roi_beta_value(indices_this_roi(1) - 1 + [idx idx+length(idx)]); %doubling up the idx to average between long and short unless there is a reason to look at differences between long and short
        ordered_roi_beta_value = [ordered_roi_beta_value this_cond_ordered_roi_beta_value];
        ordered_roi_condition_name_matrix{this_unique_roi_index} = (roi_condition_name_matrix(indices_this_roi(1) - 1 + [idx idx+length(idx)], : ));
    end
end

this_figure_number = 1;
for this_roi = 1 : length(unique_rois)
    if strcmp(subject_level_directory{end}, '06_Nback')
        for this_isi = {'short', 'long'}
            this_isi_indices = contains(ordered_roi_condition_name_matrix{this_roi}(:,3), this_isi)
            
            x_num = [1 : sum(this_isi_indices)];
            x_label = ordered_roi_condition_name_matrix{this_roi}(this_isi_indices,4);
            y = ordered_roi_beta_value(this_isi_indices,this_roi)';
            
            this_figure_handle = fprintf('%s',unique_rois{this_roi})
            
           if (length(handles.handle_plot) == length(unique_rois) * 2)
               figure(handles.handle_plot(this_figure_number))
           else
               handles.handle_plot(this_figure_number) = figure;
           end
           hold on;
           plot(x_num, y, 'o', 'MarkerFaceColor', this_subject_color, 'MarkerSize',10)
           xticks([x_num])
           xlim([0 5])
           title([unique_rois(this_roi) this_isi])
           xtickangle(45)
           set(gca,'xticklabel',x_label.')
           this_figure_number = this_figure_number + 1;
        end
    end
end
    
end