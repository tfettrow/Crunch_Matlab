clear, clc
data_path = pwd;
b = regexp(data_path, '\d*0*\d','match');
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

file_names=spm_select('FPList', data_path, '^smoothed.*\.nii$');

for i_file = 1 : size(file_names,1)
    matlabbatch{1}.spm.util.disp.data = {[file_names(i_file,:)]};
    
    spm_jobman('run',matlabbatch);
    
    saveas(gcf,[b{1} '_smoothed_run' num2str(i_file)],'png')
    
    clear matlabbatch
end
