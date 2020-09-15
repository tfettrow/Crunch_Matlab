function create_imageryQuality_figure(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'task_folder', '')
addParameter(parser, 'subjects', '')
addParameter(parser, 'group_names', '')
addParameter(parser, 'group_ids', '')
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

headers={'subject_id', 'flat', 'low', 'medium', 'high'};
imagery_data = xlsread(fullfile(data_path,'spreadsheet_data','imagery_data','imageryvividness_data.xlsx'));

% for this_subject_index = 1 : length(subjects)
%     this_subject_row_walking_data = find(strcmp(string(imagery_data(:,1)), subjects{this_subject_index}));
% %     this_subject_imagery_data(this_subject_index,:) = imagery_data(this_subject_row_walking_data,2:5);
% end

number_of_levels = 0:3;
for this_group_index = 1 : length(group_names)
    this_group_subjectindices = find(group_ids==this_group_index);
    this_group_subject_array(1:length(this_group_subjectindices)) = subjects(this_group_subjectindices);
    this_group_subjectindices_imageryindices = find(contains(string(imagery_data(:,1)), this_group_subject_array));
    
    this_group_imagery_averages(this_group_index,:) = mean(imagery_data(this_group_subjectindices_imageryindices,2:5));
    this_group_imagery_stds(this_group_index,:) = std(imagery_data(this_group_subjectindices_imageryindices,2:5));
    
%     bar(number_of_levels,this_group_imagery_averages) %, 'Color',  group_color_matrix(this_group_index, :))
end
figure; hold on;
b = bar(number_of_levels,this_group_imagery_averages)
% errorbar([number_of_levels; number_of_levels],this_group_imagery_averages,this_group_imagery_stds)
b(1).FaceColor = group_color_matrix(1,:)
b(2).FaceColor = group_color_matrix(2,:)
ylim([1 5])
ax = gca;
ax.YDir = 'reverse'

nbars = size(this_group_imagery_averages, 1);

x = [];
for i = 1:nbars
    x = [x ; b(i).XEndPoints];
end
errorbar(x,this_group_imagery_averages,this_group_imagery_stds,'k','linestyle','none')
hold off

xticks([number_of_levels])
xlim([-1 4])

title('Self-Reported Imagery Quality')