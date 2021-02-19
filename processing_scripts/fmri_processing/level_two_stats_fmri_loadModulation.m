function level_two_stats_fmri_loadModulation(create_model_and_estimate, task_folder, group_subject_codes, group_name)

create_model_and_estimate=1;
task_folder='05_MotorImagery';
% task_folder = '06_Nback';
%  subject_codes =  {'1002','1004','1010','1011','1013'};
% subject_codes =  {'2002','2007','2008','2012','2013','2015','2018','2020','2021','2022','2023','2025','2026'};
% subject_codes =  {'1002','1004','1007','1009','1010','1013','1020','1022','1027','2021','2015','2002','2018','2017','2012','2025','2020','2026','2023','2022','2007','2013','2008','2033','2034','2037','2052','2042'};
% subject_codes = {'1002','1004','1007','1009','1010','1011','1013','1020','1022','1027','1024'};
subject_codes = {'2021','2015','2002','2018','2017','2012','2025','2020','2026','2023','2022','2007','2013','2008','2033','2034','2037','2052','2042'};
% group_name='YA';
group_name='OA';

subject_codes = split(subject_codes,",");

data_path = pwd; % assuming shell script places wd as study level folder
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

% cd(strcat('spreadsheet_data',filesep,'imagery_data'))
imageryvividness_data = xlsread(strcat('spreadsheet_data',filesep,'imagery_data',filesep,'imageryvividness_data.xlsx'));
% cd ..

level2_results_dir = fullfile(data_path, 'Results_fmri_loadModulation', 'MRI_files', task_folder, group_name);

if strcmp(task_folder, '05_MotorImagery')
    for this_subject_index = 1 : length(subject_codes)
       
        this_subject_SPM_path = fullfile(data_path, subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain', 'SPM.mat');
        this_subject_info_path = fullfile(data_path, subject_codes(this_subject_index), 'subject_info.csv');
        
        this_subject_info = readtable(char(this_subject_info_path));
        
        all_subjects_gender(this_subject_index) = this_subject_info.gender;
        all_subjects_age(this_subject_index) = this_subject_info.age;

        load(char(this_subject_SPM_path))
        for this_contrast_index = 1:length(SPM.xCon)
            contrasts{this_contrast_index} = SPM.xCon(this_contrast_index).name;
        end
        
        Flat_greaterthan_Rest_contrast_index = find(strcmp(contrasts, 'flat>Rest'));
        Low_greaterthan_Rest_contrast_index = find(strcmp(contrasts, 'low>Rest'));
        Moderate_greaterthan_Rest_contrast_index =  find(strcmp(contrasts, 'medium>Rest'));
        High_greaterthan_Rest_index = find(strcmp(contrasts, 'high>Rest'));
        
        number_of_conditions = length([Flat_greaterthan_Rest_contrast_index Low_greaterthan_Rest_contrast_index Moderate_greaterthan_Rest_contrast_index High_greaterthan_Rest_index]);
        
        this_subject_conn_images = dir(char(fullfile(data_path, subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain', 'con_*')));
         
%         matlabbatch{1}.spm.stats.factorial_design.des.anova.icell(this_subject_index).scans = {
%             fullfile(this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).name)
%             fullfile(this_subject_conn_images(Low_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Low_greaterthan_Rest_contrast_index).name)
%             fullfile(this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).name)
%             fullfile(this_subject_conn_images(High_greaterthan_Rest_index).folder, this_subject_conn_images(High_greaterthan_Rest_index).name)
%          };

matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(this_subject_index).scans = {
    fullfile(this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).name)
    fullfile(this_subject_conn_images(Low_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Low_greaterthan_Rest_contrast_index).name)
    fullfile(this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).name)
    fullfile(this_subject_conn_images(High_greaterthan_Rest_index).folder, this_subject_conn_images(High_greaterthan_Rest_index).name)
            };
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(this_subject_index).conds =[1:number_of_conditions];

%         matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(this_subject_index).scans = {
%             fullfile(this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).name)
%             fullfile(this_subject_conn_images(Low_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Low_greaterthan_Rest_contrast_index).name)
%             fullfile(this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).name)
%             fullfile(this_subject_conn_images(High_greaterthan_Rest_index).folder, this_subject_conn_images(High_greaterthan_Rest_index).name)
%             };
%         matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(this_subject_index).conds = [1:number_of_conditions];
    end
    
elseif strcmp(task_folder, '06_Nback')
     for this_subject_index = 1 : length(subject_codes)
        this_subject_SPM_path = fullfile(data_path, subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Wholebrain', 'SPM.mat');
        this_subject_info_path = fullfile(data_path, subject_codes(this_subject_index), 'subject_info.csv');
        
        this_subject_info = readtable(char(this_subject_info_path));
        
        all_subjects_gender(this_subject_index) = this_subject_info.gender;
        all_subjects_age(this_subject_index) = this_subject_info.age;
        
        load(char(this_subject_SPM_path))
        
        for this_contrast_index = 1:length(SPM.xCon)
            contrasts{this_contrast_index} = SPM.xCon(this_contrast_index).name;
        end
        
        zero_greaterthan_Rest_contrast_index =  find(strcmp(contrasts, 'zero>Rest'));
%          longZero_greaterthan_Rest_contrast_index = find(contains(contrasts, 'long_zero>Rest'));
         one_greaterthan_Rest_contrast_index = find(strcmp(contrasts,'one>Rest'));
%          longOne_greaterthan_Rest_index = find(contains(contrasts, 'long_one>Rest'));
         two_greaterthan_Rest_index =  find(strcmp(contrasts, 'two>Rest'));
%          longTwo_greaterthan_Rest_index = find(contains(contrasts, 'long_two>Rest'));
         three_greaterthan_Rest_index = find(strcmp(contrasts, 'three>Rest'));
%          longThree_greaterthan_Rest_index = find(contains(contrasts, 'long_three>Rest'));
%         
        number_of_conditions = length([zero_greaterthan_Rest_contrast_index one_greaterthan_Rest_contrast_index ...
            two_greaterthan_Rest_index three_greaterthan_Rest_index]);
        
        this_subject_conn_images = dir(char(fullfile(data_path, subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Wholebrain', 'con_*')));
        
%          matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(this_subject_index).scans = {
%             fullfile(this_subject_conn_images(zero_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(zero_greaterthan_Rest_contrast_index).name)
%             fullfile(this_subject_conn_images(one_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(one_greaterthan_Rest_contrast_index).name)
%             fullfile(this_subject_conn_images(two_greaterthan_Rest_index).folder, this_subject_conn_images(two_greaterthan_Rest_index).name)
%             fullfile(this_subject_conn_images(three_greaterthan_Rest_index).folder, this_subject_conn_images(three_greaterthan_Rest_index).name)
%             };
%         matlabbatch{1}.spm.stats.factorial_design.des.anova.icell(this_subject_index).scans = {
%             fullfile(this_subject_conn_images(zero_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(zero_greaterthan_Rest_contrast_index).name)
%             fullfile(this_subject_conn_images(one_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(one_greaterthan_Rest_contrast_index).name)
%             fullfile(this_subject_conn_images(two_greaterthan_Rest_index).folder, this_subject_conn_images(two_greaterthan_Rest_index).name)
%             fullfile(this_subject_conn_images(three_greaterthan_Rest_index).folder, this_subject_conn_images(three_greaterthan_Rest_index).name)
%             };

matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(this_subject_index).scans = {
            fullfile(this_subject_conn_images(zero_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(zero_greaterthan_Rest_contrast_index).name)
            fullfile(this_subject_conn_images(one_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(one_greaterthan_Rest_contrast_index).name)
            fullfile(this_subject_conn_images(two_greaterthan_Rest_index).folder, this_subject_conn_images(two_greaterthan_Rest_index).name)
            fullfile(this_subject_conn_images(three_greaterthan_Rest_index).folder, this_subject_conn_images(three_greaterthan_Rest_index).name)
            };
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(this_subject_index).conds = [1:number_of_conditions];
% matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(2).scans = '<UNDEFINED>';
% matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(2).conds = '<UNDEFINED>';

%         matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(this_subject_index).conds = [1:number_of_conditions];
    end
else
    disp('task folder specified does not exist!!')
end


% imageryscores = [];
% if strcmp(task_folder, '05_MotorImagery')
%     for this_subject_index = 1 : length(subject_codes)
%         this_subject_index_row = find(strcmp(subject_codes(this_subject_index), string(imageryvividness_data(:,1))));
%         imageryscores = [imageryscores; imageryvividness_data(this_subject_index_row,2); imageryvividness_data(this_subject_index_row,3); imageryvividness_data(this_subject_index_row,4); imageryvividness_data(this_subject_index_row,5)] ; 
%     end
%     matlabbatch{1}.spm.stats.factorial_design.cov(1).c = imageryscores;
%     matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'imagery';
% end



% place the age of each subject for each condition
% age_covariate_matrix = [];
% for i_subject = 1 : length(subject_codes)
%     age_covariate_matrix = [age_covariate_matrix; ones(number_of_conditions,1) * all_subjects_age(i_subject)];
% end
% 
% matlabbatch{1}.spm.stats.factorial_design.cov(1).c = [age_covariate_matrix];
% %%
% matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'age';
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1; % what is this??
% matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1; % what is this??
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% place the age of each subject for each condition
gender_covariate_matrix = [];
for i_subject = 1 : length(subject_codes)
    if strcmp(all_subjects_gender(i_subject),'M')
        all_subjects_gender_coded = 1;
    elseif strcmp(all_subjects_gender(i_subject),'F')
        all_subjects_gender_coded = 0;
    else
        disp('gender not identified as M or F')
    end
    gender_covariate_matrix = [gender_covariate_matrix; ones(number_of_conditions,1) * all_subjects_gender_coded];
end

matlabbatch{1}.spm.stats.factorial_design.cov(1).c = [gender_covariate_matrix];

matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'sex';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1; % what is this??
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1; % what is this??
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imageryscores = [];
if strcmp(task_folder, '05_MotorImagery')
    for this_subject_index = 1 : length(subject_codes)
        this_subject_index_row = find(strcmp(subject_codes(this_subject_index), string(imageryvividness_data(:,1))));
        imageryscores = [imageryscores; imageryvividness_data(this_subject_index_row,2); imageryvividness_data(this_subject_index_row,3); imageryvividness_data(this_subject_index_row,4); imageryvividness_data(this_subject_index_row,5)] ; 
    end
    matlabbatch{1}.spm.stats.factorial_design.cov(2).c = imageryscores;
    matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'imagery';
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1; % what is this??
    matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 1; % what is this??
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
% 
matlabbatch{1}.spm.stats.factorial_design.dir = {level2_results_dir};
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.ancova = 0;
% matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {fullfile(data_path, 'ROIs', 'MNI_2mm_gmMask.nii')};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

if create_model_and_estimate
    if exist(fullfile(level2_results_dir,'SPM.mat'),'file')
        rmdir(level2_results_dir, 's')
    end    
    spm_jobman('run',matlabbatch);
end
clear matlabbatch


%%
a = spm_select('FPList', level2_results_dir,'SPM.mat');%SPM.mat file
matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr(a);
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
% 

if create_model_and_estimate
    spm_jobman('run',matlabbatch);
end
clear matlabbatch

load(fullfile(level2_results_dir,'SPM.mat'))

b = spm_select('FPList', level2_results_dir,'SPM.mat');%SPM.mat file
matlabbatch{1}.spm.stats.con.spmmat = cellstr(b);

matlabbatch{1}.spm.stats.con.consess{1}.fcon.name = 'linear increase';
matlabbatch{1}.spm.stats.con.consess{1}.fcon.weights = [1 -1 0 0 zeros(1,length(subject_codes)); 0 1 -1 0 zeros(1,length(subject_codes)); 0 0 1 -1 zeros(1,length(subject_codes))];
matlabbatch{1}.spm.stats.con.consess{1}.fcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{2}.fcon.name = 'linear decrease';
matlabbatch{1}.spm.stats.con.consess{2}.fcon.weights = [-1 1 0 0 zeros(1,length(subject_codes)); 0 -1 1 0 zeros(1,length(subject_codes)); 0 0 -1 1 zeros(1,length(subject_codes))];
matlabbatch{1}.spm.stats.con.consess{2}.fcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.delete = 1; %this deletes the previously existing contrasts; set to 0 if you do not want to delete previous contrasts!
% 
spm_jobman('run',matlabbatch);
clear matlabbatch
end