function coregister_fmri_to_MeanFM_single(functional_file_name)
data_path = pwd;
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);


this_file_to_coregister = spm_select('FPList', data_path, strcat('^',functional_file_name,'$'));

merged_distortion_map = spm_select('ExtFPList', data_path, 'Mean_AP_PA_merged.nii');

if size(merged_distortion_map,1) >= 2 
    error('check the images being grabbed!!')
end

    this_file_path_with_volumes = spm_select('expand', this_file_to_coregister);

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

