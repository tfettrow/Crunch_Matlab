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


function level_two_stats_betweenGroup(create_model_and_estimate, task_folder, group_one_subject_codes, group_two_subject_codes)
create_model_and_estimate=1;
task_folder = '05_MotorImagery';

group_one_subject_codes = {'1002', '1004', '1010', '1011','1013'}; % need to figure out how to pass cell from shell
group_two_subject_codes =  {'2002','2007','2008','2012','2013','2015','2018','2020','2021','2022','2023','2025','2026'};

group_one_subject_codes = split(group_one_subject_codes,",");
group_two_subject_codes = split(group_two_subject_codes,",");

data_path = pwd; % assuming shell script places wd as study level folder
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

level2_results_dir = fullfile(data_path, 'betweenGroup_Results_3Fac', 'MRI_files', task_folder);
% 
matlabbatch{1}.spm.stats.factorial_design.dir = {level2_results_dir};
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'subject';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 0; % 0=independence yes
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 1; % 0 = variance unequal
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).name = 'group';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).name = 'condition';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(3).ancova = 0;

% seems a bit redundant but lets go with it for now
if strcmp(task_folder, '05_MotorImagery')
    group_one_scans = [];
    group_one_conditions=[];
    number_of_subjects = 1;
    for this_subject_index = 1 : length(group_one_subject_codes)
        
        this_subject_SPM_path = fullfile(data_path, group_one_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Results', 'SPM.mat');
        this_subject_info_path = fullfile(data_path, group_one_subject_codes(this_subject_index), 'subject_info.csv');
        
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
        
        this_subject_conn_images = dir(char(fullfile(data_path, group_one_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Results', 'con*')));
        number_of_conditions = length([Flat_greaterthan_Rest_contrast_index Low_greaterthan_Rest_contrast_index Moderate_greaterthan_Rest_contrast_index High_greaterthan_Rest_index]);
        
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(number_of_subjects).scans = {fullfile(this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).name); ...
            fullfile(this_subject_conn_images(Low_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Low_greaterthan_Rest_contrast_index).name); ....
            fullfile(this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).name); ...
            fullfile(this_subject_conn_images(High_greaterthan_Rest_index).folder, this_subject_conn_images(High_greaterthan_Rest_index).name)};
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(number_of_subjects).conds = [1 1; 1 2; 1 3; 1 4];
        number_of_subjects = number_of_subjects + 1;
    end
    
    group_two_scans = [];
    group_two_conditions=[];
    for this_subject_index = 1 : length(group_two_subject_codes)
        
        this_subject_SPM_path = fullfile(data_path, group_two_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Results', 'SPM.mat');
        this_subject_info_path = fullfile(data_path, group_two_subject_codes(this_subject_index), 'subject_info.csv');
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
        
        this_subject_conn_images = dir(char(fullfile(data_path, group_two_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Results', 'con*')));
        number_of_conditions = length([Flat_greaterthan_Rest_contrast_index Low_greaterthan_Rest_contrast_index Moderate_greaterthan_Rest_contrast_index High_greaterthan_Rest_index]);
        
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(number_of_subjects).scans = {fullfile(this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).name); ...
            fullfile(this_subject_conn_images(Low_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Low_greaterthan_Rest_contrast_index).name); ....
            fullfile(this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).name); ...
            fullfile(this_subject_conn_images(High_greaterthan_Rest_index).folder, this_subject_conn_images(High_greaterthan_Rest_index).name)};
        matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(number_of_subjects).conds = [2 1; 2 2; 2 3; 2 4];
    number_of_subjects = number_of_subjects + 1;
    end  
    
%     matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(1).scans = cellstr(group_one_scans);
%     matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(1).conds = group_one_conditions;
%     matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(2).scans = cellstr(group_two_scans);
%     matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(2).conds = group_two_conditions;
    
else
    disp('task folder specified does not exist!!')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{2}.fmain.fnum = 3;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{3}.inter.fnums = [2 3];

% matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum =[1 1]; 
% matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{2}.fmain.fnum = [2 3]; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
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

    % equations for contrast (see Glascher and Gitelman (2008) http://www.sbirc.ed.ac.uk/cyril/download/Contrast_Weighting_Glascher_Gitelman_2008.pdf
    n1 = 4;
    n2 = 13;
    nc=4;
    ng=2;
    MEc=[1:nc]-mean(1:nc); %Main effect condition
    MEg_ya = [1 -1];  %g1>g2
    MEg_oa = [-1 1];  %g2>g2
     
    %Main effect of group
    first = MEg_ya;
    second = zeros(1,nc);
    third = ones(1,nc)/nc;
    fourth = -ones(1,nc)/nc;
    main_effect_contrast_group_ya_gt_oa = [first second third fourth];
    
    %Main effect of group
    first = MEg_oa;
    second = zeros(1,nc);
    third = -ones(1,nc)/nc;
    fourth = ones(1,nc)/nc;
    main_effect_contrast_group_oa_gt_ya = [first second third fourth];
    
% Main effect of condition
    first = zeros(1,ng);
    second = MEc;
    third = MEc*[n1/(n1+n2)];
    fourth = MEc*[n2/(n1+n2)];
    main_effect_contrast_condition = [first second third fourth];
    
    
    %% vvv these do not make sense  vv %%
    %Interaction group x condition
    first = zeros(1,ng);
    second = zeros(1,nc);
    third = MEc;
    fourth = -MEc;
    interaction_contrast_ya_gt_oa = [first second third fourth];
    
    %Interaction group x condition
    first = zeros(1,ng);
    second = zeros(1,nc);
    third = -MEc;
    fourth = MEc;
    interaction_contrast_oa_gt_ya = [first second third fourth];
    
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Main effect group_ya_gt_oa';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = main_effect_contrast_group_ya_gt_oa;
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Main effect group_oa_gt_ya';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = main_effect_contrast_group_oa_gt_ya;
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Main effect condition';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = main_effect_contrast_condition;
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    
%     matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Interaction_ya_gt_oa';
%     matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = interaction_contrast_ya_gt_oa;
%     matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
%     
%     matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'Interaction_oa_gt_ya';
%     matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = interaction_contrast_oa_gt_ya;
%     matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

    
    
%     matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'low>Rest';
%     matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 1 0 0];
%     matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
%     
%     matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'low>Rest';
%     matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 1 0 0];
%     matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
%     
%     matlabbatch{1}.spm.stats.con.consess{4}.tcon.name =  'medium>Rest';
%     matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [0 0 1 0];
%     matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
%     
%     matlabbatch{1}.spm.stats.con.consess{5}.tcon.name =  'hard>Rest';
%     matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 1];
%     matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
end

% 
% 
matlabbatch{1}.spm.stats.con.delete = 1; %this deletes the previously existing contrasts; set to 0 if you do not want to delete previous contrasts!
% 
spm_jobman('run',matlabbatch);
clear matlabbatch

%v%%%%%%% Main Effect
% data_path = ['/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/SWM_AS/Cerebellum/CB/maineffect'];
% b = spm_select('FPList', data_path,'SPM.mat');%SPM.mat file
% matlabbatch{1}.spm.stats.con.spmmat = cellstr(b);
%
% %001 = ACTIVATION
% matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Main effect activation';
% matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 1 1 1 1 1];
% matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
%
% %002 = DEACTIVATION
% matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Main effect deactivation';
% matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [-1 -1 -1 -1 -1 -1];
% matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
%
% matlabbatch{1}.spm.stats.con.delete = 1; %this deletes the previously existing contrasts; set to 0 if you do not want to delete previous contrasts!
%
% spm_jobman('run',matlabbatch);
end

