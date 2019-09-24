% Normalise: Write
%--------------------------------------------------------------------------

data_path = pwd;
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

files_to_normalise = spm_select('FPList', data_path, '^unwarpedRealigned.*\.nii$');

for i_file = 1 : size(files_to_normalise,1)
    this_file_with_volumes = spm_select('expand', files_to_normalise(i_file,:));
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.def  = cellstr('y_T1.nii');
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(this_file_with_volumes);
    
    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox  = [2 2 2];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'normalized_';
 
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
end
