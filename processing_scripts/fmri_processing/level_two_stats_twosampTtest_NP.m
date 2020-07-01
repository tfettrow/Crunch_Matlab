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
condition='high'; % need to run once per condition (flat,low,medium,high)
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

level2_results_dir = fullfile(data_path, 'Level2_Results_twosampTtestNP', 'MRI_files', task_folder, condition);

matlabbatch{1}.spm.tools.snpm.des.TwoSampT.DesignName = '2 Groups: Two Sample T test; 1 scan per subject';
matlabbatch{1}.spm.tools.snpm.des.TwoSampT.DesignFile = 'snpm_bch_ui_TwoSampT';
matlabbatch{1}.spm.tools.snpm.des.TwoSampT.dir = {level2_results_dir};


group_one_scans = [];
for this_subject_index = 1 : length(group_one_subject_codes)
    
    this_subject_SPM_path = fullfile(data_path, group_one_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Results', 'SPM.mat');
    this_subject_info_path = fullfile(data_path, group_one_subject_codes(this_subject_index), 'subject_info.csv');
    
    load(char(this_subject_SPM_path))
    for this_contrast_index = 1:length(SPM.xCon)
        contrasts{this_contrast_index} = SPM.xCon(this_contrast_index).name;
    end
    
        Flat_greaterthan_Rest_contrast_index =  find(contains(contrasts, 'flat>Rest'));
        Low_greaterthan_Rest_contrast_index = find(contains(contrasts, 'low>Rest'));
        Moderate_greaterthan_Rest_contrast_index =  find(contains(contrasts, 'medium>Rest'));
        High_greaterthan_Rest_index = find(contains(contrasts, 'high>Rest'));

    
    this_subject_conn_images = dir(char(fullfile(data_path, group_one_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Results', 'con*')));
    
    group_one_scans = [group_one_scans; fullfile(this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).name); ...
            fullfile(this_subject_conn_images(Low_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Low_greaterthan_Rest_contrast_index).name); ....
            fullfile(this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).name); ...
            fullfile(this_subject_conn_images(High_greaterthan_Rest_index).folder, this_subject_conn_images(High_greaterthan_Rest_index).name)];
end

group_two_scans = [];
for this_subject_index = 1 : length(group_two_subject_codes)
    
    this_subject_SPM_path = fullfile(data_path, group_two_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Results', 'SPM.mat');
    
    load(char(this_subject_SPM_path))
    for this_contrast_index = 1:length(SPM.xCon)
        contrasts{this_contrast_index} = SPM.xCon(this_contrast_index).name;
    end
    
 Flat_greaterthan_Rest_contrast_index =  find(contains(contrasts, 'flat>Rest'));
        Low_greaterthan_Rest_contrast_index = find(contains(contrasts, 'low>Rest'));
        Moderate_greaterthan_Rest_contrast_index =  find(contains(contrasts, 'medium>Rest'));
        High_greaterthan_Rest_index = find(contains(contrasts, 'high>Rest'));
    
    this_subject_conn_images = dir(char(fullfile(data_path, group_two_subject_codes(this_subject_index), 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_Results', 'con*')));
    
    group_two_scans = [group_two_scans; fullfile(this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Flat_greaterthan_Rest_contrast_index).name); ...
            fullfile(this_subject_conn_images(Low_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Low_greaterthan_Rest_contrast_index).name); ....
            fullfile(this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).folder, this_subject_conn_images(Moderate_greaterthan_Rest_contrast_index).name); ...
            fullfile(this_subject_conn_images(High_greaterthan_Rest_index).folder, this_subject_conn_images(High_greaterthan_Rest_index).name)];
    
end

matlabbatch{1}.spm.tools.snpm.des.TwoSampT.scans1 = cellstr(group_one_scans);
matlabbatch{1}.spm.tools.snpm.des.TwoSampT.scans2 = cellstr(group_two_scans);


imageryscores = [];
for this_subject_index = 1 : length(group_one_subject_codes)
    this_subject_index_row = find(strcmp(group_one_subject_codes(this_subject_index), string(imageryvividness_data(:,1))));
    imageryscores = [imageryscores; imageryvividness_data(this_subject_index_row,2); imageryvividness_data(this_subject_index_row,3); imageryvividness_data(this_subject_index_row,4); imageryvividness_data(this_subject_index_row,5)] ;
end
for this_subject_index = 1 : length(group_two_subject_codes)
    this_subject_index_row = find(strcmp(group_two_subject_codes(this_subject_index), string(imageryvividness_data(:,1))));
    imageryscores = [imageryscores; imageryvividness_data(this_subject_index_row,2); imageryvividness_data(this_subject_index_row,3); imageryvividness_data(this_subject_index_row,4); imageryvividness_data(this_subject_index_row,5)] ;
end

%%
matlabbatch{1}.spm.tools.snpm.des.TwoSampT.cov(1).c = imageryscores;
matlabbatch{1}.spm.tools.snpm.des.TwoSampT.cov(1).cname = 'imagery scores';

matlabbatch{1}.spm.tools.snpm.des.TwoSampT.nPerm = 10000;
matlabbatch{1}.spm.tools.snpm.des.TwoSampT.vFWHM = [0 0 0];
matlabbatch{1}.spm.tools.snpm.des.TwoSampT.bVolm = 1;
matlabbatch{1}.spm.tools.snpm.des.TwoSampT.ST.ST_none = 0;
matlabbatch{1}.spm.tools.snpm.des.TwoSampT.masking.tm.tm_none = 1;
matlabbatch{1}.spm.tools.snpm.des.TwoSampT.masking.im = 1;
matlabbatch{1}.spm.tools.snpm.des.TwoSampT.masking.em = {''};
matlabbatch{1}.spm.tools.snpm.des.TwoSampT.globalc.g_omit = 1;
matlabbatch{1}.spm.tools.snpm.des.TwoSampT.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.tools.snpm.des.TwoSampT.globalm.glonorm = 1;

if create_model_and_estimate
    if exist(fullfile(level2_results_dir,'SPM.mat'),'file')
        rmdir(level2_results_dir, 's')
    end    
    spm_jobman('run',matlabbatch);
end
clear matlabbatch

%%  Compute
% matlabbatch{1}.spm.tools.snpm.cp.snpmcfg = {strcat(level2_results_dir, filesep, 'SnPMcfg.mat')};
% spm_jobman('run',matlabbatch);
% clear matlabbatch

%% Inference/Results
% matlabbatch{1}.spm.tools.snpm.cp.snpmcfg = {'M:\share\FromExternal\Research_Projects_UF\NASA_GT\AGBRESA_Level_Two\SnPM_ttest\SnPMcfg.mat'};

matlabbatch{1}.spm.tools.snpm.inference.SnPMmat = {strcat(level2_results_dir, filesep, 'SnPMcfg.mat')};
matlabbatch{1}.spm.tools.snpm.inference.Thr.Vox.VoxSig.Pth = 0.001;
matlabbatch{1}.spm.tools.snpm.inference.Tsign = 1;
matlabbatch{1}.spm.tools.snpm.inference.WriteFiltImg.WF_no = 0;
matlabbatch{1}.spm.tools.snpm.inference.Report = 'MIPtable';

spm_jobman('run',matlabbatch);
clear matlabbatch
end