
% roi_results figure generation
clear,clc
close all

task={'05_MotorImagery'};                            
population={'youngAdult', 'oldAdult'};
% rois_of_interest={'anterior_cingulate', 'caudate', 'inferior_parietal_lobule', 'insula_1', 'insula_2', 'mid_frontal_gyrus_1','mid_frontal_gyrus_2','mid_frontal_gyrus_3','parahippocampal_1','precentral_gyrus','precuneus','subcallosal_gyrus','sup_frontal_gyrus','sup_temporal_gyrus','superior_parietal_lobule_1'}
rois_of_interest={'caudate',  'insula_1', 'insula_2', 'mid_frontal_gyrus_2','mid_frontal_gyrus_3','parahippocampal_1','precentral_gyrus','precuneus','subcallosal_gyrus','sup_temporal_gyrus',}
% rois_of_interest={'Lprecuneus1','Rcalcarine','LmidOcc','Lprecent','LsupFrontalMed','Lputamen','LsuppMotor','Rangular','Rinsula','RrolandicOper'};
create_corr_table=0;

subplot_row = 2;
subplot_col = 5;

%% TO DO ::: Setup for loop for each task/group???XXXX %%%
% seperate=1;

roi_type = 'manual';
extraction_type='voxel';
% extraction_type='WFU';
% extraction_type='Network';

no_labels = 0;

% roi_type = '5sig';

data_path = pwd;

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
    
    oa_color = [160/255 32/255 240/255];
    ya_color = [0 1 0];
    this_figure_number = 1;
    if any(strcmp(task, '05_MotorImagery'))
        for this_roi = rois_of_interest
            subplot(subplot_row, subplot_col, this_figure_number);
            this_oa_roi_index = find(strcmp(oa_crunch.rois_imagery_manual,this_roi));
            this_oa_roi_betas = oa_crunch.beta_matrix_imagery_manual(:,:,this_oa_roi_index);
            oa_average_activation_betas = mean(this_oa_roi_betas,2);
            
            this_ya_roi_index = find(strcmp(ya_crunch.rois_imagery_manual,this_roi));
            this_ya_roi_betas = ya_crunch.beta_matrix_imagery_manual(:,:,this_ya_roi_index);
            ya_average_activation_betas = mean(this_ya_roi_betas,2);
            
            bar(1:length(oa_average_activation_betas), oa_average_activation_betas, 'FaceColor', oa_color); hold on;
            bar(length(oa_average_activation_betas)+1:length(oa_average_activation_betas)+length(ya_average_activation_betas), ya_average_activation_betas, 'FaceColor', ya_color);
             title([oa_crunch.rois_imagery_manual(this_oa_roi_index)])
              set(gca,'XTick',[]);
            this_figure_number = this_figure_number + 1;
        end
    end
    
    if create_corr_table
        this_x_var_index = 2;
        for this_roi_x = rois_of_interest
            this_y_var_index = 2;
            for this_roi_y = rois_of_interest
                if ~strcmp(this_roi_x, this_roi_y)
                    
                    this_oa_roi_x_index = find(strcmp(oa_crunch.rois_imagery_manual,this_roi_x));
                    this_oa_roi_x_betas = oa_crunch.beta_matrix_imagery_manual(:,:,this_oa_roi_x_index);
                    this_oa_roi_x_avg_betas = mean(this_oa_roi_x_betas,2);
                    
                    this_oa_roi_y_index = find(strcmp(oa_crunch.rois_imagery_manual,this_roi_y));
                    this_oa_roi_y_betas = oa_crunch.beta_matrix_imagery_manual(:,:,this_oa_roi_y_index);
                    this_oa_roi_y_avg_betas = mean(this_oa_roi_y_betas,2);
                     
                    [r , p] = corr(this_oa_roi_x_avg_betas, this_oa_roi_y_avg_betas);
                    this_roi_table_ylabels(this_x_var_index,1) = this_roi_x;
                    this_roi_table_xlabels(1,this_y_var_index) = this_roi_y;
                    this_roi_table_betas(this_x_var_index, this_y_var_index) = r;
                end
                 this_y_var_index=this_y_var_index+1; 
            end
            this_x_var_index=this_x_var_index+1;
        end
        T=array2table(this_roi_table_betas(2:end,2:end), 'VariableNames', this_roi_table_ylabels(2:end), 'RowNames', this_roi_table_xlabels(2:end));
        writetable(T,'Roi2RoiCorrelations.xlsx')

    end
end