function DropBox_transfer_rawdata(varargin)
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
    
    mkdir(cell2mat(fullfile(file_path_to_transfer,this_subject)))
%     
    sourceFile = fullfile(study_dir,this_subject,'Raw','MRI_files','*.zip');
    destinationFile = fullfile(file_path_to_transfer,this_subject,filesep);
    copyfile(sourceFile{:}, destinationFile{:})
    disp(['copying' sourceFile{:} 'to' destinationFile{:}])
    
end
end
