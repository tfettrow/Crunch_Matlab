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


function level_two_stats_fmri_twosampTtest(create_model_and_estimate, task_folder, group_one_subject_codes, group_two_subject_codes)
create_model_and_estimate=1;
task_folder = '05_MotorImagery';
condition='all'; % need to run once per condition (all,flat,low,medium,high)
group_one_subject_codes = {'1002', '1004', '1010', '1011'}; % need to figure out how to pass cell from shell
group_two_subject_codes =  {'2002','2007','2008','2012','2013','2015','2018','2020','2021','2022','2023','2025','2026'};

group_one_subject_codes = split(group_one_subject_codes,",");
group_two_subject_codes = split(group_two_subject_codes,",");

data_path = pwd; % assuming shell script places wd as study level folder
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

headers={'subject_id', 'flat', 'low', 'medium', 'high'};
imageryvividness_data = xlsread(strcat('spreadsheet_data', filesep, 'imagery_data', filesep, 'imageryvividness_data.xlsx'));

level2_results_dir = fullfile(data_path, 'Results_fmri_twosampTtest', 'MRI_files', task_folder, condition);

matlabbatch{1}.spm.stats.factorial_design.dir = {level2_results_dir};
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;

group_one_scans = [];
for this_subject_index = 1 : length(group_one_subject_codes)
    
    this_subject_SPM_path = fullfile(data_path, group_one_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Results', 'SPM.mat');
    this_subject_info_path = fullfile(data_path, group_one_subject_codes(this_subject_index), 'subject_info.csv');
    
    load(char(this_subject_SPM_path))
    for this_contrast_index = 1:length(SPM.xCon)
        contrasts{this_contrast_index} = SPM.xCon(this_contrast_index).name;
    end
    
    if strcmp(condition,'flat')
        condition_spm_index =  find(contains(contrasts, 'flat>Rest'));
    elseif strcmp(condition,'low')
        condition_spm_index = find(contains(contrasts, 'low>Rest'));
    elseif strcmp(condition,'medium')
        condition_spm_index =  find(contains(contrasts, 'medium>Rest'));
    elseif strcmp(condition,'high')
        condition_spm_index = find(contains(contrasts, 'high>Rest'));
    end
    
    this_subject_conn_images = dir(char(fullfile(data_path, group_one_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Results', 'con*')));
    
    group_one_scans = [group_one_scans; fullfile(this_subject_conn_images(condition_spm_index).folder, this_subject_conn_images(condition_spm_index).name)];
end
group_two_scans = [];
for this_subject_index = 1 : length(group_two_subject_codes)
    
    this_subject_SPM_path = fullfile(data_path, group_two_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Results', 'SPM.mat');
    
    load(char(this_subject_SPM_path))
    for this_contrast_index = 1:length(SPM.xCon)
        contrasts{this_contrast_index} = SPM.xCon(this_contrast_index).name;
    end
    
    if strcmp(condition,'flat')
        condition_spm_index =  find(contains(contrasts, 'flat>Rest'));
    elseif strcmp(condition,'low')
        condition_spm_index = find(contains(contrasts, 'low>Rest'));
    elseif strcmp(condition,'medium')
        condition_spm_index =  find(contains(contrasts, 'medium>Rest'));
    elseif strcmp(condition,'high')
        condition_spm_index = find(contains(contrasts, 'high>Rest'));
    elseif strcmp(condition,'main')
        condition_spm_index = find(contains(contrasts, 'main effect'));
    end
    
    this_subject_conn_images = dir(char(fullfile(data_path, group_two_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Results', 'con*')));
    
    group_two_scans = [group_two_scans; fullfile(this_subject_conn_images(condition_spm_index).folder, this_subject_conn_images(condition_spm_index).name)];
    
end


matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = cellstr(group_one_scans);
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = cellstr(group_two_scans);

imageryscores = [];
for this_subject_index = 1 : length(group_one_subject_codes)
    this_subject_index_row = find(strcmp(group_one_subject_codes(this_subject_index), string(imageryvividness_data(:,1))));
    imageryscores = [imageryscores; imageryvividness_data(this_subject_index_row,2); imageryvividness_data(this_subject_index_row,3); imageryvividness_data(this_subject_index_row,4); imageryvividness_data(this_subject_index_row,5)] ;
end
for this_subject_index = 1 : length(group_two_subject_codes)
    this_subject_index_row = find(strcmp(group_two_subject_codes(this_subject_index), string(imageryvividness_data(:,1))));
    imageryscores = [imageryscores; imageryvividness_data(this_subject_index_row,2); imageryvividness_data(this_subject_index_row,3); imageryvividness_data(this_subject_index_row,4); imageryvividness_data(this_subject_index_row,5)] ;
end

% matlabbatch{1}.spm.stats.factorial_design.cov.c = imageryscores;
% matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'imagery';
% matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
% matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 0;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
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

%%

load(fullfile(level2_results_dir,'SPM.mat'))

b = spm_select('FPList', level2_results_dir,'SPM.mat');%SPM.mat file
matlabbatch{1}.spm.stats.con.spmmat = cellstr(b);

% if strcmp(task_folder, '05_MotorImagery')  

    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'young>old';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'old>young';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.delete = 1; %this deletes the previously existing contrasts; set to 0 if you do not want to delete previous contrasts!
% 
spm_jobman('run',matlabbatch);
clear matlabbatch

end

