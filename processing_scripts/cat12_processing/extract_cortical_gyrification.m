function extract_cortical_gyrification(varargin)
%  extract_cortical_thickness('roi_settings_filename', 'ROI_settings_CAT12_surface', 'subjects', {'1002','1004','1007','1009','1010','1011','1013','1020','1022','1027','1024','2021','2015','2002','2018','2017','2012','2025','2020','2026','2023','2022','2007','2013','2008','2033','2034','2037','2052','2042','3004','3006','3007','3008'},'group_names',{'YA' 'hOA' 'lOA'},'group_ids',[1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3],'save_figures',0, 'no_labels', 0)
parser = inputParser;
parser.KeepUnmatched = true;
addParameter(parser, 'roi_settings_filename', '')
addParameter(parser, 'subjects', '')
addParameter(parser, 'group_names', '')
addParameter(parser, 'group_ids', '')
addParameter(parser, 'no_labels', 0)
addParameter(parser, 'save_figures', 0)
addParameter(parser, 'save_scores', 0)
parse(parser, varargin{:})
roi_settings_filename = parser.Results.roi_settings_filename;
subjects = parser.Results.subjects;
group_names = parser.Results.group_names;
group_ids = parser.Results.group_ids;
no_labels = parser.Results.no_labels;
save_figures = parser.Results.save_figures;
save_scores = parser.Results.save_scores;
project_path = pwd;
group_color_matrix = distinguishable_colors(length(group_names));
% close all


% go into subject folder, grab the combined thickness file, and for each
% ROI in ROI_surfuace_settings.txt grab the ROI mesh, and extract the
% corresponding subject data (avg) and store in thickness_data


if isempty(roi_settings_filename)
    error('need an roi settings file for this analysis')
end
file_name = roi_settings_filename;

fileID = fopen(file_name, 'r');

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
    settings_cell{i_line} = this_line; %#ok<AGROW>
    
    % remove comments
    if length(this_line) > 1 && any(ismember(this_line, '#'))
        lines_to_prune(i_line) = true;
    end
    
    % flag lines consisting only of white space
    if all(ismember(this_line, ' ') | double(this_line) == 9)
        lines_to_prune(i_line) = true;
    end
    
end
settings_cell(lines_to_prune) = [];

roi_dir = dir([strcat('rois', filesep,'*.gii')]);
clear roi_file_name_list;
[available_roi_file_name_list{1:length(roi_dir)}] = deal(roi_dir.name);

for this_roi_index = 1:length(settings_cell)
    this_roi_settings_line = strsplit(settings_cell{this_roi_index}, ',');
    roi_core_name_cell{this_roi_index} = this_roi_settings_line{1};
    roi_image_cell{this_roi_index} = strtrim(this_roi_settings_line{4});
    split_roi_image = strsplit(roi_image_cell{this_roi_index},'.');
    roi_name_cell{this_roi_index} = split_roi_image{2};
end

for this_subject_index = 1 : length(subjects)
    subject_image = fullfile(project_path, subjects{this_subject_index}, 'Processed', 'MRI_files', '02_T1', 'CAT12_Analysis', 'surf', 's20.mesh.gyrification.resampled_32k.T1.gii');
    surf_headerinfo = spm_data_hdr_read(subject_image);
    surface_file_data = spm_data_read(spm_data_hdr_read(subject_image)); %,'xyz',1 ;
    
    for this_roi_index = 1:length(roi_image_cell)
        this_roi_file = roi_image_cell{this_roi_index};
        roi_image = strcat('\\exasmb.rc.ufl.edu\blue\rachaelseidler\share\FromExternal\Research_Projects_UF\CRUNCH\MiM_Data\ROIs\',this_roi_file,'.gii');
        
        roi_headerinfo = spm_data_hdr_read(roi_image);
        roi_file_data = spm_data_read(spm_data_hdr_read(roi_image)); %,'xyz',1;
        
        thickness_results(this_subject_index,this_roi_index) = nanmean(surface_file_data(find(roi_file_data)));
    end
end


for this_roi_index = 1: length(roi_image_cell)
    figure; hold on
%     subplot(1, length(roi_network_cell), this_roi_index); hold on;
    for this_group_index = 1 : length(group_names)
        this_group_subjectindices = find(group_ids==this_group_index);
        this_group_and_roi_vol_results = thickness_results(this_group_subjectindices,this_roi_index);

        
        singleBoxPlot(this_group_and_roi_vol_results,'abscissa', this_group_index, 'EdgeColor',group_color_matrix(this_group_index,:), 'MarkerColor',group_color_matrix(this_group_index,:),'WiskColor',group_color_matrix(this_group_index,:), 'MeanColor',group_color_matrix(this_group_index,:), 'EdgeLinewidth', 1, 'WiskLinewidth', 1, 'MeanLinewidth', 1 )
           
%         bar(this_group_index, mean(this_group_and_roi_vol_results),'facecolor',group_color_matrix(:,this_group_index))
%         errorbar(this_group_index, mean(this_group_and_roi_vol_results), std(this_group_and_roi_vol_results)/nnz(this_group_subjectindices), 'k'); hold on;
        
        %         boxplot(this_group_and_roi_vol_results, this_group_index);
    end
    xlim([ 0 length(group_names)+1])
    title(roi_name_cell{this_roi_index},'interpreter','latex')
    xlim([0 length(group_names)+1])
%     ylim([0 1])
    ylabel('Avg Cortical Gyrification (?)')
    set(gca,'XTick',1:length(group_names),'xticklabel',{'YA','high-OA','low-OA'},'TickLabelInterpreter','none')
    xtickangle(45)
    set(gcf, 'ToolBar', 'none');
    set(gcf, 'MenuBar', 'none');
    if no_labels
        set(get(gca, 'xlabel'), 'visible', 'off');
        set(get(gca, 'ylabel'), 'visible', 'off');
        set(get(gca, 'title'), 'visible', 'off');
        legend(gca, 'hide');
    end
    if save_figures
        fig_title = ['gyrification_' roi_name_cell{this_roi_index}];
        filename =  fullfile(project_path, 'figures', fig_title);
        saveas(gca, filename, 'tiff')
    end
end
if save_scores
   subject_table = array2table(subjects');
   subject_table.Properties.VariableNames = {'subject_ids'};
   
%    group_table = array2table(group_ids');
%    group_table.Properties.VariableNames = {'group_ids'};
   
   surf_cell_table = array2table(thickness_results);
   surf_cell_table.Properties.VariableNames = roi_name_cell;
   
%    vol_results_table = [subject_table, vol_cell_table, group_table];
   surf_results_table = [subject_table, surf_cell_table];
   
   writetable(surf_results_table,fullfile(project_path,'spreadsheet_data','surfGyrification_score.csv'))
end







% 
% 
% 
% 
% 
% 
% for this_subject_index = 1 : length(subjects)
%     subj_results_dir = fullfile(project_path, subjects{this_subject_index}, 'Processed', 'MRI_files', task_folder, 'CAT12_Analysis', 'surf', 's15.mesh.thickness.resampled_32k.T1.gii'));
%     
%     fileID = fopen(subj_results_dir);
%     
%     data = textscan(fileID,'%s','delimiter',',','headerlines',0);
%     data = reshape(data{:},length(data{1})/2,2);
%     for this_beta = 3:length(data)
%         split_condition_name = strsplit(data{this_beta,1},'_');
%         % WARNING: reading roi names and overwriting (per subject) may be
%         % an issue if different subjs have different roi results files...
%         % need to write a buffer for this..
%         roi_names{this_beta-2} = data{this_beta,1};
%         vol_results(this_subject_index,this_beta-2) = str2num(data{this_beta,2});
%     end
% 
% end
% 

% for this_roi_index = 1: length(roi_names)
%     subplot(1, 3, this_roi_index); hold on;
%     for this_group_index = 1 : length(group_names)
%         this_group_subjectindices = find(group_ids==this_group_index);
%         this_group_and_roi_vol_results = vol_results(this_group_subjectindices,this_roi_index);
% 
%         
%         singleBoxPlot(this_group_and_roi_vol_results,'abscissa', this_group_index, 'EdgeColor',group_color_matrix(this_group_index,:), 'MarkerColor',group_color_matrix(this_group_index,:),'WiskColor',group_color_matrix(this_group_index,:), 'MeanColor',group_color_matrix(:,this_group_index), 'EdgeLinewidth', 1, 'WiskLinewidth', 1, 'MeanLinewidth', 1 )
%            
% %         bar(this_group_index, mean(this_group_and_roi_vol_results),'facecolor',group_color_matrix(:,this_group_index))
% %         errorbar(this_group_index, mean(this_group_and_roi_vol_results), std(this_group_and_roi_vol_results)/nnz(this_group_subjectindices), 'k'); hold on;
%         
%         %         boxplot(this_group_and_roi_vol_results, this_group_index);
%     end
%     xlim([ 0 length(this_group_index+1)])
%     title([roi_names(this_roi_index)],'interpreter','latex')
%     xlim([0 length(group_names)+1])
%     ylim([0 1])
%     ylabel('Grey Matter Volume/Intensity')
%     set(gca,'XTick',1:length(group_names),'xticklabel',{'YA','high-OA','low-OA'},'TickLabelInterpreter','none')
%     xtickangle(45)
%     set(gcf, 'ToolBar', 'none');
%     set(gcf, 'MenuBar', 'none');
%     if no_labels
%         set(get(gca, 'xlabel'), 'visible', 'off');
%         set(get(gca, 'ylabel'), 'visible', 'off');
%         set(get(gca, 'title'), 'visible', 'off');
%         legend(gca, 'hide');
%     end
%     if save_figures
%         fig_title = 'groups_roi_gmv';
%         filename =  fullfile(project_path, 'figures', fig_title);
%         saveas(gca, filename, 'tiff')
%     end
% end
% if save_scores
%    subject_table = array2table(subjects');
%    subject_table.Properties.VariableNames = {'subject_ids'};
%    
% %    group_table = array2table(group_ids');
% %    group_table.Properties.VariableNames = {'group_ids'};
%    
%    vol_cell_table = array2table(vol_results);
%    vol_cell_table.Properties.VariableNames = roi_names;
%    
% %    vol_results_table = [subject_table, vol_cell_table, group_table];
%    vol_results_table = [subject_table, vol_cell_table];
%    
%    writetable(vol_results_table,fullfile(project_path,'spreadsheet_data','vol_score.csv'))
% end
% 




%% Legacy attempts at extract surface data
% this_contrast_data = spm_vol(template);
% 
% a = ind2sub(this_contrast_data.dim(1),this_contrast_data.dim(2),this_contrast_data.dim(3))
% 
% this_roi_vox_coord = [roi_x roi_y roi_z 1] * this_contrast_data.mat';
% 
% 
% ordered_intensity_vector = spm_data_read(spm_data_hdr_read(fullfile(data_dir,surf_image)));
% 
% somethin = gifti(fullfile(data_dir,surf_image))
% 
% 
% H.S{ind}.M = gifti(H.S{ind}.info(1).Pmesh);            
%         % get adjacency information
%         H.S{ind}.A = spm_mesh_adjacency(H.S{ind}.M);
%         
%         g1 = gifti(fullfile(spm('dir'), 'toolbox', 'cat12', ['templates_surfaces' H.str32k], [H.S{i}.info(1).side '.mc.freesurfer.gii']));
%         
%         % first entries are atlases
% plot_mean = H.cursor_mode - 5;
% pos = get(evt, 'Position');
% 
% i = ismember(get(H.patch(1), 'vertices'), pos, 'rows');
% node = find(i);
% ind = 1;
% node_list = 1:numel(get(H.patch(1), 'vertices'));


% 
% 
% roi_name = strtrim(roi_name);
% 
% roi_x = str2num(roi_x);
% roi_y = str2num(roi_y);
% roi_z = str2num(roi_z);
% 
% this_contrast_data = spm_vol(surf_image);
% 
% this_roi_vox_coord = [roi_x roi_y roi_z 1] / ordered_intensity_vector.mat' -1;
% this_roi_vox_coord1 = this_roi_vox_coord(1);
% this_roi_vox_coord2 = this_roi_vox_coord(2);
% this_roi_vox_coord3 = this_roi_vox_coord(3);


% OR 
% roi_name = strtrim(roi_name);
% 
% roi_x = str2num(roi_x);
% roi_y = str2num(roi_y);
% roi_z = str2num(roi_z);
% 
% this_contrast_data = spm_vol('MNI_2mm.nii');
% 
% this_roi_vox_coord = [roi_x roi_y roi_z 1] * this_contrast_data.mat';
% this_roi_vox_coord1 = this_roi_vox_coord(1);
% this_roi_vox_coord2 = this_roi_vox_coord(2);
% this_roi_vox_coord3 = this_roi_vox_coord(3);
    

% Y = SPM.xX.X * SPM.xCon(Ic).c * pinv(SPM.xCon(Ic).c) * beta;

% get raw data and whiten
% y = spm_data_read(SPM.xY.VY, 'xyz', XYZ);

%   y = cat_stat_nanmean(y, 2);



end