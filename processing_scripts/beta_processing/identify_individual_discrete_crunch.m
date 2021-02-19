function identify_individual_discrete_crunch(varargin)
%%this function calculates the individual crunch curves for the subjects specified. Please see the emaple command line
%%input to run the code
%%Example command line: identify_individual_discrete_crunch('subjects',{'1002','1004','1007','1009','1010','1011','1013','1020','1022','1024','1027','2002','2007','2008','2012','2013','2015','2017','2018','2020','2021','2022','2023','2025','2026','2033','2034','2037','2042','2052'},'task_folder','05_MotorImagery','output_filename','CRUNCH_discete_roi_newacc.mat','beta_filename_extension','_fmri_roi_betas_newacc')
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'task_folder', '')
addParameter(parser, 'subjects', '')
addParameter(parser, 'no_labels', 0)
addParameter(parser, 'output_filename', '')
addParameter(parser, 'beta_filename_extension', '')
addParameter(parser, 'save_variables', 1)
parse(parser, varargin{:})
subjects = parser.Results.subjects;
task_folder = parser.Results.task_folder;
output_filename = parser.Results.output_filename;
beta_filename_extension = parser.Results.beta_filename_extension;
save_variables = parser.Results.save_variables;

data_path = pwd; %make sure to set the path to the MiM_data folder

if any(strcmp(task_folder, '05_MotorImagery'))
    task='MotorImagery';
elseif any(strcmp(task_folder, '06_Nback'))
    task='Nback';
end

for sub = 1:length(subjects)
    %create file path for beta values
    subj_results_dir = fullfile(data_path, subjects{sub}, 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain');
    this_subject_roiResults_path = fullfile(subj_results_dir, strcat(subjects{sub},beta_filename_extension,'.csv'));
%     delete(fullfile(subj_results_dir, '*.mat'))
    fileID = fopen(this_subject_roiResults_path);
    
    %read the csv file and reshape to have separate headers and values
    data = textscan(fileID,'%s','delimiter',',');
    data = reshape(data{:},length(data{1})/2,2);
    
    roi_names={};
    
    for this_beta = 3:length(data)
        split_roi_name = strsplit(data{this_beta,1},'_');%separate difficulty and brain region
        if any(strcmp(task_folder, '05_MotorImagery'))
            ordered_conditions{this_beta-2} = split_roi_name{1}; %difficulty level = flat to high
            for this_roi_part = 2:length(split_roi_name)
                if this_roi_part == 2
                    roi_names{this_beta-2} = split_roi_name{this_roi_part};
                else
                    roi_names{this_beta-2} = strcat(roi_names{this_beta-2}, '_', split_roi_name{this_roi_part});
                end
            end
        elseif any(strcmp(task_folder, '06_Nback'))
            ordered_conditions{this_beta-2} = strcat(split_roi_name{1},'_',split_roi_name{2}); % difficulty = 0 to 3 with long or short ISI
           for this_roi_part = 3:length(split_roi_name)
                if this_roi_part == 3
                    roi_names{this_beta-2} = split_roi_name{this_roi_part};
                else
                    roi_names{this_beta-2} = strcat(roi_names{this_beta-2}, '_', split_roi_name{this_roi_part});
                end
            end
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
        subplot(1, length(unique_rois), this_figure_number);
        hold on;
        
        if any(strcmp(task_folder, '05_MotorImagery'))
            number_of_levels = 0:3; %difficulty levels (x axis)
            plot(number_of_levels,beta_values,'-or');
            max_beta_index = find(max(beta_values)==beta_values); %find the index of max beta value
            if (max_beta_index  == 1)
                cr{this_roi_index} = 0; %start CRUNCH point
            elseif (max_beta_index  == 2) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr{this_roi_index} = 1; %early CRUNCH point
            elseif (max_beta_index  == 3) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr{this_roi_index} = 2; %late CRUNCH point
            elseif (max_beta_index  == 4) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr{this_roi_index} = 3; %late CRUNCH point
                % TO DO: create a best fit for increasing crunchers
%                 number_of_levels_extrapolate = 0:4;
%                 coeffs=polyfit(number_of_levels, beta_values, 2);
%                 fittedX=linspace(min(number_of_levels_extrapolate), max(number_of_levels_extrapolate), 100);
%                 fittedY=polyval(coeffs, fittedX);      
%                 plot(fittedX,fittedY,'-b')
%                 if round(max(fittedY)) < 3.5
%                     cr{this_roi_index} = 3;
%                 else
%                     cr{this_roi_index} = 4;
%                 end
                
                % deprecated
                % cr{this_roi_index} = 3; %never CRUNCH point
            end
            max_beta_cr{this_roi_index} = beta_values(max_beta_index);
        elseif any(strcmp(task_folder, '06_Nback'))
            number_of_levels = 0:3;
            
            plot(number_of_levels,beta_values(1:4),'-or');
            plot(number_of_levels,beta_values(5:8),'-.or');
            max_beta_index = find(max(beta_values(1:4))==beta_values(1:4)); %CRUNCH for 1500 ISI
            if (max_beta_index  == 1)
                cr_1500{this_roi_index} = 0; %start CRUNCH point
            elseif (max_beta_index  == 2) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr_1500{this_roi_index} = 1; %early CRUNCH point
            elseif (max_beta_index  == 3) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr_1500{this_roi_index} = 2; %late CRUNCH point
            elseif (max_beta_index  == 4) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr_1500{this_roi_index} = 3; %late CRUNCH point
%                 number_of_levels_extrapolate = 0:4;
%                 coeffs=polyfit(number_of_levels, beta_values(1:4), 2);
%                 fittedX=linspace(min(number_of_levels_extrapolate), max(number_of_levels_extrapolate), 100);
%                 fittedY=polyval(coeffs, fittedX);
%                 plot(fittedX,fittedY,'-b')
%                 if round(max(fittedY)) < 3.5
%                     cr_1500{this_roi_index} = 3;
%                 else
%                     cr_1500{this_roi_index} = 4;
%                 end
%                 cr_1500{this_roi_index} = 3; %never CRUNCH point
            end
            max_beta_cr_1500{this_roi_index} = beta_values(max_beta_index);
            max_beta_index = find(max(beta_values(5:8))==beta_values(5:8)); %CRUNCH for 500 ISI
            if (max_beta_index  == 1)
                cr_500{this_roi_index} = 0; %start CRUNCH point
            elseif (max_beta_index  == 2) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr_500{this_roi_index} = 1; %early CRUNCH point
            elseif (max_beta_index  == 3) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr_500{this_roi_index} = 2; %late CRUNCH point
            elseif (max_beta_index  == 4) %if the subject has a CRUNCH point (on a scale of 1-4)
                cr_500{this_roi_index} = 3; %late CRUNCH point
%                 number_of_levels_extrapolate = 0:4;
%                 coeffs=polyfit(number_of_levels, beta_values(5:8), 2);
%                 fittedX=linspace(min(number_of_levels_extrapolate), max(number_of_levels_extrapolate), 100);
%                 fittedY=polyval(coeffs, fittedX);
%                 plot(fittedX,fittedY,'-b')
%                 if round(max(fittedY)) < 3.5
%                     cr_500{this_roi_index} = 3;
%                 else
%                     cr_500{this_roi_index} = 4;
%                 end
%                 cr_500{this_roi_index} = 3; %never CRUNCH point
            end
            max_beta_cr_500{this_roi_index} = beta_values(max_beta_index+4);
        end
        hold off;
        xticks(number_of_levels)
        xlim([-1 4])
        title(char(unique_rois(this_roi_index)),'interpreter','latex')
        this_figure_number = this_figure_number + 1;
        ylabel('beta value')
        %         clearvars beta_values;
    end
    suptitle(strcat(subjects{sub}, {' '}, 'Brain Activity'))
    hold off;
    
    if save_variables
        if any(strcmp(task_folder, '05_MotorImagery'))
            task='MotorImagery';
            save(char(strcat(subj_results_dir,filesep,strcat(subjects{sub},'_',task,'_',output_filename))),'cr*','data','unique_rois','max_beta_cr*');
        elseif any(strcmp(task_folder, '06_Nback'))
            task='Nback';
            save(char(strcat(subj_results_dir,filesep,strcat(subjects{sub},'_',task,'_',output_filename))),'cr*','data','unique_rois','max_beta_cr*');
        end
    end
    fclose(fileID);
    clearvars beta_values cr* max_beta* data temp ordered_conditions this_beta this_roi_index;
end
end

