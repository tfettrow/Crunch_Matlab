function convert_to_mniVoxel_coordinates_4surfExtract(roi_name, roi_x, roi_y, roi_z)
% roi_name = 'caudate';
% % roi_mni_coord = [-34 -32 66];
% roi_x = '0';
% roi_y = '24'; 
% roi_z = '-4';


roi_name = strtrim(roi_name);

roi_x = str2num(roi_x);
roi_y = str2num(roi_y);
roi_z = str2num(roi_z);

this_contrast_data = spm_vol('\\exasmb.rc.ufl.edu\blue\rachaelseidler\tfettrow\Crunch_Code\MR_Templates\MNI_15mm.nii');

this_roi_vox_coord = [roi_x roi_y roi_z 1] / this_contrast_data.mat' -1;
this_roi_vox_coord1 = this_roi_vox_coord(1);
this_roi_vox_coord2 = this_roi_vox_coord(2);
this_roi_vox_coord3 = this_roi_vox_coord(3);


T = cell2table({this_roi_vox_coord}, 'VariableNames', {roi_name});

writetable(T, strcat('mniVoxel_',roi_name,'.csv'))

disp([roi_name ' information converted and saved'])
end