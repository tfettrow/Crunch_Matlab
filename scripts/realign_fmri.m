data_path = pwd;
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

functional_files = spm_select('ExtFPList', data_path, '^slicetimed.*\.nii$');

% check the folder name and specify the volumes accordingly
path_components = strsplit(data_path,'/');

if strcmp(path_components{end},"05_MotorImagery")
    files_to_realign1 = functional_files(1:168,:);
    files_to_realign2 = functional_files(169:336,:);
elseif strcmp(path_components{end},"06_Nback")
    files_to_realign1 = functional_files(1:200,:);
    files_to_realign2 = functional_files(201:400,:);
    files_to_realign3 = functional_files(401:602,:);
    files_to_realign4 = functional_files(603:804,:);
end

% Realign:
% The goal is to find the best possible alignment between an input image and some target image (To all images)
% Determine the rigid body transformation that minimizes some cost function (SPM: least-square; FSL: normalized correlation ratio).
% Rigid Body Transformation: defined by 3 translations in x,y, and z directions and 3 rotations, around the x, y, and z axes.
%--------------------------------------------------------------------------
if strcmp(path_components{end},"05_MotorImagery")
    matlabbatch{1}.spm.spatial.realign.estwrite.data = {cellstr(files_to_realign1) cellstr(files_to_realign2)};
elseif strcmp(path_components{end},"06_Nback")
    matlabbatch{1}.spm.spatial.realign.estwrite.data = {cellstr(files_to_realign1) cellstr(files_to_realign2) cellstr(files_to_realign3) cellstr(files_to_realign4)};
end
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'realigned_';
spm_jobman('run',matlabbatch);
clear matlabbatch
