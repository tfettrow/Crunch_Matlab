function visualize_correlation(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'subjects', '')
addParameter(parser, 'group_names', '')
addParameter(parser, 'group_ids', '')
addParameter(parser, 'no_labels', 0)
addParameter(parser, 'regressor_variable1', '')
addParameter(parser, 'regressor_variable2', '')
addParameter(parser, 'crunchers_only', '0')
parse(parser, varargin{:})
subjects = parser.Results.subjects;
group_names = parser.Results.group_names;
group_ids = parser.Results.group_ids;
no_labels = parser.Results.no_labels;
regressor_variable1 = parser.Results.regressor_variable1;
regressor_variable2 = parser.Results.regressor_variable2;
crunchers_only = parser.Results.crunchers_only;
data_path = pwd;
close all

group_color_matrix = distinguishable_colors(length(group_names));
% data_path = pwd;
if strcmp(regressor_variable1,'cr_score_mi')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','cr_score_mi.csv'));
end
if strcmp(regressor_variable1,'maxbeta_score_mi')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','maxbeta_score_mi.csv'));
end
if strcmp(regressor_variable1,'cr_score_nb')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','cr_score_nb.csv'));
end
if strcmp(regressor_variable1,'maxbeta_score_nb')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','maxbeta_score_nb.csv'));
end
if strcmp(regressor_variable1,'400m_walk')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','400m_walk.csv'));
end
if strcmp(regressor_variable1,'vol_score')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','vol_score.csv'));
end
if strcmp(regressor_variable1,'within_score')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','within_score.csv'));
end
if strcmp(regressor_variable1,'between_score')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','between_score.csv'));
end
if strcmp(regressor_variable1,'seg_score')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','seg_score.csv'));
end
if strcmp(regressor_variable1,'TM_ml')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','TM_ml.csv'));
end
if strcmp(regressor_variable1,'pain_thresh')
    headers = {'subject_id','PainThreshold_Average','PainInventory_Average','Tactile_Mono','Tactile_Dual'};
    potential_regressor1_data = xlsread('sensory_data.xlsx');
end

if strcmp(regressor_variable2,'cr_score_mi')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','cr_score_mi.csv'));
end
if strcmp(regressor_variable2,'maxbeta_score_mi')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','maxbeta_score_mi.csv'));
end
if strcmp(regressor_variable2,'cr_score_nb')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','cr_score_nb.csv'));
end
if strcmp(regressor_variable2,'maxbeta_score_nb')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','maxbeta_score_nb.csv'));
end
if strcmp(regressor_variable2,'400m_walk')
    potential_regressor2_data = readtable(fullfile(data_path,'spreadsheet_data','400m_walk.csv'));
    for i_data_entry = 1:length(potential_regressor2_data.time_to_walk_400_meters)
        this_data_entry = potential_regressor2_data.time_to_walk_400_meters{i_data_entry}; 
        split_data_entry = strsplit(this_data_entry, ':');
        if ~(length(split_data_entry) == 1)
            potential_regressor2_data.time_to_walk_400_meters(i_data_entry) = {(str2num(split_data_entry{1}) * 60) + str2num(split_data_entry{2})};
        end
    end
end
if strcmp(regressor_variable2,'vol_score')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','vol_score.csv'));
end
if strcmp(regressor_variable2,'within_score')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','within_score.csv'));
end
if strcmp(regressor_variable2,'between_score')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','between_score.csv'));
end
if strcmp(regressor_variable2,'seg_score')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','seg_score.csv'));
end
if strcmp(regressor_variable2,'TM_ml')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','TM_ml.csv'));
    converting_data_pre = table2cell(potential_regressor2_data);
    clear potential_regressor2_data
    converting_data_post = [];
    for i_data_entry = 1:size(converting_data_pre,1) %just chose a condition.. doesnt matter
        
        idx = isnan(cell2mat(converting_data_pre(i_data_entry,2:end)));
        idx = [0 idx];
        coefs = polyfit(1:sum(~idx),cell2mat(converting_data_pre(i_data_entry,~idx)),1);
        
        converting_data_post = [converting_data_post; coefs(1)];
    end
    potential_regressor2_data = table(converting_data_pre(:,1), converting_data_post);
    potential_regressor2_data.Properties.VariableNames = {'subject_ids', 'slope_ml_ptp'};
    
end
if strcmp(regressor_variable2,'pain_thresh')
    headers = {'subject_id','PainThreshold_Average','PainInventory_Average','Tactile_Mono','Tactile_Dual'};
    potential_regressor2_data = xlsread('sensory_data.xlsx');
end
xlabel_text = potential_regressor1_data.Properties.VariableNames(2:end);
ylabel_text = potential_regressor2_data.Properties.VariableNames(2:end);

% adjust group ids based on which data is available
adjust_group_id_indices = [];
inclusion_counter = 1;
for this_subject_index = 1 : length(subjects)
   this_subject_row_data_reg1 = find(strcmp(string(table2cell(potential_regressor1_data(:,1))), subjects{this_subject_index}));
   this_subject_row_data_reg2 = find(strcmp(string(table2cell(potential_regressor2_data(:,1))), subjects{this_subject_index}));
   if isempty(this_subject_row_data_reg1) || isempty(this_subject_row_data_reg2) || isempty(table2cell(potential_regressor2_data(this_subject_row_data_reg2,2:end))) || isempty(table2cell(potential_regressor1_data(this_subject_row_data_reg1,2:end))) || ... 
           any(isnan(cell2mat(table2cell(potential_regressor2_data(this_subject_row_data_reg2,2:end))))) || any(isnan(cell2mat(table2cell(potential_regressor1_data(this_subject_row_data_reg1,2:end)))));
       adjust_group_id_indices = [adjust_group_id_indices this_subject_index];
   else
       this_regressor1_data(inclusion_counter,:) = table2cell(potential_regressor1_data(this_subject_row_data_reg1,2:end));
       this_regressor2_data(inclusion_counter,:) = table2cell(potential_regressor2_data(this_subject_row_data_reg2,2:end));
       inclusion_counter = inclusion_counter + 1;
   end
end
group_ids(adjust_group_id_indices) = [];
subjects(adjust_group_id_indices) = [];

for this_reg1_index = 1 : size(potential_regressor1_data,2)-1
    for this_reg2_index = 1 : size(potential_regressor2_data,2)-1
%         allYLim = [];
        figure; hold on;
        for this_group_index = 1 : length(group_names)
            this_group_subjectindices{this_group_index,:} = find(group_ids==this_group_index);
            plot(cell2mat(this_regressor1_data(this_group_subjectindices{this_group_index,:},this_reg1_index))', cell2mat(this_regressor2_data(this_group_subjectindices{this_group_index,:},this_reg2_index))', 'o', 'MarkerEdge', 'k', 'MarkerFace', group_color_matrix(this_group_index, :))
        end
        xLimits = get(gca,'XLim');
        T = [];
        for this_group_index = 1 : length(group_names)     
            if length(this_group_subjectindices{this_group_index,:}) >= 3
                [r , p] = corr(cell2mat(this_regressor1_data(this_group_subjectindices{this_group_index,:},this_reg1_index)), cell2mat(this_regressor2_data(this_group_subjectindices{this_group_index,:},this_reg2_index)));
                r2 = r^2;
                coefs = polyfit(cell2mat(this_regressor1_data(this_group_subjectindices{this_group_index,:},this_reg1_index)), cell2mat(this_regressor2_data(this_group_subjectindices{this_group_index,:},this_reg2_index)),1);
                
                fittedX=linspace(xLimits(1), xLimits(2), 100);
                fittedY=polyval(coefs, fittedX);
                plot(fittedX, fittedY, '-', 'Color',group_color_matrix(this_group_index, :),'LineWidth',1);
                
                str=[group_names{this_group_index}, ': ', 'r=',num2str(round(r,2)), ' m=',num2str(round(coefs(1),2))];
                T = strvcat(T, str);
            end
        end
        legend(group_names)
        text(0.1,0.9,T,'Units','normalized')
        title(strcat(regressor_variable1, '(x)', {' '}, 'vs.', {' '}, regressor_variable2, '(y)') ,'interpreter','latex')
        xlabel(xlabel_text{this_reg1_index},'interpreter','latex')
        ylabel(ylabel_text{this_reg2_index},'interpreter','latex')
    end
end
end