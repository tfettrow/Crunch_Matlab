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

clear, clc
data_path = pwd;
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

data_path = pwd;

% what is expected initial directory? 
% navigate to appropriate functional images
conn_images = spm_select('FPList', data_path,'SUIT.nii'); 													% SUIT.nii 

% navigate to appropriate behavior data
cd 'spreadsheet_data'
cd 'walking_data'
headers={'subject_id', 'sppb_balance', 'sppb_speed', 'sppb_stand', 'sppb_total','400m'};
walking_data = xlsread('walking_data.xlsx');
cd ..
cd 'sensory_data'
headers={'subject_id','PainThreshold_Average','PainInventory_Average','Tactile_Mono','Tactile_Dual'};
sensory_data = xlsread('sensory_data.xlsx');
cd ..
cd ..

matlabbatch{1}.spm.tools.snpm.des.Corr.DesignName = 'MultiSub: Simple Regression; 1 covariate of interest';
matlabbatch{1}.spm.tools.snpm.des.Corr.DesignFile = 'snpm_bch_ui_Corr';
matlabbatch{1}.spm.tools.snpm.des.Corr.dir = data_path;
matlabbatch{1}.spm.tools.snpm.des.Corr.P = '<UNDEFINED>';  % con images??
matlabbatch{1}.spm.tools.snpm.des.Corr.CovInt = '<UNDEFINED>'; % behavioral data??
matlabbatch{1}.spm.tools.snpm.des.Corr.cov = struct('c', {}, 'cname', {});
matlabbatch{1}.spm.tools.snpm.des.Corr.nPerm = 10000;
matlabbatch{1}.spm.tools.snpm.des.Corr.vFWHM = [0 0 0];
matlabbatch{1}.spm.tools.snpm.des.Corr.bVolm = 1;
matlabbatch{1}.spm.tools.snpm.des.Corr.ST.ST_none = 0;
matlabbatch{1}.spm.tools.snpm.des.Corr.masking.tm.tm_none = 1;
matlabbatch{1}.spm.tools.snpm.des.Corr.masking.im = 1;
matlabbatch{1}.spm.tools.snpm.des.Corr.masking.em = {''};
matlabbatch{1}.spm.tools.snpm.des.Corr.globalc.g_omit = 1;
matlabbatch{1}.spm.tools.snpm.des.Corr.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.tools.snpm.des.Corr.globalm.glonorm = 1;

spm_jobman('run',matlabbatch);