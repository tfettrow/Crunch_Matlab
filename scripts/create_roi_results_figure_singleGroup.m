% separate long and short figs
average_isi = 1;

% roi_results figure generation
clear,clc
close all
data_path = pwd;

handles.handle_plot = [];
directory_pieces = regexp(data_path,filesep,'split');
levels_back = 1; % assuming only working in ANTS folder atm
subject_level_directory = getfield( directory_pieces, {1:length(directory_pieces)-levels_back} );
  
isi_colors = [250/250 162/250 43/250; 43/250 73/250 222/250];

% find each subject roi_results file
roi_results_file_list = dir('CONmeantsGroupAveragemask_roi_results.txt');

for this_subject_results_file = 1 : length(roi_results_file_list)
%     this_subject_color = rand(1,3);
    %     this_subject_results_file
    fileID = fopen('CONmeantsGroupAveragemask_roi_results.txt')
    data = textscan(fileID,'%s %f', 'Delimiter',',')
%     data = readtable(roi_results_file_list(this_subject_results_file).name);
    %      data = readtable('1002_roi_results.txt');
    
    
    if size(data,2) > 2
        error 'something wrong with results file'
    end
    roi_condition_name = data{1};
    roi_beta_value = data{2};
    
    if strcmp(subject_level_directory{end}, '05_MotorImagery')
        condition_order = {'flat', 'low', 'medium', 'hard'};
    end
    if strcmp(subject_level_directory{end}, '06_Nback')
        condition_order = {'zero', 'one', 'two', 'three'};
    end
    
    for this_roi_index = 1 : length(roi_condition_name)
        roi_condition_name_matrix(this_roi_index,:) = strsplit(roi_condition_name{this_roi_index},'_');
    end
    
    % just preallocating
    ordered_roi_beta_value = [];
    ordered_roi_condition_name_matrix = [];
    unique_rois = unique(roi_condition_name_matrix(:,3));
    for this_unique_roi_index = 1 : length(unique_rois)
        indices_this_roi = find(contains(roi_condition_name_matrix(:, 3), unique_rois{this_unique_roi_index}));
        
        % order the matrix based on condition_order
        % Nback has more columns in roi_condition_name_matrix
        if strcmp(subject_level_directory{end}, '05_MotorImagery')
            [tf, idx] =ismember(condition_order, roi_condition_name_matrix(indices_this_roi, 3))
            this_cond_ordered_roi_beta_value = roi_beta_value(indices_this_roi(1) - 1 + idx);
            ordered_roi_beta_value = [ordered_roi_beta_value this_cond_ordered_roi_beta_value];
            ordered_roi_condition_name_matrix = [ordered_roi_condition_name_matrix; roi_condition_name_matrix(indices_this_roi(1) - 1 + idx, : )];
        end
        if strcmp(subject_level_directory{end}, '06_Nback')
            [tf, idx] =ismember(condition_order, roi_condition_name_matrix(indices_this_roi, 5));
            this_cond_ordered_roi_beta_value = roi_beta_value(indices_this_roi(1) - 1 + [idx idx+length(idx)]); %doubling up the idx to average between long and short unless there is a reason to look at differences between long and short
            ordered_roi_beta_value = [ordered_roi_beta_value this_cond_ordered_roi_beta_value];
            ordered_roi_condition_name_matrix{this_unique_roi_index} = (roi_condition_name_matrix(indices_this_roi(1) - 1 + [idx idx+length(idx)], : ));
        end
    end
    
    this_figure_number = 1;
    isi_options = {'short', 'long'};
    for this_roi_index = 1 : length(unique_rois)
        if strcmp(subject_level_directory{end}, '06_Nback')
            x_label = {};
            y = [];
            x_num = [];
             for this_isi_index = 1 : length(isi_options)
                 this_isi_indices = contains(ordered_roi_condition_name_matrix{this_roi_index}(:,4), isi_options{this_isi_index});
 
             
                x_num = [1 : 4];
                x_label = [ordered_roi_condition_name_matrix{this_roi_index}(this_isi_indices,5)];
                y = [y; ordered_roi_beta_value(this_isi_indices,this_roi_index)'];
             end 
%                  [ha, pos] = tight_subplot(length(unique_rois), length(isi_options),[.01 .03],[.1 .01],[.01 .01])
%                 ha(this_figure_number)
             for this_isi = 1:size(y,1)
                this_isi_color =  isi_colors(this_isi, :);
                subaxis(length(unique_rois),1, this_figure_number, 'SpacingVert',.01,'MR',.1);
%                 subplot(length(unique_rois),1, this_figure_number);
                hold on;

                plot(x_num, y(this_isi,:),'-o', 'MarkerFaceColor', this_isi_color, 'MarkerSize',10)
             end
                xticks([x_num])
                xlim([0 5])
%                 title([unique_rois(this_roi_index)])  %title([unique_rois(this_roi_index) isi_options(this_isi_index)])
                xtickangle(45)
                text(0.5, .15, unique_rois(this_roi_index), 'Units', 'Normalized', 'fontsize', 26);
%                 text(2.25, .1, unique_rois(this_roi_index), 'FontSize', 20)
                set(gca,'xticklabel',x_label', 'FontSize', 26)
                this_figure_number = this_figure_number + 1;
                
                %ax.text(.5,.9,'centered title', horizontalalignment='center', transform=ax.transAxes)
%             end
        end
    end
end

allYLim = [];
for this_subplot = 1 : this_figure_number  - 1
    subaxis(length(unique_rois),1, this_subplot, 'SpacingVert',.01,'MR',.1);
    if this_subplot < this_figure_number - 1
        set(gca,'XTick',[]);
    end
    
    h = findobj(gca,'Type','line');
   	thisYLim = get(gca, 'YLim');
    allYLim = [allYLim thisYLim];
%     x_data_to_fit=get(h,'Xdata');
% %     x_data_to_fit = x_data_to_fit;
%     y_data_to_fit=get(h,'Ydata');
% %     y_data_to_fit = cell2mat(y_data_to_fit);
%     
%     coeffs=polyfit(x_data_to_fit, y_data_to_fit, 2);
%     fittedX=linspace(min(x_num), max(x_num), 100);
%     fittedY=polyval(coeffs, fittedX);
%     
%     
%     plot(fittedX, fittedY, 'Color', 'k','LineWidth',3);

end

for this_subplot = 1 : this_figure_number  - 1
     subaxis(length(unique_rois), 1, this_subplot, 'SpacingVert',.01,'MR',.1);
     set(gca, 'YLim', [min(allYLim), max(allYLim)]);
end
legend('500 ISI','1500 ISI')
% hL = legend('500 ISI','1500 ISI');
% % Programatically move the Legend
% newPosition = [0.75 0.75 0.2 0.2];
% newUnits = 'normalized';
% set(hL,'Position', newPosition,'Units', newUnits);

MaximizeFigureWindow;

% save( 'CONmeants.tiff')