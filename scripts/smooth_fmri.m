 % Smooth
 %--------------------------------------------------------------------------
 
data_path = pwd;
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);


files_to_smooth_MNI = spm_select('FPList', data_path, '^normalized2MNI.*\.nii$');
files_to_smooth_t1 = spm_select('FPList', data_path, '^normalized2t1.*\.nii$');


for i_file = 1 : size(files_to_smooth_MNI,1)
    this_file_with_volumes_MNI = spm_select('expand', files_to_smooth_MNI(i_file,:));
    this_file_with_volumes_t1 = spm_select('expand', files_to_smooth_t1(i_file,:));

    matlabbatch{1}.spm.spatial.smooth.data = cellstr(files_to_smooth_MNI);
    matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{1}.spm.spatial.smooth.prefix = 'smoothed_';
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
    matlabbatch{1}.spm.spatial.smooth.data = cellstr(files_to_smooth_t1);
    matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{1}.spm.spatial.smooth.prefix = 'smoothed_';
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
end