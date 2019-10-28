function level_one_stats(TR_from_json)
    TR_from_json = str2num(TR_from_json);
    data_path = pwd;
    clear matlabbatch
    spm('Defaults','fMRI');
    spm_jobman('initcfg');
    spm_get_defaults('cmdline',true);

    files_to_test = spm_select('FPList', data_path, '^smoothed.*\.nii$');
    art_regression_outlier_files  = spm_select('FPList',  data_path,'^art_regression_outliers_and_movement.*.mat');
    condition_onset_files = spm_select('FPList', data_path, '^Condition_Onsets_.*.csv');
    
    directory_pieces = regexp(data_path,'/','split');
    subject_level_directory = getfield( directory_pieces, {1:length(directory_pieces)-3} );
    for i_path_element = 1:size(subject_level_directory,2);
        subject_level_directory{i_path_element}(end+1) = '/';
    end
    subject_level_directory_string = cellfun(@string,subject_level_directory);
    subject_level_directory_full = join(subject_level_directory_string,'');
    
    outlier_settings_file_path = fullfile(subject_level_directory_full, 'outlier_removal_settings.txt');
    
     fileID = fopen(outlier_settings_file_path, 'r');
    
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
    level1_results_dir = fullfile(data_path,"Level1_Results");
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
                this_line_run_matches(this_line) =  str2num(line_pieces_per_run{2}) ==  i_run;
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
        
        
        if (any(this_line_match_index) && i_run == str2num(this_line_pieces{2}))
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
    
    
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = .8;  % ..8 is default .... can also change -inf
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};  %  gets rid of errors outside of brain but should only be run if mthresh is -inf
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    
     spm_jobman('run',matlabbatch);
    clear matlabbatch

    
    % Model Estimation  ( does this need to be run??)
    %--------------------------------------------------------------------------
    
    design_matrix_file = spm_select('FPList', level1_results_dir, 'SPM.mat'); % design matrix    
    matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr(design_matrix_file);
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    
     spm_jobman('run',matlabbatch);
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
%         art_regressor_files(i_reg_file,:) = fullfile(art_regression_outlier_files(i_reg_file).folder, art_regression_outlier_files(i_reg_file).name);
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
    
    % go through all perumations of condition comparisons to create
    % contrasts
    number_of_contrasts = 1;
    %            contrast_array = [];
    contrast_array_previousRun = [];
    this_contrast_array = [];
    for i = 1:size(all_unique_condition_names,1)
        for j = 1:size(all_unique_condition_names,1)
            this_contrast_cond_left = all_unique_condition_names(i);
            this_contrast_cond_right = all_unique_condition_names(j);
            if ~contains(this_contrast_cond_left, this_contrast_cond_right)
                
                for i_run = 1:number_of_runs
                    this_contrast_cond_left_SPMindex_this_run = find(contains(condition_names_array(:,i_run), this_contrast_cond_left));
                    this_contrast_cond_right_Run1_SPMindex_this_run = find(contains(condition_names_array(:,i_run), this_contrast_cond_right));
                    
                    contrast_zero_padded = [zeros(length(condition_names_array) * 2,1) ]'; %two betas per condition
                    contrast_zero_padded(this_contrast_cond_left_SPMindex_this_run * 2 - 1) = 1;
                    contrast_zero_padded(this_contrast_cond_right_Run1_SPMindex_this_run * 2 - 1) = -1;
                    
                    % matlab does not like this ...
                    if i_run < number_of_runs
                        if ~isempty(contrast_array_previousRun)
                            this_contrast_array = [contrast_array_previousRun contrast_zero_padded regressor_array{:,i_run}];
                        else
                            this_contrast_array = [contrast_zero_padded regressor_array{:,i_run}];
                        end
                    else
                        final_contrast_array(number_of_contrasts,:) = [contrast_array_previousRun contrast_zero_padded];
                    end
                    
                    contrast_array_previousRun = this_contrast_array;
                    this_contrast_array = [];
                    
                    this_contrast_greaterthan_name{number_of_contrasts,i_run} = [char(this_contrast_cond_left) '>' char(this_contrast_cond_right)];
                    
                end
                %                       final_contrast_cell_array{number_of_contrasts} = this_final_contrast_array;
                number_of_contrasts = number_of_contrasts + 1;
            end
        end
    end
    
    design_matrix_file = spm_select('FPList', level1_results_dir,'SPM.mat'); 
    matlabbatch{1}.spm.stats.con.spmmat = cellstr(design_matrix_file);
    
    for this_contrast = 1:size(this_contrast_greaterthan_name,1)
        % need to check other runs in case there is a difference.. not sure
        % how this could be though..
        matlabbatch{1}.spm.stats.con.consess{this_contrast}.tcon.name = this_contrast_greaterthan_name{this_contrast,1};
        
        matlabbatch{1}.spm.stats.con.consess{this_contrast}.tcon.weights = final_contrast_array(this_contrast,:);
        matlabbatch{1}.spm.stats.con.consess{this_contrast}.tcon.sessrep = 'none';
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



