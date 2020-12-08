function identify_overlap_between_networks(varargin)
% add arguments 1) conn_project 2) original seed to find the nodes
% associated???
parser = inputParser;
parser.KeepUnmatched = true;
addParameter(parser, 'roi_settings_filename', '')
addParameter(parser, 'distance_threshold', '')
addParameter(parser, 'seed_names', '') %'left_hand','left_mouth','medial_prefrontal_cortex','left_post_ips','left_insular','visual_cortex','left_ips','right_thalamus','left_rsc', 'post_cingulate', 'right_aud_cortex', 'right_post_ips', 'right_insular', 'right_ips', 'right_hand', 'right_mouth', 'right_leg', 'right_rsc', 'left_dlpfc','right_dlpfc', 'left_acc', 'right_acc', 'left_aud_cortex','dACC', 'mpc_and_pc'}
parse(parser, varargin{:})
roi_settings_filename = parser.Results.roi_settings_filename;
distance_threshold = parser.Results.distance_threshold;
seed_names = parser.Results.seed_names;

if length(seed_names) ~= 2 
    error('need to specify only 2 seed names')
end

file_name = roi_settings_filename;
settings_file_split = strsplit(roi_settings_filename,{'_','.'});
project_name = strjoin(settings_file_split(3:end-1),'_');

fileID = fopen(file_name, 'r');
%     read text to cell
text_line = fgetl(fileID);
text_cell = {};
while ischar(text_line)
    text_cell = [text_cell; text_line]; %#ok<AGROW>
    text_line = fgetl(fileID);
end
fclose(fileID);
%     prune lines
lines_to_prune = false(size(text_cell, 1), 1);
for i_line = 1 : size(text_cell, 1)
    this_line = text_cell{i_line};
    %         remove initial white space
    while ~isempty(this_line) && (this_line(1) == ' ' || double(this_line(1)) == 9)
        this_line(1) = [];
    end
    settings_cell{i_line} = this_line; %#ok<AGROW>
    %         remove comments
    if length(this_line) > 1 && any(ismember(this_line, '#'))
        lines_to_prune(i_line) = true;
    end
    %         flag lines consisting only of white space
    if all(ismember(this_line, ' ') | double(this_line) == 9)
        lines_to_prune(i_line) = true;
    end
end
settings_cell(lines_to_prune) = [];

roi_dir = dir([strcat('ROIs', filesep,'*.nii')]);
clear roi_file_name_list;
[available_roi_file_name_list{1:length(roi_dir)}] = deal(roi_dir.name);

for this_roi_index = 1:length(settings_cell)
    this_roi_settings_split(this_roi_index,:) = strsplit(settings_cell{this_roi_index}, ',');
end

%   find the unique networks
this_file_unique_networks = strtrim(unique(this_roi_settings_split(:,5)));

% assumming only two seed names
% TO DO: throw error if not 2 seed names specified
first_unique_network_bool = contains(this_roi_settings_split(:,5), strcat(seed_names(1),'_network'));
first_unique_network_indices = find(first_unique_network_bool);
first_unique_network_corename = strtrim(this_roi_settings_split(first_unique_network_indices,4));
first_unique_network_cordinates = str2num(cell2mat(this_roi_settings_split(first_unique_network_indices,1:3)));

second_unique_network_bool = contains(this_roi_settings_split(:,5), strcat(seed_names(2),'_network'));
second_unique_network_indices = find(second_unique_network_bool);
second_unique_network_corename = strtrim(this_roi_settings_split(second_unique_network_indices,4));
second_unique_network_cordinates = str2num(cell2mat(this_roi_settings_split(second_unique_network_indices,1:3)));

fid = fopen(strcat('ROI_overlap_',project_name,'_',seed_names{1},'_',seed_names{2},'.txt'),'wt');
for this_first_network_node_coordinate_index = 1:size(first_unique_network_cordinates)
    for this_second_network_node_coordinate_index = 1:size(second_unique_network_cordinates)
        distance_between_these_nodes = pdist2(first_unique_network_cordinates(this_first_network_node_coordinate_index,:), second_unique_network_cordinates(this_second_network_node_coordinate_index,:));
        if distance_between_these_nodes < distance_threshold 
           fprintf(fid, '%f, %f, %f, %s, %f, %f, %f, %s\n', first_unique_network_cordinates(this_first_network_node_coordinate_index,1), first_unique_network_cordinates(this_first_network_node_coordinate_index,2), first_unique_network_cordinates(this_first_network_node_coordinate_index,3), first_unique_network_corename{this_first_network_node_coordinate_index}, second_unique_network_cordinates(this_second_network_node_coordinate_index,1), second_unique_network_cordinates(this_second_network_node_coordinate_index,2), second_unique_network_cordinates(this_second_network_node_coordinate_index,3), second_unique_network_corename{this_second_network_node_coordinate_index});
        end
    end
end
fclose(fid)

%% 
%     fid = fopen(strcat(conn_project_name,filesep,'results',filesep,'secondlevel',filesep,'SBC_01',filesep,'AllSubjects',filesep,'rest',filesep,seed_names{this_seed_folder},filesep,'ROI_settings_connNodeID_',seed_names{this_seed_folder},'.txt'),'wt');
%     
%     for this_node = 1:size(ordered_voxel_coords_thresholded,2)
%         if strcmp(project_name_split(end),'cb')
%             fprintf(fid, '%f, %f, %f, %s, %s, %s\n', ordered_voxel_coords_thresholded(1,this_node), ordered_voxel_coords_thresholded(2,this_node), ordered_voxel_coords_thresholded(3,this_node), strcat(seed_names{this_seed_folder},'_node',num2str(this_node),'_cb'), strcat(seed_names{this_seed_folder},'_network'), 'whole_brain_unsmoothed');
%         else
%             fprintf(fid, '%f, %f, %f, %s, %s, %s\n', ordered_voxel_coords_thresholded(1,this_node), ordered_voxel_coords_thresholded(2,this_node), ordered_voxel_coords_thresholded(3,this_node), strcat(seed_names{this_seed_folder},'_node',num2str(this_node)), strcat(seed_names{this_seed_folder},'_network'), 'whole_brain_unsmoothed');
%         end

%%
% for this_seed_folder = 1:length(seed_names)
%     
%     % make sure to grab the cb masked wb spmT file
%     if strcmp(project_name_split(end),'wb')
%         this_contrast_data = spm_vol(strcat(conn_project_name,filesep,'results',filesep,'secondlevel',filesep,'SBC_01',filesep,'AllSubjects',filesep,'rest',filesep,seed_names{this_seed_folder},filesep,'masked_spmT_0001.nii'));
%     else
%         this_contrast_data = spm_vol(strcat(conn_project_name,filesep,'results',filesep,'secondlevel',filesep,'SBC_01',filesep,'AllSubjects',filesep,'rest',filesep,seed_names{this_seed_folder},filesep,'spmT_0001.nii'));
%     end
%     
%     this_contrast_betas = spm_read_vols(this_contrast_data);
%     [x,y,z] = ind2sub(size(this_contrast_betas),1:(size(this_contrast_betas,1)*size(this_contrast_betas,2)*size(this_contrast_betas,3)));
%     
%     for i_value = 1:length(x)
%         betas_above_zero(i_value) = this_contrast_betas(x(i_value), y(i_value), z(i_value));
%     end
%     
%     [sorted_betas, ordered_indices] = sort(betas_above_zero,'descend');
%     
%     % find betas or T values (should do z map conversion) above threshold
%     indices_above_intensity_threshold = find(sorted_betas > T_threshold);
% 
%     ordered_indices_above_intensity_threshold = ordered_indices(indices_above_intensity_threshold);
%     
%     this_index = 1;
%     ordered_voxel_coords=[];
%     for this_ordered_coord = ordered_indices_above_intensity_threshold
%         ordered_voxel_coords(:,this_index) = [x(this_ordered_coord), y(this_ordered_coord), z(this_ordered_coord) ]-1;
%         this_index = this_index + 1;
%     end
%     
%     indices_tooClose_all_nodes=[0]; % little hack to get the logic to work below
%     for this_ordered_coord_index = 1:size(ordered_voxel_coords,2)
%         if ~ismember(indices_tooClose_all_nodes, this_ordered_coord_index)
%             distance_from_previous_node = pdist2(ordered_voxel_coords(:,this_ordered_coord_index)', ordered_voxel_coords');
%             indices_tooClose_to_this_node = find(distance_from_previous_node < distance_threshold);
%             this_ordered_coord_index_removal = find(indices_tooClose_to_this_node == this_ordered_coord_index);
%             indices_tooClose_to_this_node(this_ordered_coord_index_removal) = []; % remove this coord index bc it will obviously be 0 distance from itself
%             indices_tooClose_all_nodes = sort(unique([indices_tooClose_all_nodes indices_tooClose_to_this_node]));
%         end
%     end
%     
    
    
    
    
    
    
    
    
    
    
    
%     %% read roi settings file
% if ~isempty(roi_settings_filename)
%     file_name = roi_settings_filename;
%     fileID = fopen(file_name, 'r');
%     % read text to cell
%     text_line = fgetl(fileID);
%     text_cell = {};
%     while ischar(text_line)
%         text_cell = [text_cell; text_line]; %#ok<AGROW>
%         text_line = fgetl(fileID);
%     end
%     fclose(fileID);
%     % prune lines
%     lines_to_prune = false(size(text_cell, 1), 1);
%     for i_line = 1 : size(text_cell, 1)
%         this_line = text_cell{i_line};
%         % remove initial white space
%         while ~isempty(this_line) && (this_line(1) == ' ' || double(this_line(1)) == 9)
%             this_line(1) = [];
%         end
%         settings_cell{i_line} = this_line; %#ok<AGROW>
%         % remove comments
%         if length(this_line) > 1 && any(ismember(this_line, '#'))
%             lines_to_prune(i_line) = true;
%         end
%         % flag lines consisting only of white space
%         if all(ismember(this_line, ' ') | double(this_line) == 9)
%             lines_to_prune(i_line) = true;
%         end
%     end
%     settings_cell(lines_to_prune) = [];
%     
%     roi_dir = dir([strcat('ROIs', filesep,'*.nii')]);
%     clear roi_file_name_list;
%     [available_roi_file_name_list{1:length(roi_dir)}] = deal(roi_dir.name);
%     
%     for this_roi_index = 1:length(settings_cell)
%          this_roi_settings_split(this_roi_index,:) = strsplit(settings_cell{this_roi_index}, ',');
%     end
%     
%     % 1) find the unique networks           
%     this_file_unique_networks = strtrim(unique(this_roi_settings_split(:,5)));
%     
%     for this_unique_network_index = 1:length(this_file_unique_networks)
%         these_rois_unique_network_bool = contains(this_roi_settings_split(:,5), this_file_unique_networks(this_unique_network_index));
%         these_rois_unique_network_indices = find(these_rois_unique_network_bool);
%         this_roi_core_name = this_roi_settings_split(these_rois_unique_network_indices,4);
%         this_roi_file_name = strcat(strtrim(this_roi_core_name), '.nii');
%         [fda, this_roi_index_in_available_files, asdf] = intersect(available_roi_file_name_list, this_roi_file_name);