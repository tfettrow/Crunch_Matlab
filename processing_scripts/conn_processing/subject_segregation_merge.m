% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

function subject_segregation_merge(varargin)
close all
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'conn_project_name', 'conn_SSROIs_SS_wb_23Apr30')
addParameter(parser, 'cb_project_name', 'conn_SSROIs_SS_cb_23Apr30')
addParameter(parser, 'outfile','SS_merge_17Apr23')
%addParameter(parser, 'roi_settings_filename', 'ROI_settings_conn_wu120_all_wb_cb.txt')
addParameter(parser, 'roi_settings_filename', 'ROI_settings_conn_SS.txt')
addParameter(parser, 'seed_names', {'left_hand', 'left_op2', 'medial_prefrontal_cortex_post_cingulate',...
    'right_hand','right_op2','visual_cortex','left_dlpfc','right_dlpfc','left_acc','right_acc'}) 
addParameter(parser, 'group_names', '')
addParameter(parser, 'group_ids', '')
addParameter(parser, 'no_labels', 0)
addParameter(parser, 'separate_groups', 0)
addParameter(parser, 'plot_figures', 0)
addParameter(parser, 'save_figures', 0)
addParameter(parser, 'export_figures', 0)
addParameter(parser, 'correlate_outcomes', 0)
addParameter(parser, 'save_scores', 1)
addParameter(parser, 'save_mim_scores', 0)
parse(parser, varargin{:})
conn_project_name = parser.Results.conn_project_name;
cb_project_name = parser.Results.cb_project_name;
roi_settings_filename = parser.Results.roi_settings_filename;
separate_groups = parser.Results.separate_groups;
plot_figures = parser.Results.plot_figures;
seed_names = parser.Results.seed_names;
save_figures = parser.Results.save_figures;
export_figures = parser.Results.export_figures;
correlate_outcomes = parser.Results.correlate_outcomes;
no_labels = parser.Results.no_labels;
save_scores = parser.Results.save_scores;
save_mim_scores = parser.Results.save_mim_scores;
outfile=parser.Results.outfile;

load([conn_project_name filesep 'subject_ids'])

project_path = pwd;
%%%%%
data_path = pwd;

seed_to_network_map = {'left_hand', 'left_op2', 'medial_prefrontal_cortex_post_cingulate','right_hand','right_op2','visual_cortex','left_dlpfc','right_dlpfc','left_acc','right_acc' ; ...
    'Left Hand', 'Left Vestibular','Default', 'Right Hand', 'Right Vestibular', 'Visual','Left DLPFC', 'Right DLPFC', 'Left ACC', 'Right ACC'};

% seed_to_network_map = {'left_hand','medial_prefrontal_cortex_post_cingulate','right_mouth','left_aud_cortex','right_post_ips','left_insular','dACC','visual_cortex','left_dlpfc','right_dlpfc','left_acc','right_acc','left_ips','left_op2' ; ...
%     'Hand','Default', 'Mouth', 'Auditory', 'DAN', 'Salience', 'CinguloOperc', 'Visual', 'Left DLPFC', 'Right DLPFC', 'Left ACC', 'Right ACC', 'FrontoParietal', 'Vestibular'};


% WARNING: this logic only works for MiM data
if separate_groups
    % find first number of subject id (1,2 or 3)
%     for this_subject = 1:length(subjects)
%         group_ids{this_subject} = subjects{:,this_subject}(1);
%     end
    unique_groups = unique(group_ids);
    
    % identify colors based on number of unique groups ^^
    color_groups = distinguishable_colors(length(unique_groups));
else
    unique_groups = 1;
end
    
% wdir = strcat(project_path, filesep, conn_project_name, filesep, 'results', filesep, 'firstlevel');
% corr_net = 'SBC_01'; % WARNING: this may change

wdir = strcat(data_path, filesep, conn_project_name, filesep, 'results', filesep, 'firstlevel');
corr_net = 'SBC_01'; % WARNING: this may change

first_level_corr_folder = strcat(wdir, filesep, corr_net);

corr_file_dir = dir([strcat(first_level_corr_folder, filesep, 'resultsROI_Subject*.mat')]);
clear roi_file_name_list;
[available_subject_file_name_list{1:length(corr_file_dir)}] = deal(corr_file_dir.name);

%%%%%%cerebellum data path
cbdir = strcat(data_path, filesep, cb_project_name, filesep, 'results', filesep, 'firstlevel');
cbfirst_level_corr_folder = strcat(cbdir, filesep, corr_net);
cbcorr_file_dir = dir([strcat(cbfirst_level_corr_folder, filesep, 'resultsROI_Subject*.mat')]);
clear roi_file_name_list;
[cbavailable_subject_file_name_list{1:length(cbcorr_file_dir)}] = deal(cbcorr_file_dir.name);


%%%%%make sure cerebellum subject file name is equal
if isequal(cbavailable_subject_file_name_list, available_subject_file_name_list) 
else
    disp('WB and cerebellum subjects are not the same! check')
    equalsubjcheck = cellfun(@isequal, cbavailable_subject_file_name_list, available_subject_file_name_list);
    disp(equalsubjcheck)
end
    


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

roi_dir = dir([strcat('RestingState_Aging_ROI_SS', filesep,'*.nii')]);
%roi_dir = dir([strcat('rois', filesep,'*.nii')]);
clear roi_file_name_list;
[available_roi_file_name_list{1:length(roi_dir)}] = deal(roi_dir.name);

for this_roi_index = 1:length(settings_cell)
    this_roi_settings_line = strsplit(settings_cell{this_roi_index}, ',');
    roi_core_name_cell{this_roi_index} = this_roi_settings_line{1};
    roi_network_cell{this_roi_index} = strtrim(this_roi_settings_line{5});
end

for i_subject = 1 : length(available_subject_file_name_list)
    this_subject_data = load(strcat(first_level_corr_folder, filesep, available_subject_file_name_list{i_subject}));
    %%%%%load cerebellum
    cbthis_subject_data = load(strcat(cbfirst_level_corr_folder, filesep, cbavailable_subject_file_name_list{i_subject}));
    
    average_total_conn(i_subject) = mean(nanmean(this_subject_data.Z));

    roi_pairs_between_network = [];
    for this_seed_name_index = 1:length(seed_names)
        this_within_network_occurences = contains(roi_network_cell, strcat(seed_names{this_seed_name_index},'_network'));
        this_within_network_indices = find(this_within_network_occurences);
        roi_pairs_within_network = nchoosek(this_within_network_indices,2);
        
        % find seed names outside of this_seed_name to generate
        % this_outside_network_occurences
        not_this_seed_name_index = 1:length(seed_names);
        not_this_seed_name_index(this_seed_name_index) = [];
        this_outside_network_occurences = contains(roi_network_cell, strcat(seed_names(not_this_seed_name_index)','_network'));
        this_outside_network_indices = find(this_outside_network_occurences);
        
        for idx = 1 : length(this_within_network_indices)
            this_within_network_index = this_within_network_indices(idx);
            this_within_network_index_matrix = repmat(this_within_network_index, 1, length(this_outside_network_indices))';
            this_within_and_between_network_index_pairs = [this_within_network_index_matrix, this_outside_network_indices'];
            roi_pairs_between_network = [roi_pairs_between_network; this_within_and_between_network_index_pairs];
        end
        
        this_within_network_corr_vector=[];
        %%%%%
       cerebellumROI = [89,91,278,279];
                   %cerebellum ROI nodes:
% 89 = medial_prefrontal_cortex_post_cingulate_node37 
% 91 =  medial_prefrontal_cortex_post_cingulate_node39
% 278 = right_dlpfc_node1_cb
% 279 = right_dlpfc_node2_cb
for this_roi_pair = 1:size(roi_pairs_within_network,1)

    if ismember(roi_pairs_within_network(this_roi_pair,1), cerebellumROI) == 1 && ismember(roi_pairs_within_network(this_roi_pair,2), cerebellumROI) == 1
        this_network_roi_value = cbthis_subject_data.Z(roi_pairs_within_network(this_roi_pair,1), roi_pairs_within_network(this_roi_pair,2));
    else
        this_network_roi_value = this_subject_data.Z(roi_pairs_within_network(this_roi_pair,1), roi_pairs_within_network(this_roi_pair,2));
    end
    % if anti-correlated set to 0
    if this_network_roi_value < 0
        this_network_roi_value = 0;
    end
    this_within_network_corr_vector(this_roi_pair) = this_network_roi_value;
end
        avg_within_network_conn(this_seed_name_index, i_subject) = mean(this_within_network_corr_vector);
        
        this_between_network_corr_vector=[];
        for this_roi_pair = 1:size(roi_pairs_between_network,1)
             if ismember(roi_pairs_between_network(this_roi_pair,1), cerebellumROI) == 1 && ismember(roi_pairs_between_network(this_roi_pair,2), cerebellumROI) == 1
        this_network_roi_value = cbthis_subject_data.Z(roi_pairs_between_network(this_roi_pair,1), roi_pairs_between_network(this_roi_pair,2));
    else
        this_network_roi_value = this_subject_data.Z(roi_pairs_between_network(this_roi_pair,1), roi_pairs_between_network(this_roi_pair,2));
    end
            %this_network_roi_value = this_subject_data.Z(roi_pairs_between_network(this_roi_pair,1), roi_pairs_between_network(this_roi_pair,2));
            % if anti-correlated set to 0
            if this_network_roi_value < 0
                this_network_roi_value = 0;
            end
            this_between_network_corr_vector(this_roi_pair) = this_network_roi_value;
        end
        avg_between_network_conn(this_seed_name_index, i_subject) = mean(this_between_network_corr_vector);
        
        network_segregation(this_seed_name_index, i_subject) = (avg_within_network_conn(this_seed_name_index, i_subject) - avg_between_network_conn(this_seed_name_index, i_subject))/(avg_within_network_conn(this_seed_name_index, i_subject));
    end
    
    % WARNING: MiM Specific
    if save_mim_scores
        networks_of_interest_indices = find(contains(seed_names,{'left_dlpfc', 'right_dlpfc', 'left_acc'}));
        this_table_cell = {subjects{i_subject}, 'base_v4_mri_arm_1'};
        seed_names_cell = {'record_id', 'redcap_event_name'};
        for i_net = 1:length(networks_of_interest_indices)
            this_table_cell{i_net+2} = network_segregation(networks_of_interest_indices(i_net),i_subject);
            seed_names_cell(i_net+2) = strcat('conn_',seed_names(networks_of_interest_indices(i_net)));
        end
        
        seed_names_cell{end+1} = 'conn_complete';
        this_table_cell{end+1} = '2';
        
        T = cell2table(this_table_cell, 'VariableNames', seed_names_cell);
        
        subject_folder = subjects{i_subject};
        mkdir(fullfile(project_path, subject_folder, 'Processed', 'MRI_files','04_rsfMRI','ANTS_Normalization','Level1'));
        writetable(T, fullfile(project_path, subject_folder, 'Processed', 'MRI_files','04_rsfMRI','ANTS_Normalization','Level1', strcat(subjects{i_subject},outfile,'.csv')))
    end
end

if plot_figures
    for this_seed_name_index = 1:length(seed_names)
        this_seed_to_network_index = contains(seed_to_network_map(1,:),seed_names{this_seed_name_index});
        network_name = seed_to_network_map{2,this_seed_to_network_index};
        %% Inidividual WITHIN
        figure; hold on;
        if separate_groups
            group_1_indices = (group_ids==1);
            group_2_indices = (group_ids==2);
            
            bar(1:sum(group_1_indices), avg_within_network_conn(this_seed_name_index,group_1_indices), 'FaceColor', color_groups(1,:)); hold on;
            bar(sum(group_1_indices)+1:sum(group_2_indices)+sum(group_1_indices), avg_within_network_conn(this_seed_name_index,group_2_indices), 'FaceColor', color_groups(2,:));hold on;
            
            if length(unique_groups) > 2
                group_3_indices = (group_ids==3);
                bar(sum(group_2_indices)+sum(group_1_indices)+1:sum(group_3_indices)+sum(group_2_indices)+sum(group_1_indices), avg_within_network_conn(this_seed_name_index,group_3_indices), 'FaceColor', color_groups(3,:));
            end
        else
            bar(1:length(subjects), avg_within_network_conn(this_seed_name_index,:))
        end
        
        title(strcat('WITHIN Network Connectivity ', {' '}, network_name),'interpreter','none', 'FontSize',18)
        ylabel('Connectivity')
        set(gca,'XTick',1:length(subjects),'xticklabel',subjects,'TickLabelInterpreter','none','FontSize',8)
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
            MaximizeFigureWindow
            fig_title = strcat('subjects_', network_name, 'within_network_connectivity');
            filename =  fullfile(project_path, 'figures', fig_title);
            saveas(gca, filename, 'tiff')
        end
        if export_figures
            export_fig('-pdf','-append')
        end
        
        % Group AVG WITHIN
        if separate_groups
            figure; hold on;
            group_1_indices = (group_ids==1);
            group_2_indices = (group_ids==2);
            
            singleBoxPlot(avg_within_network_conn(this_seed_name_index,group_1_indices),'abscissa', 1, 'EdgeColor', color_groups(1,:), 'MarkerColor', color_groups(1,:),'WiskColor',  color_groups(1,:), 'MeanColor', color_groups(1,:))
            singleBoxPlot(avg_within_network_conn(this_seed_name_index,group_2_indices),'abscissa', 2, 'EdgeColor', color_groups(2,:), 'MarkerColor', color_groups(2,:),'WiskColor',  color_groups(2,:), 'MeanColor', color_groups(2,:))
            xlim([0 3])
            if length(unique_groups) > 2
                group_3_indices = (group_ids==3);
                singleBoxPlot(avg_within_network_conn(this_seed_name_index,group_3_indices),'abscissa', 3, 'EdgeColor', color_groups(3,:), 'MarkerColor', color_groups(3,:),'WiskColor',  color_groups(3,:), 'MeanColor', color_groups(3,:))
                xlim([0 4])
            end
             ylim([0 .3])
             title(strcat('WITHIN Network Connectivity', {' '}, network_name),'interpreter','none', 'FontSize',18)
             ylabel('Connectivity')
             %     legend({'YA','high-OA','low-OA'})
             set(gca,'XTick',1:length(unique_groups),'xticklabel',{'YA','high-OA','low-OA'},'TickLabelInterpreter','none','FontSize',16)
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
                 fig_title = strcat('groups_', network_name, 'within_network_connectivity');
                 filename =  fullfile(project_path, 'figures', fig_title);
                 saveas(gca, filename, 'tiff')
             end
             if export_figures
                 export_fig('-pdf','-append')
             end
        end
        
        %% Individual BETWEEN
        figure; hold on;
        if separate_groups
            group_1_indices = (group_ids==1);
            group_2_indices = (group_ids==2);
            
            bar(1:sum(group_1_indices), avg_between_network_conn(this_seed_name_index,group_1_indices), 'FaceColor', color_groups(1,:)); hold on;
            bar(sum(group_1_indices)+1:sum(group_2_indices)+sum(group_1_indices), avg_between_network_conn(this_seed_name_index,group_2_indices), 'FaceColor', color_groups(2,:));hold on;
            
            if length(unique_groups) > 2
                group_3_indices = (group_ids==3);
                bar(sum(group_2_indices)+sum(group_1_indices)+1:sum(group_3_indices)+sum(group_2_indices)+sum(group_1_indices), avg_between_network_conn(this_seed_name_index,group_3_indices), 'FaceColor', color_groups(3,:));
            end
        else
            bar(1:length(subjects), avg_between_network_conn(this_seed_name_index,:))
        end
        
        title(strcat('BETWEEN Network Connectivity', {' '}, network_name),'interpreter','none', 'FontSize',18)
        ylabel('Connectivity')
        set(gca,'XTick',1:length(subjects),'xticklabel',subjects,'TickLabelInterpreter','none','FontSize',8)
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
            MaximizeFigureWindow
            fig_title = strcat('subjects_', network_name, 'between_network_connectivity');
            filename =  fullfile(project_path, 'figures', fig_title);
            saveas(gca, filename, 'tiff')
        end
        if export_figures
            export_fig('-pdf','-append')
        end
        
        
        if separate_groups
            figure; hold on;
            group_1_indices = (group_ids==1);
            group_2_indices = (group_ids==2);
            
            singleBoxPlot(avg_between_network_conn(this_seed_name_index,group_1_indices),'abscissa', 1, 'EdgeColor', color_groups(1,:), 'MarkerColor', color_groups(1,:),'WiskColor',  color_groups(1,:), 'MeanColor', color_groups(1,:))
            singleBoxPlot(avg_between_network_conn(this_seed_name_index,group_2_indices),'abscissa', 2, 'EdgeColor', color_groups(2,:), 'MarkerColor', color_groups(2,:),'WiskColor',  color_groups(2,:), 'MeanColor', color_groups(2,:))
            xlim([0 3])
            if length(unique_groups) > 2
                group_3_indices = (group_ids==3);
                singleBoxPlot(avg_between_network_conn(this_seed_name_index,group_3_indices),'abscissa', 3, 'EdgeColor', color_groups(3,:), 'MarkerColor', color_groups(3,:),'WiskColor',  color_groups(3,:), 'MeanColor', color_groups(3,:))
                xlim([0 4])
            end
            ylim([0 .1])
            title(strcat('BETWEEN Network Connectivity', {' '}, network_name),'interpreter','none', 'FontSize',18)
            ylabel('Connectivity')
            set(gca,'XTick',1:length(unique_groups),'xticklabel',{'YA','high-OA','low-OA'},'TickLabelInterpreter','none','FontSize',16)
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
                fig_title = strcat('groups_', network_name, 'between_network_connectivity');
                filename =  fullfile(project_path, 'figures', fig_title);
                saveas(gca, filename, 'tiff')
            end
            if export_figures
                export_fig('-pdf','-append')
            end
        end
        
        
        %% Individual SEGREGATION
        figure; hold on;
        if separate_groups
            group_1_indices = (group_ids==1);
            group_2_indices = (group_ids==2);
            
            bar(1:sum(group_1_indices), network_segregation(this_seed_name_index,group_1_indices), 'FaceColor', color_groups(1,:)); hold on;
            bar(sum(group_1_indices)+1:sum(group_2_indices)+sum(group_1_indices), network_segregation(this_seed_name_index,group_2_indices), 'FaceColor', color_groups(2,:));hold on;
            
            if length(unique_groups) > 2
                group_3_indices = (group_ids==3);
                bar(sum(group_2_indices)+sum(group_1_indices)+1:sum(group_3_indices)+sum(group_2_indices)+sum(group_1_indices), network_segregation(this_seed_name_index,group_3_indices), 'FaceColor', color_groups(3,:));
            end
        else
            bar(1:length(subjects), network_segregation(this_seed_name_index,:))
        end
        title(strcat('Segregation', {' '}, network_name),'interpreter','none', 'FontSize',18)
        ylabel('Segregation')
        set(gca,'XTick',1:length(subjects), 'xticklabel',subjects,'TickLabelInterpreter','none','FontSize',8)
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
            MaximizeFigureWindow
            fig_title = strcat('subjects_', network_name, 'network_segregation');
            filename =  fullfile(project_path, 'figures', fig_title);
            saveas(gca, filename, 'tiff')
        end
        if export_figures
            export_fig('-pdf','-append')
        end
        
        % Group SEGREGATION
        if separate_groups
            figure; hold on;
            group_1_indices = (group_ids==1);
            group_2_indices = (group_ids==2);
            
            singleBoxPlot(network_segregation(this_seed_name_index,group_1_indices),'abscissa', 1, 'EdgeColor', color_groups(1,:), 'MarkerColor', color_groups(1,:),'WiskColor',  color_groups(1,:), 'MeanColor', color_groups(1,:))
            singleBoxPlot(network_segregation(this_seed_name_index,group_2_indices),'abscissa', 2, 'EdgeColor', color_groups(2,:), 'MarkerColor', color_groups(2,:),'WiskColor',  color_groups(2,:), 'MeanColor', color_groups(2,:))
            xlim([0 3])
            if length(unique_groups) > 2
                group_3_indices = (group_ids==3);
                singleBoxPlot(network_segregation(this_seed_name_index,group_3_indices),'abscissa', 3, 'EdgeColor', color_groups(3,:), 'MarkerColor', color_groups(3,:),'WiskColor',  color_groups(3,:), 'MeanColor', color_groups(3,:))
                xlim([0 4])
            end
            ylim([0 .85])
            title(strcat('Segregation', {' '}, network_name),'interpreter','none', 'FontSize',18)
            ylabel('Segregation')
            %     legend({'YA','high-OA','low-OA'})
            set(gca,'XTick',1:length(unique_groups),'xticklabel',{'YA','high-OA','low-OA'},'TickLabelInterpreter','none','FontSize',16)
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
                fig_title = strcat('groups_', network_name, 'network_segregation');
                filename =  fullfile(project_path, 'figures', fig_title);
                saveas(gca, filename, 'tiff')
            end
            if export_figures
                export_fig('-pdf','-append')
            end
        end
    end
end

if save_scores
    % Need to create a "table" for each score and save to .mat within
    % spreadsheet_data
    
    %     this_seed_to_network_index = contains(seed_to_network_map(1,:),seed_names{this_seed_name_index_1});
    %     network_name_matrix{this_seed_name_index_1} = seed_to_network_map{2,this_seed_to_network_index};
    subject_table = array2table(subjects');
    subject_table.Properties.VariableNames = {'subject_ids'};
      
    within_cell_table = array2table(avg_within_network_conn');
    within_cell_table.Properties.VariableNames = seed_names;
    
    between_cell_table = array2table(avg_between_network_conn');
    between_cell_table.Properties.VariableNames = seed_names;
    
    seg_cell_table = array2table(network_segregation');
    seg_cell_table.Properties.VariableNames = seed_names;

    within_results_table = [subject_table, within_cell_table];
    between_results_table = [subject_table, between_cell_table];
    seg_results_table = [subject_table, seg_cell_table];
    
    writetable(within_results_table, fullfile(project_path, conn_project_name, 'results', 'within_score_merge.csv'))
    writetable(between_results_table, fullfile(project_path, conn_project_name, 'results', 'between_score_merge.csv'))
    writetable(seg_results_table, fullfile(project_path, conn_project_name, 'results', 'seg_score_merge.csv'))


%     writetable(within_results_table,fullfile(project_path,'spreadsheet_data','within_score_SS.csv'))
%     writetable(between_results_table,fullfile(project_path,'spreadsheet_data','between_score_SS.csv'))
%     writetable(seg_results_table,fullfile(project_path,'spreadsheet_data','seg_score_SS.csv'))
end

%% correlations
if correlate_outcomes
    % R2 (of subject corrs) of each network compared to the other (for each variable so three figs) 
    for this_seed_name_index_1 = 1:length(seed_names)
        for this_seed_name_index_2 = 1:length(seed_names)
            if this_seed_name_index_1 ~= this_seed_name_index_2
                [r , p] = corr(avg_within_network_conn(this_seed_name_index_1,:)', avg_within_network_conn(this_seed_name_index_2,:)');
                avg_within_network_conn_correlation_matrix(this_seed_name_index_1,this_seed_name_index_2) = r;
            else
                avg_within_network_conn_correlation_matrix(this_seed_name_index_1,this_seed_name_index_2) = 1;
            end
        end
        this_seed_to_network_index = contains(seed_to_network_map(1,:),seed_names{this_seed_name_index_1});
        network_name_matrix{this_seed_name_index_1} = seed_to_network_map{2,this_seed_to_network_index};
    end
    figure; imagesc(avg_within_network_conn_correlation_matrix); colorbar;
    caxis([-1 1]);
    title('Within Network Correlations')
    xtickangle(45)
    set(gca,'XTickLabel',network_name_matrix)
    set(gca,'YTickLabel',network_name_matrix)
    set(gcf, 'ToolBar', 'none');
    set(gcf, 'MenuBar', 'none');
    fig_title = 'correlations_within_network';
    filename =  fullfile(project_path, 'figures', fig_title);
%     saveas(gca, filename, 'tiff')
    I=getframe(gcf);
    imwrite(I.cdata,strcat(filename,'.tiff'));

    for this_seed_name_index_1 = 1:length(seed_names)
        for this_seed_name_index_2 = 1:length(seed_names)
            if this_seed_name_index_1 ~= this_seed_name_index_2
                [r , p] = corr(avg_between_network_conn(this_seed_name_index_1,:)', avg_between_network_conn(this_seed_name_index_2,:)');
                avg_between_network_conn_correlation_matrix(this_seed_name_index_1,this_seed_name_index_2) = r;
            else
                avg_between_network_conn_correlation_matrix(this_seed_name_index_1,this_seed_name_index_2) = 1;
            end
        end
        this_seed_to_network_index = contains(seed_to_network_map(1,:),seed_names{this_seed_name_index_1});
        network_name_matrix{this_seed_name_index_1} = seed_to_network_map{2,this_seed_to_network_index};
    end
    figure; imagesc(avg_between_network_conn_correlation_matrix); colorbar;
    caxis([-1 1]);
    title('Between Network Correlations')
    xtickangle(45)
    set(gca,'XTickLabel',network_name_matrix)
    set(gca,'YTickLabel',network_name_matrix)
    set(gcf, 'ToolBar', 'none');
    set(gcf, 'MenuBar', 'none');
    fig_title = 'correlations_between_network';
    filename =  fullfile(project_path, 'figures', fig_title);
%     saveas(gca, filename, 'tiff')
    I=getframe(gcf);
    imwrite(I.cdata,strcat(filename,'.tiff'));
    
    for this_seed_name_index_1 = 1:length(seed_names)
        for this_seed_name_index_2 = 1:length(seed_names)
            if this_seed_name_index_1 ~= this_seed_name_index_2
                [r , p] = corr(network_segregation(this_seed_name_index_1,:)', network_segregation(this_seed_name_index_2,:)');
                network_segregation_correlation_matrix(this_seed_name_index_1,this_seed_name_index_2) = r;
            else
                network_segregation_correlation_matrix(this_seed_name_index_1,this_seed_name_index_2) = 1;
            end
        end
        this_seed_to_network_index = contains(seed_to_network_map(1,:),seed_names{this_seed_name_index_1});
        network_name_matrix{this_seed_name_index_1} = seed_to_network_map{2,this_seed_to_network_index};
    end
    figure; imagesc(network_segregation_correlation_matrix); colorbar;
    caxis([-1 1]);
    title('Network Segregation Correlations')
    xtickangle(45)
    set(gca,'XTickLabel',network_name_matrix)
    set(gca,'YTickLabel',network_name_matrix)
    set(gcf, 'ToolBar', 'none');
    set(gcf, 'MenuBar', 'none');
    fig_title = 'correlations_network_segregation';
    filename =  fullfile(project_path, 'figures', fig_title);
    %     saveas(gca, filename, 'tiff')
    I=getframe(gcf);
    imwrite(I.cdata,strcat(filename,'.tiff'));
    
end
end
