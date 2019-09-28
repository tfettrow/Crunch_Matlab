function art_fmri(functional_file_name)
data_path = pwd;

    clear matlabbatch
    spm('Defaults','fMRI');
    spm_jobman('initcfg');
    spm_get_defaults('cmdline',true);


    this_file_to_art = spm_select('FPList', data_path, strcat('^',functional_file_name,'$'));
    this_structural = spm_select('FPList', data_path, '^T1.*\.nii$');
    
    BATCH.New.structurals{1} = this_structural;
    
    BATCH.New.functionals{1}{1} = this_file_to_art;
    BATCH.New.steps = {'functional_art'};
    BATCH.filename = 'Conn_Art_Folder_Stuff';
    BATCH.New.art_thresholds(1)= 9;  % z threshold
    BATCH.New.art_thresholds(2)= 2;  % movement threshold
    
    conn_batch(BATCH)
    
    
    [filepath,file_name,ext] = fileparts(this_file_to_art);
    
    movefile('art_screenshot.jpg', strcat('ARTscreenshot_',file_name,'.jpg'))

  
end