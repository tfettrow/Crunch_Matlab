function find_roi_voxel_coordinates(roi_name, roi_mni_coord)
roi_name = 'LM1'
roi_mni_coord = [-34 -32 66];

this_contrast_data = spm_vol('con_0001.nii');

this_roi_vox_coord = [roi_mni_coord 1] / this_contrast_data.mat';
 
this_contrast_betas = spm_read_vols(this_contrast_data);

indx = find(this_contrast_betas>0);
% [peaks, peak_indx] = spm_clusters(this_contrast_betas);
[x,y,z] = ind2sub(size(this_contrast_betas),indx);

D = pdist2([x,y,z], this_roi_vox_coord(1:3));

[closest_peak_voxel, closest_peak_voxel_index] = min(D);

this_peak_cluster_coord = [x(closest_peak_voxel_index) y(closest_peak_voxel_index) z(closest_peak_voxel_index)];
    
% this_table_cell = {gender, age, weight, height};

T = cell2table({this_peak_cluster_coord}, 'VariableNames', {strcat('roi_',roi_name)});

writetable(T, strcat('roi_',roi_name,'.csv'))

end