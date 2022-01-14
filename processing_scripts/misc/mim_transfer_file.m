function mim_transfer_file(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
addParameter(parser, 'subjects', '')
addParameter(parser, 'file_path_to_transfer', '') %files to 
addParameter(parser, 'root_destination', '') %destination up to subject folder
addParameter(parser, 'subject_folder_destination', '') %destination after subject folder
parse(parser, varargin{:})
file_path_to_transfer = parser.Results.file_path_to_transfer;
root_destination = parser.Results.root_destination;
subject_folder_destination = parser.Results.subject_folder_destination;
subjects = parser.Results.subjects;

study_dir = pwd;

for this_subject = subjects
    
    %     sourceFile = fullfile(study_dir, this_subject, file_path_to_transfer);
%     sourceFile = fullfile(study_dir, 'FAt',strcat('FW_',this_subject, '__FA.nii'));
    sourceFile = fullfile(study_dir, 'FAt_skeletons',strcat('FAt_skeleton_',this_subject, '.nii'));
    %     sourceFile = fullfile(subject_dir,file_path_to_transfer);
    
    destinationFile = fullfile(root_destination, this_subject, subject_folder_destination);
    
%     mkdir(destination_subject_folder{:})
    
%         sourceFile = fullfile(subject_dir, 'Processed','MRI_files','02_T1',filesep,'T1.nii');
%     destinationFile = fullfile(destination_subject_folder, 'T1.nii');
    copyfile(sourceFile{:}, destinationFile{:})
        disp(['copying' sourceFile{:} 'to' destinationFile{:}])
    
%     sourceFile = fullfile(subject_dir, 'Processed','MRI_files','02_T1',filesep,'T1.nii');
%     destinationFile = fullfile(destination_subject_folder, 'T1.nii');
%     copyfile(sourceFile{:}, destinationFile{:})
%     
%     sourceFile = fullfile(subject_dir, 'Processed','MRI_files','02_T1',filesep,'T1.json');
%     destinationFile = fullfile(destination_subject_folder, 'T1.json');
%     copyfile(sourceFile{:}, destinationFile{:})
%     disp(['copying T1 for ' this_subject])
%     
%     
%     sourceFile = fullfile(subject_dir, 'Processed','MRI_files','02_T1',filesep,'c1biascorrected_T1.nii');
%     destinationFile = fullfile(destination_subject_folder, 'c1biascorrected_T1.nii');
%     copyfile(sourceFile{:}, destinationFile{:})
%     
%     sourceFile = fullfile(subject_dir, 'Processed','MRI_files','02_T1',filesep,'c2biascorrected_T1.nii');
%     destinationFile = fullfile(destination_subject_folder, 'c2biascorrected_T1.nii');
%     copyfile(sourceFile{:}, destinationFile{:})
%     
%     sourceFile = fullfile(subject_dir, 'Processed','MRI_files','02_T1',filesep,'c3biascorrected_T1.nii');
%     destinationFile = fullfile(destination_subject_folder, 'c3biascorrected_T1.nii');
%     copyfile(sourceFile{:}, destinationFile{:})
%     
%     sourceFile = fullfile(subject_dir, 'Processed','MRI_files','02_T1',filesep,'c4biascorrected_T1.nii');
%     destinationFile = fullfile(destination_subject_folder, 'c4biascorrected_T1.nii');
%     copyfile(sourceFile{:}, destinationFile{:})
%     
%     sourceFile = fullfile(subject_dir, 'Processed','MRI_files','02_T1',filesep,'c5biascorrected_T1.nii');
%     destinationFile = fullfile(destination_subject_folder, 'c5biascorrected_T1.nii');
%     copyfile(sourceFile{:}, destinationFile{:})
%     
%     disp(['copying segmentation images' this_subject])
%     
%     sourceFile = fullfile(subject_dir, 'Processed','MRI_files','02_T1',filesep,'SkullStripped_biascorrected_T1.nii');
%     destinationFile = fullfile(destination_subject_folder, 'SkullStripped_biascorrected_T1.nii');
%     copyfile(sourceFile{:}, destinationFile{:})
%     
%     disp(['copying skull stripped image' this_subject])
end
