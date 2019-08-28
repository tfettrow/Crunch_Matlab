
data_path = pwd; % assuming the shell command places the wd to: ('Processed/MRI_files/03_Fieldmaps/Fieldmap_nback' or /Fieldmap_motorImagery' or /DTI) 

spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

fieldmap_file = spm_select('ExtFPList',data_path, '^fpm.*\.img$');
%epi_file = spm_select('FPList',data_path, '^se.*\.nii$');
%magnitude_file = spm_select('FPList',data_path, '^.*\.nii$');
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.precalcfieldmap.precalcfieldmap = {fieldmap_file};
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session.epi = {''};
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.precalcfieldmap.magfieldmap ={''};
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsfile = {'Ugrant_defaults.m'};
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchvdm = 0;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.sessname = 'session';
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.anat = '';
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchanat = 0;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.writeunwarped = 0;
spm_jobman('run',matlabbatch);
clear matlabbatch