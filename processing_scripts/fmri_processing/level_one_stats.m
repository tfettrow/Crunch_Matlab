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

% TO DO: allow for input of "files_to_test" to enable ceres images through
% level one script
function level_one_stats(create_model_and_estimate, TR_from_json, file_to_test_prefix, results_file_name)
%      TR_from_json = str2num(TR_from_json);
%     file_to_test_prefix = 'smoothed_warpedToSUIT';
%     results_file_name = 'Level1_Ceres';
%      create_model_and_estimate=1;
%      TR_from_json=1.5;
     
    data_path = pwd;
    clear matlabbatch
    spm('Defaults','fMRI');
    spm_jobman('initcfg');
    spm_get_defaults('cmdline',true);

    % TO DO: need more specific prefix check to decipher between ANTS and
    % SPM norm files (need to be able to exclude smothed T1)
    files_to_test = spm_select('FPList', data_path, strcat('^',file_to_test_prefix,'.*\.nii$'));
    art_regression_outlier_files  = spm_select('FPList',  data_path,'^art_regression_outliers_and_movement.*.mat');
    condition_onset_files = spm_select('FPList', data_path, '^Condition_Onsets_.*.csv');
    
    directory_pieces = regexp(data_path,filesep,'split');
    levels_back_subject = 3; % standard number of folders from data to subject level
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
%     
    level1_results_dir = fullfile(data_path, results_file_name);
    matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(level1_results_dir);
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR_from_json;

    for i_run = 1:size(files_to_test,1)
        this_file_with_volumes = spm_select('expand', files_to_test(i_run,:));
        this_art_regression_file = art_regression_outlier_files(i_run,:);
        
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
     
            matlabbatch{1}.spm.stats.fmri_spec.sess(i_run).scans = cellstr(this_file_with_volumes);
            matlabbatch{1}.spm.stats.fmri_spec.sess(i_run).cond(i_cond).name = char(unique_condition_names(i_cond));
            matlabbatch{1}.spm.stats.fmri_spec.sess(i_run).cond(i_cond).onset = this_cond_onset_times_corrected;
            matlabbatch{1}.spm.stats.fmri_spec.sess(i_run).cond(i_cond).duration = this_cond_durations;
            matlabbatch{1}.spm.stats.fmri_spec.sess(i_run).cond(i_cond).tmod = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess(i_run).cond(i_cond).pmod = struct('name', {}, 'param', {}, 'poly', {});
            matlabbatch{1}.spm.stats.fmri_spec.sess(i_run).cond(i_cond).orth = 1;
        end
        
        matlabbatch{1}.spm.stats.fmri_spec.sess(i_run).multi = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(i_run).regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(i_run).multi_reg = cellstr(this_art_regression_file); % ART file goes here
        matlabbatch{1}.spm.stats.fmri_spec.sess(i_run).hpf = 128;
        
    end
    
%     error('fix this')
    % XXX TO DO: implement microtime resolution XXX 
%     matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
%     matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;

    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = .8;  % ..8 is default .... can also change -inf
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};  %  gets rid of errors outside of brain but should only be run if mthresh is -inf
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    
%     error('confirm this is working')
    if create_model_and_estimate
        % unlink beta and other analysis files
        if exist(fullfile(level1_results_dir,'SPM.mat'),'file')
            rmdir(level1_results_dir, 's')
        end
        spm_jobman('run',matlabbatch);
    end
    clear matlabbatch

    
    % Model Estimation  ( does this need to be run??)
    %--------------------------------------------------------------------------
    
    design_matrix_file = spm_select('FPList', level1_results_dir, 'SPM.mat'); % design matrix    
    matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr(design_matrix_file);
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    
    if create_model_and_estimate
        spm_jobman('run',matlabbatch);
    end
    clear matlabbatch

        % Contrasts
    %--------------------------------------------------------------------------
        % Need to create the weights that match the regressors in model
    % specified above... already have condition onsets and art regressors..
    % 1a) need to store all the condition names for all runs
    % 1b) read all condition names and create all possible contrast list
    % 2) read SPM.sess.Fc to find the name of the contrast of interest and
    % the indices associated with that contrast
    % 3) if this condition name on the greater side then assign -1
    
    load(fullfile(level1_results_dir,'SPM.mat'))       
    all_unique_condition_names = unique(all_condition_names);
    
    for i_reg_file = 1:size(art_regression_outlier_files,1)
        load(art_regression_outlier_files(i_reg_file,:))
        number_of_regressors = size(R,2);
        regressor_array{:,i_reg_file} = zeros(1,number_of_regressors);
    end
    % need to check other regressor file..
    
    number_of_runs = sum(~cellfun(@isempty,{SPM.Sess.Fc}))
    for this_run = 1:number_of_runs
        % unpack the SPM data in case SPM does not store in same order as
        % inserted in steps above
        for this_unique_cond = 1 : size(all_unique_condition_names, 1)
            condition_names_array{this_unique_cond, this_run} = SPM.Sess(this_run).Fc(this_unique_cond).name;
            condition_indices_array{this_unique_cond, this_run} = SPM.Sess(this_run).Fc(this_unique_cond).i;
        end
    end
    
    % TO DO: need to check whether conditions names are different by run.. if so
    % throw error
       
    % go through all perumations of condition comparisons to create
    % contrasts
    number_of_contrasts = 1;
    number_of_isicombined_contrasts = 1;
    previousRun_greaterthan_Cond_contrast_array = [];
    this_greaterthan_Cond_contrast_array = [];
    previousRun_greaterthan_Rest_contrast_array = [];
    this_greaterthan_Rest_contrast_array = [];
    previousRun_lessthan_Rest_contrast_array = [];
    this_lessthan_Rest_contrast_array = [];
    previousRun_isicombined_greaterthan_Rest_contrast_array = [];
    this_isicombined_greaterthan_Rest_contrast_array = [];
    isicombined_greaterthan_Rest_contrast_name = [];
    
    for i = 1:size(all_unique_condition_names,1)
        for j = 1:size(all_unique_condition_names,1)
            this_contrast_cond_left = all_unique_condition_names(i);
            this_contrast_cond_right = all_unique_condition_names(j);
            if ~contains(this_contrast_cond_left, this_contrast_cond_right)
                for i_run = 1:number_of_runs
                    this_contrast_cond_left_SPMindex_this_run = find(contains(condition_names_array(:,i_run), this_contrast_cond_left));
                    this_contrast_cond_right_Run1_SPMindex_this_run = find(contains(condition_names_array(:,i_run), this_contrast_cond_right));
                    
                    % create this run's greaterthanCond array
%                     thisRun_greaterthan_Cond_contrast_array = [zeros(length(condition_names_array) * 2,1) ]'; % two betas per condition if time derivative (how can we check this?)
%                     thisRun_greaterthan_Cond_contrast_array(this_contrast_cond_left_SPMindex_this_run * 2 - 1)  = 1;
%                     thisRun_greaterthan_Cond_contrast_array(this_contrast_cond_right_Run1_SPMindex_this_run * 2 - 1) =  -1;

                     % create this run's greaterthanRest array
                    thisRun_greaterthan_Rest_contrast_array = [zeros(length(condition_names_array) * 2,1) ]'; % two betas per condition if time derivative (how can we check this?)
                    thisRun_greaterthan_Rest_contrast_array(this_contrast_cond_left_SPMindex_this_run * 2 - 1) = 1;
                    
                     % create this run's lessthanRest array
                    thisRun_lessthan_Rest_contrast_array = [zeros(length(condition_names_array) * 2,1) ]'; % two betas per condition if time derivative (how can we check this?)
                    thisRun_lessthan_Rest_contrast_array(this_contrast_cond_left_SPMindex_this_run * 2 - 1) = -1;
                   
                    
                    if i_run < number_of_runs
                        if ~isempty(previousRun_greaterthan_Rest_contrast_array)
%                             this_greaterthan_Cond_contrast_array = [previousRun_greaterthan_Cond_contrast_array thisRun_greaterthan_Cond_contrast_array regressor_array{:,i_run}];
                            this_greaterthan_Rest_contrast_array = [previousRun_greaterthan_Rest_contrast_array thisRun_greaterthan_Rest_contrast_array regressor_array{:,i_run}];
                            this_lessthan_Rest_contrast_array = [previousRun_lessthan_Rest_contrast_array thisRun_lessthan_Rest_contrast_array regressor_array{:,i_run}];
                            
                        else
%                             this_greaterthan_Cond_contrast_array = [thisRun_greaterthan_Cond_contrast_array regressor_array{:,i_run}];
                            this_greaterthan_Rest_contrast_array = [thisRun_greaterthan_Rest_contrast_array regressor_array{:,i_run}];
                            this_lessthan_Rest_contrast_array = [thisRun_lessthan_Rest_contrast_array regressor_array{:,i_run}];
                        end
                    else
%                         greaterthan_Cond_contrast_array(number_of_contrasts,:) = [previousRun_greaterthan_Cond_contrast_array thisRun_greaterthan_Cond_contrast_array];
                        greaterthan_Rest_contrast_array(i,:) = [previousRun_greaterthan_Rest_contrast_array thisRun_greaterthan_Rest_contrast_array];
                        lessthan_Rest_contrast_array(i,:) = [previousRun_lessthan_Rest_contrast_array thisRun_lessthan_Rest_contrast_array];
                    end
                    
%                     previousRun_greaterthan_Cond_contrast_array = this_greaterthan_Cond_contrast_array;
%                     this_greaterthan_Cond_contrast_array = [];
                    
                    previousRun_greaterthan_Rest_contrast_array = this_greaterthan_Rest_contrast_array;
                    this_greaterthan_Rest_contrast_array = [];
                    
                    previousRun_lessthan_Rest_contrast_array = this_lessthan_Rest_contrast_array;
                    this_lessthan_Rest_contrast_array = [];
                                        
                    thisRun_isicombined_greaterthan_Rest_contrast_array = [zeros(length(condition_names_array) * 2,1) ]';
                    
                    if strcmp(task_level_directory{end}, '06_Nback')
                        left_nback_condition_split = strsplit(this_contrast_cond_left{1}, '_');
                        right_nback_condition_split = strsplit(this_contrast_cond_right{1}, '_');
                        if strcmp(left_nback_condition_split{2}, right_nback_condition_split{2})
                            
                            thisRun_isicombined_greaterthan_Rest_contrast_array(this_contrast_cond_left_SPMindex_this_run * 2 - 1)  = 1;
                            thisRun_isicombined_greaterthan_Rest_contrast_array(this_contrast_cond_right_Run1_SPMindex_this_run * 2 - 1)  = 1;
                            
                            if i_run < number_of_runs
                                if ~isempty(previousRun_isicombined_greaterthan_Rest_contrast_array)
                                    this_isicombined_greaterthan_Rest_contrast_array = [previousRun_isicombined_greaterthan_Rest_contrast_array thisRun_isicombined_greaterthan_Rest_contrast_array regressor_array{:,i_run}];
                                else
                                    this_isicombined_greaterthan_Rest_contrast_array = [thisRun_isicombined_greaterthan_Rest_contrast_array regressor_array{:,i_run}];
                                end
                            else
                                if any(strcmp(isicombined_greaterthan_Rest_contrast_name, [char(left_nback_condition_split{2}) '>Rest']))
                                    
                                else
                                    isicombined_greaterthan_Rest_contrast_array(i,:) = [previousRun_isicombined_greaterthan_Rest_contrast_array thisRun_isicombined_greaterthan_Rest_contrast_array];
                                    isicombined_greaterthan_Rest_contrast_name{number_of_isicombined_contrasts} = [char(left_nback_condition_split{2}) '>Rest'];
                                    number_of_isicombined_contrasts = number_of_isicombined_contrasts + 1;
                                end
                            end
                            previousRun_isicombined_greaterthan_Rest_contrast_array = this_isicombined_greaterthan_Rest_contrast_array;
                            this_isicombined_greaterthan_Rest_contrast_array = [];
                           
                        end
                    end   
                end

%                 greaterthan_Cond_contrast_name{number_of_contrasts} = [char(this_contrast_cond_left) '>' char(this_contrast_cond_right)];
                greaterthan_Rest_contrast_name{i} = [char(this_contrast_cond_left) '>Rest' ];
                lessthan_Rest_contrast_name{i} = [char(this_contrast_cond_left) '<Rest' ];
                
%                 number_of_contrasts = number_of_contrasts + 1;
            end
        end
    end
    
    
    %     previousRun_AllgreaterthanCond_contrast_array = [];
    %
    %     thisRun_All_greaterthan_Rest_contrast_array = [zeros(length(condition_names_array) * 2,1) ]'; % two betas per condition if time derivative (how can we check this?)
    %     thisRun_All_greaterthan_Rest_contrast_array(1:2:length(condition_names_array) * 2 - 1)  = 1;
    %
    %     thisRun_All_lessthan_Rest_contrast_array = [zeros(length(condition_names_array) * 2,1) ]'; % two betas per condition if time derivative (how can we check this?)
    %     thisRun_All_lessthan_Rest_contrast_array(1:2:length(condition_names_array) * 2 - 1)  = -1;
    %
    
    %     thisRun_truncated_contrast_array = [zeros(length(condition_names_array) * 2,1)];
    %
    %     if strcmp(task_level_directory{end}, '06_Nback')
    %         for i = 1:size(all_unique_condition_names,1)
    %             for j = 1:size(all_unique_condition_names,1)
    %                 this_contrast_cond_left = all_unique_condition_names(i);
    %                 this_contrast_cond_right = all_unique_condition_names(j);
    %                 if ~contains(this_contrast_cond_left, this_contrast_cond_right)
    %                     for i_run = 1:number_of_runs
    %                         this_contrast_cond_left_SPMindex_this_run = find(contains(condition_names_array(:,i_run), this_contrast_cond_left));
    %                         this_contrast_cond_right_Run1_SPMindex_this_run = find(contains(condition_names_array(:,i_run), this_contrast_cond_right));
    %                         if  strcmp(condition_names_array(this_condition_index, 1), 'long_zero') || strcmp(condition_names_array(this_condition_index, 1), 'short_zero')
    %                             this_contrast_value = -3;
    %                         end
    %
    %                         if  strcmp(condition_names_array(this_condition_index, 1), 'long_one') || strcmp(condition_names_array(this_condition_index, 1), 'short_one')
    %                             this_contrast_value = 1;
    %                         end
    %
    %                         if  strcmp(condition_names_array(this_condition_index, 1), 'long_two') || strcmp(condition_names_array(this_condition_index, 1), 'short_two')
    %                             this_contrast_value = 1;
    %                         end
    %
    %                         if  strcmp(condition_names_array(this_condition_index, 1), 'long_three') || strcmp(condition_names_array(this_condition_index, 1), 'short_three')
    %                             this_contrast_value = 1;
    %                         end
    %
    %                         thisRun_linearZero_contrast_array(this_condition_index * 2 - 1) = this_contrast_value;
    %                     end
    %                     %     elseif strcmp(task_level_directory{end}, '05_MotorImagery')
    %                     %          for this_condition_index = 1 : length(thisRun_linearZero_contrast_array)
    %                     %              disp "Not Ready Yet"
    %                     %          end
    %                     %     else
    %                     %         disp "Need to code contrasts for this task!!!"
    %                 end
    %             end
    %         end
    %     end
    
    %     for i_run = 1:number_of_runs
    %
    %         if i_run < number_of_runs
    %             if ~isempty(previousRun_AllgreaterthanCond_contrast_array)
    %                 this_AllgreaterthanRest_contrast_array = [previousRun_AllgreaterthanCond_contrast_array thisRun_All_greaterthan_Rest_contrast_array regressor_array{:,i_run}];
    %                 this_AlllessthanRest_contrast_array = [previousRun_AlllessthanCond_contrast_array thisRun_All_lessthan_Rest_contrast_array regressor_array{:,i_run}];
    %                 this_XX_contrast_array = [previousRun_XX_contrast_array thisRun_XX_contrast_array regressor_array{:,i_run}];
    %             else
    %                 this_AllgreaterthanRest_contrast_array = [thisRun_All_greaterthan_Rest_contrast_array regressor_array{:,i_run}];
    %                 this_AlllessthanRest_contrast_array = [thisRun_All_lessthan_Rest_contrast_array regressor_array{:,i_run}];
    %                   this_XX_contrast_array = [thisRun_XX_contrast_array regressor_array{:,i_run}];
    %             end
    %         else
    %             AllgreaterthanRest_contrast_array(1,:) = [previousRun_AllgreaterthanCond_contrast_array thisRun_All_greaterthan_Rest_contrast_array];
    %             AlllessthanRest_contrast_array(1,:) = [previousRun_AlllessthanCond_contrast_array thisRun_All_lessthan_Rest_contrast_array];
    %             XX_contrast_array(1,:) = [previousRun_XX_contrast_array thisRun_XX_contrast_array];
    %         end
    %
    %         previousRun_AllgreaterthanCond_contrast_array = this_AllgreaterthanRest_contrast_array;
    %         this_AllgreaterthanRest_contrast_array = [];
    %
    %         previousRun_AlllessthanCond_contrast_array = this_AlllessthanRest_contrast_array;
    %         this_AlllessthanRest_contrast_array = [];
    %
    %     end
    %
    %     AllgreaterthanRest_contrast_name = {'All>Rest'};
    %     AlllessthanRest_contrast_name = {'All<Rest'};
    
%     if strcmp(task_level_directory{end}, '06_Nback')
%         greaterthan_Cond_contrast_name{number_of_contrasts} = ['zero_greaterthan_rest'];
%          strcmp(condition_names_array(this_condition_index, 1), 'long_zero')
%           greaterthan_Rest_contrast_array(i,:) = [previousRun_greaterthan_Rest_contrast_array thisRun_greaterthan_Rest_contrast_array];
%     end
    
% isicombined_greaterthan_Rest_contrast_array

%     final_contrast_array_matrix = [greaterthan_Cond_contrast_array; greaterthan_Rest_contrast_array; lessthan_Rest_contrast_array];
%     final_contrast_name_matrix = [greaterthan_Cond_contrast_name'; greaterthan_Rest_contrast_name'; lessthan_Rest_contrast_name'];



if strcmp(task_level_directory{end}, '06_Nback')
    final_contrast_array_matrix = [greaterthan_Rest_contrast_array; lessthan_Rest_contrast_array; isicombined_greaterthan_Rest_contrast_array];
    final_contrast_name_matrix = [greaterthan_Rest_contrast_name'; lessthan_Rest_contrast_name'; isicombined_greaterthan_Rest_contrast_name'];
else
    final_contrast_array_matrix = [greaterthan_Rest_contrast_array; lessthan_Rest_contrast_array];
    final_contrast_name_matrix = [greaterthan_Rest_contrast_name'; lessthan_Rest_contrast_name'];
end
    design_matrix_file = spm_select('FPList', level1_results_dir,'SPM.mat');
    matlabbatch{1}.spm.stats.con.spmmat = cellstr(design_matrix_file);
    
    for this_contrast = 1:size(final_contrast_array_matrix,1)
        % need to check other runs in case there is a difference.. not sure
        % how this could be though..
        matlabbatch{1}.spm.stats.con.consess{this_contrast}.tcon.name = final_contrast_name_matrix{this_contrast,1};
        
        matlabbatch{1}.spm.stats.con.consess{this_contrast}.tcon.weights = final_contrast_array_matrix(this_contrast,:);
        matlabbatch{1}.spm.stats.con.consess{this_contrast}.tcon.sessrep = 'none';
        matlabbatch{1}.spm.stats.con.delete = 1; %this deletes the previously exisiting contrasts; set to 0 if you do not want to delete previous contrasts!
    end

    % % Inference Results
    % %--------------------------------------------------------------------------
%     matlabbatch{1}.spm.stats.results.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
%     matlabbatch{1}.spm.stats.results.conspec.contrasts = 1;
%     matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'FWE';
%     matlabbatch{1}.spm.stats.results.conspec.thresh = 0.05;
%     matlabbatch{1}.spm.stats.results.conspec.extent = 0;
%     matlabbatch{1}.spm.stats.results.print = false;
    
    % % Rendering
    % %--------------------------------------------------------------------------
    % matlabbatch{1}.spm.util.render.display.rendfile = {fullfile(spm('Dir'),'canonical','cortex_20484.surf.gii')};
    % matlabbatch{1}.spm.util.render.display.conspec.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
    % matlabbatch{1}.spm.util.render.display.conspec.contrasts = 1;
    % matlabbatch{1}.spm.util.render.display.conspec.threshdesc = 'FWE';
    % matlabbatch{1}.spm.util.render.display.conspec.thresh = 0.05;
    % matlabbatch{1}.spm.util.render.display.conspec.extent = 0;
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
end



