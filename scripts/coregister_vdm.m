data_path = pwd;

spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

functional_files = spm_select('ExtFPList', data_path, '^fMRI.*\.nii$');

vdm_imagery_file = spm_select('ExtFPList', data_path, '^vdm5.*\img$');

vdm_mask_file = spm_select('ExtFPList', data_path, '^my_fieldmap_mask.*\nii$');

%--------------------------------------------------------------------------
mean_functional_image = (spm_file(functional_files,'prefix','Mean_'));

% matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(mean_functional_image);
% matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(vdm_imagery_file);
% matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

matlabbatch{1}.spm.spatial.coreg.estwrite.ref = cellstr(mean_functional_image);
matlabbatch{1}.spm.spatial.coreg.estwrite.source = cellstr(vdm_mask_file);
matlabbatch{1}.spm.spatial.coreg.estwrite.other = {''};
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'coregistered_';

spm_jobman('run',matlabbatch);
clear matlabbatch

