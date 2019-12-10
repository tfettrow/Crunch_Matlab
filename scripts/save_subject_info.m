% assumes shell script places working directory into T1 Dicom Folder
% (probably does not actually matter which dicom folder)

data_path = pwd;
dicom_file_list = dir('*.IMA');

this_collection_info = dicominfo(dicom_file_list(1).name);

gender = this_collection_info.PatientSex;

age = this_collection_info.PatientAge;
age = regexp(age,'\d*','Match');
age = regexprep(age,'^0*','');

weight = this_collection_info.PatientWeight;
height = this_collection_info.PatientSize;

this_table_cell = {gender, age, weight, height};

T = cell2table(this_table_cell, 'VariableNames', {'gender', 'age', 'weight', 'height'});

directory_pieces = regexp(data_path,filesep,'split');
levels_back_subject = 3; % standard number of folders from data to subject level

subject_level_directory = getfield( directory_pieces, {1:length(directory_pieces)-levels_back_subject} );
for i_path_element = 1:size(subject_level_directory,2)
    subject_level_directory{i_path_element}(end+1) = filesep;
end
subject_level_directory_string = cellfun(@string,subject_level_directory);
subject_level_directory_full = join(subject_level_directory_string,'');

writetable(T, fullfile(subject_level_directory_full, 'subject_info.csv'))