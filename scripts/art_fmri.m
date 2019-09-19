
data_path = pwd;

clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);


all_files_to_art = spm_select('FPList', data_path, '^unwarpedRealigned_slicetimed_.*\.nii$');

for i_file = 1 : size(all_files_to_art,1)
    this_file_to_art = all_files_to_art(i_file,:);
    
    BATCH.New.structurals{1} = 'T1.nii';
    
    BATCH.New.functionals{1}{1} = this_file_to_art;
    BATCH.New.steps = {'functional_art'};
    BATCH.filename = 'Conn_Art_Folder_Stuff';
    BATCH.New.art_thresholds(1)= 9;
    BATCH.New.art_thresholds(2)= 2;
    
    conn_batch(BATCH)
end
   

