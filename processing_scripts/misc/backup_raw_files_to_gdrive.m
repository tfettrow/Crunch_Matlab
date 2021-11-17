
mim_root = fullfile('\\exasmb.rc.ufl.edu\blue\rachaelseidler\share\FromExternal\Research_Projects_UF\CRUNCH\MiM_Data');
gdrive_root = fullfile('G:',filesep,'Shared drives',filesep,'MiM_Backup'); % thought this might work for mac but after a quick thought it prob wont

subject_id = '1002';

mkdir(fullfile(gdrive_root,subject_id,'Raw'));

copyfile(fullfile(mim_root,subject_id,'Raw'), fullfile(gdrive_root,subject_id,'Raw'))
        
disp(['copying' sourceFile{:} 'to' destinationFile{:}])