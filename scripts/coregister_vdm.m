data_path = pwd;


clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

% mean_functional_image = spm_select('ExtFPList', data_path, 'Mean_fMRI.*\.nii$');
functional_files = spm_select('ExtFPList', data_path, '^slicetimed_fMRI.*\.nii$');

% vdm_imagery_file = spm_select('ExtFPList', data_path, '^vdm5.*\img$');

vdm_mask_file = spm_select('ExtFPList', data_path, 'my_fieldmap_mask_brain.nii');
if size(vdm_mask_file,1) >= 2 
    error('check the images being grabbed!!')
end

% check the folder name and specify the volumes accordingly
path_components = strsplit(data_path,'/');

if strcmp(path_components{end},"05_MotorImagery")
    files_to_coregister1 = functional_files(1:168,:);
    files_to_coregister2 = functional_files(169:336,:);
    if    size(functional_files, 1) ~= 336
        error('check functional run being grabbed!!')
    end
elseif strcmp(path_components{end},"06_Nback")
    files_to_coregister1 = functional_files(1:200,:);
    files_to_coregister2 = functional_files(201:400,:);
    files_to_coregister3 = functional_files(401:602,:);
    files_to_coregister4 = functional_files(603:804,:);
   
     if size(functional_files, 1) ~= 804
        error('check functional run being grabbed!!')
    end
end

matlabbatch{1}.spm.spatial.coreg.estimate.ref = cellstr(vdm_mask_file);
matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(files_to_coregister1(1,:));
matlabbatch{1}.spm.spatial.coreg.estimate.other = cellstr(files_to_coregister1);
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
spm_jobman('run',matlabbatch);
clear matlabbatch

matlabbatch{1}.spm.spatial.coreg.estimate.ref = cellstr(vdm_mask_file);
matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(files_to_coregister2(1,:));
matlabbatch{1}.spm.spatial.coreg.estimate.other = cellstr(files_to_coregister2);
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
spm_jobman('run',matlabbatch);
clear matlabbatch

spm_jobman('run',matlabbatch);
clear matlabbatch

if strcmp(path_components{end},"06_Nback")
    
    matlabbatch{1}.spm.spatial.coreg.estimate.ref = cellstr(vdm_mask_file);
    matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(files_to_coregister3(1,:));
    matlabbatch{1}.spm.spatial.coreg.estimate.other = cellstr(files_to_coregister3);
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
    matlabbatch{1}.spm.spatial.coreg.estimate.ref = cellstr(vdm_mask_file);
    matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(files_to_coregister4(1,:));
    matlabbatch{1}.spm.spatial.coreg.estimate.other = cellstr(files_to_coregister4);
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    spm_jobman('run',matlabbatch);
    clear matlabbatch

end
    