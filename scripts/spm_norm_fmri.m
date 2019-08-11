% Normalise: Write
%--------------------------------------------------------------------------

data_path = pwd;

spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

% check the folder name and specify the volumes accordingly
path_components = strsplit(data_path,'/');

files_to_normalise = spm_select('ExtFPList', data_path, '^unwarpedRealigned.*\.nii$');

if strcmp(path_components{end},"05_MotorImagery")
    files_to_normalise1 = files_to_normalise(1:168,:);
    files_to_normalise2 = files_to_normalise(169:336,:);
elseif strcmp(path_components{end},"06_Nback")
    files_to_normalise1 = files_to_normalise(1:200,:);
    files_to_normalise2 = files_to_normalise(201:400,:);
    files_to_normalise3 = files_to_normalise(401:602,:);
    files_to_normalise4 = files_to_normalise(603:804,:);
end


matlabbatch{1}.spm.spatial.normalise.write.subj.def  = cellstr('y_T1.nii');
matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(files_to_normalise1);

matlabbatch{1}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];
matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'normalized_';

% This is superimposing subject's functional activations on their own
% anatomy... how? grabbing specific files?
% What do we actually do?
% matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
% matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(spm_file(a,'prefix','m','ext','nii'));
% matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [1 1 3];

spm_jobman('run',matlabbatch);
clear matlabbatch


matlabbatch{1}.spm.spatial.normalise.write.subj.def  = cellstr('y_T1.nii');
matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(files_to_normalise2);
matlabbatch{1}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];
matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'normalized_';

% This is superimposing subject's functional activations on their own
% anatomy... how? grabbing specific files?
% What do we actually do?
% matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
% matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(spm_file(a,'prefix','m','ext','nii'));
% matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [1 1 3];

spm_jobman('run',matlabbatch);
clear matlabbatch

if strcmp(path_components{end},"06_Nback")
    matlabbatch{1}.spm.spatial.normalise.write.subj.def  = cellstr('y_T1.nii');
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(files_to_normalise3);

    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'normalized_';
    
    % This is superimposing subject's functional activations on their own
    % anatomy... how? grabbing specific files?
    % What do we actually do?
    % matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
    % matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(spm_file(a,'prefix','m','ext','nii'));
    % matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [1 1 3];
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.def  = cellstr('y_T1.nii');
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(files_to_normalise4);
    
    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'normalized_';
    
    % This is superimposing subject's functional activations on their own
    % anatomy... how? grabbing specific files?
    % What do we actually do?
    % matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
    % matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(spm_file(a,'prefix','m','ext','nii'));
    % matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [1 1 3];
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end

files_to_normalise = spm_select('ExtFPList', data_path, '^slicetimed_realigned.*\.nii$');

if strcmp(path_components{end},"05_MotorImagery")
    files_to_normalise1 = files_to_normalise(1:168,:);
    files_to_normalise2 = files_to_normalise(169:336,:);
elseif strcmp(path_components{end},"06_Nback")
    files_to_normalise1 = files_to_normalise(1:200,:);
    files_to_normalise2 = files_to_normalise(201:400,:);
    files_to_normalise3 = files_to_normalise(401:602,:);
    files_to_normalise4 = files_to_normalise(603:804,:);
end

matlabbatch{1}.spm.spatial.normalise.write.subj.def  = cellstr('y_T1.nii');
matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(files_to_normalise1);
matlabbatch{1}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];
matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'normalized_';

% This is superimposing subject's functional activations on their own
% anatomy... how? grabbing specific files?
% What do we actually do?
% matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
% matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(spm_file(a,'prefix','m','ext','nii'));
% matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [1 1 3];

spm_jobman('run',matlabbatch);
clear matlabbatch


matlabbatch{1}.spm.spatial.normalise.write.subj.def  = cellstr('y_T1.nii');

matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(files_to_normalise2);

matlabbatch{1}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];
matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'normalized_';

% This is superimposing subject's functional activations on their own
% anatomy... how? grabbing specific files?
% What do we actually do?
% matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
% matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(spm_file(a,'prefix','m','ext','nii'));
% matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [1 1 3];

spm_jobman('run',matlabbatch);
clear matlabbatch

if strcmp(path_components{end},"06_Nback")
    matlabbatch{1}.spm.spatial.normalise.write.subj.def  = cellstr('y_T1.nii');
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(files_to_normalise3);
    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'normalized_';
    
    % This is superimposing subject's functional activations on their own
    % anatomy... how? grabbing specific files?
    % What do we actually do?
    % matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
    % matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(spm_file(a,'prefix','m','ext','nii'));
    % matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [1 1 3];
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.def  = cellstr('y_T1.nii');
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(files_to_normalise4);
    
    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'normalized_';
    
    % This is superimposing subject's functional activations on their own
    % anatomy... how? grabbing specific files?
    % What do we actually do?
    % matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
    % matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(spm_file(a,'prefix','m','ext','nii'));
    % matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [1 1 3];
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end