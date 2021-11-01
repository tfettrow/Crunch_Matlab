% seed=55;
subject_id = 1001;
formatOut = 'yyyy-mm-dd';
DateString = datestr(now,formatOut);
newDateString = erase(DateString,"-");
posture_order = {'standing'; 'sitting'; 'lying'};
difficulty_levels = {'0'; '5'; '10'; '15'};
trial_type = {'control'; 'percept'};

rand_posture_order = posture_order(randperm(length(posture_order)));

experimental_conditions = {};

for this_posture = 1:length(rand_posture_order)
    [m,n] = ndgrid(trial_type,difficulty_levels);
    potential_posture_trial_order = [m(:),n(:)];
    potential_posture_trial_order_indices = 1:length(potential_posture_trial_order);
    random_posture_trial_order = potential_posture_trial_order(randperm(length(potential_posture_trial_order)),:);
    experimental_conditions = [experimental_conditions; repmat(rand_posture_order(this_posture),length(random_posture_trial_order),1), random_posture_trial_order];
end

% T = cell2table(c(2:end,:),'VariableNames',c(1,:))
 
% Write the table to a CSV file
% writetable(T,'myDataFile.csv')

T = cell2table(experimental_conditions);
writetable(T,strcat('C:\Code\crest-master\crest-master\crest\Assets\',newDateString,'_',num2str(subject_id),'.csv'))

% writematrix(experimental_conditions, strcat('C:\Code\crest-master\crest-master\crest\Assets\', subject_id,DateString,'.csv'));