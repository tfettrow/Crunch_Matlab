 % Smooth
 %--------------------------------------------------------------------------
 
data_path = pwd;

spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

files_to_smooth = spm_select('ExtFPList', data_path, '^normalized.*\.nii$');

% check the folder name and specify the volumes accordingly
path_components = strsplit(data_path,'/');

if strcmp(path_components{end},"05_MotorImagery")
    files_to_smooth1 = files_to_smooth(1:168,:);
    files_to_smooth2 = files_to_smooth(169:336,:);
elseif strcmp(path_components{end},"06_Nback")
    files_to_smooth1 = files_to_smooth(1:200,:);
    files_to_smooth2 = files_to_smooth(201:400,:);
    files_to_smooth3 = files_to_smooth(401:602,:);
    files_to_smooth4 = files_to_smooth(603:804,:);
end 
 
 matlabbatch{1}.spm.spatial.smooth.data = cellstr(files_to_smooth1);
 matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
 matlabbatch{1}.spm.spatial.smooth.prefix = 'smooth_';
 spm_jobman('run',matlabbatch);
 clear matlabbatch
 
 matlabbatch{1}.spm.spatial.smooth.data =  cellstr(files_to_smooth2);
 matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
 matlabbatch{1}.spm.spatial.smooth.prefix = 'smooth_';
 
 spm_jobman('run',matlabbatch);
 clear matlabbatch
 
 if strcmp(path_components{end},"06_Nback")
     matlabbatch{1}.spm.spatial.smooth.data = cellstr(files_to_smooth3);
     matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
     matlabbatch{1}.spm.spatial.smooth.prefix = 'smooth_';
     spm_jobman('run',matlabbatch);
     clear matlabbatch
     
     matlabbatch{1}.spm.spatial.smooth.data =  cellstr(files_to_smooth4);
     matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
     matlabbatch{1}.spm.spatial.smooth.prefix = 'smooth_';
     
     spm_jobman('run',matlabbatch);
     clear matlabbatch
 end
 % Smooth
 %--------------------------------------------------------------------------

files_to_smooth = spm_select('ExtFPList', data_path, '^wslicetimed_realigned.*\.nii$');
 

if strcmp(path_components{end},"05_MotorImagery")
    files_to_smooth1 = files_to_smooth(1:168,:);
    files_to_smooth2 = files_to_smooth(169:336,:);
elseif strcmp(path_components{end},"06_Nback")
    files_to_smooth1 = files_to_smooth(1:200,:);
    files_to_smooth2 = files_to_smooth(201:400,:);
    files_to_smooth3 = files_to_smooth(401:602,:);
    files_to_smooth4 = files_to_smooth(603:804,:);
end 
 
 
 matlabbatch{1}.spm.spatial.smooth.data = cellstr(files_to_smooth1);
 matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
 matlabbatch{1}.spm.spatial.smooth.prefix = 'smooth_';
 spm_jobman('run',matlabbatch);
 clear matlabbatch
 
 matlabbatch{1}.spm.spatial.smooth.data =  cellstr(files_to_smooth2);
 matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
 matlabbatch{1}.spm.spatial.smooth.prefix = 'smooth_'; 
 spm_jobman('run',matlabbatch);
 clear matlabbatch
 
 if strcmp(path_components{end},"06_Nback")
     matlabbatch{1}.spm.spatial.smooth.data = cellstr(files_to_smooth3);
     matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
     matlabbatch{1}.spm.spatial.smooth.prefix = 'smooth_';
     spm_jobman('run',matlabbatch);
     clear matlabbatch
     
     matlabbatch{1}.spm.spatial.smooth.data =  cellstr(files_to_smooth4);
     matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
     matlabbatch{1}.spm.spatial.smooth.prefix = 'smooth_';
     spm_jobman('run',matlabbatch);
     clear matlabbatch
 end