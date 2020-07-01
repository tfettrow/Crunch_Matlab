% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

% WARNING: This assumes there is always a smoothed and nonsmoothed dataset also does not take into account multiple secondary
  % datasets
  
function conn_setup_restingstate(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'project_name', 'conn_project')
addParameter(parser, 'primary_smoothed', 'smoothed_warpedToMNI_unwarpedRealigned_slicetimed_RestingState.nii')
addParameter(parser, 'primary_unsmoothed', 'warpedToMNI_unwarpedRealigned_slicetimed_RestingState.nii')
addParameter(parser, 'secondary_smoothed', '')
addParameter(parser, 'secondary_unsmoothed', '')
addParameter(parser, 'structural', 'warpedToMNI_biascorrected_SkullStripped_T1.nii')
addParameter(parser, 'roi_settings_filename', '')
addParameter(parser, 'primary_dataset', 'whole_brain')  % 'whole_brain' or 'cerebellum'
addParameter(parser, 'TR', 1.5) % assuming default is UF sequence
addParameter(parser, 'subjects', '')
addParameter(parser, 'group_names', '')
addParameter(parser, 'group_ids', '')
parse(parser, varargin{:})
TR = parser.Results.TR;
subjects = parser.Results.subjects;
primary_smoothed = parser.Results.primary_smoothed;
primary_unsmoothed = parser.Results.primary_unsmoothed;
structural = parser.Results.structural;
secondary_smoothed = parser.Results.secondary_smoothed;
secondary_unsmoothed = parser.Results.secondary_unsmoothed;
project_name = parser.Results.project_name;
roi_settings_filename = parser.Results.roi_settings_filename;
primary_dataset = parser.Results.primary_dataset;
group_names = parser.Results.group_names;
group_ids = parser.Results.group_ids;

disp(strcat(['Primary: ', primary_smoothed, ' Structural: ', structural, ' Secondary: ', secondary_smoothed]));

clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

if isempty(subjects)
    error('need to specify input for arguments "task_folder" and "subjects" ')
end

for this_subject_index = 1:length(subjects)
    this_subject = subjects(this_subject_index);
    cd(strcat([this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep '04_rsfMRI' filesep 'ANTS_Normalization']))
    data_path = pwd;
    
    primary_smoothed_path = spm_select('FPList', data_path, strcat('^',primary_smoothed,'$'));
    structural_path = spm_select('FPList', data_path, strcat('^',structural,'$'));
    
    primary_unsmoothed_path = spm_select('FPList', data_path, strcat('^',primary_unsmoothed,'$'));
    if ~isempty(secondary_smoothed)
        secondary_smoothed_path = spm_select('ExtFPList', data_path, strcat('^',secondary_smoothed,'$'));
    end
    if ~isempty(secondary_unsmoothed)
        secondary_unsmoothed_path = spm_select('ExtFPList', data_path, strcat('^',secondary_unsmoothed,'$'));
    end
    if ~isempty(secondary_smoothed) && isempty(secondary_unsmoothed)
        error('need to specify unsmoothed secondary file name ')
    end
     
    BATCH.Setup.nsubjects=length(subjects);
    
    BATCH.Setup.structurals{this_subject_index} = structural_path;
    BATCH.Setup.functionals{this_subject_index}{1} = primary_smoothed_path;
    
    gray_matter_path = spm_select('FPList', data_path, '^warpedToMNI_c1T1*');
    white_matter_path = spm_select('FPList', data_path, '^warpedToMNI_c2T1*');
    csf_matter_path = spm_select('FPList', data_path, '^warpedToMNI_c3T1*');
         
    BATCH.Setup.masks.Grey.files{this_subject_index} = gray_matter_path;
    BATCH.Setup.masks.White.files{this_subject_index} = white_matter_path;
    BATCH.Setup.masks.CSF.files{this_subject_index} = csf_matter_path;

    % WARNING: This always set target dataset to smoothed whole-brain
    if strcmp(primary_dataset, 'whole_brain')
        BATCH.Setup.masks.Grey.dataset = 0;
        BATCH.Setup.masks.White.dataset = 0;
        BATCH.Setup.masks.CSF.dataset = 0;
    else
        if ~isempty(primary_unsmoothed_path)
            BATCH.Setup.masks.Grey.dataset = 2;
            BATCH.Setup.masks.White.dataset = 2;
            BATCH.Setup.masks.CSF.dataset = 2;
        else
            BATCH.Setup.masks.Grey.dataset = 1;
            BATCH.Setup.masks.White.dataset = 1;
            BATCH.Setup.masks.CSF.dataset = 1;
        end
    end
    
    % Preallocating and add as we check for number of datasets
    number_of_secondary_datasets = 1;
    if ~isempty(primary_unsmoothed)
        BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_type = 4;
        BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_label = 'primary_unsmoothed';
        BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_explicit{this_subject_index}{1} = primary_unsmoothed_path;
        number_of_secondary_datasets = number_of_secondary_datasets + 1;
    end
    if ~isempty(secondary_smoothed)
        BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_type = 4;
        BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_label = 'secondary_smoothed';
        BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_explicit{this_subject_index}{1} = secondary_smoothed_path;
        number_of_secondary_datasets = number_of_secondary_datasets + 1;
    end
    if ~isempty(secondary_unsmoothed)
        BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_type = 4;
        BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_label = 'secondary_unsmoothed';
        BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_explicit{this_subject_index}{1} = secondary_unsmoothed_path;
        number_of_secondary_datasets = number_of_secondary_datasets + 1;
    end
    cd('..')
    
    data_path = pwd;
    BATCH.Setup.covariates.names = {'head_movement'};
    
    this_outlier_and_movement_file = spm_select('FPList', data_path, strcat('^','art_regression_outliers_and_movement_unwarpedRealigned_slicetimed_RestingState.mat','$'));
  
    BATCH.Setup.covariates.files{1}{this_subject_index}{1} = this_outlier_and_movement_file;
    
    cd(strcat(['..' filesep '..' filesep '..' filesep '..' ]))    
end

disp('gathered all subject data...')

if ~isempty(group_names)
    if length(group_ids) ~= length(subjects) || length(unique(group_ids)) ~= length(group_names)
        error('Something wrong with "group_names" or "group_ids"...')
    end
    for this_group_name = 1:length(group_names)
        BATCH.Setup.subjects.group_names{this_group_name} = group_names{this_group_name};
    end
    BATCH.Setup.subjects.groups = group_ids;
    BATCH.Setup.subjects.add = 0;
end

BATCH.filename = project_name;
BATCH.Setup.isnew=1;
BATCH.Setup.done=1;
BATCH.Setup.overwrite=1;
BATCH.Setup.RT=TR;
BATCH.Setup.acquisitiontype=1;

%% read roi settings file
 
if ~isempty(roi_settings_filename)
    file_name = roi_settings_filename;
    fileID = fopen(file_name, 'r');
    % read text to cell
    text_line = fgetl(fileID);
    text_cell = {};
    while ischar(text_line)
        text_cell = [text_cell; text_line]; %#ok<AGROW>
        text_line = fgetl(fileID);
    end
    fclose(fileID);
    % prune lines
    lines_to_prune = false(size(text_cell, 1), 1);
    for i_line = 1 : size(text_cell, 1)
        this_line = text_cell{i_line};
        % remove initial white space
        while ~isempty(this_line) && (this_line(1) == ' ' || double(this_line(1)) == 9)
            this_line(1) = [];
        end
        settings_cell{i_line} = this_line; %#ok<AGROW>
        % remove comments
        if length(this_line) > 1 && any(ismember(this_line, '#'))
            lines_to_prune(i_line) = true;
        end
        % flag lines consisting only of white space
        if all(ismember(this_line, ' ') | double(this_line) == 9)
            lines_to_prune(i_line) = true;
        end
    end
    settings_cell(lines_to_prune) = [];
    
    roi_dir = dir([strcat('ROIs', filesep,'*.nii')]);
    clear roi_file_name_list;
    [available_roi_file_name_list{1:length(roi_dir)}] = deal(roi_dir.name);
    
    for this_roi_index = 1:length(settings_cell)
        this_roi_settings_line = strsplit(settings_cell{this_roi_index}, ',');
        this_roi_core_name = this_roi_settings_line{1};
        this_roi_file_name = strcat(this_roi_core_name, '.nii');
        this_roi_dataset_target = this_roi_settings_line{6};
        
        % find the file that matches roi_core_name
        [fda, this_roi_index_in_available_files, asdf] = intersect(available_roi_file_name_list, this_roi_file_name);
        BATCH.Setup.rois.names{this_roi_index} = this_roi_core_name;
        BATCH.Setup.rois.files{this_roi_index} = strcat('ROIs', filesep, available_roi_file_name_list{this_roi_index_in_available_files});
        BATCH.Setup.rois.multiplelabels(1) = 1;
        if strcmp(primary_dataset, 'whole_brain')
            if strcmp(this_roi_dataset_target, ' whole_brain_smoothed')
                BATCH.Setup.rois.dataset(this_roi_index) = 0;
            elseif strcmp(this_roi_dataset_target, ' whole_brain_unsmoothed')
                BATCH.Setup.rois.dataset(this_roi_index) = 1;
            elseif strcmp(this_roi_dataset_target, ' cerebellum_smoothed')
                BATCH.Setup.rois.dataset(this_roi_index) = 2;
            elseif strcmp(this_roi_dataset_target, ' cerebellum_unsmoothed')
                BATCH.Setup.rois.dataset(this_roi_index) = 3;
            else
                error('something wrong with target dataset label in roi_settings file')
            end
        elseif strcmp(primary_dataset, 'cerebellum')
             if strcmp(this_roi_dataset_target, ' cerebellum_smoothed')
                 BATCH.Setup.rois.dataset(this_roi_index) = 0; % assumming only two datasets
             elseif strcmp(this_roi_dataset_target, ' cerebellum_unsmoothed')
                 BATCH.Setup.rois.dataset(this_roi_index) = 1;
             elseif strcmp(this_roi_dataset_target, ' whole_brain_smoothed')
                 BATCH.Setup.rois.dataset(this_roi_index) = 2;
             elseif strcmp(this_roi_dataset_target, ' whole_brain_unsmoothed')
                 BATCH.Setup.rois.dataset(this_roi_index) = 3;
             else
                error('something wrong with target dataset label in roi_settings file')
             end
        end
        BATCH.Setup.rois.add = 0;
    end
end

% 
BATCH.Setup.analyses=[1,2,3];
BATCH.Setup.outputfiles=[0,0,0,0,0,0];

BATCH.Denoising.done=1;

BATCH.Analysis.done =1;
BATCH.Analysis.measure = 1; % 1 = 'correlation (bivariate)', 2 = 'correlation (semipartial)', 3 = 'regression (bivariate)', 4 = 'regression (multivariate)'; [1]
BATCH.Analysis.type = 3;

BATCH.vvAnalysis.done=1;
BATCH.wAnalysis.overwite=1;

%% supposed to but does not seem to run... have to go in and manually run.. obviously
%BATCH.Results PERFORMS SECOND-LEVEL ANALYSES (ROI-to-ROI and Seed-to-Voxel analyses) %!
BATCH.Results.done=1;
BATCH.Results.overwrite=1;

%BATCH.vvResults PERFORMS SECOND-LEVEL ANALYSES (Voxel-to-Voxel analyses) %!
BATCH.wResults.done=1;
BATCH.wResults.overwrite=1;

disp('starting conn...')
 
conn_batch(BATCH)

disp('saving subject ids for later use...')
save([project_name filesep 'subject_ids'], 'subjects')

end