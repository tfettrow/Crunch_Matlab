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
group_one_subject_codes = {'1002', '1004'}; % need to figure out how to pass cell from shell
group_two_subject_codes =  {'2007','2008'};

group_one_subject_codes = split(group_one_subject_codes,",");
group_two_subject_codes = split(group_two_subject_codes,",");

data_path = pwd; % assuming shell script places wd as study level folder
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

% level2_results_dir = fullfile(data_path, 'twosampTtest_Results', 'MRI_files', task_folder, condition); 
% matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = cellstr(group_one_scans);
% matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = cellstr(group_two_scans);
% matlabbatch{1}.spm.stats.factorial_design.dir = {level2_results_dir};
% matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
% matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
% matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
% matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
% matlabbatch{1}.spm.stats.factorial_design.cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
% matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
% matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
% matlabbatch{1}.spm.stats.factorial_design.masking.im = 0;
% matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
% matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
% matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
% matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
% 
% if create_model_and_estimate
%     if exist(fullfile(level2_results_dir,'SPM.mat'),'file')
%         rmdir(level2_results_dir, 's')
%     end
%     spm_jobman('run',matlabbatch);
% end
% clear matlabbatch

matlabbatch{1}.spm.stats.factorial_design.dir = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = '<UNDEFINED>';
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.tools.cat.tools.check_SPM.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.use_unsmoothed_data = 1;
matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.adjust_data = 1;
matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.outdir = {''};
matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.fname = 'CATcheckdesign_';
matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.save = 0;
matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_ortho = 1;

end