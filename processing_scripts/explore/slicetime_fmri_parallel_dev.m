function slicetime_fmri_parallel_dev(file_name)

% disp file_name_string
    file_name_string=num2str(file_name);

    data_path = pwd
    clear matlabbatch
    spm('Defaults','fMRI');
    spm_jobman('initcfg');
    spm_get_defaults('cmdline',true);
    
    json_path_names =spm_select('FPList', data_path, [file_name_string '.*\.json$']);

    all_files_to_slicetime = spm_select('FPList', data_path, [file_name_string '.*\.nii$']);

    this_file_with_volumes = spm_select('expand', all_files_to_slicetime);
    
    this_scan_fullpath_cell{1,1} =  cellstr(this_file_with_volumes);
    
    matlabbatch{1}.spm.temporal.st.scans = this_scan_fullpath_cell;
    [stMsec, TRsec] = bidsSliceTiming(json_path_names);
    if isempty(stMsec) || isempty(TRsec), error('Update dcm2niix? Unable determine slice timeing or TR from BIDS file %s', BIDSname); end;
    
    reftime = max(stMsec)/2;
    
    timing = [0 TRsec];
    matlabbatch{1}.spm.temporal.st.nslices = length(stMsec);
    matlabbatch{1}.spm.temporal.st.tr = TRsec;
    matlabbatch{1}.spm.temporal.st.ta = 0;
    matlabbatch{1}.spm.temporal.st.so = stMsec;
    matlabbatch{1}.spm.temporal.st.refslice = reftime;
    matlabbatch{1}.spm.temporal.st.prefix = 'PARslicetimed_';
    
 

    spm_jobman('run',matlabbatch);
end