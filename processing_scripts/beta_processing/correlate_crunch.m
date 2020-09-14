function create_redcap_behaviorCRUNCH_figure(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'task_folder', '')
addParameter(parser, 'subjects', '')
addParameter(parser, 'group_names', '')
addParameter(parser, 'group_ids', '')
addParameter(parser, 'no_labels', 0)
addParameter(parser, 'Results_filename', 'CRUNCH_secondorder_max.mat')
parse(parser, varargin{:})
subjects = parser.Results.subjects;
group_names = parser.Results.group_names;
group_ids = parser.Results.group_ids;
task_folder = parser.Results.task_folder;
no_labels = parser.Results.no_labels;
Results_filename = parser.Results.Results_filename;
data_path = pwd;


group_color_matrix = distinguishable_colors(length(group_names));
% results = [];

data_path = pwd;

headers={'subject_id', 'sppb_balance', 'sppb_speed', 'sppb_stand', 'sppb_total','400m'};
walking_data = xlsread(fullfile(data_path,'spreadsheet_data','walking_data','walking_data.xlsx'));
% headers={'subject_id','PainThreshold_Average','PainInventory_Average','Tactile_Mono','Tactile_Dual'};
% sensory_data = xlsread('sensory_data.xlsx');


for this_subject_index = 1 : length(subjects)
    subj_results_dir = fullfile(data_path, subjects{this_subject_index}, 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain');
    if any(strcmp(task_folder, '05_MotorImagery'))
        task='MotorImagery';
         % loading and grabbing data
         load(char(strcat(subj_results_dir,filesep,strcat(subjects{this_subject_index},'_',task,'_',Results_filename))));
         results(this_subject_index,:) = crunchpoint_x;
    elseif any(strcmp(task_folder, '06_Nback'))
        task='Nback';
        % loading and grabbing data
        load(char(strcat(subj_results_dir,filesep,strcat(subjects{this_subject_index},'_',task,'_',Results_filename))));
        results(this_subject_index,:) = [crunchpoint_x1 crunchpoint_x2];
    end

    this_subject_row_walking_data = find(strcmp(string(walking_data(:,1)), subjects{this_subject_index}));
    this_subject_400m_data(this_subject_index) = walking_data(this_subject_row_walking_data,6);
end

    allYLim = [];
for this_group_index = 1 : length(group_names)
    this_group_subjectindices = find(group_ids==this_group_index);
    this_figure_number = 1;

    for this_roi_index = 1 : length(unique_rois)
        if any(strcmp(task_folder, '05_MotorImagery'))
            subplot(1, 4, this_figure_number); hold on;           
            plot( results(this_group_subjectindices,this_roi_index), this_subject_400m_data(this_group_subjectindices), 'o', 'MarkerEdge', 'k', 'MarkerFace', group_color_matrix(this_group_index, :))
            [r , p] = corr(results(this_group_subjectindices,this_roi_index), this_subject_400m_data(this_group_subjectindices)');
            r2 = r^2;
            coefs = polyfit(results(this_group_subjectindices,this_roi_index)', this_subject_400m_data(this_group_subjectindices), 1);
            fittedX=linspace(0, 5, 100);
            fittedY=polyval(coefs, fittedX);
            plot(fittedX, fittedY, '-', 'Color',group_color_matrix(this_group_index, :),'LineWidth',1);
            if this_figure_number == 1
                ylabel('Walking Time (seconds)')
            end
            this_figure_number = this_figure_number+1;
        elseif any(strcmp(task_folder, '06_Nback'))
            subplot(1, 4, this_figure_number); hold on;
            plot(results(this_group_subjectindices,this_roi_index), this_subject_400m_data(this_group_subjectindices), 'o', 'MarkerEdge', 'k', 'MarkerFace',  group_color_matrix(this_group_index, :))
            plot(results(this_group_subjectindices,this_roi_index+4), this_subject_400m_data(this_group_subjectindices), 'o', 'MarkerEdge', 'k', 'MarkerFace',  (group_color_matrix(this_group_index, :)+.2)*.5)
            [r1 , p] = corr(results(this_group_subjectindices,this_roi_index), this_subject_400m_data(this_group_subjectindices)');
            [r2 , p] = corr(results(this_group_subjectindices,this_roi_index+4), this_subject_400m_data(this_group_subjectindices)');
            r21 = r1^2;
            r22 = r2^2;
            coefs1 = polyfit(results(this_group_subjectindices,this_roi_index)', this_subject_400m_data(this_group_subjectindices), 1);
            coefs2 = polyfit(results(this_group_subjectindices,this_roi_index+4)', this_subject_400m_data(this_group_subjectindices), 1);
            fittedX=linspace(0, 5, 100);
            fittedY1=polyval(coefs1, fittedX);
            fittedY2=polyval(coefs2, fittedX);
            plot(fittedX, fittedY1, '-', 'Color',group_color_matrix(this_group_index, :),'LineWidth',1);
            plot(fittedX, fittedY2, '-', 'Color',(group_color_matrix(this_group_index, :)+.2)*.5,'LineWidth',1);
            if this_figure_number == 1
                ylabel('Walking Time (seconds)')
            end
            this_figure_number = this_figure_number+1;
        end
        title([unique_rois(this_roi_index)],'interpreter','latex')
        xticks([1:4])
        xlim([0 5])
        ylim([200 550])
    end
end