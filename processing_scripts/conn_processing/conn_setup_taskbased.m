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

function conn_setup_taskbased(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'project_name', '')
addParameter(parser, 'primary_smoothed', 'smoothed_warpedToMNI_unwarpedRealigned_slicetimed_')
addParameter(parser, 'primary_unsmoothed', '')
addParameter(parser, 'secondary_smoothed', '')
addParameter(parser, 'secondary_unsmoothed', '')
addParameter(parser, 'structural', 'warpedToMNI_biascorrected_SkullStripped_T1.nii')
addParameter(parser, 'roi_settings_filename', '') %%%Grant: Use powers2011 roi dataset
addParameter(parser, 'primary_dataset', 'whole_brain')  % whole_brain or cerebellum, based on what the primary datatset is
addParameter(parser, 'TR', 1.5)
addParameter(parser, 'subjects', '')
addParameter(parser, 'task_folder', '')  %% nback folder
addParameter(parser, 'group_names', '')
addParameter(parser, 'group_ids', '')
%%%addParameter(parser, 'band_pass_threshold', '')  %%%%  This is to adjust the band threshold of filtering, flips what a low and high pass do
parse(parser, varargin{:})
TR = parser.Results.TR;
subjects = parser.Results.subjects;
primary_smoothed = parser.Results.primary_smoothed;
primary_unsmoothed = parser.Results.primary_unsmoothed;
secondary_unsmoothed = parser.Results.secondary_unsmoothed;
secondary_smoothed = parser.Results.secondary_smoothed;
structural = parser.Results.structural;
roi_settings_filename = parser.Results.roi_settings_filename;
primary_dataset = parser.Results.primary_dataset;
project_name = parser.Results.project_name;
task_folder = parser.Results.task_folder;
group_names = parser.Results.group_names;
group_ids = parser.Results.group_ids;


disp(strcat(['Primary: ', primary_smoothed, ' Structural: ', structural, ' Secondary: ', secondary_smoothed]));
clear matlabbatch


spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

if isempty(task_folder) || isempty(subjects)
    error('need to specify input for arguments "task_folder" and "subjects" ')
end

for this_subject_index = 1:length(subjects)
    this_subject = subjects(this_subject_index);
    cd(strcat([this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep task_folder filesep 'ANTS_Normalization']))
    data_path = pwd;
    condition_onset_files = spm_select('FPList', data_path, '^Condition_Onsets_.*.csv');
    primary_smoothed_path = spm_select('FPList', data_path, strcat('^', primary_smoothed, '.*\.nii$'));
    this_outlier_and_movement_file = spm_select('FPList', data_path,'^art_regression_outliers_and_movement_unwarpedRealigned_slicetimed_.*\.mat$');
    structural_path = spm_select('FPList', data_path, strcat('^',structural,'$'));
    primary_unsmoothed_path = spm_select('FPList', data_path, strcat('^',primary_unsmoothed, '.*\.nii$'));
%     if ~isempty(secondary_smoothed)
%         secondary_smoothed_path = spm_select('ExtFPList', data_path, strcat('^',secondary_smoothed,'$'));
%     end
%     if ~isempty(secondary_unsmoothed)
%         secondary_unsmoothed_path = spm_select('ExtFPList', data_path, strcat('^',secondary_unsmoothed,'$'));
%     end
    if ~isempty(secondary_smoothed) && isempty(secondary_unsmoothed)
        error('need to specify unsmoothed secondary file name ')
    end
    
    gray_matter_path = spm_select('FPList', data_path, '^c1warpedToMNI*');
    white_matter_path = spm_select('FPList', data_path, '^c2warpedToMNI*');
    csf_matter_path = spm_select('FPList', data_path, '^c3warpedToMNI*');
    
    BATCH.Setup.masks.Grey.files{this_subject_index} = gray_matter_path;
    BATCH.Setup.masks.White.files{this_subject_index} = white_matter_path;
    BATCH.Setup.masks.CSF.files{this_subject_index} = csf_matter_path;
    
    
    BATCH.Setup.nsubjects=length(subjects);
    BATCH.Setup.structurals{this_subject_index} = structural_path;
    
    
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
    
    data_path = pwd;
    BATCH.Setup.covariates.names = {'head_movement'};
    
    this_outlier_and_movement_file = spm_select('FPList', data_path, '^art_regression_outliers_and_movement_unwarpedRealigned_slicetimed_.*\.mat$');
    
    BATCH.Setup.covariates.files{1}{this_subject_index}{1} = this_outlier_and_movement_file;
    
    %%  this just reads outlier removal settings ... try to package as a stand alone function .. needs implemented in all fmri processing
    % Find outlier removal settings
    directory_pieces = regexp(data_path,filesep,'split');
    levels_back_subject = 2; % standard number of folders from data to subject level
    levels_back_task = 0;
    fileID=-1;
    while fileID == -1
        subject_level_directory = getfield( directory_pieces, {1:length(directory_pieces)-levels_back_subject} );
        task_level_directory = getfield( directory_pieces, {1:length(directory_pieces)-levels_back_task} );
        for i_path_element = 1:size(subject_level_directory,2)
            subject_level_directory{i_path_element}(end+1) = filesep;
        end
        subject_level_directory_string = cellfun(@string,subject_level_directory);
        subject_level_directory_full = join(subject_level_directory_string,'');
        
        outlier_settings_file_path = fullfile(subject_level_directory_full, 'outlier_removal_settings.txt');
        
        fileID = fopen(outlier_settings_file_path, 'r');
        levels_back_subject = levels_back_subject + 1;
        levels_back_task = levels_back_task + 1;
        disp(strcat('searching for outlier_removal_settings for ', this_subject, '...'))
    end
    
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
        outlier_removal_cell{i_line} = this_line; %#ok<AGROW>
        
        % remove comments
        if length(this_line) > 1 && any(ismember(this_line, '#'))
            lines_to_prune(i_line) = true;
        end
        
        % remove lines that do not match this processed folder
        this_line_pieces = strsplit(this_line, ',');
        if ~strcmp(directory_pieces{end},this_line_pieces{1})
            lines_to_prune(i_line) = true;
        end
        
        % flag lines consisting only of white space
        if all(ismember(this_line, ' ') | double(this_line) == 9)
            lines_to_prune(i_line) = true;
        end
        
    end
    outlier_removal_cell(lines_to_prune) = [];
    
    
    %% identify onset and duration of tasks and correct for outliers
    
    if size(condition_onset_files,1) ~= size(primary_smoothed_path,1)
        error('Need the same # of Onset Files as Functional Runs')
    end
    
    for i_run = 1:size(primary_smoothed_path,1)
        this_primary_smoothed_file_with_volumes = spm_select('expand', primary_smoothed_path(i_run,:));
        this_primary_unsmoothed_file_with_volumes = spm_select('expand', primary_unsmoothed_path(i_run,:));
        %         this_secondary_file_with_volumes = spm_select('expand', secondary_path(i_run,:));
        
        % check to see if there were any outlier removals for this run
        % remove lines that do not match this processed folder
        this_line_run_matches = [];
        if ~isempty(outlier_removal_cell)
            for this_line = 1:size(outlier_removal_cell,2)
                line_pieces_per_run = strsplit(outlier_removal_cell{this_line}, ',');
                if strcmp(task_level_directory{end}, line_pieces_per_run{1})
                    this_line_run_matches(this_line) =  str2num(line_pieces_per_run{2}) ==  i_run;
                end
            end
            
            if sum(this_line_run_matches > 1)
                error 'Should not have more than one line for each run in same processed folder in otlier_removal_settings.txt'
            end
        end
        
        this_line_match_index = find(this_line_run_matches);
        if any(this_line_match_index)
            this_line = outlier_removal_cell{this_line_match_index};
            this_line_pieces = strsplit(this_line, ',');
        end
        
        if (any(this_line_match_index) && i_run == str2num(this_line_pieces{2})) && ~strcmp(this_line_pieces{3}, 'NA')
            this_run_start_volume = this_line_pieces{3};
            this_run_time_correction = TR_from_json * str2double(this_run_start_volume);
        else
            this_run_start_volume = 0;
            this_run_time_correction = 0;
        end
        
        this_condition_onset_file = condition_onset_files(i_run,:);
        this_onset_data = readtable(this_condition_onset_file);
        
        this_run_condition_names = this_onset_data.condition_names;
        all_condition_names(:,i_run) = this_run_condition_names;
        unique_condition_names = unique(this_run_condition_names);
        
        % WARNGING: Does not go through same DD as inidividual conditions (see
        % below).. refine this..
        this_duration_data = this_onset_data.rest_onset - this_onset_data.condition_onset;
        
        BATCH.Setup.conditions.names{1} = 'All_Imagery_Conds';
        BATCH.Setup.conditions.onsets{1}{this_subject_index}{i_run} =  this_onset_data.condition_onset / 1000;
        BATCH.Setup.conditions.durations{1}{this_subject_index}{i_run} = this_duration_data / 1000;
        
        for i_cond = 1:size(unique_condition_names,1)
            
            this_condition_name_onset_indices = find(contains(this_run_condition_names,unique_condition_names(i_cond)));
            this_cond_onset_times =  this_onset_data(this_condition_name_onset_indices,:).condition_onset;
            this_cond_rest_times = this_onset_data(this_condition_name_onset_indices,:).rest_onset;
            
            if (numel(num2str(this_cond_onset_times)) < 4 )
                error('check the condition onset values (expecting ms)')
            else
                this_cond_onset_times = this_cond_onset_times / 1000;
                this_cond_rest_times = this_cond_rest_times / 1000;
            end
            
            % correct for the start volume if necessary
            this_cond_onset_times_corrected = this_cond_onset_times - this_run_time_correction;
            this_cond_rest_times_corrected = this_cond_rest_times - this_run_time_correction;
            
            % this occurs when beginning of run is removed due to
            % outliers..
            if any(this_cond_onset_times_corrected < 0)
                negative_onset_indices = find(this_cond_onset_times_corrected < 0)
                negative_rest_indices = find(this_cond_rest_times_corrected < 0)
                
                %correct negative onset times
                this_cond_onset_times_corrected(negative_onset_indices) = 0;
                this_cond_rest_times_corrected(negative_rest_indices) = 0;
            end
            
            % check to see if the onset and duration are divisible by TR..
            % if not, increase onset time and decrease duration
            while (mod(this_cond_onset_times_corrected, TR) ~= 0)
                this_cond_onset_times_corrected = round(this_cond_onset_times_corrected, 1) + 0.1;
            end
            
            this_cond_durations = this_cond_rest_times_corrected - this_cond_onset_times_corrected;
            
            while (mod(this_cond_durations, 1.5)  ~= 0)
                this_cond_durations = round(this_cond_durations, 1) - 0.1;
            end
            
            BATCH.Setup.covariates.names = {'head_movement'};
            BATCH.Setup.covariates.files{1}{this_subject_index}{i_run} = this_outlier_and_movement_file(i_run,:);
            
            % 1+ bc already populated 1 with All Conds
            BATCH.Setup.conditions.names{1+i_cond} = char(unique_condition_names(i_cond));
            BATCH.Setup.conditions.onsets{1+i_cond}{this_subject_index}{i_run} = this_cond_onset_times_corrected;
            BATCH.Setup.conditions.durations{1+i_cond}{this_subject_index}{i_run} = this_cond_durations;
        end
        
        BATCH.Setup.functionals{this_subject_index}{i_run} = this_primary_smoothed_file_with_volumes;

        % Preallocating and add as we check for number of datasets
        number_of_secondary_datasets = 1;
        if ~isempty(primary_unsmoothed)
            BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_type = 4;
            BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_label = 'primary_unsmoothed';
            BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_explicit{this_subject_index}{i_run} = this_primary_unsmoothed_file_with_volumes;
            number_of_secondary_datasets = number_of_secondary_datasets + 1;
        end
%         if ~isempty(secondary_smoothed)
%             BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_type = 4;
%             BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_label = 'secondary_smoothed';
%             BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_explicit{this_subject_index}{1} = secondary_smoothed_path;
%             number_of_secondary_datasets = number_of_secondary_datasets + 1;
%         end
%         if ~isempty(secondary_unsmoothed)
%             BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_type = 4;
%             BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_label = 'secondary_unsmoothed';
%             BATCH.Setup.secondarydatasets(number_of_secondary_datasets).functionals_explicit{this_subject_index}{1} = secondary_unsmoothed_path;
%             number_of_secondary_datasets = number_of_secondary_datasets + 1;
%         end
    end
    cd(strcat(['..' filesep '..' filesep '..' filesep '..'  filesep '..' ]))

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

%%  read roi settings file
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


BATCH.filename = project_name;
BATCH.Setup.isnew=1;
BATCH.Setup.done=1;
BATCH.Setup.overwrite=1;
BATCH.Setup.RT=TR;
BATCH.Setup.acquisitiontype=1;

BATCH.Denoising.done=1;
% BATCH.Denoising PERFORMS DENOISING STEPS (confound removal & filtering) %!
%  Denoising
%
%    done            : 1/0: 0 defines fields only; 1 runs DENOISING processing steps [0]
%    overwrite       : (for done=1) 1/0: overwrites target files if they exist [1]
%    filter          : vector with two elements specifying band pass filter: low-frequency & high-frequency cutoffs (Hz)
%    detrending      : 0/1/2/3: BOLD times-series polynomial detrending order (0: no detrending; 1: linear detrending;
%                       ... 3: cubic detrending)
%    despiking       : 0/1/2: temporal despiking with a hyperbolic tangent squashing function (1:before regression;
%                       2:after regression) [0]
%    regbp           : 1/2: order of band-pass filtering step (1 = RegBP: regression followed by band-pass; 2 = Simult:
%                       simultaneous regression&band-pass) [1]
%    confounds       : Cell array of confound names (alternatively see 'confounds.names' below)

BATCH.Setup.analyses=[1,2,3];
BATCH.Setup.outputfiles=[0,0,0,0,0,0];

BATCH.Analysis.done =1;
BATCH.Analysis.measure = 1; % 1 = 'correlation (bivariate)', 2 = 'correlation (semipartial)', 3 = 'regression (bivariate)', 4 = 'regression (multivariate)'; [1]
BATCH.Analysis.type = 3;
%
BATCH.vvAnalysis.done=1;
BATCH.vvAnalysis.measures = 'MCOR';

conn_batch(BATCH)
end
