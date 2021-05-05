% exploreDTI flip/permute MiM data

data_path = pwd;

dwi_filename= strcat(data_path,filesep,'DWI.nii');
param=[];
param.suff= '';
param.permute= [1 2 3];
param.flip= [0 0 0];
param.force_voxel_size = [2 2 2];

E_DTI_flip_permute_nii_file_exe(dwi_filename,param,dwi_filename);
