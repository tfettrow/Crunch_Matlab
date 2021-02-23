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


function level_two_stats_gyrification_twosampTtest(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'create_model_and_estimate', 1)
addParameter(parser, 't1_folder', '02_T1')
addParameter(parser, 'template_dir' , '')
addParameter(parser, 'group_one_subject_codes', '')
addParameter(parser, 'group_two_subject_codes' , '')
addParameter(parser, 'group_comparison_string', '')
addParameter(parser, 'tfce', '')
parse(parser, varargin{:})
create_model_and_estimate = parser.Results.create_model_and_estimate;
t1_folder = parser.Results.t1_folder;
template_dir = parser.Results.template_dir;
group_one_subject_codes = parser.Results.group_one_subject_codes;
group_two_subject_codes = parser.Results.group_two_subject_codes;
group_comparison_string = parser.Results.group_comparison_string;
tfce = parser.Results.tfce;

group_one_subject_codes = split(group_one_subject_codes,",");
group_two_subject_codes = split(group_two_subject_codes,",");

data_path = pwd; % assuming shell script places wd as study level folder
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

for this_subject_index = 1 : length(group_one_subject_codes)
     this_subject_path = strcat([data_path filesep group_one_subject_codes{this_subject_index} filesep 'Processed' filesep 'MRI_files' filesep t1_folder filesep 'CAT12_Analysis']);
     group_one_scans{this_subject_index,:} = fullfile(this_subject_path,'surf','s20.mesh.gyrification.resampled_32k.T1.gii');
end

for this_subject_index = 1 : length(group_two_subject_codes)
    this_subject_path = strcat([data_path filesep group_two_subject_codes{this_subject_index} filesep 'Processed' filesep 'MRI_files' filesep t1_folder filesep 'CAT12_Analysis']);
    group_two_scans{this_subject_index,:} = fullfile(this_subject_path,'surf', 's20.mesh.gyrification.resampled_32k.T1.gii');
end

level2_results_dir = fullfile(data_path, strcat('Results_gyrification_twosampTtest_wholebrain_',group_comparison_string));

matlabbatch{1}.spm.stats.factorial_design.dir = {level2_results_dir};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 =  cellstr(group_one_scans);
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 =  cellstr(group_two_scans);
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



if create_model_and_estimate
    if exist(fullfile(level2_results_dir,'SPM.mat'),'file')
        rmdir(level2_results_dir, 's')
    end
    spm_jobman('run',matlabbatch);
end
clear matlabbatch

% Using CAT12 Estimation
if create_model_and_estimate
    cd(level2_results_dir)
    cat_stat_spm();
    cd(project_path)
end

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


% TFCE
if tfce
    b = spm_select('FPList', level2_results_dir,'SPM.mat');%SPM.mat file
    matlabbatch{1}.spm.tools.tfce_estimate.spmmat = cellstr(b);
    matlabbatch{1}.spm.tools.tfce_estimate.mask = '';
    matlabbatch{1}.spm.tools.tfce_estimate.conspec.titlestr = '';
    matlabbatch{1}.spm.tools.tfce_estimate.conspec.contrasts = Inf;
    matlabbatch{1}.spm.tools.tfce_estimate.conspec.n_perm = 5000;
    matlabbatch{1}.spm.tools.tfce_estimate.nuisance_method = 2;
    matlabbatch{1}.spm.tools.tfce_estimate.tbss = 0;
    matlabbatch{1}.spm.tools.tfce_estimate.E_weight = 0.5;
    matlabbatch{1}.spm.tools.tfce_estimate.singlethreaded = 1;
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end
