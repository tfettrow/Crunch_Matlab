
% roi_results figure generation
clear,clc
% close all

data_path = pwd;

cd 'spreadsheet_data'
cd 'walking_data'
headers={'subject_id', 'sppb_balance', 'sppb_speed', 'sppb_stand', 'sppb_total','400m'};
walking_data = xlsread('walking_data.xlsx');
cd ..
cd 'sensory_data'
headers={'subject_id','PainThreshold_Average','PainInventory_Average','Tactile_Mono','Tactile_Dual'};
sensory_data = xlsread('sensory_data.xlsx');
cd ..
cd ..

% find each subject roi_results file
    cd(strcat('Group_Results_loadModulation', filesep, 'MRI_files'))
%     cd 'MRI_files'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% motor imagery manual
if strcmp(roi_type,'manual')
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

    oa_color = [160/255 32/255 240/255];
    ya_color = [0 1 0];
    
    oa_beta_average = squeeze(nanmean(oa_crunch.beta_matrix_imagery_manual,1))';
    oa_beta_std = squeeze(nanstd(oa_crunch.beta_matrix_imagery_manual,1))';
    oa_beta_sem =squeeze(nanstd(oa_crunch.beta_matrix_imagery_manual,1)/sqrt(size(oa_crunch.beta_matrix_imagery_manual,1)))';
    oa_crunchpoint = oa_crunch.crunchpoint_matrix_imagery_manual; 
    oa_subject_id = oa_crunch.subject_id_imagery;
    
    
    ya_beta_average = squeeze(nanmean(ya_crunch.beta_matrix_imagery_manual,1))';
    ya_beta_std = squeeze(nanstd(ya_crunch.beta_matrix_imagery_manual,1))';
    ya_beta_sem = squeeze(nanstd(ya_crunch.beta_matrix_imagery_manual,1)/sqrt(size(ya_crunch.beta_matrix_imagery_manual,1)))';
    ya_crunchpoint = ya_crunch.crunchpoint_matrix_imagery_manual;
    ya_subject_id = ya_crunch.subject_id_imagery;
    
    figure;
    this_figure_number = 1;
    for this_roi_index = 1 : size(oa_crunch.rois_imagery_manual,1)
        for this_oa_subject_index = 1:length(oa_subject_id)
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
            hold on; 
            %             title([oa_crunch.rois_imagery_manual{this_roi_index} 'vs 400m' ])
            
            this_subject_id = oa_subject_id(this_oa_subject_index);
            
            difficulty_spectrum = linspace(0,3,100);

            this_subject_row_walking_data = find(strcmp(string(walking_data(:,1)), this_subject_id));
            this_oa_y_data(this_oa_subject_index, this_roi_index) = walking_data(this_subject_row_walking_data,6);
            
            this_oa_x_percent = oa_crunchpoint(this_oa_subject_index, this_roi_index);
            this_oa_x_data(this_oa_subject_index, this_roi_index) = difficulty_spectrum(this_oa_x_percent);
            
            plot(this_oa_x_data(this_oa_subject_index, this_roi_index), this_oa_y_data(this_oa_subject_index, this_roi_index), 'o', 'MarkerEdge', 'k', 'MarkerFace', 'r')
            
            title([oa_crunch.rois_imagery_manual(this_roi_index)])
        end
        this_figure_number = this_figure_number + 1;
    end
    
    allYLim=[];
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
        set(gca, 'XLim', [0 3])
        if this_subplot == 1
%             ylabel(['Brain Activity'], 'FontSize', 32)
        end
        thisYLim = get(gca, 'YLim');
        allYLim = [allYLim thisYLim];
        
    end
  
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
                 set(gca, 'YLim', [min(allYLim), max(allYLim)]);
        
        [r , p] = corr(this_oa_x_data(:, this_subplot), this_oa_y_data(:, this_subplot));
        r2_oa = r^2;
        coefs_oa = polyfit(this_oa_x_data(:, this_subplot), this_oa_y_data(:, this_subplot), 1);
        fittedX_oa=linspace(0, 3, 100);
        fittedY_oa=polyval(coefs_oa, fittedX_oa);
        
        %         [r , p] = corr(this_ya_x_data(:, this_subplot), this_ya_y_data(:, this_subplot));
        %             r2_ya = r^2;
        %         coefs_ya = polyfit(this_ya_x_data(:, this_subplot), this_ya_y_data(:, this_subplot), 1);
        %         fittedX_ya=linspace(0, 3, 100);
        %         fittedY_ya=polyval(coefs_ya, fittedX_ya);
        
        plot(fittedX_oa, fittedY_oa, '-', 'Color','r','LineWidth',1);
        %         plot(fittedX_ya, fittedY_ya, '-', 'Color','b','LineWidth',1);
        
        x1 = 0.1;
        y1 = min(allYLim) + min(allYLim) * .25;
        y2 = min(allYLim) + min(allYLim) * .2;
        y3 = min(allYLim) + min(allYLim) * .1;
        y4 = min(allYLim) + min(allYLim) * .05;
        text1 = ['OA r^2 = ' num2str(r2_oa)];
        text2 = ['OA m = ' num2str(coefs_oa(1))];
%         text3 = ['YA r^2 = ' num2str(r2_ya)];
%         text4 = ['YA m = ' num2str(coefs_ya(1))];
        
        text(x1,y1,text1)
%         text(x1,y2,text2)
%         text(x1,y3,text3)
%         text(x1,y4,text4)
    end
     suptitle('CRUNCH vs 400m Walk')
     
    %% Pain Threshold and MI CRUNCH
%     figure 
    figure;
    this_figure_number = 1;
    this_oa_y_data=[];
    this_oa_x_data=[];
    for this_roi_index = 1 : size(oa_crunch.rois_imagery_manual,1)
        for this_oa_subject_index = 1:length(oa_subject_id)
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
            hold on;
            title([oa_crunch.rois_imagery_manual(this_roi_index)])
%             title([oa_crunch.rois_imagery_manual{this_roi_index} 'vs 400m' ])
            
            this_subject_id = oa_subject_id(this_oa_subject_index);
            
            difficulty_spectrum = linspace(0,3,100);

            this_subject_row_sensory_data = find(strcmp(string(sensory_data(:,1)), this_subject_id));
            if ~isnan(sensory_data(this_subject_row_sensory_data,2))
                this_oa_y_data(this_oa_subject_index, this_roi_index) = sensory_data(this_subject_row_sensory_data,2);
                
                this_oa_x_percent = oa_crunchpoint(this_oa_subject_index, this_roi_index);
                this_oa_x_data(this_oa_subject_index, this_roi_index) = difficulty_spectrum(this_oa_x_percent);
                
                plot(this_oa_x_data(this_oa_subject_index, this_roi_index), this_oa_y_data(this_oa_subject_index, this_roi_index), 'o', 'MarkerEdge', 'k', 'MarkerFace', 'r')
            end
        end
%         for this_ya_subject_index = 1:length(ya_subject_id)
%             this_subject_id = ya_subject_id(this_ya_subject_index);
%             
%             this_subject_row_sensory_data = find(strcmp(string(sensory_data(:,1)), this_subject_id));
%             
%             this_ya_y_data(this_ya_subject_index, this_roi_index) = sensory_data(this_subject_row_sensory_data,2);
%             
%             this_ya_x_percent = ya_crunchpoint(this_ya_subject_index, this_roi_index);
%             this_ya_x_data(this_ya_subject_index, this_roi_index) = difficulty_spectrum(this_ya_x_percent);
%             
%             plot(this_ya_x_data(this_ya_subject_index, this_roi_index), this_ya_y_data(this_ya_subject_index, this_roi_index), 'o', 'MarkerEdge', 'k', 'MarkerFace', 'b')
%         end
        this_figure_number = this_figure_number + 1;
    end
    
    allYLim=[];
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
        set(gca, 'XLim', [0 3])
        if this_subplot == 1
%             ylabel(['Brain Activity'], 'FontSize', 32)
        end
        thisYLim = get(gca, 'YLim');
        allYLim = [allYLim thisYLim];
        
%         xtickangle(45)
%         xticks([1 2 3 4])
%         xticklabels({'Flat', 'Low', 'Medium', 'High'})
%         set(gca,'FontSize', 16)
        
        %     set(gca,
        %     set(gca, 'XLim',  [0, 100]);
    end


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
         set(gca, 'YLim', [min(allYLim), max(allYLim)]);
         
            [r , p] = corr(this_oa_x_data(:, this_subplot), this_oa_y_data(:, this_subplot));
            r2_oa = r^2;
        coefs_oa = polyfit(this_oa_x_data(:, this_subplot), this_oa_y_data(:, this_subplot), 1);
        fittedX_oa=linspace(0, 3, 100);
        fittedY_oa=polyval(coefs_oa, fittedX_oa);
        
%         [r , p] = corr(this_ya_x_data(:, this_subplot), this_ya_y_data(:, this_subplot));
%             r2_ya = r^2;
%         coefs_ya = polyfit(this_ya_x_data(:, this_subplot), this_ya_y_data(:, this_subplot), 1);
%         fittedX_ya=linspace(0, 3, 100);
%         fittedY_ya=polyval(coefs_ya, fittedX_ya);
%         
        plot(fittedX_oa, fittedY_oa, '-', 'Color','r','LineWidth',1);
%         plot(fittedX_ya, fittedY_ya, '-', 'Color','b','LineWidth',1);
         
              x1 = 0.1;
        y1 = min(allYLim) + min(allYLim) * .25;
        y2 = min(allYLim) + min(allYLim) * .2;  
%         y3 = min(allYLim) + min(allYLim) * .1;
%         y4 = min(allYLim) + min(allYLim) * .05;
        text1 = ['OA r^2 = ' num2str(r2_oa)];
        text2 = ['OA m = ' num2str(coefs_oa(1))];
%         text3 = ['YA r^2 = ' num2str(r2_ya)];
%         text4 = ['YA m = ' num2str(coefs_ya(1))];
%         
        text(x1,y1,text1)
%         text(x1,y2,text2)
%         text(x1,y3,text3)
%         text(x1,y4,text4)
     end
     suptitle('CRUNCH vs Pain Threshold')
    
    %% Proprio Mono and MI CRUNCH
    figure;
    this_figure_number = 1;
    this_oa_y_data=[];
    this_oa_x_data=[];
    for this_roi_index = 1 : size(oa_crunch.rois_imagery_manual,1)
        for this_oa_subject_index = 1:length(oa_subject_id)
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
            hold on;
            title([oa_crunch.rois_imagery_manual(this_roi_index)])
%             title([oa_crunch.rois_imagery_manual{this_roi_index} 'vs 400m' ])
            
            this_subject_id = oa_subject_id(this_oa_subject_index);
            
            difficulty_spectrum = linspace(0,3,100);
            
            this_subject_row_sensory_data = find(strcmp(string(sensory_data(:,1)), this_subject_id));
            if ~isnan(sensory_data(this_subject_row_sensory_data,4))
                this_oa_y_data(this_oa_subject_index, this_roi_index) = sensory_data(this_subject_row_sensory_data,4);
                
                this_oa_x_percent = oa_crunchpoint(this_oa_subject_index, this_roi_index);
                this_oa_x_data(this_oa_subject_index, this_roi_index) = difficulty_spectrum(this_oa_x_percent);
                
                plot(this_oa_x_data(this_oa_subject_index, this_roi_index), this_oa_y_data(this_oa_subject_index, this_roi_index), 'o', 'MarkerEdge', 'k', 'MarkerFace', 'r')
            end
            
        end

        this_figure_number = this_figure_number + 1;
    end
    
    allYLim=[];
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
        set(gca, 'XLim', [0 3])
        if this_subplot == 1
%             ylabel(['Brain Activity'], 'FontSize', 32)
        end
        thisYLim = get(gca, 'YLim');
        allYLim = [allYLim thisYLim];
        
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
        set(gca, 'YLim', [min(allYLim), max(allYLim)]);
    end

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
%          set(gca, 'YLim', [min(allYLim), max(allYLim)]);
         
            [r , p] = corr(this_oa_x_data(:, this_subplot), this_oa_y_data(:, this_subplot));
            r2_oa = r^2;
        coefs_oa = polyfit(this_oa_x_data(:, this_subplot), this_oa_y_data(:, this_subplot), 1);
        fittedX_oa=linspace(0, 3, 100);
        fittedY_oa=polyval(coefs_oa, fittedX_oa);
        
%         [r , p] = corr(this_ya_x_data(:, this_subplot), this_ya_y_data(:, this_subplot));
%             r2_ya = r^2;
%         coefs_ya = polyfit(this_ya_x_data(:, this_subplot), this_ya_y_data(:, this_subplot), 1);
%         fittedX_ya=linspace(0, 3, 100);
%         fittedY_ya=polyval(coefs_ya, fittedX_ya);
%         
        plot(fittedX_oa, fittedY_oa, '-', 'Color','r','LineWidth',1);
%         plot(fittedX_ya, fittedY_ya, '-', 'Color','b','LineWidth',1);
         
              x1 = 0.1;
        y1 = min(allYLim) + min(allYLim) * .25;
        y2 = min(allYLim) + min(allYLim) * .2;  
%         y3 = min(allYLim) + min(allYLim) * .1;
%         y4 = min(allYLim) + min(allYLim) * .05;
        text1 = ['OA r^2 = ' num2str(r2_oa)];
        text2 = ['OA m = ' num2str(coefs_oa(1))];
%         text3 = ['YA r^2 = ' num2str(r2_ya)];
%         text4 = ['YA m = ' num2str(coefs_ya(1))];
%         
        text(x1,y1,text1)
%         text(x1,y2,text2)
%         text(x1,y3,text3)
%         text(x1,y4,text4)
     end
     suptitle('CRUNCH vs Tactile Mono')
    
    
    %% Proprio Dual and MI CRUNCH
    figure;
    this_figure_number = 1;
    this_oa_y_data=[];
    this_oa_x_data=[];
    for this_roi_index = 1 : size(oa_crunch.rois_imagery_manual,1)
        for this_oa_subject_index = 1:length(oa_subject_id)
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
            hold on;
            title([oa_crunch.rois_imagery_manual(this_roi_index)])
%             title([oa_crunch.rois_imagery_manual{this_roi_index} 'vs 400m' ])
            
            this_subject_id = oa_subject_id(this_oa_subject_index);
            
            difficulty_spectrum = linspace(0,3,100);

            this_subject_row_sensory_data = find(strcmp(string(sensory_data(:,1)), this_subject_id));
            if ~isnan(sensory_data(this_subject_row_sensory_data,5))
                this_oa_y_data(this_oa_subject_index, this_roi_index) = sensory_data(this_subject_row_sensory_data,5);
                
                this_oa_x_percent = oa_crunchpoint(this_oa_subject_index, this_roi_index);
                this_oa_x_data(this_oa_subject_index, this_roi_index) = difficulty_spectrum(this_oa_x_percent);
                
                plot(this_oa_x_data(this_oa_subject_index, this_roi_index), this_oa_y_data(this_oa_subject_index, this_roi_index), 'o', 'MarkerEdge', 'k', 'MarkerFace', 'r')
            end
        end
%         for this_ya_subject_index = 1:length(ya_subject_id)
%             this_subject_id = ya_subject_id(this_ya_subject_index);
%             
%             this_subject_row_sensory_data = find(strcmp(string(sensory_data(:,1)), this_subject_id));
%             
%             this_ya_y_data(this_ya_subject_index, this_roi_index) = sensory_data(this_subject_row_sensory_data,2);
%             
%             this_ya_x_percent = ya_crunchpoint(this_ya_subject_index, this_roi_index);
%             this_ya_x_data(this_ya_subject_index, this_roi_index) = difficulty_spectrum(this_ya_x_percent);
%             
%             plot(this_ya_x_data(this_ya_subject_index, this_roi_index), this_ya_y_data(this_ya_subject_index, this_roi_index), 'o', 'MarkerEdge', 'k', 'MarkerFace', 'b')
%         end
        this_figure_number = this_figure_number + 1;
    end
    
    allYLim=[];
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
        set(gca, 'XLim', [0 3])
        if this_subplot == 1
%             ylabel(['Brain Activity'], 'FontSize', 32)
        end
        thisYLim = get(gca, 'YLim');
        allYLim = [allYLim thisYLim];
        
%         xtickangle(45)
%         xticks([1 2 3 4])
%         xticklabels({'Flat', 'Low', 'Medium', 'High'})
%         set(gca,'FontSize', 16)
        
        %     set(gca,
        %     set(gca, 'XLim',  [0, 100]);
    end

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
         set(gca, 'YLim', [min(allYLim), max(allYLim)]);
         
            [r , p] = corr(this_oa_x_data(:, this_subplot), this_oa_y_data(:, this_subplot));
            r2_oa = r^2;
        coefs_oa = polyfit(this_oa_x_data(:, this_subplot), this_oa_y_data(:, this_subplot), 1);
        fittedX_oa=linspace(0, 3, 100);
        fittedY_oa=polyval(coefs_oa, fittedX_oa);
        
%         [r , p] = corr(this_ya_x_data(:, this_subplot), this_ya_y_data(:, this_subplot));
%             r2_ya = r^2;
%         coefs_ya = polyfit(this_ya_x_data(:, this_subplot), this_ya_y_data(:, this_subplot), 1);
%         fittedX_ya=linspace(0, 3, 100);
%         fittedY_ya=polyval(coefs_ya, fittedX_ya);
%         
        plot(fittedX_oa, fittedY_oa, '-', 'Color','r','LineWidth',1);
%         plot(fittedX_ya, fittedY_ya, '-', 'Color','b','LineWidth',1);
         
              x1 = 0.1;
        y1 = min(allYLim) + min(allYLim) * .25;
        y2 = min(allYLim) + min(allYLim) * .2;  
%         y3 = min(allYLim) + min(allYLim) * .1;
%         y4 = min(allYLim) + min(allYLim) * .05;
        text1 = ['OA r^2 = ' num2str(r2_oa)];
        text2 = ['OA m = ' num2str(coefs_oa(1))];
%         text3 = ['YA r^2 = ' num2str(r2_ya)];
%         text4 = ['YA m = ' num2str(coefs_ya(1))];
%         
        text(x1,y1,text1)
%         text(x1,y2,text2)
%         text(x1,y3,text3)
%         text(x1,y4,text4)
     end
    suptitle('CRUNCH vs Tactile Dual')
    
    
    
       %% Proprio Dual and MI CRUNCH
    figure;
    this_figure_number = 1;
    this_oa_y_data=[];
    this_oa_x_data=[];
    for this_roi_index = 1 : size(oa_crunch.rois_imagery_manual,1)
        for this_oa_subject_index = 1:length(oa_subject_id)
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
            hold on;
            title([oa_crunch.rois_imagery_manual(this_roi_index)])
%             title([oa_crunch.rois_imagery_manual{this_roi_index} 'vs 400m' ])
            
            this_subject_id = oa_subject_id(this_oa_subject_index);
            
            difficulty_spectrum = linspace(0,3,100);

            this_subject_row_sensory_data = find(strcmp(string(walking_data(:,1)), this_subject_id));
            if ~isnan(walking_data(this_subject_row_sensory_data,5))
                this_oa_y_data(this_oa_subject_index, this_roi_index) = walking_data(this_subject_row_sensory_data,5);
                
                this_oa_x_percent = oa_crunchpoint(this_oa_subject_index, this_roi_index);
                this_oa_x_data(this_oa_subject_index, this_roi_index) = difficulty_spectrum(this_oa_x_percent);
                
                plot(this_oa_x_data(this_oa_subject_index, this_roi_index), this_oa_y_data(this_oa_subject_index, this_roi_index), 'o', 'MarkerEdge', 'k', 'MarkerFace', 'r')
            end
        end
%         for this_ya_subject_index = 1:length(ya_subject_id)
%             this_subject_id = ya_subject_id(this_ya_subject_index);
%             
%             this_subject_row_sensory_data = find(strcmp(string(sensory_data(:,1)), this_subject_id));
%             
%             this_ya_y_data(this_ya_subject_index, this_roi_index) = sensory_data(this_subject_row_sensory_data,2);
%             
%             this_ya_x_percent = ya_crunchpoint(this_ya_subject_index, this_roi_index);
%             this_ya_x_data(this_ya_subject_index, this_roi_index) = difficulty_spectrum(this_ya_x_percent);
%             
%             plot(this_ya_x_data(this_ya_subject_index, this_roi_index), this_ya_y_data(this_ya_subject_index, this_roi_index), 'o', 'MarkerEdge', 'k', 'MarkerFace', 'b')
%         end
        this_figure_number = this_figure_number + 1;
    end
    
    allYLim=[];
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
        set(gca, 'XLim', [0 3])
        if this_subplot == 1
%             ylabel(['Brain Activity'], 'FontSize', 32)
        end
        thisYLim = get(gca, 'YLim');
        allYLim = [allYLim thisYLim];
        
%         xtickangle(45)
%         xticks([1 2 3 4])
%         xticklabels({'Flat', 'Low', 'Medium', 'High'})
%         set(gca,'FontSize', 16)
        
        %     set(gca,
        %     set(gca, 'XLim',  [0, 100]);
    end

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
         set(gca, 'YLim', [min(allYLim), max(allYLim)]);
         
            [r , p] = corr(this_oa_x_data(:, this_subplot), this_oa_y_data(:, this_subplot));
            r2_oa = r^2;
        coefs_oa = polyfit(this_oa_x_data(:, this_subplot), this_oa_y_data(:, this_subplot), 1);
        fittedX_oa=linspace(0, 3, 100);
        fittedY_oa=polyval(coefs_oa, fittedX_oa);
        
%         [r , p] = corr(this_ya_x_data(:, this_subplot), this_ya_y_data(:, this_subplot));
%             r2_ya = r^2;
%         coefs_ya = polyfit(this_ya_x_data(:, this_subplot), this_ya_y_data(:, this_subplot), 1);
%         fittedX_ya=linspace(0, 3, 100);
%         fittedY_ya=polyval(coefs_ya, fittedX_ya);
%         
        plot(fittedX_oa, fittedY_oa, '-', 'Color','r','LineWidth',1);
%         plot(fittedX_ya, fittedY_ya, '-', 'Color','b','LineWidth',1);
         
              x1 = 0.1;
        y1 = min(allYLim) + min(allYLim) * .25;
        y2 = min(allYLim) + min(allYLim) * .2;  
%         y3 = min(allYLim) + min(allYLim) * .1;
%         y4 = min(allYLim) + min(allYLim) * .05;
        text1 = ['OA r^2 = ' num2str(r2_oa)];
        text2 = ['OA m = ' num2str(coefs_oa(1))];
%         text3 = ['YA r^2 = ' num2str(r2_ya)];
%         text4 = ['YA m = ' num2str(coefs_ya(1))];
%         
        text(x1,y1,text1)
%         text(x1,y2,text2)
%         text(x1,y3,text3)
%         text(x1,y4,text4)
     end
    suptitle('CRUNCH vs SPPB')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


cd ..
    
end