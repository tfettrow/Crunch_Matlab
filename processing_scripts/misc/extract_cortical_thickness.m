function extract_cortical_thickness(surf_image,x,y,z)
% convert mni to voxel coords
surf_image = 'spmT_0001.gii';
template = '\\exasmb.rc.ufl.edu\blue\rachaelseidler\tfettrow\Crunch_Code\MR_Templates\MNI_15mm.nii'
% % roi_mni_coord = [-34 -32 66];
roi_voxel_x = '60';
roi_voxel_y = '32'; 
roi_voxel_z = '21';

data_dir = pwd;

info = cat_surf_info(fullfile(data_dir,surf_image),0);

P = spm_select([1 24], {'mesh','image'}, 'Select up to 24 volume or surface maps');
 
headerinfo = spm_data_hdr_read(fullfile(data_dir,surf_image));
surface_file_data = spm_data_read(spm_data_hdr_read(fullfile(data_dir,surf_image)),'xyz',1);

this_contrast_data = spm_vol(template);

a = ind2sub(this_contrast_data.dim(1),this_contrast_data.dim(2),this_contrast_data.dim(3))

this_roi_vox_coord = [roi_x roi_y roi_z 1] * this_contrast_data.mat';


ordered_intensity_vector = spm_data_read(spm_data_hdr_read(fullfile(data_dir,surf_image)));

somethin = gifti(fullfile(data_dir,surf_image))


H.S{ind}.M = gifti(H.S{ind}.info(1).Pmesh);            
        % get adjacency information
        H.S{ind}.A = spm_mesh_adjacency(H.S{ind}.M);
        
        g1 = gifti(fullfile(spm('dir'), 'toolbox', 'cat12', ['templates_surfaces' H.str32k], [H.S{i}.info(1).side '.mc.freesurfer.gii']));
        
        % first entries are atlases
plot_mean = H.cursor_mode - 5;
pos = get(evt, 'Position');

i = ismember(get(H.patch(1), 'vertices'), pos, 'rows');
node = find(i);
ind = 1;
node_list = 1:numel(get(H.patch(1), 'vertices'));


% 
% 
% roi_name = strtrim(roi_name);
% 
% roi_x = str2num(roi_x);
% roi_y = str2num(roi_y);
% roi_z = str2num(roi_z);
% 
this_contrast_data = spm_vol(surf_image);
% 
% this_roi_vox_coord = [roi_x roi_y roi_z 1] / ordered_intensity_vector.mat' -1;
% this_roi_vox_coord1 = this_roi_vox_coord(1);
% this_roi_vox_coord2 = this_roi_vox_coord(2);
% this_roi_vox_coord3 = this_roi_vox_coord(3);


% OR 
% roi_name = strtrim(roi_name);
% 
% roi_x = str2num(roi_x);
% roi_y = str2num(roi_y);
% roi_z = str2num(roi_z);
% 
% this_contrast_data = spm_vol('MNI_2mm.nii');
% 
% this_roi_vox_coord = [roi_x roi_y roi_z 1] * this_contrast_data.mat';
% this_roi_vox_coord1 = this_roi_vox_coord(1);
% this_roi_vox_coord2 = this_roi_vox_coord(2);
% this_roi_vox_coord3 = this_roi_vox_coord(3);
    

Y = SPM.xX.X * SPM.xCon(Ic).c * pinv(SPM.xCon(Ic).c) * beta;

% get raw data and whiten
% y = spm_data_read(SPM.xY.VY, 'xyz', XYZ);

%   y = cat_stat_nanmean(y, 2);



end