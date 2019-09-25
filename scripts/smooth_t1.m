 % Smooth
 %--------------------------------------------------------------------------
 
data_path = pwd;
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);


files_to_smooth = spm_select('FPList', data_path, '^normalized.*\.nii$');
files_to_smooth_t1 = spm_select('FPList', data_path, '^normalized.*\.nii$');

for i_file = 1 : size(files_to_smooth,1)
    this_file_with_volumes = spm_select('expand', files_to_smooth(i_file,:));

    matlabbatch{1}.spm.spatial.smooth.data = cellstr(this_file_with_volumes);
    matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{1}.spm.spatial.smooth.prefix = 'smoothed_';
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end