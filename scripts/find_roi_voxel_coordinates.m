function find_roi_voxel_coordinates(roi_name, roi_x, roi_y, roi_z)
roi_name = 'LM1';
% roi_mni_coord = [-34 -32 66];
roi_x = '43';
roi_y = '-2'; 
roi_z = '46';

roi_x = str2num(roi_x);
roi_y = str2num(roi_y);
roi_z = str2num(roi_z);


this_contrast_data = spm_vol('con_0001.nii');

this_roi_vox_coord = [roi_x roi_y roi_z 1] / this_contrast_data.mat' -1;
 
this_contrast_betas = spm_read_vols(this_contrast_data);

this_contrast_betas(isnan(this_contrast_betas)) = 0;

BW = imregionalmax(this_contrast_betas);

indx = find(BW>0);

[x,y,z] = ind2sub(size(BW),indx);

A = spm_clusters([x,y,z]);

D = pdist2([x,y,z], this_roi_vox_coord(1:3));

[closest_peak_voxel, closest_peak_voxel_index] = min(D);

this_peak_cluster_coord = [x(closest_peak_voxel_index) y(closest_peak_voxel_index) z(closest_peak_voxel_index)];

T = cell2table({this_peak_cluster_coord}, 'VariableNames', {strcat('roi_',roi_name)});

writetable(T, strcat('roi_',roi_name,'.csv'))

disp([roi_name ' information converted and saved'])

end