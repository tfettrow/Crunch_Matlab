
% roi_results figure generation
clear,clc
% close all

%% settings
%select the task 1 = MOTO, 2 = nback
task = 1;

if task == 1
    task_folder='05_MotorImagery';
    subjects = [1002,1004,1010,1011,1013,1009];
elseif task == 2
    task_folder='06_Nback';
    subjects =  [2002,2007,2008,2012,2013,2015,2018,2020,2021,2022,2023,2025,2026,2033,2034];
end

Results_filename='CRUNCH_discrete_vas.mat';

save_variables = 1;
no_labels = 0;
% data folder path
data_path = 'Z:\share\FromExternal\Research_Projects_UF\CRUNCH\MiM_Data'; % change this to reflect the share drive path for your PC

%subject_color_matrix = distinguishable_colors(length(subjects));


for sub = 1
    %%create file path for beta values
    subj_results_dir = fullfile(data_path, num2str(subjects(sub)), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain');
    this_subject_roiResults_path = fullfile(subj_results_dir, strcat(num2str(subjects(sub)),'_fmri_redcap.csv'));
    
    fileID = fopen(this_subject_roiResults_path);
    
    %%read the csv file and reshape to have separate headers and values
    data = textscan(fileID,'%s','delimiter',',');
    data = reshape(data{:},length(data{1})/2,2);
    
    for this_beta = 3:length(data)
        split_difficulty = strsplit(data{this_beta,1},'_');%separate difficulty and brain region
        if task == 1
            ordered_conditions{this_beta-2} = split_difficulty{1}; %difficulty level = flat to high
            roi_names{this_beta-2} = strcat(split_difficulty{2},'_',split_difficulty{3}); %brain region name, l-pfc, r-pfc, l-acc, r-acc
            ordered_beta{this_beta-2} = data{this_beta,2}; %beta value arranged here
        elseif task == 2
            ordered_conditions{this_beta-2} = strcat(split_difficulty{1},'_',split_difficulty{2}); % difficulty = 0 to 3 with long or short ISI
            roi_names{this_beta-2} = strcat(split_difficulty{3},'_',split_difficulty{4}); %brain region name
            ordered_beta{this_beta-2} = data{this_beta,2}; %beta value
        end
    end
    unique_rois = unique(roi_names); %delete the repeats of the brain region name
    
    this_figure_number = 1;
    for this_roi_index = 1 : length(unique_rois) %1:4, l-pfc, r-pfc, l-acc, r-acc
        this_roi_indices = find(strcmp(roi_names, unique_rois{this_roi_index})); %find the index of when the current ROI occurs
        
        temp = ordered_beta(:,this_roi_indices)'; %temporary hold the beta values
        for i_beta= 1:length(temp)
            beta_values(:,i_beta) = textscan(temp{i_beta},'%f'); %beta values for current ROI
        end
        beta_values = cell2mat(beta_values);
        subplot(1, 4, this_figure_number);
        hold on;
        
        if any(strcmp(task_folder, '05_MotorImagery'))
            number_of_levels = 1:4;
            plot(number_of_levels,beta_values,'-or');
            mm = find(max(beta_values)==beta_values);
            if (mm < 2 || mm > 3)
                cr(this_roi_index) = 0;
            else
                cr(this_roi_index) = mm;
            end

%             coeffs=polyfit(number_of_levels, beta_values, 2);
%             fittedX=linspace(min(number_of_levels), max(number_of_levels), 100);
%             fittedY=polyval(coeffs, fittedX);
%             
%             plot(number_of_levels, beta_values,'o', 'MarkerFaceColor', subject_color_matrix(sub, :), 'MarkerEdgeColor', subject_color_matrix(sub, :), 'MarkerSize', 3)
%             plot(fittedX, fittedY, '--', 'Color', subject_color_matrix(sub, :),'LineWidth',1);
%             
%             % identify crunch point in terms of difficulty level
%             [crunchpoint_y, crunchpoint_percent_of_fit(sub,this_roi_index)] = max(fittedY);
%             crunchpoint_x(this_roi_index) = fittedX(crunchpoint_percent_of_fit(sub,this_roi_index));
%             
%             scatter(fittedX(crunchpoint_percent_of_fit(sub,this_roi_index)), fittedY(crunchpoint_percent_of_fit(sub,this_roi_index)), 100,  'o', 'MarkerFaceColor',  subject_color_matrix(sub, :), 'MarkerEdgeColor', subject_color_matrix(sub, :), 'MarkerFaceAlpha',3/8); % 'MarkerSize', 12)
       
        elseif any(strcmp(task_folder, '06_Nback'))
            number_of_levels = 1:4;
            slope_cr = diff(beta_values)./diff(number_of_levels); %find slope
            plot(number_of_levels,beta_values(1:4),'-or');
            plot(number_of_levels,beta_values(5:8),'-.or');
            mm = find(max(beta_values)==beta_values);
            if (mm < 2 || mm > 3)
                cr(this_roi_index) = 0;
            else
                cr(this_roi_index) = mm;
            end
            
%             coeffs1=polyfit(number_of_levels, beta_values(1:4), 2);
%             coeffs2=polyfit(number_of_levels, beta_values(5:8), 2);
%             fittedX=linspace(min(number_of_levels), max(number_of_levels), 100);
%             fittedY1=polyval(coeffs1, fittedX);
%             fittedY2=polyval(coeffs2, fittedX);
%             
%             
%             plot(fittedX, fittedY1, '--', 'Color', subject_color_matrix(sub, :),'LineWidth',1);
%             plot(fittedX, fittedY2, '-', 'Color', subject_color_matrix(sub, :),'LineWidth',1);
%             plot(number_of_levels, beta_values(1:4),'o', 'MarkerFaceColor', subject_color_matrix(sub, :), 'MarkerEdgeColor', subject_color_matrix(sub, :), 'MarkerSize', 3)
%             plot(number_of_levels, beta_values(5:8),'o', 'MarkerFaceColor', subject_color_matrix(sub, :), 'MarkerEdgeColor', subject_color_matrix(sub, :), 'MarkerSize', 3)
%             
%             [crunchpoint_y1, crunchpoint_percent_of_fit_1(sub,this_roi_index)] = max(fittedY1);
%             [crunchpoint_y2, crunchpoint_percent_of_fit_2(sub,this_roi_index)] = max(fittedY2);
%             crunchpoint_x1(this_roi_index) = fittedX(crunchpoint_percent_of_fit_1(sub,this_roi_index));
%             crunchpoint_x2(this_roi_index) = fittedX(crunchpoint_percent_of_fit_2(sub,this_roi_index));
%             
%             scatter(fittedX(crunchpoint_percent_of_fit_1(sub,this_roi_index)), fittedY1(crunchpoint_percent_of_fit_1(sub,this_roi_index)), 100,  'o', 'MarkerFaceColor',  subject_color_matrix(sub, :), 'MarkerEdgeColor', subject_color_matrix(sub, :), 'MarkerFaceAlpha',3/8); % 'MarkerSize', 12,
%             scatter(fittedX(crunchpoint_percent_of_fit_2(sub,this_roi_index)), fittedY2(crunchpoint_percent_of_fit_2(sub,this_roi_index)), 100,  'o', 'MarkerFaceColor',  subject_color_matrix(sub, :), 'MarkerEdgeColor', subject_color_matrix(sub, :), 'MarkerFaceAlpha',3/8); % 'MarkerSize', 12,
        end
        xticks(number_of_levels)
        xlim([0 5])
        title(unique_rois(this_roi_index),'interpreter','latex')
        this_figure_number = this_figure_number + 1;
        ylabel('beta value')
        clearvars beta_values;
    end
    if save_variables
        if any(strcmp(task_folder, '05_MotorImagery'))
            task='MotorImagery';
            save(char(strcat(subj_results_dir,filesep,strcat(num2str(subjects(sub)),'_',task,'_',Results_filename))));
        elseif any(strcmp(task_folder, '06_Nback'))
            task='Nback';
            save(char(strcat(subj_results_dir,filesep,strcat(num2str(subjects(sub)),'_',task,'_',Results_filename))));
        end
    end
end

allYLim = [];
for this_subplot = 1 : this_figure_number  - 1
    subplot(1, 4, this_subplot);
    if this_subplot > 1
        ylabel([])
    end
    
    h = findobj(gca,'Type','line');
    thisYLim = get(gca, 'YLim');
    allYLim = [allYLim thisYLim];
    
    if no_labels
        set(get(gca, 'xlabel'), 'visible', 'off');
        set(get(gca, 'ylabel'), 'visible', 'off');
        set(get(gca, 'title'), 'visible', 'off');
        set(gca, 'xticklabel', '');
        set(gca, 'yticklabel', '');
        legend(gca, 'hide');
    end
end
% MaximizeFigureWindow;

figure;hold on;
title('Correlations between left_acc and right_acc', 'interpreter','latex')
% ylabel('right_acc', 'interpreter','latex')
% xlabel('left_acc', 'interpreter','latex')

xlim([0 100])
ylim([0 100])

if any(strcmp(task_folder, '05_MotorImagery'))
    coeffs1=polyfit(crunchpoint_percent_of_fit(:,1), crunchpoint_percent_of_fit(:,3), 1);
    fittedX=linspace(0, 100, 100);
    fittedY1=polyval(coeffs1, fittedX);
    plot(crunchpoint_percent_of_fit(:,1), crunchpoint_percent_of_fit(:,3), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b', 'MarkerSize', 12)
    plot(fittedX, fittedY1, '--', 'Color', 'k','LineWidth',1);
    [r , p] = corr(crunchpoint_percent_of_fit(:,1), crunchpoint_percent_of_fit(:,3));
    r2 = r^2;
    thisXLim = get(gca, 'XLim');
    thisYLim = get(gca, 'YLim');
    x1 = 45;
    y1 = 95;
    y2 = 90;
    y3 = min(allYLim) + min(allYLim) * .1;
    y4 = min(allYLim) + min(allYLim) * .05;
    text1 = ['r^2 = ' num2str(r2)];
    text2 = ['m = ' num2str(coeffs1(1))];
    text(x1,y1,text1)
    text(x1,y2,text2)
elseif any(strcmp(task_folder, '06_Nback'))
    coeffs1=polyfit(crunchpoint_percent_of_fit_1(:,1), crunchpoint_percent_of_fit_1(:,1), 1);
    coeffs2=polyfit(crunchpoint_percent_of_fit_2(:,1), crunchpoint_percent_of_fit_2(:,1), 1);
    fittedX=linspace(0, 100, 100);
    fittedY1=polyval(coeffs1, fittedX);
    fittedY2=polyval(coeffs2, fittedX);
    plot(crunchpoint_percent_of_fit_1(:,1), crunchpoint_percent_of_fit_1(:,3), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b', 'MarkerSize', 12)
    plot(fittedX, fittedY1, '--', 'Color', 'k','LineWidth',1);
    plot(crunchpoint_percent_of_fit_2(:,1), crunchpoint_percent_of_fit_2(:,3), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b', 'MarkerSize', 12)
    plot(fittedX, fittedY1, '--', 'Color', 'k','LineWidth',1);
    plot(fittedX, fittedY2, '--', 'Color', 'k','LineWidth',1);
    [r , p] = corr([crunchpoint_percent_of_fit_1(:,1); crunchpoint_percent_of_fit_2(:,1)], [crunchpoint_percent_of_fit_1(:,3); crunchpoint_percent_of_fit_2(:,3)]);
    r2 = r^2;
    thisXLim = get(gca, 'XLim');
    thisYLim = get(gca, 'YLim');
    x1 = 45;
    y1 = 95;
    y2 = 90;
    y3 = min(allYLim) + min(allYLim) * .1;
    y4 = min(allYLim) + min(allYLim) * .05;
    text1 = ['r^2 = ' num2str(r2)];
    text2 = ['m = ' mean([num2str(coeffs1(1)) num2str(coeffs2(1))])];
    text(x1,y1,text1)
    text(x1,y2,text2)
end