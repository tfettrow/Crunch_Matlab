
% roi_results figure generation
clear,clc
% close all

task={'05_MotorImagery'};  
%% TO DO ::: Setup for loop for each task/group???XXXX %%%

roi_type = 'manual';
extraction_type='voxel';
% extraction_type='WFU';
% extraction_type='Network';
% roi_type = '5sig';

population = 'oldAdult';
%  population = 'youngAdult';

no_labels = 0;

data_path = pwd;

handles.handle_plot = [];
directory_pieces = regexp(data_path,filesep,'split');
levels_back = 1; % assuming only working in ANTS folder atm
subject_level_directory = getfield( directory_pieces, {1:length(directory_pieces)-levels_back} );

if any(strcmp(task, '05_MotorImagery'))
    cd 05_MotorImagery
    cd( population )
    
    % find each subject roi_results file
    if strcmp(roi_type,'manual')
        if strcmp(extraction_type,'voxel')
            roi_results_file_list = dir('*_roi_results.txt');
        elseif strcmp(extraction_type,'WFU')
            roi_results_file_list = dir('*meantsWFUROI_roi_results.txt');
        elseif strcmp(extraction_type, 'Network')
            roi_results_file_list = dir('*meantsNetworkROI_roi_results.txt');
        end
    elseif strcmp(roi_type,'5sig')
        roi_results_file_list = dir('*CONmeants5mm_roi_results.txt');
    end
    
    subject_color_matrix = distinguishable_colors(length(roi_results_file_list));
    
    for this_subject_index = 1 : length(roi_results_file_list)
        
        fileID = fopen(roi_results_file_list(this_subject_index).name);
        
        split_filename = strsplit(roi_results_file_list(this_subject_index).name,'_');
        subject_id_imagery{this_subject_index}  = split_filename{1};
        
        data = textscan(fileID,'%s %s %f', 'Delimiter',',');
        
%         if size(data,2) > 2
%             error 'something wrong with results file'
%         end
        roi_condition_name = data{2};
        rois_names = data{1};
        roi_beta_value = data{3};
        
        %     if strcmp(subject_level_directory{end}, '05_MotorImagery')
        condition_order = {'flat', 'low', 'medium', 'high'};
        %     end
        
        for this_roi_index = 1 : length(roi_condition_name)
            roi_condition_name_matrix(this_roi_index,:) = strsplit(roi_condition_name{this_roi_index},'_');
        end
        
        % just preallocating
        ordered_roi_beta_value = [];
        ordered_roi_condition_name_matrix = [];
        unique_rois = unique(rois_names);
        unique_rois = unique_rois(1:end-1);
        for this_unique_roi_index = 1 : length(unique_rois)
            indices_this_roi = find(contains(rois_names, unique_rois{this_unique_roi_index}));
            
            % order the matrix based on condition_order
            % Nback has more columns in roi_condition_name_matrix
            %         if strcmp(subject_level_directory{end}, '05_MotorImagery')
            [tf, idx] =ismember(condition_order, roi_condition_name_matrix(indices_this_roi));
            this_cond_ordered_roi_beta_value = roi_beta_value(indices_this_roi(1) - 1 + idx);
            ordered_roi_beta_value = [ordered_roi_beta_value this_cond_ordered_roi_beta_value];
            ordered_roi_condition_name_matrix = [ordered_roi_condition_name_matrix; roi_condition_name_matrix(indices_this_roi(1) - 1 + idx, : )];
            %         end
        end
        
        this_figure_number = 1;
        for this_roi_index = 1 : length(unique_rois)
            %         if strcmp(subject_level_directory{end}, '05_MotorImagery')
            
            x_num = [1 : 4];
            starting_index_for_this_roi = this_roi_index * 4 - 3;
            x_label = {'flat', 'low', 'medium', 'high'};
            y = ordered_roi_beta_value(:,this_roi_index)';
            
            if length(unique_rois)<=6
                subplot(1, 6, this_figure_number);
            elseif length(unique_rois)>6 & length(unique_rois)<=12
                subplot(2, 6, this_figure_number);
            elseif length(unique_rois)>12 & length(unique_rois)<=18
                subplot(3, 6, this_figure_number);
            elseif length(unique_rois)>18 & length(unique_rois)<=24
                subplot(4, 6, this_figure_number);
            elseif length(unique_rois)>24 & length(unique_rois)<=30
                subplot(5, 6, this_figure_number);
            end
            
            hold on;
            
            plot(x_num, y,'o', 'MarkerFaceColor', subject_color_matrix(this_subject_index, :), 'MarkerEdgeColor', subject_color_matrix(this_subject_index, :), 'MarkerSize', 3)
            
            xticks([x_num])
            xlim([0 5])
            title([unique_rois(this_roi_index)])
            xtickangle(45)
            set(gca,'xticklabel',x_label', 'FontSize', 16)
            %             xlabel('Motor Imagery Condition')
            coeffs=polyfit(x_num, y, 2);
            
            fittedX=linspace(min(x_num), max(x_num), 100);
            fittedY=polyval(coeffs, fittedX);
            
            crunch_point = max(fittedY);
            
            plot(fittedX, fittedY, '--', 'Color', subject_color_matrix(this_subject_index, :),'LineWidth',1);
            
            [crunchpoint_y, crunchpoint_percent] = max(fittedY);
            
            crunchpoint_matrix_imagery(this_subject_index, this_roi_index) = crunchpoint_percent;
            
            if strcmp(roi_type,'manual')
                crunchpoint_matrix_imagery_manual(this_subject_index, this_roi_index) = crunchpoint_percent;
                beta_matrix_imagery_manual(this_subject_index,:, this_roi_index) = y;
                rois_imagery_manual = unique_rois;
            elseif strcmp(roi_type,'5sig')
                crunchpoint_matrix_imagery_5sig(this_subject_index, this_roi_index) = crunchpoint_percent;
                beta_matrix_imagery_5sig(this_subject_index, :, this_roi_index) = y;
                rois_imagery_5sig = unique_rois;
            end
            
            scatter(fittedX(crunchpoint_percent), fittedY(crunchpoint_percent), 100,  'o', 'MarkerFaceColor',  subject_color_matrix(this_subject_index, :), 'MarkerEdgeColor', subject_color_matrix(this_subject_index, :), 'MarkerFaceAlpha',3/8); % 'MarkerSize', 12,
            this_figure_number = this_figure_number + 1;
            %            ax = gca;
            %             ax.FontSize = 16;
            ylabel('beta value', 'FontSize', 32)
            %             set(gca,'yticklabel', 'FontSize', 16)
            %         end
        end
    end
    
    
    allYLim = [];
    for this_subplot = 1 : this_figure_number  - 1
        %     if strcmp(subject_level_directory{end}, '05_MotorImagery')
        if length(unique_rois)<=6
            subplot(1, 6, this_subplot);
        elseif length(unique_rois)>6 & length(unique_rois)<=12
            subplot(2, 6, this_subplot);
        elseif length(unique_rois)>12 & length(unique_rois)<=18
            subplot(3, 6, this_subplot);
        elseif length(unique_rois)>18 & length(unique_rois)<=24
            subplot(4, 6, this_subplot);
        elseif length(unique_rois)>24 & length(unique_rois)<=30
            subplot(5, 6, this_subplot);
        end
        
        %         if this_subplot < this_figure_number - 1
        if this_subplot > 1
            ylabel([])
        end
        if this_subplot <= 24
            set(gca,'XTick',[]);
        end
        %     end
        h = findobj(gca,'Type','line');
        thisYLim = get(gca, 'YLim');
        allYLim = [allYLim thisYLim];
    end
    
    for this_subplot = 1 : this_figure_number  - 1
        %     if strcmp(subject_level_directory{end}, '05_MotorImagery')
        if length(unique_rois)<=6
            subplot(1, 6, this_subplot);
        elseif length(unique_rois)>6 & length(unique_rois)<=12
            subplot(2, 6, this_subplot);
        elseif length(unique_rois)>12 & length(unique_rois)<=18
            subplot(3, 6, this_subplot);
        elseif length(unique_rois)>18 & length(unique_rois)<=24
            subplot(4, 6, this_subplot);
        elseif length(unique_rois)>24 & length(unique_rois)<=30
            subplot(5, 6, this_subplot);
        end
        %     end
%         set(gca, 'YLim', [min(allYLim), max(allYLim)]);
    end
    
    if no_labels
        for this_subplot = 1 : this_figure_number  - 1
            if length(unique_rois)<=6
                subplot(1, 6, this_subplot);
            elseif length(unique_rois)>6 & length(unique_rois)<=12
                subplot(2, 6, this_subplot);
            elseif length(unique_rois)>12 & length(unique_rois)<=18
                subplot(3, 6, this_subplot);
            elseif length(unique_rois)>18 & length(unique_rois)<=24
                subplot(4, 6, this_subplot);
            elseif length(unique_rois)>24 & length(unique_rois)<=30
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
% MaximizeFigureWindow;
%
% legend_cell={};
% for this_subject = 1 : length(roi_results_file_list)
%     legend_cell = [legend_cell strcat('Subject ', num2str(this_subject))];
% end
% legend(legend_cell)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555 nback starts

cd ..
cd ..

if any(strcmp(task, '06_Nback'))
    
    cd 06_Nback
    cd( population )
    
    figure;
    % find each subject roi_results file
    if strcmp(roi_type,'manual')
        if strcmp(extraction_type,'voxel')
            roi_results_file_list = dir('*meants5mmManEnteredROI_roi_results.txt');
        elseif strcmp(extraction_type,'WFU')
            roi_results_file_list = dir('*meantsWFUROI_roi_results.txt');
        elseif strcmp(extraction_type, 'Network')
            roi_results_file_list = dir('*meantsNetworkROI_roi_results.txt');
        end
    end
    
    for this_subject_index = 1 : length(roi_results_file_list)
        %     this_subject_color = rand(1,3);
        
        fileID = fopen(roi_results_file_list(this_subject_index).name);
        
        split_filename = strsplit(roi_results_file_list(this_subject_index).name,'_');
        subject_id_nback{this_subject_index}  = split_filename{1};
        
        data = textscan(fileID,'%s %f', 'Delimiter',',');
        
        if size(data,2) > 2
            error 'something wrong with results file'
        end
        roi_beta_value = data{2};
        roi_condition_name = data{1}(1:length(roi_beta_value));
        
        
        %     if strcmp(subject_level_directory{end}, '06_Nback')
        condition_order = {'zero', 'one', 'two', 'three'};
        %     end
        
        roi_condition_name_matrix = {};
        %     if length(roi_condition_name)
        %         length(roi_condition_name)
        %     else
        
        %     end
        for this_roi_index = 1 : length(roi_condition_name)
            roi_condition_name_matrix(this_roi_index,:) = strsplit(roi_condition_name{this_roi_index},'_');
        end
        
        % just preallocating
        ordered_roi_beta_value = [];
        ordered_roi_condition_name_matrix = [];
        unique_rois = unique(roi_condition_name_matrix(:,2));
        for this_unique_roi_index = 1 : length(unique_rois)
            indices_this_roi = find(contains(roi_condition_name_matrix(:, 2), unique_rois{this_unique_roi_index}));
            
            % order the matrix based on condition_order
            % Nback has more columns in roi_condition_name_matrix
            
            %         if strcmp(subject_level_directory{end}, '06_Nback')
            %             [tf, idx] =ismember(condition_order, roi_condition_name_matrix(indices_this_roi, 4));
            
            [tf, idx] =ismember(condition_order, roi_condition_name_matrix(indices_this_roi, 3));
            this_cond_ordered_roi_beta_value = roi_beta_value(indices_this_roi(1) - 1 + idx);
            ordered_roi_beta_value = [ordered_roi_beta_value this_cond_ordered_roi_beta_value];
            ordered_roi_condition_name_matrix = [ordered_roi_condition_name_matrix; roi_condition_name_matrix(indices_this_roi(1) - 1 + idx, : )];
            %
            %              [tf, idx] =ismember(condition_order, roi_condition_name_matrix(indices_this_roi, 3))
            %             this_cond_ordered_roi_beta_value = roi_beta_value(indices_this_roi(1) - 1 + [idx idx+length(idx)]); %doubling up the idx to average between long and short unless there is a reason to look at differences between long and short
            %             ordered_roi_beta_value = [ordered_roi_beta_value this_cond_ordered_roi_beta_value];
            %             ordered_roi_condition_name_matrix{this_unique_roi_index} = (roi_condition_name_matrix(indices_this_roi(1) - 1 + [idx idx+length(idx)], : ));
            %         end
        end
        
        this_figure_number = 1;
        %     isi_options = {'short','long'};
        for this_roi_index = 1 : length(unique_rois)
            %         if strcmp(subject_level_directory{end}, '06_Nback')
            %             for this_isi_index = 1 : length(isi_options)
            
            %                 this_isi_indices = contains(ordered_roi_condition_name_matrix{this_roi_index}(:,3), isi_options(this_isi_index));
            
            starting_index_for_this_roi = this_roi_index * 4 - 3;
            x_label = ordered_roi_condition_name_matrix(starting_index_for_this_roi:starting_index_for_this_roi+3, 3);
            y = ordered_roi_beta_value(:,this_roi_index)';
            
            
            x_num = [1 : 4];
            %                 x_num = [1 : sum(this_isi_indices)];
            %                 x_label = ordered_roi_condition_name_matrix{this_roi_index}(this_isi_indices,4);
            %                 x_label = ordered_roi_condition_name_matrix{this_roi_index,3};
            x_label = {'zero'; 'one'; 'two'; 'three'}
            
            %                 subplot(length(unique_rois), length(isi_options), this_figure_number);
            
            subplot(1, length(unique_rois), this_figure_number);
            
            hold on;
            % y
            if any(y <-50) || any(y > 50)
                % do nothing
                a =1;
            else
                plot(x_num, y,'o', 'MarkerFaceColor', subject_color_matrix(this_subject_index, :), 'MarkerEdgeColor', subject_color_matrix(this_subject_index, :), 'MarkerSize', 3)
                
                
                xticks([x_num])
                xlim([0 5])
                title([unique_rois(this_roi_index)])
                xtickangle(45)
                set(gca,'xticklabel',x_label', 'FontSize', 16)
                %                     xlabel('N-Back Condition', 'FontSize', 30)
                
                coeffs=polyfit(x_num, y, 2);
                
                fittedX=linspace(min(x_num), max(x_num), 100);
                fittedY=polyval(coeffs, fittedX);
                
                crunch_point = max(fittedY);
                
                plot(fittedX, fittedY, '--', 'Color', subject_color_matrix(this_subject_index, :),'LineWidth',1);
                
                [crunchpoint, crunchpoint_percent] = max(fittedY);
                crunchpoint_matrix_nback(this_subject_index, this_roi_index) = crunchpoint_percent;
                if strcmp(roi_type,'manual')
                    crunchpoint_matrix_nback_manual(this_subject_index, this_roi_index) = crunchpoint_percent;
                    beta_matrix_nback_manual(this_subject_index,:, this_roi_index) = y;
                    rois_nback_manual = unique_rois;
                elseif strcmp(roi_type,'5sig')
                    crunchpoint_matrix_nback_5sig(this_subject_index, this_roi_index) = crunchpoint_percent;
                    beta_matrix_nback_5sig(this_subject_index,:, this_roi_index) = y;
                    rois_nback_5sig = unique_rois;
                end
                
                scatter(fittedX(crunchpoint_percent), fittedY(crunchpoint_percent), 100,  'o', 'MarkerFaceColor',  subject_color_matrix(this_subject_index, :), 'MarkerEdgeColor', subject_color_matrix(this_subject_index, :), 'MarkerFaceAlpha',3/8); % 'MarkerSize', 12,
            end
            this_figure_number = this_figure_number + 1;
            ylabel('brain activity', 'FontSize', 32)
            %                 set(gca,'yticklabel', 'FontSize', 16)
            
            %         end
        end
    end
    
    allYLim = [];
    for this_subplot = 1 : this_figure_number  - 1
        %     if strcmp(subject_level_directory{end}, '06_Nback')
        subplot(1, length(unique_rois), this_subplot);
        
        %         if this_subplot < this_figure_number - 1
        if this_subplot > 1
            %             set(gca,'XTick',[]);
            ylabel([])
        end
        %     end
        h = findobj(gca,'Type','line');
        thisYLim = get(gca, 'YLim');
        allYLim = [allYLim thisYLim];
    end
    
    for this_subplot = 1 : this_figure_number  - 1
        %     if strcmp(subject_level_directory{end}, '06_Nback')
        subplot(1, length(unique_rois), this_subplot);
        %     end
        set(gca, 'YLim', [min(allYLim), max(allYLim)]);
    end
    
    if no_labels
        for this_subplot = 1 : this_figure_number  - 1
            subplot(1, length(unique_rois), this_subplot);
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

% cd ..
% cd ..

if strcmp(roi_type,'manual')
    if strcmp(population, 'youngAdult')
        if strcmp(extraction_type,'voxel')
            save('youngAdult_crunch_voxel', 'subject_id_imagery', 'crunchpoint_matrix_imagery_manual', 'rois_imagery_manual', 'beta_matrix_imagery_manual'); %'subject_id_nback', 'crunchpoint_matrix_nback_manual', 'rois_nback_manual', 'beta_matrix_nback_manual'
        elseif strcmp(extraction_type,'WFU')
            save('youngAdult_crunch_wfu', 'subject_id_imagery', 'subject_id_nback', 'crunchpoint_matrix_imagery_manual', 'rois_imagery_manual', 'beta_matrix_imagery_manual', 'crunchpoint_matrix_nback_manual', 'rois_nback_manual', 'beta_matrix_nback_manual');
        elseif strcmp(extraction_type, 'Network')
            save('youngAdult_crunch_network', 'subject_id_imagery', 'subject_id_nback', 'crunchpoint_matrix_imagery_manual', 'rois_imagery_manual', 'beta_matrix_imagery_manual', 'crunchpoint_matrix_nback_manual', 'rois_nback_manual', 'beta_matrix_nback_manual');
        end
    elseif strcmp(population, 'oldAdult')
        if strcmp(extraction_type,'voxel')
            save('oldAdult_crunch_voxel', 'subject_id_imagery', 'crunchpoint_matrix_imagery_manual', 'rois_imagery_manual', 'beta_matrix_imagery_manual'); %'subject_id_nback', 'crunchpoint_matrix_nback_manual', 'rois_nback_manual', 'beta_matrix_nback_manual'
        elseif strcmp(extraction_type,'WFU')
            save('oldAdult_crunch_wfu', 'subject_id_imagery', 'subject_id_nback', 'crunchpoint_matrix_imagery_manual', 'rois_imagery_manual', 'beta_matrix_imagery_manual', 'crunchpoint_matrix_nback_manual', 'rois_nback_manual', 'beta_matrix_nback_manual');
        elseif strcmp(extraction_type, 'Network')
            save('oldAdult_crunch_network', 'subject_id_imagery', 'subject_id_nback', 'crunchpoint_matrix_imagery_manual', 'rois_imagery_manual', 'beta_matrix_imagery_manual', 'crunchpoint_matrix_nback_manual', 'rois_nback_manual', 'beta_matrix_nback_manual');
        end
    end
elseif strcmp(roi_type,'5sig')
    if strcmp(population, 'youngAdult')
        save('youngAdult_crunch_5sig', 'subject_id_imagery', 'subject_id_nback', 'crunchpoint_matrix_imagery_5sig', 'rois_imagery_5sig', 'beta_matrix_imagery_5sig', 'crunchpoint_matrix_nback_5sig',  'rois_nback_5sig', 'beta_matrix_nback_5sig');
    elseif strcmp(population, 'oldAdult')
        save('oldAdult_crunch_5sig', 'subject_id_imagery', 'subject_id_nback', 'crunchpoint_matrix_imagery_5sig', 'rois_imagery_5sig', 'beta_matrix_imagery_5sig', 'crunchpoint_matrix_nback_5sig',  'rois_nback_5sig', 'beta_matrix_nback_5sig');
    end
end


% legend_cell={};
% for this_subject = 1 : length(roi_results_file_list)
%     legend_cell = [legend_cell strcat('Subject ', num2str(this_subject))];
% end
% legend(legend_cell)

