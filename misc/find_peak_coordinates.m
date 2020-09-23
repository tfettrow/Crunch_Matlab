function find_roi_voxel_coordinates(filename)
filename='spmT_0001.nii';

this_contrast_data = spm_vol(filename);

this_contrast_betas = spm_read_vols(this_contrast_data);

indices_with_values = find(this_contrast_betas>0);

[x,y,z] = ind2sub(size(this_contrast_betas),indices_with_values);

for i_value = 1:length(x)
       betas_above_zero(i_value) = this_contrast_betas(x(i_value), y(i_value), z(i_value));
end

[sorted_betas, ordered_indices] = sort(betas_above_zero,'descend');

% find betas or T values (should do z map conversion) above threshold
split_filename = split(filename,'_');
if strcmp(split_filename{1},'spmT')
    indices_above_intensity_threshold = find(sorted_betas > 5);
elseif strcmp(split_filename{1},'con')
    indices_above_intensity_threshold = find(sorted_betas > 1);
end

ordered_indices_above_intensity_threshold = ordered_indices(indices_above_intensity_threshold);
    
this_index = 1;
for this_ordered_coord = ordered_indices_above_intensity_threshold
    ordered_voxel_coords(:,this_index) = [x(this_ordered_coord), y(this_ordered_coord), z(this_ordered_coord) ]-1;
    this_index = this_index + 1;
end

indices_tooClose_all_nodes=[0]; % little hack to get the logic to work below
for this_ordered_coord_index = 1:size(ordered_voxel_coords,2)
    if ~ismember(indices_tooClose_all_nodes, this_ordered_coord_index)
        distance_from_previous_node = pdist2(ordered_voxel_coords(:,this_ordered_coord_index)', ordered_voxel_coords');
        indices_tooClose_to_this_node = find(distance_from_previous_node < 10);
        this_ordered_coord_index_removal = find(indices_tooClose_to_this_node == this_ordered_coord_index);
        indices_tooClose_to_this_node(this_ordered_coord_index_removal) = []; % remove this coord index bc it will obviously be 0 distance from itself
        indices_tooClose_all_nodes = sort(unique([indices_tooClose_all_nodes indices_tooClose_to_this_node]))
    end
end
indices_tooClose_all_nodes(1) = []; %removing the zero index hack 

ordered_voxel_coords_thresholded = ordered_voxel_coords;
ordered_voxel_coords_thresholded(:,indices_tooClose_all_nodes) = [];

cell_coords = num2cell(ordered_voxel_coords_thresholded);

T = cell2table(cell_coords);

writetable(T, strcat('ordered_thresholded_coords_',filename,'.csv'))

end