% skull strip

% Segment fMRI
data_path = pwd;

spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

% TO DO: Automate the file grabbing...
matlabbatch{1}.spm.util.imcalc.input = {
    spm_select('ExtFPList',data_path, '^c1.*\.nii$')
    spm_select('ExtFPList',data_path, '^c2.*\.nii$')
    spm_select('ExtFPList',data_path, '^c3.*\.nii$')
    spm_select('ExtFPList',data_path, '^T1.*\.nii$')
    };
matlabbatch{1}.spm.util.imcalc.output = 'SkullStripped_Template';
matlabbatch{1}.spm.util.imcalc.outdir = {pwd};
matlabbatch{1}.spm.util.imcalc.expression = '(i1+i2+i3).*i4';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

spm_jobman('run',matlabbatch);
clear matlabbatch