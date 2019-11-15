% roi_results figure generation

data_path = pwd;

directory_pieces = regexp(data_path,filesep,'split');
levels_back = 2; % assuming only working in ANTS folder atm
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

data = readtable('roi_results.txt');

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
        ordered_roi_condition_name_matrix = [ordered_roi_condition_name_matrix; roi_condition_name_matrix(indices_this_roi(1) - 1 + [idx idx+length(idx)], : )];
    end
end


% save condition_order and ordered_roi_beta_value to results.mat
figure; plot;




    
