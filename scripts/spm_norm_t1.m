
data_path = pwd;
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

files_to_normalise = spm_select('ExtFPList', data_path, '^mT1.*\.nii$');

matlabbatch{1}.spm.spatial.normalise.write.subj.def  = cellstr('y_T1.nii');
matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(files_to_normalise);

matlabbatch{1}.spm.spatial.normalise.write.woptions.vox  = [2 2 2];
matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'normalized_';

spm_jobman('run',matlabbatch);
clear matlabbatch

