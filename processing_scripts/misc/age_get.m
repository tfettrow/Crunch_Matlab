function [meanage,stdage,gend,agerange]=age_get(subjects)
warning('specify the output args:[meanage,stdage,gend,agerange]=age_get(subjects)')
%subjects = {'1002','1004','1007','1009','1010','1011','1013','1020','1022','1024','1027','2002','2007','2008','2012','2013','2015','2017','2018','2020','2021','2022','2023','2025','2026','2033','2034','2037','2042','2052'};
for i = 1:length(subjects)
    subj_results_dir = fullfile(pwd, subjects{i});
    gender(i,:)=table2array(readtable(fullfile(subj_results_dir,'subject_info.csv'),'Range','A2:A2'));
    age(i,:)=table2array(readtable(fullfile(subj_results_dir,'subject_info.csv'),'Range','B2:B2'));
end
meanage = mean(age);
stdage = std(age);
[agerange(1),agerange(2)] = bounds(age);
g = cell2mat(gender);
gend = length(find(g == 'F'));
end

