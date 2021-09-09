function update_spm_file_paths(varargin)
% plot_CAT12_results('task_folder', '05_MotorImagery', 'subjects',
% plot_CAT12_results('task_folder', '02_T1', 'subjects', {'1002','1004','1007','1009','1010','1011','1013','1020','1022','1027','1024','2021','2015','2002','2018','2017','2012','2025','2020','2026','2023','2022','2007','2013','2008','2033','2034','2037','2052','2042','3004','3006','3007','3008'},'group_names',{'YA' 'hOA' 'lOA'},'group_ids',[1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3],'save_figures',0, 'no_labels', 0)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'subjects', '')
% addParameter(parser, 'path_to_newfiles', '');
addParameter(parser, 'results_dir', '');
parse(parser, varargin{:})
subjects = parser.Results.subjects;
% path_to_newfiles = parser.Results.path_to_newfiles;
results_dir = parser.Results.results_dir;
data_path = pwd;

% results_drive = 'G:\Shared drives\GABA_Aging_MoCap';
% image_drive = 'G:\Shared drives\GABA_Aging_Brain_Structure\BRAIN_DATA';

% The goal of this function is to find the 1) "path_to_newfiles" for each
% "subect", 2) read the spm.mat in "results_dir", 3) make sure the order of
% subjects is the same as original (if not throw error fullstop), 4) if all
% good then go ahead and updated SPM.xY.P = new_paths ( { 'path1'; 'path2';
% 'path3' } ) ... save results_dir/SPM

load(fullfile(data_path,results_dir,'SPM'))

scans = {};
for this_subject_index = 1 : length(subjects)
   % gdrive
%     this_subject_t1_path = fullfile(image_drive, subjects{this_subject_index}, '\01_CAT12_v1725\mri', strcat('s8_mwp1T1_',subjects{this_subject_index},'.nii'));
   % HG
       this_subject_t1_path = fullfile(data_path, subjects{this_subject_index}, 'structural_metrics', strcat('s8_mwp1T1_',subjects{this_subject_index},'.nii'));
    scans = [scans; this_subject_t1_path];
end

SPM.swd = fullfile(data_path,results_dir);
SPM.xY.P = scans;
for this_scan = 1:length(scans)
    SPM.xY.VY(this_scan).fname = scans{this_scan};
end
save(fullfile(data_path,results_dir, 'SPM'), 'SPM')
