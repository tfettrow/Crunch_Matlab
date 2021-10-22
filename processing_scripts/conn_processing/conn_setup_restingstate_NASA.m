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
%   conn_setup_restingstate('project_name','conn_mim_all_20210714','TR',2.5,'rs_folder', '04_rsfMRI', 'subjects',{'1002','2002','3028'},'group_names',{'ya','hoa','loa'},'group_ids',[1,2,3], 'primary_smoothed', 'smoothed_warpedToMNI_unwarpedRealigned_slicetimed_RestingState.nii', 'primary_unsmoothed', 'warpedToMNI_unwarpedRealigned_slicetimed_RestingState.nii', 'secondary_smoothed', 'smoothed_warpedToSUIT_CBmasked_coregToT1_unwarpedRealigned_slicetimed_RestingState.nii', 'secondary_unsmoothed', 'warpedToSUIT_CBmasked_coregToT1_unwarpedRealigned_slicetimed_RestingState.nii', 'roi_settings_filename', 'ROI_settings_conn_wu120_all_wb_cb.txt', 'primary_dataset','whole_brain')

%  conn_setup_restingstate('project_name','conn_mim_all_20210714','TR',2.5,'rs_folder', '04_rsfMRI', 'subjects',{'3028'},'group_ids',[3], 'primary_smoothed', 'smoothed_warpedToMNI_unwarpedRealigned_slicetimed_RestingState.nii', 'primary_unsmoothed', 'warpedToMNI_unwarpedRealigned_slicetimed_RestingState.nii', 'secondary_smoothed', 'smoothed_warpedToSUIT_CBmasked_coregToT1_unwarpedRealigned_slicetimed_RestingState.nii', 'secondary_unsmoothed', 'warpedToSUIT_CBmasked_coregToT1_unwarpedRealigned_slicetimed_RestingState.nii', 'roi_settings_filename', 'ROI_settings_conn_wu120_all_wb_cb.txt', 'primary_dataset','whole_brain')
function conn_setup_restingstate_NASA(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'project_name', 'conn_project')
addParameter(parser, 'primary_smoothed', '')
addParameter(parser, 'primary_unsmoothed', '')
addParameter(parser, 'secondary_smoothed', '')
addParameter(parser, 'secondary_unsmoothed', '')
addParameter(parser, 'structural', '')
addParameter(parser, 'structural_folder', '')
addParameter(parser, 'roi_settings_filename', '')
addParameter(parser, 'rs_folder', '')
addParameter(parser, 'primary_dataset', 'whole_brain')  % 'whole_brain' or 'cerebellum'
addParameter(parser, 'TR', 1.5) % assuming default is UF sequence
addParameter(parser, 'subjects', '')
addParameter(parser, 'group_names', '')
addParameter(parser, 'group_ids', '')
addParameter(parser, 'add_subjects', 0)
parse(parser, varargin{:})
TR = parser.Results.TR;
subjects = parser.Results.subjects;
primary_smoothed = parser.Results.primary_smoothed;
primary_unsmoothed = parser.Results.primary_unsmoothed;
structural_folder = parser.Results.structural_folder;
structural = parser.Results.structural;
secondary_smoothed = parser.Results.secondary_smoothed;
secondary_unsmoothed = parser.Results.secondary_unsmoothed;
project_name = parser.Results.project_name;
rs_folder = parser.Results.rs_folder;
roi_settings_filename = parser.Results.roi_settings_filename;
primary_dataset = parser.Results.primary_dataset;
group_names = parser.Results.group_names;
group_ids = parser.Results.group_ids;
add_subjects = parser.Results.add_subjects;

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
    data_path = pwd;
    
    % ADJUSTED FOR NASA
        this_subject_path = strcat([data_path filesep this_subject{1} filesep '02']);
%     this_subject_path = strcat([data_path filesep this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep rs_folder filesep 'ANTS_Normalization']);
    
    % ADJUSTED FOR NASA
primary_smoothed_path = spm_select('FPList',  fullfile(this_subject_path,rs_folder), strcat('^',this_subject{1},'_',primary_smoothed,'$'));
%     primary_smoothed_path = spm_select('FPList', this_subject_path, strcat('^',primary_smoothed,'$'));
    primary_unsmoothed_path = spm_select('FPList', fullfile(this_subject_path,rs_folder), strcat('^',this_subject{1},'_',primary_unsmoothed,'$'));

    % Beware: Hard coded for WU120 data
    if ~exist(primary_smoothed_path)
        primary_smoothed_corename = strsplit(primary_smoothed,'.');
        primary_unsmoothed_corename = strsplit(primary_unsmoothed,'.');
        primary_smoothed_path= spm_select('FPList', this_subject_path, strcat('^',primary_smoothed_corename{1},'1.nii'));
        primary_unsmoothed_path = spm_select('FPList', this_subject_path, strcat('^',primary_unsmoothed_corename{1},'1.nii'));
    end
    
    structural_path = spm_select('FPList', fullfile(this_subject_path,structural_folder), strcat('^',this_subject{1},'_',structural,'$'));
    
    if ~isempty(secondary_smoothed)
        secondary_smoothed_path = spm_select('FPList', this_subject_path, strcat('^',secondary_smoothed,'$'));
    end
    if ~isempty(secondary_unsmoothed)
        secondary_unsmoothed_path = spm_select('FPList', this_subject_path, strcat('^',secondary_unsmoothed,'$'));
         % Beware: Hard coded for WU120 data
         if ~exist(secondary_smoothed_path)
             secondary_smoothed_corename = strsplit(secondary_smoothed,'.');
             secondary_unsmoothed_corename = strsplit(secondary_unsmoothed,'.');
             secondary_smoothed_path= spm_select('FPList', this_subject_path, strcat('^',secondary_smoothed_corename{1},'1.nii'));
             secondary_unsmoothed_path = spm_select('FPList', this_subject_path, strcat('^',secondary_unsmoothed_corename{1},'1.nii'));
         end
    end
    if ~isempty(secondary_smoothed) && isempty(secondary_unsmoothed)
        error('need to specify unsmoothed secondary file name ')
    end
     
    BATCH.Setup.nsubjects=length(subjects);
    
    BATCH.Setup.structurals{this_subject_index} = structural_path;
    BATCH.Setup.functionals{this_subject_index}{1} = primary_smoothed_path;
    
    gray_matter_path = spm_select('FPList', fullfile(this_subject_path,structural_folder), strcat('^c1',this_subject{1},'_02_T1_SPM_MNIspace*'));
    white_matter_path = spm_select('FPList', fullfile(this_subject_path,structural_folder), strcat('^c2',this_subject{1},'_02_T1_SPM_MNIspace*'));
    csf_matter_path = spm_select('FPList', fullfile(this_subject_path,structural_folder), strcat('^c3',this_subject{1},'_02_T1_SPM_MNIspace*'));
%     gray_matter_path = spm_select('FPList', this_subject_path, '^warpedToMNI_c1T1*');
%     white_matter_path = spm_select('FPList', this_subject_path, '^warpedToMNI_c2T1*');
%     csf_matter_path = spm_select('FPList', this_subject_path, '^warpedToMNI_c3T1*');
         
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


    BATCH.Setup.covariates.names = {'realignment'};
     this_movement_file = spm_select('FPList', fullfile(this_subject_path,rs_folder), strcat('^','rp_a',this_subject{1},'_02_RestingState_s003a001.txt'))
%     this_movement_file = spm_select('FPList', this_subject_path, strcat('^','rp_unwarpedRealigned_slicetimed_RestingState.txt','$'));
 
%     Beware... Hard coded for WU120 data
%     if ~exist(this_movement_file)
%         this_movement_file = spm_select('FPList', this_subject_path, strcat('^','rp_unwarpedRealigned_slicetimed_RestingState1.txt','$'));
%     end
    BATCH.Setup.covariates.files{1}{this_subject_index}{1} = this_movement_file;
    
end

disp('gathered all subject data...')

if ~isempty(group_names)
    if length(group_ids) ~= length(subjects) || length(unique(group_ids)) ~= length(group_names)
        error('Something wrong with "group_names" or "group_ids"...')
    end
    BATCH.Setup.subjects.groups = group_ids;
    if add_subjects
        BATCH.Setup.subjects.add = 1;
    else
        for this_group_name = 1:length(group_names)
            BATCH.Setup.subjects.group_names{this_group_name} = group_names{this_group_name};
        end
        BATCH.Setup.subjects.add = 0;
    end
end

BATCH.filename = project_name;
BATCH.Setup.RT=TR;
BATCH.Setup.acquisitiontype=1;

if add_subjects
    BATCH.Setup.isnew=0;
    BATCH.Setup.done=1;
    BATCH.Setup.overwrite=0;
    BATCH.Setup.add=1;
else
    BATCH.Setup.isnew=1;
    BATCH.Setup.done=1;
    BATCH.Setup.overwrite=1;
end

BATCH.Setup.preprocessing.steps = {'functional_art'};
%     BATCH.filename = 'Conn_Art_Folder_Stuff';
BATCH.Setup.preprocessing.art_thresholds(1)= 9;  % z threshold
BATCH.Setup.preprocessing.art_thresholds(2)= 0.5;  % movement threshold

% read roi settings file
 
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
        this_roi_core_name = this_roi_settings_line{4};
        this_roi_file_name = strtrim(strcat(this_roi_core_name, '.nii'));
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
% BATCH.Setup.analyses=[1,2,3];
% BATCH.Setup.outputfiles=[0,0,0,0,0,0];
% 

%% DENOISING step
% CONN Denoising                                    % Default options (uses White Matter+CSF+realignment+scrubbing+conditions as confound regressors); see conn_batch for additional options 
% batch.Denoising.filter=[0.01, 0.1];                 % frequency filter (band-pass values, in Hz)
if add_subjects
    BATCH.Denoising.done=1;
    BATCH.Denoising.overwrite='No';
else
    BATCH.Denoising.done=1;
    BATCH.Denoising.overwrite='Yes';
end

%% save QA DENOISING
BATCH.QA.foldename = strcat(project_name, filesep, 'results', filesep, 'qa');
BATCH.QA.plots = {'QA_DENOISE_histogram', 'QA_DENOISE_FC-QC'};  %(11) : histogram of voxel-to-voxel correlation values (before and after denoising) 
%  QA_DENOISE FC-QC      (13) : histogram of FC-QC associations; between-subject correlation between QC (Quality Control) 
%                                       and FC (Functional Connectivity) measures

% CONN Analysis                                         % Default options (uses all ROIs in conn/rois/ as connectivity sources); see conn_batch for additional options 
% BATCH.Analysis.done=1;
% BATCH.Analysis.overwrite='Yes';

BATCH.Analysis.done =1;
BATCH.Analysis.measure = 1; % 1 = 'correlation (bivariate)', 2 = 'correlation (semipartial)', 3 = 'regression (bivariate)', 4 = 'regression (multivariate)'; [1]
BATCH.Analysis.type = 3;
BATCH.vvAnalysis.done=1;
BATCH.vvAnalysis.measures = 'MCOR';


%% supposed to but does not seem to run... have to go in and manually run.. obviously
%BATCH.Results PERFORMS SECOND-LEVEL ANALYSES (ROI-to-ROI and Seed-to-Voxel analyses) %!
% BATCH.Results PERFORMS SECOND-LEVEL ANALYSES (ROI-to-ROI and Seed-to-Voxel analyses) %!
%  Results             
% 
%    done            : 1/0: 0 defines fields only; 1 runs processing steps [0]
%    overwrite       : (for done=1) 1/0: overwrites target files if they exist [1]
%    name            : analysis name (identifying each set of first-level independent analysis)
%                       (alternatively sequential index identifying each set of first-level independent analyses [1])
%    display         : 1/0 display results [1]
%    saveas          : (optional) name to save between-subjects/between_conditions contrast
%    foldername      : (optional) alternative folder name to store the results
% 
%    between_subjects
%      effect_names  : cell array of second-level effect names
%      contrast      : contrast vector (same size as effect_names)
%  
%    between_conditions [defaults to multiple analyses, one per condition]
%      effect_names  : cell array of condition names (as in Setup.conditions.names)
%      contrast      : contrast vector (same size as effect_names)
%  
%    between_sources    [defaults to multiple analyses, one per source]
%      effect_names  : cell array of source names (as in Analysis.regressors, typically appended with _1_1; generally 
%                       they are appended with _N_M -where N is an index ranging from 1 to 1+derivative order, and M 
%                       is an index ranging from 1 to the number of dimensions specified for each ROI; for example 
%                       ROINAME_2_3 corresponds to the first derivative of the third PCA component extracted from the 
%                       roi ROINAME) 
%      contrast      : contrast vector (same size as effect_names)

if add_subjects
    BATCH.Results.done=1;
    BATCH.Results.overwrite=0;
else
    BATCH.Results.done=1;
    BATCH.Results.overwrite=1;
end
% BATCH.Results.name=1;

%also does not run as is...
%BATCH.vvResults PERFORMS SECOND-LEVEL ANALYSES (Voxel-to-Voxel analyses) %!
if add_subjects
    BATCH.vvResults.done=1;
    BATCH.vvResults.overwrite=1;
else
    BATCH.vvResults.done=1;
    BATCH.vvResults.overwrite=1;
end
% BATCH.vvResults.name=1;
%  
conn_batch(BATCH)
disp('saving subject ids for later use...')
if add_subjects
    old_subjects = load([project_name filesep 'subject_ids']);
    new_subjects = [old_subjects.subjects subjects];
    new_group_ids = [old_subjects.group_ids group_ids];
    subjects = new_subjects;
    group_ids = new_group_ids;
    save([project_name filesep 'subject_ids'], 'subjects', 'group_ids') 
else    
    save([project_name filesep 'subject_ids'], 'subjects', 'group_ids') 
end

end