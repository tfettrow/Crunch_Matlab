% Coregister fMRI
%--------------------------------------------------------------------------

data_path = pwd;

spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

% functional_files = spm_select('FPList', data_path, '^unwarpedRealigned_slicetimed_.*\.nii$');
structural_file = spm_select('ExtFPList', data_path, '^T1.*\.nii$');
functional_files = spm_select('ExtFPList', data_path, '^unwarpedRealigned_slicetimed.*\.nii$');

% check the folder name and specify the volumes accordingly
path_components = strsplit(data_path,'\');

if strcmp(path_components{end},"05_MotorImagery")
    files_to_coregister1 = functional_files(1:168,:);
    files_to_coregister2 = functional_files(169:336,:);
elseif strcmp(path_components{end},"06_Nback")
    files_to_coregister1 = functional_files(1:200,:);
    files_to_coregister2 = functional_files(201:400,:);
    files_to_coregister3 = functional_files(401:602,:);
    files_to_coregister4 = functional_files(603:804,:);
end

volumes_in_file = size(files_to_coregister1,1);
for i = 1:volumes_in_file
    matlabbatch{1}.spm.spatial.coreg.estwrite.ref = cellstr(structural_file);
    matlabbatch{1}.spm.spatial.coreg.estwrite.source = cellstr(files_to_coregister1(i,:));
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
end














%--------------------------------------------------------------------------
% mean_functional_image = (spm_file(functional_files,'prefix','Mean_'));
% if strcmp(path_components{end},"05_MotorImagery")
%     mean_functional_image1 = mean_functional_image(1,:);
%     mean_functional_image2 = mean_functional_image(2,:);
% elseif strcmp(path_components{end},"06_Nback")
%     mean_functional_image1 = mean_functional_image(1,:);
%     mean_functional_image2 = mean_functional_image(2,:);
%     mean_functional_image3 = mean_functional_image(3,:);
%     mean_functional_image4 = mean_functional_image(4,:);
% end
% matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(mean_functional_image1);
% matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(structural_files);
% matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
% 
% spm_jobman('run',matlabbatch);
% clear matlabbatch
% 
% matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(mean_functional_image2);
% matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(structural_files);
% matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
% 
% spm_jobman('run',matlabbatch);
% clear matlabbatch
% 
% if strcmp(path_components{end},"06_Nback")
%     matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(mean_functional_image3);
%     matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(structural_files);
%     matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
%     matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
%     matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
%     matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
%     matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
% 
%     spm_jobman('run',matlabbatch);
%     clear matlabbatch
% 
%     matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(mean_functional_image4);
%     matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(structural_files);
%     matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
%     matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
%     matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
%     matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
%     matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
% 
%     spm_jobman('run',matlabbatch);
%     clear matlabbatch
% end
% 
% mean_functional_image = (spm_file(functional_files,'prefix','meanrealigned_'));
% mean_functional_image1 = mean_functional_image(1,1:end-4);
% mean_functional_image2 = mean_functional_image(2,1:end-4);
% if strcmp(path_components{end},"06_Nback")
%     mean_functional_image3 = mean_functional_image(3,1:end-4);
%     mean_functional_image4 = mean_functional_image(4,1:end-4);
% end
% matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(mean_functional_image1);
% matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(structural_files);
% matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
% 
% spm_jobman('run',matlabbatch);
% clear matlabbatch
% 
% matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(mean_functional_image2);
% matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(structural_files);
% matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
% matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
% 
% spm_jobman('run',matlabbatch);
% clear matlabbatch
% 
% if strcmp(path_components{end},"06_Nback")
%     matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(mean_functional_image3);
%     matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(structural_files);
%     matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
%     matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
%     matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
%     matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
%     matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
% 
%     spm_jobman('run',matlabbatch);
%     clear matlabbatch
% 
%     matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(mean_functional_image4);
%     matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(structural_files);
%     matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
%     matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
%     matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
%     matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
%     matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
% 
%     spm_jobman('run',matlabbatch);
%     clear matlabbatch
% end