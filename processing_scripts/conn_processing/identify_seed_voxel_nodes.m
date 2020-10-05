function identify_seed_voxel_nodes(varargin)
% add arguments 1) conn_project 2) original seed to find the nodes
% associated???
parser = inputParser;
parser.KeepUnmatched = true;
addParameter(parser, 'conn_project_name', '')
addParameter(parser, 'T_threshold', '')
addParameter(parser, 'distance_threshold', '')
addParameter(parser, 'seed_names', '')
parse(parser, varargin{:})
conn_project_name = parser.Results.conn_project_name;
% seed_name = parser.Results.seed_name;
T_threshold = parser.Results.T_threshold;
distance_threshold = parser.Results.distance_threshold;
seed_names = parser.Results.seed_names;

% need to find out if this is cb to append to node name
project_name_split = strsplit(conn_project_name,'_');
    
% some reason folders appending dir from two above what interested in??
for this_seed_folder = 1:length(seed_names)
    
    % make sure to grab the cb masked wb spmT file
    if strcmp(project_name_split(end),'wb')
        this_contrast_data = spm_vol(strcat(conn_project_name,filesep,'results',filesep,'secondlevel',filesep,'SBC_01',filesep,'AllSubjects',filesep,'rest',filesep,seed_names{this_seed_folder},filesep,'masked_spmT_0001.nii'));
    else
        this_contrast_data = spm_vol(strcat(conn_project_name,filesep,'results',filesep,'secondlevel',filesep,'SBC_01',filesep,'AllSubjects',filesep,'rest',filesep,seed_names{this_seed_folder},filesep,'spmT_0001.nii'));
    end
    
    this_contrast_betas = spm_read_vols(this_contrast_data);
    [x,y,z] = ind2sub(size(this_contrast_betas),1:(size(this_contrast_betas,1)*size(this_contrast_betas,2)*size(this_contrast_betas,3)));
    
    for i_value = 1:length(x)
        betas_above_zero(i_value) = this_contrast_betas(x(i_value), y(i_value), z(i_value));
    end
    
    [sorted_betas, ordered_indices] = sort(betas_above_zero,'descend');
    
    % find betas or T values (should do z map conversion) above threshold
    indices_above_intensity_threshold = find(sorted_betas > T_threshold);

    ordered_indices_above_intensity_threshold = ordered_indices(indices_above_intensity_threshold);
    
    this_index = 1;
    ordered_voxel_coords=[];
    for this_ordered_coord = ordered_indices_above_intensity_threshold
        ordered_voxel_coords(:,this_index) = [x(this_ordered_coord), y(this_ordered_coord), z(this_ordered_coord) ]-1;
        this_index = this_index + 1;
    end
    
    indices_tooClose_all_nodes=[0]; % little hack to get the logic to work below
    for this_ordered_coord_index = 1:size(ordered_voxel_coords,2)
        if ~ismember(indices_tooClose_all_nodes, this_ordered_coord_index)
            distance_from_previous_node = pdist2(ordered_voxel_coords(:,this_ordered_coord_index)', ordered_voxel_coords');
            indices_tooClose_to_this_node = find(distance_from_previous_node < distance_threshold);
            this_ordered_coord_index_removal = find(indices_tooClose_to_this_node == this_ordered_coord_index);
            indices_tooClose_to_this_node(this_ordered_coord_index_removal) = []; % remove this coord index bc it will obviously be 0 distance from itself
            indices_tooClose_all_nodes = sort(unique([indices_tooClose_all_nodes indices_tooClose_to_this_node]));
        end
    end
    indices_tooClose_all_nodes(1) = []; %removing the zero index hack
    
    ordered_voxel_coords_thresholded = ordered_voxel_coords;
    ordered_voxel_coords_thresholded(:,indices_tooClose_all_nodes) = [];
    
    fid = fopen(strcat(conn_project_name,filesep,'results',filesep,'secondlevel',filesep,'SBC_01',filesep,'AllSubjects',filesep,'rest',filesep,seed_names{this_seed_folder},filesep,'ROI_settings_connNodeID_',seed_names{this_seed_folder},'.txt'),'wt');
    
    for this_node = 1:size(ordered_voxel_coords_thresholded,2)
        if strcmp(project_name_split(end),'cb')
            fprintf(fid, '%f, %f, %f, %s, %s, %s\n', ordered_voxel_coords_thresholded(1,this_node), ordered_voxel_coords_thresholded(2,this_node), ordered_voxel_coords_thresholded(3,this_node), strcat(seed_names{this_seed_folder},'_node',num2str(this_node),'_cb'), strcat(seed_names{this_seed_folder},'_network'), 'whole_brain_unsmoothed');
        else
            fprintf(fid, '%f, %f, %f, %s, %s, %s\n', ordered_voxel_coords_thresholded(1,this_node), ordered_voxel_coords_thresholded(2,this_node), ordered_voxel_coords_thresholded(3,this_node), strcat(seed_names{this_seed_folder},'_node',num2str(this_node)), strcat(seed_names{this_seed_folder},'_network'), 'whole_brain_unsmoothed');
        end
    end
    
    fclose(fid);
    disp(strcat(num2str(size(ordered_voxel_coords_thresholded,2)),{' '}, 'nodes associated with ',{' '}, seed_names{this_seed_folder}, ' seed'))
    
end
end