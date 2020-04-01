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

function conn_network_withinGroup_taskbased(varargin)
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

% functional_file_name = 'smoothed_warpedToMNI_unwarpedRealigned_slicetimed_RestingState.*\.nii$';
structural_file_name = 'warpedToMNI_biascorrected_SkullStripped_T1.nii';

TR_from_json = varargin{1};

for this_subject_index = 1:length(varargin)-1 % already took the first index of varagin
    this_subject = varargin(1+this_subject_index);
    cd(strcat([this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep '05_MotorImagery' filesep 'ANTS_Normalization']))
    data_path = pwd;
    
    BATCH.Setup.nsubjects=length(varargin)-1;
    
    
    files_to_test = spm_select('FPList', data_path, '^smoothed_warpedToMNI_unwarpedRealigned_slicetimed_.*\.nii$');
    this_structural = spm_select('FPList', data_path, strcat('^',structural_file_name,'$'));
    this_outlier_and_movement_file = spm_select('FPList', data_path, '^art_regression_outliers_and_movement_unwarpedRealigned_slicetimed_.*\.mat$');
    
    condition_onset_files = spm_select('FPList', data_path, '^Condition_Onsets_.*.csv');
    
    BATCH.Setup.structurals{this_subject_index} = this_structural;
    
%     cd('..')
    
%     data_path = pwd;
    
    
   
    
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
        disp('searching for outlier_removal_settings...')
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
     
     
    
    
    if size(condition_onset_files,1) ~= size(files_to_test,1)
        error('Need the same # of Onset Files as Functional Runs')
    end
    
    for i_run = 1:size(files_to_test,1)
        this_file_with_volumes = spm_select('expand', files_to_test(i_run,:));
        
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
            while (mod(this_cond_onset_times_corrected, TR_from_json) ~= 0)
                this_cond_onset_times_corrected = round(this_cond_onset_times_corrected, 1) + 0.1;
            end
            
            this_cond_durations = this_cond_rest_times_corrected - this_cond_onset_times_corrected;
            
            while (mod(this_cond_durations, 1.5)  ~= 0)
                this_cond_durations = round(this_cond_durations, 1) - 0.1;
            end
            
            BATCH.Setup.functionals{this_subject_index}{i_run} = this_file_with_volumes;
            
            BATCH.Setup.covariates.names = {'head_movement'};
            BATCH.Setup.covariates.files{1}{this_subject_index}{i_run} = this_outlier_and_movement_file(i_run,:);
            
            % 1+ bc already populated 1 with All Conds
            BATCH.Setup.conditions.names{1+i_cond} = char(unique_condition_names(i_cond));
            BATCH.Setup.conditions.onsets{1+i_cond}{this_subject_index}{i_run} = this_cond_onset_times_corrected;
            BATCH.Setup.conditions.durations{1+i_cond}{this_subject_index}{i_run} = this_cond_durations;
        end
    end
    cd(strcat(['..' filesep '..' filesep '..' filesep '..'  filesep '..' ]))    
end

% BATCH.New.steps = {'initialization'};
BATCH.filename = 'conn_project_F32';
BATCH.Setup.isnew=1;
BATCH.Setup.done=1;
BATCH.Setup.overwrite=1;
BATCH.Setup.RT=1.5;
BATCH.Setup.acquisitiontype=1;
 
 BATCH.Setup.analyses=[1,2,3];
 BATCH.Setup.outputfiles=[0,0,0,0,0,0];
 
BATCH.Denoising.done=1;


BATCH.Analysis.done =1;
BATCH.Analysis.measure = 1; % 1 = 'correlation (bivariate)', 2 = 'correlation (semipartial)', 3 = 'regression (bivariate)', 4 = 'regression (multivariate)'; [1]
BATCH.Analysis.type = 3;
% 
BATCH.vvAnalysis.done=1;
BATCH.vvAnalysis.measures = 'MCOR';


conn_batch(BATCH)

end