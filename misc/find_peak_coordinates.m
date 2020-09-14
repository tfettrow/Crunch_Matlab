function find_roi_voxel_coordinates(roi_name)
roi_name = 'neurosynth_dlpfc.nii';
% roi_name = 'neurosynth_acc.nii';

this_contrast_data = spm_vol(roi_name);

% this_roi_vox_coord = [roi_mni_coord 1] / this_contrast_data.mat';
 
this_contrast_betas = spm_read_vols(this_contrast_data);

indices_with_values = find(this_contrast_betas>0);

[x,y,z] = ind2sub(size(this_contrast_betas),indices_with_values);

for i_value = 1:length(x)
       betas_above_zero(i_value) = this_contrast_betas(x(i_value), y(i_value), z(i_value));
end

[sorted_betas, ordered_indices] = sort(betas_above_zero,'descend');

this_index = 1;
for this_ordered_index = ordered_indices
    ordered_voxel_coords(:,this_index) = [x(this_ordered_index), y(this_ordered_index), z(this_ordered_index) ]-1;
    this_index = this_index + 1;
end

cell_coords = num2cell(ordered_voxel_coords);

T = cell2table(cell_coords);

writetable(T, strcat('ordered_betas_',roi_name,'.csv'))

end