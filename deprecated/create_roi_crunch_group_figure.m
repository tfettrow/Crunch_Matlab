% roi_results figure generation
clear,clc
% close all

task={'05_MotorImagery'};                            
population={'youngAdult', 'oldAdult'};             

%% TO DO ::: Setup for loop for each task/group???XXXX %%%
% seperate=1;

roi_type = 'manual';
extraction_type='voxel';
% extraction_type='WFU';
% extraction_type='Network';

no_labels = 0;

% roi_type = '5sig';

data_path = pwd;

% find each subject roi_results file


if any(strcmp(task, '05_MotorImagery'))
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % motor imagery manual
    
    if strcmp(roi_type,'manual')
        if strcmp(extraction_type,'voxel')
            if any(strcmp(population, 'oldAdult'))
                oa_crunch = load('oldAdult_crunch_voxel');
            end
            if any(strcmp(population, 'youngAdult'))
                ya_crunch = load('youngAdult_crunch_voxel');
            end
        elseif strcmp(extraction_type,'WFU')
            oa_crunch = load('oldAdult_crunch_wfu');
            ya_crunch = load('youngAdult_crunch_wfu');
        elseif strcmp(extraction_type, 'Network')
            oa_crunch = load('oldAdult_crunch_network');
            ya_crunch = load('youngAdult_crunch_network');
        end
        
        %         oa_average = mean(oa_crunch.crunchpoint_matrix_imagery_manual,1);
        %         oa_std = std(oa_crunch.crunchpoint_matrix_imagery_manual,1);
        %
        %         oa_sem =std(oa_crunch.crunchpoint_matrix_imagery_manual,1)/sqrt(size(oa_crunch.crunchpoint_matrix_imagery_manual,1));
        
        %             ya_average = mean(ya_crunch.crunchpoint_matrix_imagery_manual,1);
        %             ya_std = std(ya_crunch.crunchpoint_matrix_imagery_manual,1);
        %             ya_sem =std(ya_crunch.crunchpoint_matrix_imagery_manual,1)/sqrt(size(ya_crunch.crunchpoint_matrix_imagery_manual,1));
        
        % check to confirm roi_lables are same length between YA + OA and = to
        % length (matrix)
        
        oa_color = [160/255 32/255 240/255];
        ya_color = [0 1 0];
        
        %         this_figure_number = 1;
        %         for this_roi_index = 1 : size(oa_crunch.rois_imagery_manual,1)
        %             %         if strcmp(subject_level_directory{end}, '05_MotorImagery')
        %
        %             subplot(1, size(oa_crunch.rois_imagery_manual,1), this_figure_number);
        %
        %             title([oa_crunch.rois_imagery_manual{this_roi_index}])
        %             hold on;
        %             if any(strcmp(population, 'youngAdult'))
        %                 f1 = plot([1], [ya_average(this_roi_index)],'o', 'MarkerFaceColor', ya_color, 'MarkerEdgeColor', ya_color, 'MarkerSize', 5)
        %                 errorbar(1, ya_average(this_roi_index), ya_std(this_roi_index), 'k')
        %             end
        %             if any(strcmp(population, 'oldAdult'))
        %                 f2 = plot([2], [oa_average(this_roi_index)],'o', 'MarkerFaceColor', oa_color, 'MarkerEdgeColor', oa_color, 'MarkerSize', 5)
        %                 errorbar(2, oa_average(this_roi_index), oa_std(this_roi_index), 'k')
        %             end
        %             if sum(any(strcmp(population, 'oldAdult'))) ==2
        %                 plot(1:2, [ya_average(this_roi_index) oa_average(this_roi_index)], '-',  'Color', 'r')
        %             else
        %                 if any(strcmp(population, 'oldAdult'))
        %                     plot(1, [oa_average(this_roi_index)], '-',  'Color', 'r')
        %                 elseif any(strcmp(population, 'youngAdult'))
        %                     plot(1, [ya_average(this_roi_index)], '-',  'Color', 'r')
        %                 end
        %             end
        %
        %             this_figure_number = this_figure_number + 1;
        %         end
        %         % convert the percentage into distance between low and high conditions
        %
        %         for this_subplot = 1 : this_figure_number  - 1
        %             %     if strcmp(subject_level_directory{end}, '06_Nback')
        %             subplot(1, size(oa_crunch.rois_imagery_manual,1), this_subplot);
        %             %     end
        %             set(gca, 'YLim', [0, 135]);
        %             set(gca, 'XLim', [0, 3])
        %             yticks([0 100])
        %             yticklabels({'Low','High'})
        %             xticks([1 2])
        %             xticklabels({'Young', 'Old'})
        %             set(gca,'FontSize', 16)
        %             %     set(gca,
        %             %     set(gca, 'XLim',  [0, 100]);
        %         end
        if any(strcmp(population, 'oldAdult'))
            oa_average = squeeze(nanmean(oa_crunch.beta_matrix_imagery_manual,1))';
            oa_std = squeeze(nanstd(oa_crunch.beta_matrix_imagery_manual,1))';
            oa_sem =squeeze(nanstd(oa_crunch.beta_matrix_imagery_manual,1)/sqrt(size(oa_crunch.beta_matrix_imagery_manual,1)))';
            %         end
            
            
            figure
            this_figure_number = 1;
            for this_roi_index = 1 : size(oa_crunch.rois_imagery_manual,1)
                %         if strcmp(subject_level_directory{end}, '05_MotorImagery')
                
%                 subplot(1, size(oa_crunch.rois_imagery_manual,1), this_figure_number);
                
                
                
                if length(oa_crunch.rois_imagery_manual)<=6
                    subplot(1, 6, oa_crunch.rois_imagery_manual);
                elseif length(oa_crunch.rois_imagery_manual)>6 & length(oa_crunch.rois_imagery_manual)<=12
                    subplot(2, 6, this_figure_number);
                elseif length(oa_crunch.rois_imagery_manual)>12 & length(oa_crunch.rois_imagery_manual)<=18
                    subplot(3, 6, this_figure_number);
                elseif length(oa_crunch.rois_imagery_manual)>18 & length(oa_crunch.rois_imagery_manual)<=24
                    subplot(4, 6, this_figure_number);
                elseif length(oa_crunch.rois_imagery_manual)>24 & length(oa_crunch.rois_imagery_manual)<=30
                    subplot(5, 6, this_figure_number);
                end
                
                title([oa_crunch.rois_imagery_manual{this_roi_index}])
                hold on;
                
                %             if any(strcmp(population, 'oldAdult'))
                f2 = plot([.95:1:3.95], [oa_average(this_roi_index,:)],'-o', 'MarkerFaceColor', oa_color, 'MarkerEdgeColor', oa_color, 'MarkerSize', 5, 'LineWidth',3, 'Color', oa_color)
                errorbar([.95:1:3.95], oa_average(this_roi_index,:), oa_sem(this_roi_index,:), 'Color', oa_color)
                %             end
                %         plot(1:2, [ya_average(this_roi_index) oa_average(this_roi_index)], '-',  'Color', 'r')
                
                this_figure_number = this_figure_number + 1;
            end
            
            allYLim = [];
            for this_subplot = 1 : this_figure_number  - 1
                  if length(oa_crunch.rois_imagery_manual)<=6
                    subplot(1, 6, oa_crunch.rois_imagery_manual);
                elseif length(oa_crunch.rois_imagery_manual)>6 & length(oa_crunch.rois_imagery_manual)<=12
                    subplot(2, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>12 & length(oa_crunch.rois_imagery_manual)<=18
                    subplot(3, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>18 & length(oa_crunch.rois_imagery_manual)<=24
                    subplot(4, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>24 & length(oa_crunch.rois_imagery_manual)<=30
                    subplot(5, 6, this_subplot);
                end
                set(gca, 'XLim', [0, 5])
                if this_subplot == 1
                    ylabel(['Brain Activity'], 'FontSize', 32)
                end
                thisYLim = get(gca, 'YLim');
                allYLim = [allYLim thisYLim];
                
                xtickangle(45)
                xticks([1 2 3 4])
                xticklabels({'Flat', 'Low', 'Medium', 'High'})
                set(gca,'FontSize', 16)
                
                %     set(gca,
                %     set(gca, 'XLim',  [0, 100]);
            end
            
            for this_subplot = 1 : this_figure_number  - 1
                %     if strcmp(subject_level_directory{end}, '05_MotorImagery')
                  if length(oa_crunch.rois_imagery_manual)<=6
                    subplot(1, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>6 & length(oa_crunch.rois_imagery_manual)<=12
                    subplot(2, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>12 & length(oa_crunch.rois_imagery_manual)<=18
                    subplot(3, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>18 & length(oa_crunch.rois_imagery_manual)<=24
                    subplot(4, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>24 & length(oa_crunch.rois_imagery_manual)<=30
                    subplot(5, 6, this_subplot);
                end
                %     end
                %                 set(gca, 'YLim', [min(allYLim), max(allYLim)]);
                set(gca, 'YLim', [-2, max(allYLim)]);
            end
            
            if no_labels
                for this_subplot = 1 : this_figure_number  - 1
                    if length(oa_crunch.rois_imagery_manual)<=6
                        subplot(1, 6, this_subplot);
                    elseif length(oa_crunch.rois_imagery_manual)>6 & length(oa_crunch.rois_imagery_manual)<=12
                        subplot(2, 6, this_subplot);
                    elseif length(oa_crunch.rois_imagery_manual)>12 & length(oa_crunch.rois_imagery_manual)<=18
                        subplot(3, 6, this_subplot);
                    elseif length(oa_crunch.rois_imagery_manual)>18 & length(oa_crunch.rois_imagery_manual)<=24
                        subplot(4, 6, this_subplot);
                    elseif length(oa_crunch.rois_imagery_manual)>24 & length(oa_crunch.rois_imagery_manual)<=30
                        subplot(5, 6, this_subplot);
                    end
                    %     set(get(gca, 'xaxis'), 'visible', 'off');
                    %     set(get(gca, 'yaxis'), 'visible', 'off');
                    set(get(gca, 'xlabel'), 'visible', 'off');
                    set(get(gca, 'ylabel'), 'visible', 'off');
                    set(get(gca, 'title'), 'visible', 'off');
                    set(gca, 'xticklabel', '');
                    set(gca, 'yticklabel', '');
                    %     set(gca, 'position', [0 0 1 1]);
                    legend(gca, 'hide');
                end
            end
        end
        %
        if any(strcmp(population, 'youngAdult'))
            ya_average = squeeze(nanmean(ya_crunch.beta_matrix_imagery_manual,1))';
            ya_std = squeeze(nanstd(ya_crunch.beta_matrix_imagery_manual,1))';
            ya_sem = squeeze(nanstd(ya_crunch.beta_matrix_imagery_manual,1)/sqrt(size(ya_crunch.beta_matrix_imagery_manual,1)))';
            
            
            figure
            this_figure_number = 1;
            for this_roi_index = 1 : size(ya_crunch.rois_imagery_manual,1)
                %         if strcmp(subject_level_directory{end}, '05_MotorImagery')
                
                %                 subplot(1, size(ya_crunch.rois_imagery_manual,1), this_figure_number);
                if length(ya_crunch.rois_imagery_manual)<=6
                    subplot(1, 6, this_figure_number);
                elseif length(ya_crunch.rois_imagery_manual)>6 & length(ya_crunch.rois_imagery_manual)<=12
                    subplot(2, 6, this_figure_number);
                elseif length(ya_crunch.rois_imagery_manual)>12 & length(ya_crunch.rois_imagery_manual)<=18
                    subplot(3, 6, this_figure_number);
                elseif length(ya_crunch.rois_imagery_manual)>18 & length(ya_crunch.rois_imagery_manual)<=24
                    subplot(4, 6, this_figure_number);
                elseif length(ya_crunch.rois_imagery_manual)>24 & length(ya_crunch.rois_imagery_manual)<=30
                    subplot(5, 6, this_figure_number);
                end
                title([ya_crunch.rois_imagery_manual{this_roi_index}])
                hold on;
                
                f1 = plot([1.05:1:4.05], [ya_average(this_roi_index,:)],'-o', 'MarkerFaceColor', ya_color, 'MarkerEdgeColor', ya_color, 'MarkerSize', 5, 'LineWidth',3, 'Color', ya_color)
                errorbar([1.05:1:4.05], ya_average(this_roi_index,:), ya_sem(this_roi_index,:), 'Color', ya_color)
               
                %         plot(1:2, [ya_average(this_roi_index) oa_average(this_roi_index)], '-',  'Color', 'r')
                
                this_figure_number = this_figure_number + 1;
            end
            
            allYLim = [];
            for this_subplot = 1 : this_figure_number  - 1
                if length(ya_crunch.rois_imagery_manual)<=6
                    subplot(1, 6, this_subplot);
                elseif length(ya_crunch.rois_imagery_manual)>6 & length(ya_crunch.rois_imagery_manual)<=12
                    subplot(2, 6, this_subplot);
                elseif length(ya_crunch.rois_imagery_manual)>12 & length(ya_crunch.rois_imagery_manual)<=18
                    subplot(3, 6, this_subplot);
                elseif length(ya_crunch.rois_imagery_manual)>18 & length(ya_crunch.rois_imagery_manual)<=24
                    subplot(4, 6, this_subplot);
                elseif length(ya_crunch.rois_imagery_manual)>24 & length(ya_crunch.rois_imagery_manual)<=30
                    subplot(5, 6, this_subplot);
                end
                set(gca, 'XLim', [0, 5])
                if this_subplot == 1
                    ylabel(['Brain Activity'], 'FontSize', 32)
                end
                thisYLim = get(gca, 'YLim');
                allYLim = [allYLim thisYLim];
                
                xtickangle(45)
                xticks([1 2 3 4])
                xticklabels({'Flat', 'Low', 'Medium', 'High'})
                set(gca,'FontSize', 16)
                
                %     set(gca,
                %     set(gca, 'XLim',  [0, 100]);
            end
            
            for this_subplot = 1 : this_figure_number  - 1
                %     if strcmp(subject_level_directory{end}, '05_MotorImagery')
                if length(ya_crunch.rois_imagery_manual)<=6
                    subplot(1, 6, this_subplot);
                elseif length(ya_crunch.rois_imagery_manual)>6 & length(ya_crunch.rois_imagery_manual)<=12
                    subplot(2, 6, this_subplot);
                elseif length(ya_crunch.rois_imagery_manual)>12 & length(ya_crunch.rois_imagery_manual)<=18
                    subplot(3, 6, this_subplot);
                elseif length(ya_crunch.rois_imagery_manual)>18 & length(ya_crunch.rois_imagery_manual)<=24
                    subplot(4, 6, this_subplot);
                elseif length(ya_crunch.rois_imagery_manual)>24 & length(ya_crunch.rois_imagery_manual)<=30
                    subplot(5, 6, this_subplot);
                end
                %     end
%                 set(gca, 'YLim', [min(allYLim), max(allYLim)]);
 set(gca, 'YLim', [-2, max(allYLim)]);
            end
            
            if no_labels
                for this_subplot = 1 : this_figure_number  - 1
                    if length(ya_crunch.rois_imagery_manual)<=6
                        subplot(1, 6, this_subplot);
                    elseif length(ya_crunch.rois_imagery_manual)>6 & length(ya_crunch.rois_imagery_manual)<=12
                        subplot(2, 6, this_subplot);
                    elseif length(ya_crunch.rois_imagery_manual)>12 & length(ya_crunch.rois_imagery_manual)<=18
                        subplot(3, 6, this_subplot);
                    elseif length(ya_crunch.rois_imagery_manual)>18 & length(ya_crunch.rois_imagery_manual)<=24
                        subplot(4, 6, this_subplot);
                    elseif length(ya_crunch.rois_imagery_manual)>24 & length(ya_crunch.rois_imagery_manual)<=30
                        subplot(5, 6, this_subplot);
                    end
                    %     set(get(gca, 'xaxis'), 'visible', 'off');
                    %     set(get(gca, 'yaxis'), 'visible', 'off');
                    set(get(gca, 'xlabel'), 'visible', 'off');
                    set(get(gca, 'ylabel'), 'visible', 'off');
                    set(get(gca, 'title'), 'visible', 'off');
                    set(gca, 'xticklabel', '');
                    set(gca, 'yticklabel', '');
                    %     set(gca, 'position', [0 0 1 1]);
                    legend(gca, 'hide');
                end
            end
        end
        
        if any(strcmp(population, 'youngAdult')) && any(strcmp(population, 'oldAdult'))
         
            
            figure
            this_figure_number = 1;
            for this_roi_index = 1 : size(ya_crunch.rois_imagery_manual,1)
                %         if strcmp(subject_level_directory{end}, '05_MotorImagery')
                
                if length(ya_crunch.rois_imagery_manual)<=6
                    subplot(1, 6, this_figure_number);
                elseif length(ya_crunch.rois_imagery_manual)>6 & length(ya_crunch.rois_imagery_manual)<=12
                    subplot(2, 6, this_figure_number);
                elseif length(ya_crunch.rois_imagery_manual)>12 & length(ya_crunch.rois_imagery_manual)<=18
                    subplot(3, 6, this_figure_number);
                elseif length(ya_crunch.rois_imagery_manual)>18 & length(ya_crunch.rois_imagery_manual)<=24
                    subplot(4, 6, this_figure_number);
                elseif length(ya_crunch.rois_imagery_manual)>24 & length(ya_crunch.rois_imagery_manual)<=30
                    subplot(5, 6, this_figure_number);
                end
                
                title([ya_crunch.rois_imagery_manual{this_roi_index}])
                hold on;
                
                f1 = plot([1.05:1:4.05], [ya_average(this_roi_index,:)],'-o', 'MarkerFaceColor', ya_color, 'MarkerEdgeColor', ya_color, 'MarkerSize', 5, 'LineWidth',3, 'Color', ya_color)
                errorbar([1.05:1:4.05], ya_average(this_roi_index,:), ya_sem(this_roi_index,:), 'Color', ya_color)
                f2 = plot([.95:1:3.95], [oa_average(this_roi_index,:)],'-o', 'MarkerFaceColor', oa_color, 'MarkerEdgeColor', oa_color, 'MarkerSize', 5, 'LineWidth',3, 'Color', oa_color)
                errorbar([.95:1:3.95], oa_average(this_roi_index,:), oa_sem(this_roi_index,:), 'Color', oa_color)
                
                xtickangle(45)
                xticks([1 2 3 4])
                xticklabels({'Flat', 'Low', 'Medium', 'High'})
                %         plot(1:2, [ya_average(this_roi_index) oa_average(this_roi_index)], '-',  'Color', 'r')
                
                this_figure_number = this_figure_number + 1;
            end
            
            allYLim = [];
            for this_subplot = 1 : this_figure_number  - 1
                if length(ya_crunch.rois_imagery_manual)<=6
                    subplot(1, 6, this_subplot);
                elseif length(ya_crunch.rois_imagery_manual)>6 & length(ya_crunch.rois_imagery_manual)<=12
                    subplot(2, 6, this_subplot);
                elseif length(ya_crunch.rois_imagery_manual)>12 & length(ya_crunch.rois_imagery_manual)<=18
                    subplot(3, 6, this_subplot);
                elseif length(ya_crunch.rois_imagery_manual)>18 & length(ya_crunch.rois_imagery_manual)<=24
                    subplot(4, 6, this_subplot);
                elseif length(ya_crunch.rois_imagery_manual)>24 & length(ya_crunch.rois_imagery_manual)<=30
                    subplot(5, 6, this_subplot);
                end
                set(gca, 'XLim', [0, 5])
                if this_subplot == 1
                    ylabel(['Beta Value'], 'FontSize', 32)
                end
                thisYLim = get(gca, 'YLim');
                allYLim = [allYLim thisYLim];
                
                
                if this_subplot <= 24
                    set(gca,'XTick',[]);
%                 set(gca,'FontSize', 16) 
                end
              
                
                %     set(gca,
                %     set(gca, 'XLim',  [0, 100]);
            end
            
            for this_subplot = 1 : this_figure_number  - 1
                %     if strcmp(subject_level_directory{end}, '05_MotorImagery')
               if length(ya_crunch.rois_imagery_manual)<=6
                    subplot(1, 6, this_subplot);
                elseif length(ya_crunch.rois_imagery_manual)>6 & length(ya_crunch.rois_imagery_manual)<=12
                    subplot(2, 6, this_subplot);
                elseif length(ya_crunch.rois_imagery_manual)>12 & length(ya_crunch.rois_imagery_manual)<=18
                    subplot(3, 6, this_subplot);
                elseif length(ya_crunch.rois_imagery_manual)>18 & length(ya_crunch.rois_imagery_manual)<=24
                    subplot(4, 6, this_subplot);
                elseif length(ya_crunch.rois_imagery_manual)>24 & length(ya_crunch.rois_imagery_manual)<=30
                    subplot(5, 6, this_subplot);
                end
                %     end
%                 set(gca, 'YLim', [min(allYLim), max(allYLim)]);
%  set(gca, 'YLim', [-2, max(allYLim)]);
            end
            
            if no_labels
                for this_subplot = 1 : this_figure_number  - 1
                    if length(ya_crunch.rois_imagery_manual)<=6
                        subplot(1, 6, this_subplot);
                    elseif length(ya_crunch.rois_imagery_manual)>6 & length(ya_crunch.rois_imagery_manual)<=12
                        subplot(2, 6, this_subplot);
                    elseif length(ya_crunch.rois_imagery_manual)>12 & length(ya_crunch.rois_imagery_manual)<=18
                        subplot(3, 6, this_subplot);
                    elseif length(ya_crunch.rois_imagery_manual)>18 & length(ya_crunch.rois_imagery_manual)<=24
                        subplot(4, 6, this_subplot);
                    elseif length(ya_crunch.rois_imagery_manual)>24 & length(ya_crunch.rois_imagery_manual)<=30
                        subplot(5, 6, this_subplot);
                    end
                    %     set(get(gca, 'xaxis'), 'visible', 'off');
                    %     set(get(gca, 'yaxis'), 'visible', 'off');
                    set(get(gca, 'xlabel'), 'visible', 'off');
                    set(get(gca, 'ylabel'), 'visible', 'off');
                    set(get(gca, 'title'), 'visible', 'off');
                    set(gca, 'xticklabel', '');
                    set(gca, 'yticklabel', '');
                    %     set(gca, 'position', [0 0 1 1]);
                    legend(gca, 'hide');
                end
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if any(strcmp(task, '06_Nback'))
        % nback manual
        figure;
        if strcmp(extraction_type,'voxel')
            oa_crunch = load('oldAdult_crunch_voxel');
            ya_crunch = load('youngAdult_crunch_voxel');
        elseif strcmp(extraction_type,'WFU')
            oa_crunch = load('oldAdult_crunch_wfu');
            ya_crunch = load('youngAdult_crunch_wfu');
        elseif strcmp(extraction_type, 'Network')
            oa_crunch = load('oldAdult_crunch_network');
            ya_crunch = load('youngAdult_crunch_network');
        end
        oa_average = mean(oa_crunch.crunchpoint_matrix_nback_manual,1);
        oa_std = std(oa_crunch.crunchpoint_matrix_nback_manual,1);
        oa_sem =squeeze(std(oa_crunch.beta_matrix_nback_manual,1)/sqrt(size(oa_crunch.beta_matrix_nback_manual,1)))';
        
        ya_average = mean(ya_crunch.crunchpoint_matrix_nback_manual,1);
        ya_std = std(oa_crunch.crunchpoint_matrix_nback_manual,1);
        ya_sem = squeeze(std(ya_crunch.beta_matrix_nback_manual,1)/sqrt(size(ya_crunch.beta_matrix_nback_manual,1)))';
        % check to confirm roi_lables are same length between YA + OA and = to
        % length (matrix)
        
        oa_color = [160/255 32/255 240/255];
        ya_color = [0 1 0];
        
        this_figure_number = 1;
        for this_roi_index = 1 : size(oa_crunch.rois_nback_manual,1)
            %         if strcmp(subject_level_directory{end}, '05_Motornback')
            
            if length(oa_crunch.rois_imagery_manual)<=6
                subplot(1, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>6 & length(oa_crunch.rois_imagery_manual)<=12
                subplot(2, 6, this_figure_number);
            elseif length(oa_crunch.rois_imagery_manual)>12 & length(oa_crunch.rois_imagery_manual)<=18
                subplot(3, 6, this_figure_number);
            elseif length(oa_crunch.rois_imagery_manual)>18 & length(oa_crunch.rois_imagery_manual)<=24
                subplot(4, 6, this_figure_number);
            elseif length(oa_crunch.rois_imagery_manual)>24 & length(oa_crunch.rois_imagery_manual)<=30
                subplot(5, 6, this_figure_number);
            end
            
            title([oa_crunch.rois_nback_manual{this_roi_index}])
            hold on;
            
            f1 = plot([1], [ya_average(this_roi_index)],'o', 'MarkerFaceColor', ya_color, 'MarkerEdgeColor', ya_color, 'MarkerSize', 5)
            f2 = plot([2], [oa_average(this_roi_index)],'o', 'MarkerFaceColor', oa_color, 'MarkerEdgeColor', oa_color, 'MarkerSize', 5)
            plot(1:2, [ya_average(this_roi_index) oa_average(this_roi_index)], '-',  'Color', 'r')
            errorbar(1, ya_average(this_roi_index), ya_sem(this_roi_index), 'k')
            errorbar(2, oa_average(this_roi_index), oa_sem(this_roi_index), 'k')
            
            this_figure_number = this_figure_number + 1;
        end
        % convert the percentage into distance between low and high conditions
        
        
        
        allYLim = [];
        for this_subplot = 1 : this_figure_number  - 1
            if length(oa_crunch.rois_imagery_manual)<=6
                subplot(1, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>6 & length(oa_crunch.rois_imagery_manual)<=12
                subplot(2, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>12 & length(oa_crunch.rois_imagery_manual)<=18
                subplot(3, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>18 & length(oa_crunch.rois_imagery_manual)<=24
                subplot(4, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>24 & length(oa_crunch.rois_imagery_manual)<=30
                subplot(5, 6, this_subplot);
            end
            set(gca, 'XLim', [0, 5])
            if this_subplot == 1
                ylabel(['Brain Activity'], 'FontSize', 32)
            end
            thisYLim = get(gca, 'YLim');
            allYLim = [allYLim thisYLim];
            
            xtickangle(45)
            xticks([1 2 3 4])
            xticklabels({'Zero', 'One', 'Two', 'Three'})
            set(gca,'FontSize', 16)
            
            %     set(gca,
            %     set(gca, 'XLim',  [0, 100]);
        end
        
        for this_subplot = 1 : this_figure_number  - 1
            %     if strcmp(subject_level_directory{end}, '05_MotorImagery')
            if length(oa_crunch.rois_imagery_manual)<=6
                subplot(1, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>6 & length(oa_crunch.rois_imagery_manual)<=12
                subplot(2, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>12 & length(oa_crunch.rois_imagery_manual)<=18
                subplot(3, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>18 & length(oa_crunch.rois_imagery_manual)<=24
                subplot(4, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>24 & length(oa_crunch.rois_imagery_manual)<=30
                subplot(5, 6, this_subplot);
            end
            %     end
%             set(gca, 'YLim', [min(allYLim), max(allYLim)]);
 set(gca, 'YLim', [-2, max(allYLim)]);
        end
        
        for this_subplot = 1 : this_figure_number  - 1
            %     if strcmp(subject_level_directory{end}, '06_Nback')
            if length(oa_crunch.rois_imagery_manual)<=6
                subplot(1, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>6 & length(oa_crunch.rois_imagery_manual)<=12
                subplot(2, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>12 & length(oa_crunch.rois_imagery_manual)<=18
                subplot(3, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>18 & length(oa_crunch.rois_imagery_manual)<=24
                subplot(4, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>24 & length(oa_crunch.rois_imagery_manual)<=30
                subplot(5, 6, this_subplot);
            end
            %     end
            set(gca, 'YLim', [0, 135]);
            set(gca, 'XLim', [0, 3])
            yticks([0 100])
            yticklabels({'Low','High'})
            xticks([1 2])
            xticklabels({'Young', 'Old'})
            set(gca,'FontSize', 16)
            %     set(gca,
            %     set(gca, 'XLim',  [0, 100]);
        end
        
        
        if no_labels
            for this_subplot = 1 : this_figure_number  - 1
                if length(oa_crunch.rois_imagery_manual)<=6
                    subplot(1, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>6 & length(oa_crunch.rois_imagery_manual)<=12
                    subplot(2, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>12 & length(oa_crunch.rois_imagery_manual)<=18
                    subplot(3, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>18 & length(oa_crunch.rois_imagery_manual)<=24
                    subplot(4, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>24 & length(oa_crunch.rois_imagery_manual)<=30
                    subplot(5, 6, this_subplot);
                end
                %     set(get(gca, 'xaxis'), 'visible', 'off');
                %     set(get(gca, 'yaxis'), 'visible', 'off');
                set(get(gca, 'xlabel'), 'visible', 'off');
                set(get(gca, 'ylabel'), 'visible', 'off');
                set(get(gca, 'title'), 'visible', 'off');
                set(gca, 'xticklabel', '');
                set(gca, 'yticklabel', '');
                %     set(gca, 'position', [0 0 1 1]);
                legend(gca, 'hide');
            end
        end
        
        oa_average = squeeze(mean(oa_crunch.beta_matrix_nback_manual,1))';
        oa_std = squeeze(std(oa_crunch.beta_matrix_nback_manual,1))';
        oa_sem =squeeze(std(oa_crunch.beta_matrix_nback_manual,1)/sqrt(size(oa_crunch.beta_matrix_nback_manual,1)))';
        
        ya_average = squeeze(mean(ya_crunch.beta_matrix_nback_manual,1))';
        ya_std = squeeze(std(ya_crunch.beta_matrix_nback_manual,1))';
        ya_sem = squeeze(std(ya_crunch.beta_matrix_nback_manual,1)/sqrt(size(ya_crunch.beta_matrix_nback_manual,1)))';
        
        figure
        this_figure_number = 1;
        for this_roi_index = 1 : size(oa_crunch.rois_nback_manual,1)
            %         if strcmp(subject_level_directory{end}, '05_Motornback')
            
            if length(oa_crunch.rois_imagery_manual)<=6
                subplot(1, 6, oa_crunch.rois_imagery_manual);
            elseif length(oa_crunch.rois_imagery_manual)>6 & length(oa_crunch.rois_imagery_manual)<=12
                subplot(2, 6, this_figure_number);
            elseif length(oa_crunch.rois_imagery_manual)>12 & length(oa_crunch.rois_imagery_manual)<=18
                subplot(3, 6, this_figure_number);
            elseif length(oa_crunch.rois_imagery_manual)>18 & length(oa_crunch.rois_imagery_manual)<=24
                subplot(4, 6, this_figure_number);
            elseif length(oa_crunch.rois_imagery_manual)>24 & length(oa_crunch.rois_imagery_manual)<=30
                subplot(5, 6, this_figure_number);
            end
            
            title([oa_crunch.rois_nback_manual{this_roi_index}])
            hold on;
            
            f1 = plot([1.05:1:4.05], [ya_average(this_roi_index,:)],'-o', 'MarkerFaceColor', ya_color, 'MarkerEdgeColor', ya_color, 'MarkerSize', 5, 'LineWidth',3, 'Color', ya_color)
            f2 = plot([.95:1:3.95], [oa_average(this_roi_index,:)],'-o', 'MarkerFaceColor', oa_color, 'MarkerEdgeColor', oa_color, 'MarkerSize', 5, 'LineWidth',3, 'Color', oa_color)
            %         plot(1:2, [ya_average(this_roi_index) oa_average(this_roi_index)], '-',  'Color', 'r')
            errorbar([1.05:1:4.05], ya_average(this_roi_index,:), ya_sem(this_roi_index,:), 'Color', ya_color)
            errorbar([.95:1:3.95], oa_average(this_roi_index,:), oa_sem(this_roi_index,:), 'Color', oa_color)
            
            this_figure_number = this_figure_number + 1;
        end
        
        
        allYLim = [];
        
        for this_subplot = 1 : this_figure_number  - 1
            
            if length(oa_crunch.rois_imagery_manual)<=6
                subplot(1, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>6 & length(oa_crunch.rois_imagery_manual)<=12
                subplot(2, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>12 & length(oa_crunch.rois_imagery_manual)<=18
                subplot(3, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>18 & length(oa_crunch.rois_imagery_manual)<=24
                subplot(4, 6, this_subplot);
            elseif length(oa_crunch.rois_imagery_manual)>24 & length(oa_crunch.rois_imagery_manual)<=30
                subplot(5, 6, this_subplot);
            end
            
            set(gca, 'XLim', [0, 5])
            
            if this_subplot == 1
                ylabel(['Brain Activity'], 'FontSize', 32)
            end
            thisYLim = get(gca, 'YLim');
            allYLim = [allYLim thisYLim];
            
            xtickangle(45)
            xticks([1 2 3 4])
            xticklabels({'Zero', 'One', 'Two', 'Three'})
            set(gca,'FontSize', 16)
            %     set(gca,
            %     set(gca, 'XLim',  [0, 100]);
        end
        
        for this_subplot = 1 : this_figure_number  - 1
            %     if strcmp(subject_level_directory{end}, '05_MotorImagery')
            if length(oa_crunch.rois_imagery_manual)<=6
                    subplot(1, 6, oa_crunch.rois_imagery_manual);
                elseif length(oa_crunch.rois_imagery_manual)>6 & length(oa_crunch.rois_imagery_manual)<=12
                    subplot(2, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>12 & length(oa_crunch.rois_imagery_manual)<=18
                    subplot(3, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>18 & length(oa_crunch.rois_imagery_manual)<=24
                    subplot(4, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>24 & length(oa_crunch.rois_imagery_manual)<=30
                    subplot(5, 6, this_subplot);
                end
            %     end
%             set(gca, 'YLim', [min(allYLim), max(allYLim)]);
 set(gca, 'YLim', [-2, max(allYLim)]);
        end
        
        if no_labels
            for this_subplot = 1 : this_figure_number  - 1
                if length(oa_crunch.rois_imagery_manual)<=6
                    subplot(1, 6, oa_crunch.rois_imagery_manual);
                elseif length(oa_crunch.rois_imagery_manual)>6 & length(oa_crunch.rois_imagery_manual)<=12
                    subplot(2, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>12 & length(oa_crunch.rois_imagery_manual)<=18
                    subplot(3, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>18 & length(oa_crunch.rois_imagery_manual)<=24
                    subplot(4, 6, this_subplot);
                elseif length(oa_crunch.rois_imagery_manual)>24 & length(oa_crunch.rois_imagery_manual)<=30
                    subplot(5, 6, this_subplot);
                end
                %     set(get(gca, 'xaxis'), 'visible', 'off');
                %     set(get(gca, 'yaxis'), 'visible', 'off');
                set(get(gca, 'xlabel'), 'visible', 'off');
                set(get(gca, 'ylabel'), 'visible', 'off');
                set(get(gca, 'title'), 'visible', 'off');
                set(gca, 'xticklabel', '');
                set(gca, 'yticklabel', '');
                %     set(gca, 'position', [0 0 1 1]);
                legend(gca, 'hide');
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %5sig
    elseif strcmp(roi_type,'5sig')
        oa_crunch =  load('oldAdult_crunch_5sig')
        ya_crunch =  load('youngAdult_crunch_5sig')
        
        oa_average = mean(oa_crunch.crunchpoint_matrix_imagery_5sig,1);
        oa_std = std(oa_crunch.crunchpoint_matrix_imagery_5sig,1);
        
        ya_average = mean(ya_crunch.crunchpoint_matrix_imagery_5sig,1);
        ya_std = std(oa_crunch.crunchpoint_matrix_imagery_5sig,1);
        
        % check to confirm roi_lables are same length between YA + OA and = to
        % length (matrix)
        
        oa_color = [160/255 32/255 240/255];
        ya_color = [0 1 0];
        
        this_figure_number = 1;
        for this_roi_index = 1 : size(oa_crunch.rois_imagery_5sig,1)
            %         if strcmp(subject_level_directory{end}, '05_MotorImagery')
            
            
            
            subplot(1, size(oa_crunch.rois_imagery_5sig,1), this_figure_number);
            
            title([oa_crunch.rois_imagery_5sig{this_roi_index}])
            hold on;
            
            f1 = plot([1], [ya_average(this_roi_index)],'o', 'MarkerFaceColor', ya_color, 'MarkerEdgeColor', ya_color, 'MarkerSize', 5);
            f2 = plot([2], [oa_average(this_roi_index)],'o', 'MarkerFaceColor', oa_color, 'MarkerEdgeColor', oa_color, 'MarkerSize', 5);
            plot(1:2, [ya_average(this_roi_index) oa_average(this_roi_index)], '-',  'Color', 'r')
            errorbar(1, ya_average(this_roi_index), ya_std(this_roi_index), 'k')
            errorbar(2, oa_average(this_roi_index), oa_std(this_roi_index), 'k')
            
            
            this_figure_number = this_figure_number + 1;
        end
        % convert the percentage into distance between low and high conditions
        
        for this_subplot = 1 : this_figure_number  - 1
            %     if strcmp(subject_level_directory{end}, '06_Nback')
            subplot(1, size(oa_crunch.rois_imagery_5sig,1), this_subplot);
            %     end
            set(gca, 'YLim', [0, 135]);
            set(gca, 'XLim', [0, 3])
            yticks([0 100])
            yticklabels({'Low','High'})
            xticks([1 2])
            xticklabels({'Young', 'Old'})
            set(gca,'FontSize', 16)
            %     set(gca,
            %     set(gca, 'XLim',  [0, 100]);
        end
        
        
        
        oa_average = squeeze(mean(oa_crunch.beta_matrix_imagery_5sig,1))';
        oa_std = squeeze(std(oa_crunch.beta_matrix_imagery_5sig,1))';
        oa_sem =squeeze(std(oa_crunch.beta_matrix_imagery_5sig,1)/sqrt(size(oa_crunch.beta_matrix_imagery_5sig,1)))';
        
        ya_average = squeeze(mean(ya_crunch.beta_matrix_imagery_5sig,1))';
        ya_std = squeeze(std(ya_crunch.beta_matrix_imagery_5sig,1))';
        ya_sem = squeeze(std(ya_crunch.beta_matrix_imagery_5sig,1)/sqrt(size(ya_crunch.beta_matrix_imagery_5sig,1)))';
        
        
        figure
        this_figure_number = 1;
        for this_roi_index = 1 : size(oa_crunch.rois_imagery_5sig,1)
            %         if strcmp(subject_level_directory{end}, '05_MotorImagery')
            
            subplot(1, size(oa_crunch.rois_imagery_5sig,1), this_figure_number);
            
            title([oa_crunch.rois_imagery_5sig{this_roi_index}])
            hold on;
            
            f1 = plot([1.05:1:4.05], [ya_average(this_roi_index,:)],'-o', 'MarkerFaceColor', ya_color, 'MarkerEdgeColor', ya_color, 'MarkerSize', 5, 'LineWidth',3, 'Color', ya_color);
            f2 = plot([.95:1:3.95], [oa_average(this_roi_index,:)],'-o', 'MarkerFaceColor', oa_color, 'MarkerEdgeColor', oa_color, 'MarkerSize', 5, 'LineWidth',3, 'Color', oa_color);
            %         plot(1:2, [ya_average(this_roi_index) oa_average(this_roi_index)], '-',  'Color', 'r')
            errorbar([1.05:1:4.05], ya_average(this_roi_index,:), ya_sem(this_roi_index,:), 'Color', ya_color)
            errorbar([.95:1:3.95], oa_average(this_roi_index,:), oa_sem(this_roi_index,:), 'Color', oa_color)
            
            this_figure_number = this_figure_number + 1;
        end
        
        for this_subplot = 1 : this_figure_number  - 1
            subplot(1, size(oa_crunch.rois_imagery_5sig,1), this_subplot);
            
            set(gca, 'XLim', [0, 5])
            if this_subplot == 1
                ylabel(['Brain Activity'], 'FontSize', 32)
            end
            xtickangle(45)
            xticks([1 2 3 4])
            xticklabels({'Flat', 'Low', 'Medium', 'High'})
            set(gca,'FontSize', 16)
            %     set(gca,
            %     set(gca, 'XLim',  [0, 100]);
        end
        
        
    end
    
end
