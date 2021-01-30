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


function level_two_stats_structural_twosampTtest(create_model_and_estimate, task_folder, group_one_subject_codes, group_two_subject_codes)
create_model_and_estimate=1;
t1_folder = '02_T1';
% condition='all'; % need to run once per condition (all,flat,low,medium,high)
% group_one_subject_codes = {'1002','1004','1007','1009'}; % need to figure out how to pass cell from shell
% group_two_subject_codes =  {'2007','2008','2012','2013'};
% 
% group_one_subject_codes = {'1002','1004','1007','1009','1010','1011','1013','1020','1022','1024','1027'}; % need to figure out how to pass cell from shell
% group_two_subject_codes =  {'2002','2007','2008','2012','2013','2015','2017','2018','2020','2021','2022','2023','2025','2026','2033','2034','2037','2042','2052'};

group_one_subject_codes = {'2002','2007','2008','2012','2013','2015','2017','2018','2020','2021','2022','2023','2025','2026','2033','2034','2037','2042','2052'}; % need to figure out how to pass cell from shell
group_two_subject_codes =  {'3004', '3006', '3007', '3008'};

group_one_subject_codes = split(group_one_subject_codes,",");
group_two_subject_codes = split(group_two_subject_codes,",");

data_path = pwd; % assuming shell script places wd as study level folder
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

for this_subject_index = 1 : length(group_one_subject_codes)
     this_subject_path = strcat([data_path filesep group_one_subject_codes{this_subject_index} filesep 'Processed' filesep 'MRI_files' filesep t1_folder filesep 'CAT12_Analysis']);
     group_one_scans{this_subject_index,:} = spm_select('ExtFPList', strcat(this_subject_path,filesep,'mri',filesep), strcat('^','smoothed_mwp1T1.nii','$'));
     this_subject_tiv_file = spm_select('FPList', strcat(this_subject_path,filesep), strcat('^','TIV.txt','$'));
     
     % read tiv info
     volume_data = load(this_subject_tiv_file);
     group_one_tiv(this_subject_index) = volume_data(1);
end

for this_subject_index = 1 : length(group_two_subject_codes)
    this_subject_path = strcat([data_path filesep group_two_subject_codes{this_subject_index} filesep 'Processed' filesep 'MRI_files' filesep t1_folder filesep 'CAT12_Analysis']);
    group_two_scans{this_subject_index,:} = spm_select('ExtFPList', strcat(this_subject_path,filesep,'mri',filesep), strcat('^','smoothed_mwp1T1.nii','$'));
    group_two_xml_files{this_subject_index,:} = spm_select('FPList', strcat(this_subject_path,filesep,'report',filesep), strcat('^','cat_T1.xml','$'));
    this_subject_tiv_file = spm_select('FPList', strcat(this_subject_path,filesep), strcat('^','TIV.txt','$'));
    
     % read tiv info
     volume_data = load(this_subject_tiv_file);
     group_two_tiv(this_subject_index) = volume_data(1);
end

level2_results_dir = fullfile(data_path, 'Results_structural_twosampTtest_hOA_lOA'); 
matlabbatch{1}.spm.stats.factorial_design.dir = {level2_results_dir};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = cellstr(group_one_scans);
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = cellstr(group_two_scans);
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;

% populating TIV as first cov
% need to read the TIV out of each xml file
matlabbatch{1}.spm.stats.factorial_design.cov(1).c = [group_one_tiv group_two_tiv];
matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'TIV';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1; % what is this??
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1; % what is this??
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});

matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
% matlabbatch{1}.spm.stats.factorial_design.masking.tm.tmr.rthresh = 0.1; % relative threshold of .1
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tma.athresh = .1; % absolute threshold of .1
% matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1; % no threshold
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {fullfile(data_path, 'ROIs', 'MNI_2mm_gmMask.nii')}; % no explicit mask
% matlabbatch{1}.spm.stats.factorial_design.masking.em = {'\\exasmb.rc.ufl.edu\blue\rachaelseidler\tfettrow\Crunch_Code\MR_Templates\mask_ICV.nii,1'};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
% matlabbatch{2}.spm.tools.cat.tools.check_SPM.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
% matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.use_unsmoothed_data = 1;
% matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.adjust_data = 1;
% matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.outdir = {''};
% matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.fname = 'CATcheckdesign_';
% matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.save = 0;
% matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_ortho = 1;

if create_model_and_estimate
    if exist(fullfile(level2_results_dir,'SPM.mat'),'file')
        rmdir(level2_results_dir, 's')
    end
    spm_jobman('run',matlabbatch);
end
clear matlabbatch


a = spm_select('FPList', level2_results_dir,'SPM.mat');%SPM.mat file
matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr(a);
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

if create_model_and_estimate
    spm_jobman('run',matlabbatch);
end
clear matlabbatch


% load(fullfile(level2_results_dir,'SPM.mat'))

b = spm_select('FPList', level2_results_dir,'SPM.mat');%SPM.mat file
matlabbatch{1}.spm.stats.con.spmmat = cellstr(b);

matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'grp1>gpr2';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'gpr2>grp1';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.delete = 1; %this deletes the previously existing contrasts; set to 0 if you do not want to delete previous contrasts!
% 
spm_jobman('run',matlabbatch);
clear matlabbatch

% load(fullfile(level2_results_dir,'SPM.mat'))
% b = spm_select('FPList', level2_results_dir,'SPM.mat');%SPM.mat file
% matlabbatch{1}.spm.stats.con.spmmat = cellstr(b);
% 
% matlabbatch{1}.spm.tools.tfce_estimate.mask = '';
% matlabbatch{1}.spm.tools.tfce_estimate.conspec.titlestr = '';
% matlabbatch{1}.spm.tools.tfce_estimate.conspec.contrasts = Inf;
% matlabbatch{1}.spm.tools.tfce_estimate.conspec.n_perm = 5000;
% matlabbatch{1}.spm.tools.tfce_estimate.nuisance_method = 2;
% matlabbatch{1}.spm.tools.tfce_estimate.tbss = 0;
% matlabbatch{1}.spm.tools.tfce_estimate.E_weight = 0.5;
% matlabbatch{1}.spm.tools.tfce_estimate.singlethreaded = 1;
% 
% spm_jobman('run',matlabbatch);
clear matlabbatch

end