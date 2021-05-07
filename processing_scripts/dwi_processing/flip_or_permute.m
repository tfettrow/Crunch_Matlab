% exploreDTI flip/permute MiM data

data_path = pwd;

if isfile('DWI_RL.nii')
    delete('DWI_RL.nii');
end

dwi_filename = strcat(data_path,filesep,'DWI.nii');
dwi_basename = strcat(data_path,filesep,'DWI'); 
param=[];
% param.suff= '_RL';
param.permute= [1 2 3];
param.flip= [0 1 0];
param.force_voxel_size = [2 2 2];

E_DTI_flip_permute_nii_file_exe(dwi_filename,param,strcat(dwi_basename, '_RL.nii'));
