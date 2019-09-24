clear, clc
data_path = pwd;
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

all_files_to_coregister = spm_select('FPList', data_path, '^slicetimed_fMRI.*\.nii$');

merged_distortion_map = spm_select('ExtFPList', data_path, 'Mean_AP_PA_merged.nii');

if size(merged_distortion_map,1) >= 2 
    error('check the images being grabbed!!')
end

for i_file = 1 : size(all_files_to_coregister,1)
    this_file_path_with_volumes = spm_select('expand', all_files_to_coregister(i_file,:));

    matlabbatch{1}.spm.spatial.coreg.estimate.ref =cellstr(merged_distortion_map);
    matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(this_file_path_with_volumes(1,:)); % take the first volume
    matlabbatch{1}.spm.spatial.coreg.estimate.other = cellstr(this_file_path_with_volumes);
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end
