function correlate_crunch(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'task_folder', '')
addParameter(parser, 'subjects', '')
addParameter(parser, 'group_names', '')
addParameter(parser, 'group_ids', '')
addParameter(parser, 'no_labels', 0)
addParameter(parser, 'Results_filename', 'CRUNCH_discete_roi_newacc.mat')
addParameter(parser, 'regressor_variable', '');
parse(parser, varargin{:})
subjects = parser.Results.subjects;
group_names = parser.Results.group_names;
group_ids = parser.Results.group_ids;
task_folder = parser.Results.task_folder;
no_labels = parser.Results.no_labels;
Results_filename = parser.Results.Results_filename;
regressor_variable = parser.Results.regressor_variable;
data_path = pwd;

group_color_matrix = distinguishable_colors(length(group_names));
data_path = pwd;

if strcmp(regressor_variable,'400m_walk')
    headers={'subject_id', 'sppb_balance', 'sppb_speed', 'sppb_stand', 'sppb_total','400m'};
    walking_data = xlsread(fullfile(data_path,'spreadsheet_data','walking_data','walking_data.xlsx'));
    walking_data = table(walking_data(:,1),walking_data(:,6));
    walking_data.Properties.VariableNames = {'subject_ids', '400_m_time'};
    potential_regressor_data = walking_data;
end
if strcmp(regressor_variable,'gmv')
    potential_regressor_data =  readtable(fullfile(data_path,'spreadsheet_data','vol_score.csv'));
end
if strcmp(regressor_variable,'within_score')
    potential_regressor_data =  readtable(fullfile(data_path,'spreadsheet_data','within_score.csv'));
end
if strcmp(regressor_variable,'between_score')
    potential_regressor_data =  readtable(fullfile(data_path,'spreadsheet_data','between_score.csv'));
end
if strcmp(regressor_variable,'seg_score')
    potential_regressor_data =  readtable(fullfile(data_path,'spreadsheet_data','seg_score.csv'));
end
if strcmp(regressor_variable,'pain_thresh')
    headers = {'subject_id','PainThreshold_Average','PainInventory_Average','Tactile_Mono','Tactile_Dual'};
    potential_regressor_data = xlsread('sensory_data.xlsx');
end
ylabel_text = potential_regressor_data.Properties.VariableNames(2:end);

cr_results = [];
adjust_group_id_indices = [];
for this_subject_index = 1 : length(subjects)
    subj_results_dir = fullfile(data_path, subjects{this_subject_index}, 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain');
    if any(strcmp(task_folder, '05_MotorImagery'))
        task='MotorImagery';
         % loading and grabbing data
         load(char(strcat(subj_results_dir,filesep,strcat(subjects{this_subject_index},'_',task,'_',Results_filename))));
         cr_results = [cr_results; cell2mat(cr)];
    elseif any(strcmp(task_folder, '06_Nback'))
        task='Nback';
        % loading and grabbing data
        load(char(strcat(subj_results_dir,filesep,strcat(subjects{this_subject_index},'_',task,'_',Results_filename))));
        cr_results = [cr_results; cell2mat(cr_1500) cell2mat(cr_500)];
    end
    %     if strcmp(regressor_variable,'400m_walk')
   this_subject_row_data = find(strcmp(string(table2cell(potential_regressor_data(:,1))), subjects{this_subject_index}));
   if isempty(this_subject_row_data)
       adjust_group_id_indices = [adjust_group_id_indices this_subject_index];
   end
   if ~isempty(this_subject_row_data)
       this_regressor_data(this_subject_index,:) = table2cell(potential_regressor_data(this_subject_row_data,2:end));
   end
end

group_ids(adjust_group_id_indices) = [];
this_regressor_data = cell2mat(this_regressor_data);

for this_reg_index = 1 : size(potential_regressor_data,2)-1
    allYLim = [];
    figure; hold on;
    for this_group_index = 1 : length(group_names)
        this_group_subjectindices = find(group_ids==this_group_index);
        
        this_figure_number = 1;
        for this_roi_index = 1 : length(unique_rois)
            if any(strcmp(task_folder, '05_MotorImagery'))
                mi_cruncherindices = find(cr_results(:,this_roi_index)>0);
                these_indices_to_plot = intersect(this_group_subjectindices,mi_cruncherindices);
                
                subplot(1, length(unique_rois), this_figure_number); hold on;
                
                plot(cr_results(these_indices_to_plot,this_roi_index), this_regressor_data(these_indices_to_plot,this_reg_index), 'o', 'MarkerEdge', 'k', 'MarkerFace', group_color_matrix(this_group_index, :))
                if length(these_indices_to_plot) > 2
                    [r , p] = corr(cr_results(these_indices_to_plot,this_roi_index), this_regressor_data(these_indices_to_plot,this_reg_index));
                    r2 = r^2;
                    coefs = polyfit(cr_results(these_indices_to_plot,this_roi_index)', this_regressor_data(these_indices_to_plot,this_reg_index), 1);
                    fittedX=linspace(0, 5, 100);
                    fittedY=polyval(coefs, fittedX);
                    plot(fittedX, fittedY, '-', 'Color',group_color_matrix(this_group_index, :),'LineWidth',1);
                end
                if this_figure_number == 1
                    ylabel(ylabel_text{this_reg_index},'interpreter','latex')
                end
                this_figure_number = this_figure_number+1;
            elseif any(strcmp(task_folder, '06_Nback'))
                nb1500_cruncherindices = find(cr_results(:,this_roi_index)>0);
                nb500_cruncherindices = find(cr_results(:,this_roi_index+4)>0);
                these_indices_to_plot_1500 = intersect(this_group_subjectindices,nb1500_cruncherindices);
                these_indices_to_plot_500 = intersect(this_group_subjectindices,nb500_cruncherindices);
                subplot(1, length(unique_rois), this_figure_number); hold on;
                plot(cr_results(these_indices_to_plot_1500,this_roi_index), this_regressor_data(these_indices_to_plot_1500,this_reg_index), 'o', 'MarkerEdge', 'k', 'MarkerFace',  group_color_matrix(this_group_index, :))
                plot(cr_results(these_indices_to_plot_500,this_roi_index+4), this_regressor_data(these_indices_to_plot_500,this_reg_index), 'o', 'MarkerEdge', 'k', 'MarkerFace',  (group_color_matrix(this_group_index, :)+.2)*.5)
                if length(these_indices_to_plot_1500) > 2
                    [r1 , p] = corr(cr_results(these_indices_to_plot_1500,this_roi_index), this_regressor_data(these_indices_to_plot_1500,this_reg_index));
                    r21 = r1^2;
                    coefs1 = polyfit(cr_results(these_indices_to_plot_1500,this_roi_index)', this_regressor_data(these_indices_to_plot_1500,this_reg_index), 1);
                    fittedX=linspace(0, 5, 100);
                    fittedY1=polyval(coefs1, fittedX);
                    plot(fittedX, fittedY1, '-', 'Color',group_color_matrix(this_group_index, :),'LineWidth',1);
                end
                if length(these_indices_to_plot_500) > 2
                    [r2 , p] = corr(cr_results(these_indices_to_plot_500,this_roi_index+4), this_regressor_data(these_indices_to_plot_500,this_reg_index));
                    r22 = r2^2;
                    coefs2 = polyfit(cr_results(these_indices_to_plot_500,this_roi_index+4)', this_regressor_data(these_indices_to_plot_500,this_reg_index), 1);
                    fittedX=linspace(0, 5, 100);
                    fittedY2=polyval(coefs2, fittedX);
                    plot(fittedX, fittedY2, '-', 'Color',(group_color_matrix(this_group_index, :)+.2)*.5,'LineWidth',1);
                end
                if this_figure_number == 1
                   ylabel(ylabel_text{this_reg_index},'interpreter','latex')
                end
                this_figure_number = this_figure_number+1;
            end
            title([unique_rois(this_roi_index)],'interpreter','latex')
            xticks([1:4])
            xlim([0 5])
%             ylim([200 550])
        end
    end
    h = suptitle(ylabel_text{this_reg_index})
    h.Interpreter = 'none';
end