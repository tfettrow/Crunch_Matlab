function image_diff(file_to_compare_1,file_to_compare_2, volume)
data_path = pwd; % assuming the shell command places the wd to: ('Processed/MRI_files/03_Fieldmaps/Fieldmap_nback' or /Fieldmap_motorImagery' or /DTI) 

spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

full_file_name_1 = spm_select('ExtFPList',data_path, strcat(file_to_compare_1,'.img'))
full_file_name_2 = spm_select('ExtFPList',data_path, strcat(file_to_compare_2,'.img'))

% TO DO: Automate the file grabbing...
matlabbatch{1}.spm.util.imcalc.input = {
    full_file_name_1(volume,:)
    full_file_name_2(volume,:)
    };

matlabbatch{1}.spm.util.imcalc.output = strcat(file_to_compare_1,'_minus_', file_to_compare_2);
matlabbatch{1}.spm.util.imcalc.outdir = {pwd};
matlabbatch{1}.spm.util.imcalc.expression = '(i1-i2)';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

spm_jobman('run',matlabbatch);
clear matlabbatch

end
