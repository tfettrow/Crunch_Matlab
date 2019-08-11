data_path = pwd;

spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

functional_files = spm_select('ExtFPList', data_path, '^fMRI.*\.nii$');

vdm_imagery_files = spm_select('ExtFPList', data_path, '^vdm5.*\img$');

% check the folder name and specify the volumes accordingly
path_components = strsplit(data_path,'/');

if strcmp(path_components{end},"05_MotorImagery")
    functional_imagery_files1 = functional_files(1:168,:);
    functional_imagery_files2 = functional_files(169:336,:);
elseif strcmp(path_components{end},"06_Nback")
    functional_imagery_files1 = functional_files(1:200,:);
    functional_imagery_files2 = functional_files(201:400,:);
    functional_imagery_files3 = functional_files(401:602,:);
    functional_imagery_files4 = functional_files(603:804,:);
end


% check the folder name and specify the volumes accordingly
path_components = strsplit(data_path,'/');

%--------------------------------------------------------------------------
mean_functional_image = (spm_file(functional_files,'prefix','meanunwarpedRealigned_'));
if strcmp(path_components{end},"05_MotorImagery")
    mean_functional_image1 = mean_functional_image(1,:);
    mean_functional_image2 = mean_functional_image(2,:);
elseif strcmp(path_components{end},"06_Nback")
    mean_functional_image1 = mean_functional_image(1,:);
    mean_functional_image2 = mean_functional_image(2,:);
    mean_functional_image3 = mean_functional_image(3,:);
    mean_functional_image4 = mean_functional_image(4,:);
end
matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(mean_functional_image1);
matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(structural_files);
matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

spm_jobman('run',matlabbatch);
clear matlabbatch

matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(mean_functional_image2);
matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(structural_files);
matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

spm_jobman('run',matlabbatch);
clear matlabbatch

if strcmp(path_components{end},"06_Nback")
    matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(mean_functional_image3);
    matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(structural_files);
    matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

    spm_jobman('run',matlabbatch);
    clear matlabbatch
