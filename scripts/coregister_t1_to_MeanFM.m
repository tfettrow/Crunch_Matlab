clear, clc
data_path = pwd;
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

structural_file = spm_select('ExtFPList', data_path, '^T1.*\.nii$');

merged_distortion_map = spm_select('ExtFPList', data_path, 'Mean_AP_PA_merged.nii');

if size(structural_file,1) >= 2 || size(merged_distortion_map,1) >= 2
    error('check the images being grabbed!!')
end

matlabbatch{1}.spm.spatial.coreg.estimate.ref =cellstr(merged_distortion_map);
matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(structural_file);
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
spm_jobman('run',matlabbatch);
clear matlabbatch


