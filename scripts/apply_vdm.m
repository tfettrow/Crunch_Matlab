
data_path = pwd; 
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);


all_files_to_uwarp = spm_select('FPList', data_path, '^realigned_slicetimed.*\.nii$');

for i_file = 1 : size(all_files_to_uwarp,1)
    this_file_with_volumes = spm_select('expand', all_files_to_uwarp(i_file,:));

    matlabbatch{1}.spm.tools.fieldmap.applyvdm.data.scans = this_file_with_volumes;
    matlabbatch{1}.spm.tools.fieldmap.applyvdm.data.vdmfile = cellstr(vdm_imagery_files);
    matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.pedir = 2;
    matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.which = [2 1];
    matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.rinterp = 4;
    matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.wrap = [0 1 0];
    matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.mask = 0;
    matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.prefix = 'unwarped_';
    spm_jobman('run',matlabbatch);
    clear matlabbatch

end