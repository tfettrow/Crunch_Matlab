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


function level_two_stats_fmri_withinGroup(create_model_and_estimate, task_folder, subject_codes, group_name)

% RUN THIS FUNCTION ONCE PER GROUP (youngAdult, oldAdult) AND TASK (Motor Imagery, Nback)

create_model_and_estimate=1;
task_folder='05_MotorImagery';
%task_folder = '06_Nback';
 subject_codes = {'1002','1004','1007','1009','1010','1011','1012','1013','1017','1018','1019','1020','1022','1024','1025','1026','1027'};
%subject_codes = {'2002','2015','2018','2012','2025','2020'};
% subject_codes =  {'2002','2007','2008','2012','2013','2015','2018','2020','2021','2022','2023','2025','2026'}; % need to write script to pass cell from shell
group_name='YA';
% group_name='oldAdult';

% cd 'spreadsheet_data'
headers={'subject_id', 'flat', 'low', 'medium', 'high'};
imageryvividness_data = xlsread(strcat('spreadsheet_data', filesep, 'imagery_data', filesep, 'imageryvividness_data.xlsx'));
% cd ..

subject_codes = split(subject_codes,",");

data_path = pwd; % assuming shell script places wd as study level folder
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

level2_results_dir = fullfile(data_path, 'Results_fmri_withinGroup', 'MRI_files', task_folder, group_name);

matlabbatch{1}.spm.stats.factorial_design.dir = {level2_results_dir};
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'subject';
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 0;
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 0;
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'Repetition';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;

% seems a bit redundant but lets go with it for now
if strcmp(task_folder, '05_MotorImagery')
    for this_subject_index = 1 : length(subject_codes)
       
        this_subject_SPM_path = fullfile(data_path, subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Results', 'SPM.mat');
        this_subject_info_path = fullfile(data_path, subject_codes(this_subject_index), 'subject_info.csv');
        
        this_subject_info = readtable(char(this_subject_info_path));
        
        all_subjects_gender(this_subject_index) = this_subject_info.gender;
        all_subjects_age(this_subject_index) = this_subject_info.age;

        load(char(this_subject_SPM_path))
        for this_contrast_index = 1:length(SPM.xCon)
            contrasts{this_contrast_index} = SPM.xCon(this_contrast_index).name;
        end
        
        Flat_greaterthan_Rest_contrast_index = find(contains(contrasts, 'flat>Rest'));
        Low_greaterthan_Rest_contrast_index = find(contains(contrasts, 'low>Rest'));
        Moderate_greaterthan_Rest_contrast_index = find(contains(contrasts, 'medium>Rest'));
        High_greaterthan_Rest_index = find(contains(contrasts, 'high>Rest'));
        
        number_of_conditions = length([Flat_greaterthan_Rest_contrast_index Low_greaterthan_Rest_contrast_index Moderate_greaterthan_Rest_contrast_index High_greaterthan_Rest_index]);
        
        this_subject_conn_images = dir(char(fullfile(data_path, subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Results', 'con_*')));
        
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(this_subject_index).scans = {
            fullfile(this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).name)
            fullfile(this_subject_conn_images(Low_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Low_greaterthan_Rest_contrast_index).name)
            fullfile(this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).name)
            fullfile(this_subject_conn_images(High_greaterthan_Rest_index).folder, this_subject_conn_images(High_greaterthan_Rest_index).name)
            };
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(this_subject_index).conds = [1:number_of_conditions];
    end
    
elseif strcmp(task_folder, '06_Nback')
     for this_subject_index = 1 : length(subject_codes)
        this_subject_SPM_path = fullfile(data_path, subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Results', 'SPM.mat');
        this_subject_info_path = fullfile(data_path, subject_codes(this_subject_index), 'subject_info.csv');
        
        this_subject_info = readtable(char(this_subject_info_path));
        
        all_subjects_gender(this_subject_index) = this_subject_info.gender;
        all_subjects_age(this_subject_index) = this_subject_info.age;
        
        load(char(this_subject_SPM_path))
        
        for this_contrast_index = 1:length(SPM.xCon)
            contrasts{this_contrast_index} = SPM.xCon(this_contrast_index).name;
        end
        
         shortZero_greaterthan_Rest_contrast_index = find(contains(contrasts, 'short_zero>Rest'));
         longZero_greaterthan_Rest_contrast_index = find(contains(contrasts, 'long_zero>Rest'));
         shortOne_greaterthan_Rest_contrast_index = find(contains(contrasts, 'short_one>Rest'));
         longOne_greaterthan_Rest_index = find(contains(contrasts, 'long_one>Rest'));
         shortTwo_greaterthan_Rest_index = find(contains(contrasts, 'short_two>Rest'));
         longTwo_greaterthan_Rest_index = find(contains(contrasts, 'long_two>Rest'));
         shortThree_greaterthan_Rest_index = find(contains(contrasts, 'short_three>Rest'));
         longThree_greaterthan_Rest_index = find(contains(contrasts, 'long_three>Rest'));
%         
        number_of_conditions = length([shortZero_greaterthan_Rest_contrast_index longZero_greaterthan_Rest_contrast_index shortOne_greaterthan_Rest_contrast_index longOne_greaterthan_Rest_index ...
            shortTwo_greaterthan_Rest_index longTwo_greaterthan_Rest_index shortThree_greaterthan_Rest_index longThree_greaterthan_Rest_index]);
        
        this_subject_conn_images = dir(char(fullfile(data_path, subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Results', 'con*')));
        
         matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(this_subject_index).scans = {
            fullfile(this_subject_conn_images(shortZero_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(shortZero_greaterthan_Rest_contrast_index).name)
            fullfile(this_subject_conn_images(longZero_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(longZero_greaterthan_Rest_contrast_index).name)
            fullfile(this_subject_conn_images(shortOne_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(shortOne_greaterthan_Rest_contrast_index).name)
            fullfile(this_subject_conn_images(longOne_greaterthan_Rest_index).folder, this_subject_conn_images(longOne_greaterthan_Rest_index).name)
            fullfile(this_subject_conn_images(shortTwo_greaterthan_Rest_index).folder, this_subject_conn_images(shortTwo_greaterthan_Rest_index).name)
            fullfile(this_subject_conn_images(longTwo_greaterthan_Rest_index).folder, this_subject_conn_images(longTwo_greaterthan_Rest_index).name)
            fullfile(this_subject_conn_images(shortThree_greaterthan_Rest_index).folder, this_subject_conn_images(shortThree_greaterthan_Rest_index).name)
            fullfile(this_subject_conn_images(longThree_greaterthan_Rest_index).folder, this_subject_conn_images(longThree_greaterthan_Rest_index).name)
            };
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(this_subject_index).conds = [1:number_of_conditions];
    end
else
    disp('task folder specified does not exist!!')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 1; % factors to include
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{2}.fmain.fnum = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

% place the age of each subject for each condition
age_covariate_matrix = [];
for i_subject = 1 : length(subject_codes)
    age_covariate_matrix = [age_covariate_matrix; ones(number_of_conditions,1) * all_subjects_age(i_subject)];
end

matlabbatch{1}.spm.stats.factorial_design.cov(1).c = [age_covariate_matrix];
%%
matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'age';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1; % what is this??
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1; % what is this??
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

matlabbatch{1}.spm.stats.factorial_design.cov(2).c = [gender_covariate_matrix];

matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'sex';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1; % what is this??
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 1; % what is this??
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imageryscores = [];
if strcmp(task_folder, '05_MotorImagery')
    for this_subject_index = 1 : length(subject_codes)
        this_subject_index_row = find(strcmp(subject_codes(this_subject_index), string(imageryvividness_data(:,1))));
        imageryscores = [imageryscores; imageryvividness_data(this_subject_index_row,2); imageryvividness_data(this_subject_index_row,3); imageryvividness_data(this_subject_index_row,4); imageryvividness_data(this_subject_index_row,5)] ; 
    end
    matlabbatch{1}.spm.stats.factorial_design.cov(3).c = imageryscores;
    matlabbatch{1}.spm.stats.factorial_design.cov(3).cname = 'imagery';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
matlabbatch{1}.spm.stats.factorial_design.cov(3).iCFI = 1; % what is this??
matlabbatch{1}.spm.stats.factorial_design.cov(3).iCC = 1; % what is this??
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_mean = 1;
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

%%

load(fullfile(level2_results_dir,'SPM.mat'))

b = spm_select('FPList', level2_results_dir,'SPM.mat');%SPM.mat file
matlabbatch{1}.spm.stats.con.spmmat = cellstr(b);

if strcmp(task_folder, '05_MotorImagery')  

    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Main effect activation';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 1 1 1];
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'flat>Rest';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [1 0 0 0];
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'low>Rest';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 1 0 0];
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name =  'medium>Rest';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [0 0 1 0];
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name =  'hard>Rest';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 1];
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
end

if strcmp(task_folder, '06_Nback')  
    
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Main effect activation';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 1 1 1 1 1 1 1];
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'zero>Rest';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [1 1 0 0 0 0 0 0];
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'one>Rest';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 0 1 1 0 0 0 0];
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'two>Rest';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 0 1 1 0 0];
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'three>Rest';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 0 0 1 1];
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

%     matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'short_zero>Rest';
%     matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [1 0 0 0 0 0 0 0];
%     matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
%         
%     matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'long_zero>Rest';
%     matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 1 0 0 0 0 0 0];
%     matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
%     
%     matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'short_one>Rest';
%     matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [0 0 1 0 0 0 0 0];
%     matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
%     
%     matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'long_one>Rest';
%     matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 1 0 0 0 0];
%     matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
%  
%     matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'short_two>Rest';
%     matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = [0 0 0 0 1 0 0 0];
%     matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
%  
%     matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'long_two>Rest';
%     matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = [0 0 0 0 0 1 0 0];
%     matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
%     
%     matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'short_three>Rest';
%     matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = [0 0 0 0 0 0 1 0];
%     matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
%     
%     matlabbatch{1}.spm.stats.con.consess{9}.tcon.name = 'long_three>Rest';
%     matlabbatch{1}.spm.stats.con.consess{9}.tcon.weights = [0 0 0 0 0 0 0 1];
%     matlabbatch{1}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
%     
    
end

% 
% 
matlabbatch{1}.spm.stats.con.delete = 1; %this deletes the previously existing contrasts; set to 0 if you do not want to delete previous contrasts!
% 
spm_jobman('run',matlabbatch);
clear matlabbatch
end

