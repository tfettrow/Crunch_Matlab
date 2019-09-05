
data_path = pwd; % assuming the shell command places the wd to: ('Processed/MRI_files/03_Fieldmaps/Fieldmap_nback' or /Fieldmap_motorImagery' or /DTI) 

spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

functional_files = spm_select('ExtFPList', data_path, '^realigned_slicetimed.*\.nii$');

vdm_imagery_files = spm_select('ExtFPList', data_path, '^vdm5.*\img$');
vdm_imagery_files_nifti = spm_select('ExtFPList', data_path, '^vdm5.*\nii$');

% check the folder name and specify the volumes accordingly
path_components = strsplit(data_path,'/');

if strcmp(path_components{end},"05_MotorImagery")
    files_to_unwarp1 = functional_files(1:168,:);
    files_to_unwarp2 = functional_files(169:336,:);
elseif strcmp(path_components{end},"06_Nback")
    files_to_unwarp1 = functional_files(1:200,:);
    files_to_unwarp2 = functional_files(201:400,:);
    files_to_unwarp3 = functional_files(401:602,:);
    files_to_unwarp4 = functional_files(603:804,:);
end

matlabbatch{1}.spm.tools.fieldmap.applyvdm.data.scans = cellstr(files_to_unwarp1);
matlabbatch{1}.spm.tools.fieldmap.applyvdm.data.vdmfile = cellstr(vdm_imagery_files);
matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.pedir = 2;
matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.which = [2 1];
matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.rinterp = 4;
matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.wrap = [0 1 0];
matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.mask = 0;
matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.prefix = 'unwarped_';
spm_jobman('run',matlabbatch);
clear matlabbatch

matlabbatch{1}.spm.tools.fieldmap.applyvdm.data.scans = cellstr(files_to_unwarp2);
matlabbatch{1}.spm.tools.fieldmap.applyvdm.data.vdmfile = cellstr(vdm_imagery_files);
matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.pedir = 2;
matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.which = [2 1];
matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.rinterp = 4;
matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.wrap = [0 1 0];
matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.mask = 0;
matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.prefix = 'unwarped_';
spm_jobman('run',matlabbatch);
clear matlabbatch


if strcmp(path_components{end},"06_Nback")
    matlabbatch{1}.spm.tools.fieldmap.applyvdm.data.scans = cellstr(files_to_unwarp3);
    matlabbatch{1}.spm.tools.fieldmap.applyvdm.data.vdmfile = cellstr(vdm_imagery_files);
    matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.pedir = 2;
    matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.which = [2 1];
    matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.rinterp = 4;
    matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.wrap = [0 1 0];
    matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.mask = 0;
    matlabbatch{1}.spm.tools.fieldmap.applyvdm.roptions.prefix = 'unwarped_';
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
    
    matlabbatch{1}.spm.tools.fieldmap.applyvdm.data.scans = cellstr(files_to_unwarp3);
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
