
data_path = pwd;

% check the folder name and specify the volumes accordingly
path_components = strsplit(data_path,'/');

BATCH.New.structurals{1} = 'T1.nii';

if strcmp(path_components{end},"05_MotorImagery")
    BATCH.New.functionals{1}{1} = 'unwarpedRealigned_slicetimed_fMRI01_Run1.nii';
    BATCH.New.steps = {'functional_art'};
    BATCH.filename = 'Conn_Art_Folder_Stuff';
    BATCH.New.art_thresholds(1)= 9;
    BATCH.New.art_thresholds(2)= 2;

    conn_batch(BATCH)

   
    BATCH.New.functionals{1}{1} = 'unwarpedRealigned_slicetimed_fMRI01_Run2.nii';
    BATCH.New.steps = {'functional_art'};
    BATCH.filename = 'Conn_Art_Folder_Stuff';
    BATCH.New.art_thresholds(1)= 9;
    BATCH.New.art_thresholds(2)= 2;

    conn_batch(BATCH)
    
elseif strcmp(path_components{end},"06_Nback")
    BATCH.New.functionals{1}{1} = 'unwarpedRealigned_slicetimed_fMRI02_Run1.nii';
    BATCH.New.steps = {'functional_art'};
    BATCH.filename = 'Conn_Art_Folder_Stuff';
    BATCH.New.art_thresholds(1)= 9;
    BATCH.New.art_thresholds(2)= 2;

    conn_batch(BATCH)
    
    
    BATCH.New.functionals{1}{1} = 'unwarpedRealigned_slicetimed_fMRI02_Run2.nii';
    BATCH.New.steps = {'functional_art'};
    BATCH.filename = 'Conn_Art_Folder_Stuff';
    BATCH.New.art_thresholds(1)= 9;
    BATCH.New.art_thresholds(2)= 2;

    conn_batch(BATCH)
    
    
    BATCH.New.functionals{1}{1} = 'unwarpedRealigned_slicetimed_fMRI02_Run3.nii';
    BATCH.New.steps = {'functional_art'};
    BATCH.filename = 'Conn_Art_Folder_Stuff';
    BATCH.New.art_thresholds(1)= 9;
    BATCH.New.art_thresholds(2)= 2;

    conn_batch(BATCH)
    
    
    BATCH.New.functionals{1}{1} = 'unwarpedRealigned_slicetimed_fMRI02_Run4.nii';
    BATCH.New.steps = {'functional_art'};
    BATCH.filename = 'Conn_Art_Folder_Stuff';
    BATCH.New.art_thresholds(1)= 9;
    BATCH.New.art_thresholds(2)= 2;

    conn_batch(BATCH)
end


