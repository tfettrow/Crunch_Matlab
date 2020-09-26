function identify_individual_discrete_crunch(varargin)
%input task folder, subject numbers {####}
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'task_folder', '')
addParameter(parser, 'subjects', '')
addParameter(parser, 'no_labels', 0)
addParameter(parser, 'Results_filename', 'CRUNCH_discrete.mat')
addParameter(parser, 'save_variables', 1)
parse(parser, varargin{:})
subjects = parser.Results.subjects;
task_folder = parser.Results.task_folder;
Results_filename = parser.Results.Results_filename;
save_variables = parser.Results.save_variables;

data_path = pwd; %make sure to set the path tot he MiM_data folder

if any(strcmp(task_folder, '05_MotorImagery'))
    task='MotorImagery';
elseif any(strcmp(task_folder, '06_Nback'))
    task='Nback';
end

for sub = 1:length(subjects)
    %create file path for beta values
    subj_results_dir = fullfile(data_path, subjects{sub}, 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain');
    this_subject_roiResults_path = fullfile(subj_results_dir, strcat(subjects{sub},'_fmri_redcap.csv'));
    delete(fullfile(subj_results_dir, '*.mat'))
    fileID = fopen(this_subject_roiResults_path);
    
    %read the csv file and reshape to have separate headers and values
    data = textscan(fileID,'%s','delimiter',',');
    data = reshape(data{:},length(data{1})/2,2);
    
    for this_beta = 3:length(data)
        split_difficulty = strsplit(data{this_beta,1},'_');%separate difficulty and brain region
        if any(strcmp(task_folder, '05_MotorImagery'))
            ordered_conditions{this_beta-2} = split_difficulty{1}; %difficulty level = flat to high
            roi_names{this_beta-2} = strcat(split_difficulty{2},'_',split_difficulty{3}); %brain region name, l-pfc, r-pfc, l-acc, r-acc
        elseif any(strcmp(task_folder, '06_Nback'))
            ordered_conditions{this_beta-2} = strcat(split_difficulty{1},'_',split_difficulty{2}); % difficulty = 0 to 3 with long or short ISI
            roi_names{this_beta-2} = strcat(split_difficulty{3},'_',split_difficulty{4}); %brain region name
        end
    end
    
    unique_rois = unique(roi_names); %delete the repeats of the brain region name
    
    this_figure_number = 1;
    figure;
    
    for this_roi_index = 1 : length(unique_rois) %1:4, l-acc, l-pfc, r-acc, r-pfc (alphabetical)
        this_roi_indices = find(strcmp(roi_names, unique_rois{this_roi_index})); %find the index of when the current ROI occurs
        
        for k = 1:length(this_roi_indices)
            temp(1,k) = textscan(data{this_roi_indices(k)+2,2},'%f'); %temporary hold the beta value
        end
        beta_values = cell2mat(temp)'; %covert from cell to matrix
        subplot(1, 4, this_figure_number);
        hold on;
        
        if any(strcmp(task_folder, '05_MotorImagery'))
            number_of_levels = 0:3; %difficulty levels (x axis)
            plot(number_of_levels,beta_values,'-or');
            max_beta_index = find(max(beta_values)==beta_values); %find the index of max beta value
            if (max_beta_index  == 1)
                cr{this_roi_index} = 'decreasing'; %CRUNCH point
            elseif (max_beta_index  == 2) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr{this_roi_index} = 'early_crunch'; %no CRUNCH point
            elseif (max_beta_index  == 3) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr{this_roi_index} = 'late_crunch'; %no CRUNCH point
            elseif (max_beta_index  == 4) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr{this_roi_index} = 'increasing'; %no CRUNCH point
            end
        elseif any(strcmp(task_folder, '06_Nback'))
            number_of_levels = 0:3;
            
            plot(number_of_levels,beta_values(1:4),'-or');
            plot(number_of_levels,beta_values(5:8),'-.or');
            max_beta_index = find(max(beta_values(1:4))==beta_values(1:4)); %CRUNCH for 1500 ISI
            if (max_beta_index  == 1)
                cr_1500{this_roi_index} = 'decreasing'; %CRUNCH point
            elseif (max_beta_index  == 2) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr_1500{this_roi_index} = 'early_crunch'; %no CRUNCH point
            elseif (max_beta_index  == 3) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr_1500{this_roi_index} = 'late_crunch'; %no CRUNCH point
            elseif (max_beta_index  == 4) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr_1500{this_roi_index} = 'increasing'; %no CRUNCH point
            end
            max_beta_index = find(max(beta_values(5:8))==beta_values(5:8)); %CRUNCH for 500 ISI
            if (max_beta_index  == 1)
                cr_500{this_roi_index} = 'decreasing'; %CRUNCH point
            elseif (max_beta_index  == 2) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr_500{this_roi_index} = 'early_crunch'; %no CRUNCH point
            elseif (max_beta_index  == 3) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr_500{this_roi_index} = 'late_crunch'; %no CRUNCH point
            elseif (max_beta_index  == 4) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr_500{this_roi_index} = 'increasing'; %no CRUNCH point
            end
        end
        hold off;
        xticks(number_of_levels)
        xlim([-1 4])
        title(char(unique_rois(this_roi_index)))
        this_figure_number = this_figure_number + 1;
        ylabel('beta value')
        %         clearvars beta_values;
    end
    hold off;
    
    if save_variables
        if any(strcmp(task_folder, '05_MotorImagery'))
            task='MotorImagery';
            save(char(strcat(subj_results_dir,filesep,strcat(subjects{sub},'_',task,'_',Results_filename))),'cr*','data','unique_rois');
        elseif any(strcmp(task_folder, '06_Nback'))
            task='Nback';
            save(char(strcat(subj_results_dir,filesep,strcat(subjects{sub},'_',task,'_',Results_filename))),'cr*','data','unique_rois');
        end
    end
    fclose(fileID);
    clearvars beta_values cr* data temp ordered_conditions this_beta this_roi_index;
end
end

