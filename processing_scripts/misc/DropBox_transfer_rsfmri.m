function DropBox_transfer_rsfmri(varargin)
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
for i = 1:length(subjects)
this_subject = subjects(1,i);
    
    %     sourceFile = fullfile(study_dir, this_subject, file_path_to_transfer);
    %     sourceFile = fullfile(study_dir, 'FAt',strcat('FW_',this_subject, '__FA.nii'));
    %     sourceFile = fullfile(study_dir, 'FAt_skeletons',strcat('FAt_skeleton_',this_subject, '.nii'));
    %     sourceFile = fullfile(subject_dir,file_path_to_transfer);
    %
    %     destinationFile = fullfile(root_destination, this_subject, subject_folder_destination);
    
    mkdir(cell2mat(fullfile(file_path_to_transfer,this_subject)))
%     rs_d = fullfile(study_dir,this_subject,'Processed','MRI_files','04_rsfMRI');
%     cd([this_subject{1,1} '/Processed/MRI_files/04_rsfMRI'])
%     if isfile('RestingState.nii.gz')
%     gunzip('*.nii.gz');
%     end
% %     norm_d = fullfile(study_dir,this_subject,'Processed','MRI_files','04_rsfMRI',filesep,'ANTS_Normalization');
%     cd('ANTS_Normalization')
%     if isfile('smoothed_*.gz')
%     gunzip('*.nii.gz');
%     end
%     cd ../../../../..;
%     
    sourceFile = fullfile(study_dir,this_subject,'Processed','MRI_files','04_rsfMRI',filesep,'RestingState.nii');
    destinationFile = fullfile(file_path_to_transfer,this_subject,filesep,'RestingState.nii');
    copyfile(sourceFile{:}, destinationFile{:})
    disp(['copying' sourceFile{:} 'to' destinationFile{:}])
       
    sourceFile = fullfile(study_dir,this_subject,'Processed','MRI_files','04_rsfMRI',filesep,'unwarpedRealigned_slicetimed_RestingState.nii');
    destinationFile = fullfile(file_path_to_transfer,this_subject,filesep,'unwarpedRealigned_slicetimed_RestingState.nii');
    copyfile(sourceFile{:}, destinationFile{:})
    disp(['copying' sourceFile{:} 'to' destinationFile{:}])
    
    sourceFile = fullfile(study_dir,this_subject,'Processed','MRI_files','04_rsfMRI',filesep,'ANTS_Normalization',filesep,'smoothed_warpedToMNI_unwarpedRealigned_slicetimed_RestingState.nii');
    destinationFile = fullfile(file_path_to_transfer,this_subject,filesep,'smoothed_warpedToMNI_unwarpedRealigned_slicetimed_RestingState.nii');
    copyfile(sourceFile{:}, destinationFile{:})
    disp(['copying' sourceFile{:} 'to' destinationFile{:}])
    
end
end
