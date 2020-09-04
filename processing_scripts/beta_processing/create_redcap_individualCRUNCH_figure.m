
% roi_results figure generation
clear,clc
% close all

task_folder={'05_MotorImagery'};  
% task_folder={'06_Nback'};  
subjects = {'1002', '1004', '1010', '1011','1013'}; % need to figure out how to pass cell from shell
% subjects =  {'2002','2007','2008','2012','2013','2015','2018','2020','2021','2022','2023','2025','2026'};

Results_filename='CRUNCH_secondorder_max.mat';
% rm

%% TO DO ::: Setup for loop for each task/group???XXXX %%%
no_labels = 0;

data_path = pwd;

subject_color_matrix = distinguishable_colors(length(subjects));


for this_subject_index = 1 : length(subjects)
    subj_results_dir = fullfile(data_path, subjects{this_subject_index}, 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain');
    this_subject_roiResults_path = fullfile(data_path, subjects{this_subject_index}, 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain', strcat(subjects{this_subject_index},'_fmri_redcap.csv'));
    
    fileID = fopen(this_subject_roiResults_path{:});
    
    data = textscan(fileID,'%s','delimiter',',','headerlines',0);
    data = reshape(data{:},length(data{1})/2,2);
    
    for this_beta = 3:length(data)
        split_condition_name = strsplit(data{this_beta,1},'_');
        if any(strcmp(task_folder, '05_MotorImagery'))
            ordered_conditions{this_beta-2} = split_condition_name{1};
            roi_names{this_beta-2} = strcat(split_condition_name{2},'_',split_condition_name{3});
            ordered_beta{this_beta-2} = data{this_beta,2};
        elseif any(strcmp(task_folder, '06_Nback'))
            ordered_conditions{this_beta-2} = strcat(split_condition_name{1},'_',split_condition_name{2});
            roi_names{this_beta-2} = strcat(split_condition_name{3},'_',split_condition_name{4});
            ordered_beta{this_beta-2} = data{this_beta,2};
        end
    end
    unique_rois = unique(roi_names);
    
    this_figure_number = 1;
    for this_roi_index = 1 : length(unique_rois)
        
        x_num = [1 : 4];

        
        this_roi_indices = find(strcmp(roi_names, unique_rois{this_roi_index}));
        
        temp = ordered_beta(:,this_roi_indices)';
        for i_beta= 1:length(temp)
            y(:,i_beta) = sscanf(temp{i_beta},'%f');
        end
        subplot(1, 4, this_figure_number);        
        hold on;
        
        if any(strcmp(task_folder, '05_MotorImagery'))
            plot(x_num, y,'o', 'MarkerFaceColor', subject_color_matrix(this_subject_index, :), 'MarkerEdgeColor', subject_color_matrix(this_subject_index, :), 'MarkerSize', 3)
            coeffs=polyfit(x_num, y, 2);
            fittedX=linspace(min(x_num), max(x_num), 100);
            fittedY=polyval(coeffs, fittedX);
            plot(fittedX, fittedY, '--', 'Color', subject_color_matrix(this_subject_index, :),'LineWidth',1);
            [crunchpoint_y, crunchpoint_percent(this_subject_index,this_roi_index)] = max(fittedY);
            scatter(fittedX(crunchpoint_percent(this_subject_index,this_roi_index)), fittedY(crunchpoint_percent(this_subject_index,this_roi_index)), 100,  'o', 'MarkerFaceColor',  subject_color_matrix(this_subject_index, :), 'MarkerEdgeColor', subject_color_matrix(this_subject_index, :), 'MarkerFaceAlpha',3/8); % 'MarkerSize', 12)
        elseif any(strcmp(task_folder, '06_Nback'))
            plot(x_num, y(1:4),'o', 'MarkerFaceColor', subject_color_matrix(this_subject_index, :), 'MarkerEdgeColor', subject_color_matrix(this_subject_index, :), 'MarkerSize', 3)
            plot(x_num, y(5:8),'o', 'MarkerFaceColor', subject_color_matrix(this_subject_index, :), 'MarkerEdgeColor', subject_color_matrix(this_subject_index, :), 'MarkerSize', 3)
            coeffs1=polyfit(x_num, y(1:4), 2);
            coeffs2=polyfit(x_num, y(5:8), 2);
            fittedX=linspace(min(x_num), max(x_num), 100);
            fittedY1=polyval(coeffs1, fittedX);
            fittedY2=polyval(coeffs2, fittedX);
            plot(fittedX, fittedY1, '--', 'Color', subject_color_matrix(this_subject_index, :),'LineWidth',1);
            plot(fittedX, fittedY2, '-', 'Color', subject_color_matrix(this_subject_index, :),'LineWidth',1);
            [crunchpoint_y1, crunchpoint_percent1(this_subject_index,this_roi_index)] = max(fittedY1);
            [crunchpoint_y2, crunchpoint_percent2(this_subject_index,this_roi_index)] = max(fittedY2);
            scatter(fittedX(crunchpoint_percent1(this_subject_index,this_roi_index)), fittedY1(crunchpoint_percent1(this_subject_index,this_roi_index)), 100,  'o', 'MarkerFaceColor',  subject_color_matrix(this_subject_index, :), 'MarkerEdgeColor', subject_color_matrix(this_subject_index, :), 'MarkerFaceAlpha',3/8); % 'MarkerSize', 12,
            scatter(fittedX(crunchpoint_percent2(this_subject_index,this_roi_index)), fittedY2(crunchpoint_percent2(this_subject_index,this_roi_index)), 100,  'o', 'MarkerFaceColor',  subject_color_matrix(this_subject_index, :), 'MarkerEdgeColor', subject_color_matrix(this_subject_index, :), 'MarkerFaceAlpha',3/8); % 'MarkerSize', 12,
        end
        if any(strcmp(task_folder, '05_MotorImagery'))
            task='MotorImagery';
            save(char(strcat(subj_results_dir,filesep,strcat(subjects{this_subject_index},'_',task,'_',Results_filename))), 'crunchpoint_percent','unique_rois');
        else any(strcmp(task_folder, '06_Nback'))
            task='Nback';
            save(char(strcat(subj_results_dir,strcat(subjects{this_subject_index},'_',task,'_',Results_filename))), 'crunchpoint_percent1', 'crunchpoint_percent2','unique_rois');
        end
         
        xticks([x_num])
        xlim([0 5])
        title([unique_rois(this_roi_index)],'interpreter','latex')
        this_figure_number = this_figure_number + 1;
        ylabel('beta value')%, 'FontSize', 32       
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
    coeffs1=polyfit(crunchpoint_percent(:,1), crunchpoint_percent(:,3), 1);
    fittedX=linspace(0, 100, 100);
    fittedY1=polyval(coeffs1, fittedX);
    plot(crunchpoint_percent(:,1), crunchpoint_percent(:,3), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b', 'MarkerSize', 12)
    plot(fittedX, fittedY1, '--', 'Color', 'k','LineWidth',1);
    [r , p] = corr(crunchpoint_percent(:,1), crunchpoint_percent(:,3));
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
    coeffs1=polyfit(crunchpoint_percent1(:,1), crunchpoint_percent1(:,1), 1);
    coeffs2=polyfit(crunchpoint_percent2(:,1), crunchpoint_percent2(:,1), 1);
    fittedX=linspace(0, 100, 100);
    fittedY1=polyval(coeffs1, fittedX);
    fittedY2=polyval(coeffs2, fittedX);
    plot(crunchpoint_percent1(:,1), crunchpoint_percent1(:,3), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b', 'MarkerSize', 12)
    plot(fittedX, fittedY1, '--', 'Color', 'k','LineWidth',1);
    plot(crunchpoint_percent2(:,1), crunchpoint_percent2(:,3), 'o', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b', 'MarkerSize', 12)
    plot(fittedX, fittedY1, '--', 'Color', 'k','LineWidth',1);
    plot(fittedX, fittedY2, '--', 'Color', 'k','LineWidth',1);
    [r , p] = corr([crunchpoint_percent1(:,1); crunchpoint_percent2(:,1)], [crunchpoint_percent1(:,3); crunchpoint_percent2(:,3)]);
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