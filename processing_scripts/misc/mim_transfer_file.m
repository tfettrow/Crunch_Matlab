function mim_transfer_file(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
addParameter(parser, 'subjects', '')
addParameter(parser, 'transfer_path', '') %files to
addParameter(parser, 'root_destination', '') %destination up to subject folder
addParameter(parser, 'subject_folder_destination', '') %destination after subject folder
parse(parser, varargin{:})
file_path_to_transfer = parser.Results.transfer_path;
root_destination = parser.Results.root_destination;
subject_folder_destination = parser.Results.subject_folder_destination;
subjects = parser.Results.subjects;

study_dir = pwd;

for this_subject = subjects
    
    %     sourceFile = fullfile(study_dir, this_subject, file_path_to_transfer);
    %     sourceFile = fullfile(study_dir, 'FAt',strcat('FW_',this_subject, '__FA.nii'));
    %     sourceFile = fullfile(study_dir, 'FAt_skeletons',strcat('FAt_skeleton_',this_subject, '.nii'));
    %     sourceFile = fullfile(subject_dir,file_path_to_transfer);
    %
    %     destinationFile = fullfile(root_destination, this_subject, subject_folder_destination);
    
    mkdir(cell2mat(fullfile(file_path_to_transfer,this_subject)))
    
    sourceFile = fullfile(study_dir,this_subject,'Processed','MRI_files','02_T1',filesep,'T1.nii');
    destinationFile = fullfile(file_path_to_transfer,this_subject,filesep,'T1.nii');
    copyfile(sourceFile{:}, destinationFile{:})
    disp(['copying' sourceFile{:} 'to' destinationFile{:}])
    
    sourceFile = fullfile(study_dir,this_subject,'Processed','MRI_files','02_T1',filesep,'T1.json');
    destinationFile = fullfile(file_path_to_transfer,this_subject,filesep,'T1.json');
    copyfile(sourceFile{:}, destinationFile{:})
    disp(['copying' sourceFile{:} 'to' destinationFile{:}])
    
    sourceFile = fullfile(study_dir,this_subject,'Processed','MRI_files','02_T1',filesep,'c1biascorrected_T1.nii');
    destinationFile = fullfile(file_path_to_transfer,this_subject,filesep,'c1biascorrected_T1.nii');
    copyfile(sourceFile{:}, destinationFile{:})
    disp(['copying' sourceFile{:} 'to' destinationFile{:}])
    
    sourceFile = fullfile(study_dir,this_subject,'Processed','MRI_files','02_T1',filesep,'c2biascorrected_T1.nii');
    destinationFile = fullfile(file_path_to_transfer,this_subject,filesep,'c2biascorrected_T1.nii');
    copyfile(sourceFile{:}, destinationFile{:})
    disp(['copying' sourceFile{:} 'to' destinationFile{:}])
    
    sourceFile = fullfile(study_dir,this_subject,'Processed','MRI_files','02_T1',filesep,'c3biascorrected_T1.nii');
    destinationFile = fullfile(file_path_to_transfer,this_subject,filesep,'c3biascorrected_T1.nii');
    copyfile(sourceFile{:}, destinationFile{:})
    disp(['copying' sourceFile{:} 'to' destinationFile{:}])
    
    sourceFile = fullfile(study_dir,this_subject,'Processed','MRI_files','02_T1',filesep,'c4biascorrected_T1.nii');
    destinationFile = fullfile(file_path_to_transfer,this_subject,filesep,'c4biascorrected_T1.nii');
    copyfile(sourceFile{:}, destinationFile{:})
    disp(['copying' sourceFile{:} 'to' destinationFile{:}])
    
    sourceFile = fullfile(study_dir,this_subject,'Processed','MRI_files','02_T1',filesep,'c5biascorrected_T1.nii');
    destinationFile = fullfile(file_path_to_transfer,this_subject,filesep,'c5biascorrected_T1.nii');
    copyfile(sourceFile{:}, destinationFile{:})
    disp(['copying' sourceFile{:} 'to' destinationFile{:}])
    
    sourceFile = fullfile(study_dir,this_subject,'Processed','MRI_files','02_T1',filesep,'SkullStripped_biascorrected_T1.nii');
    destinationFile = fullfile(file_path_to_transfer,this_subject,filesep,'SkullStripped_biascorrected_T1.nii');
    copyfile(sourceFile{:}, destinationFile{:})
    disp(['copying' sourceFile{:} 'to' destinationFile{:}])
    
end
