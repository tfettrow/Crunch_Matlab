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

SUIT_template = spm_select('FPList', data_path,'SUIT.nii'); 													% SUIT.nii 
CERES_native = spm_select('FPList', data_path,'^native_tissue_ln_crop_mmn.*\.nii$'); 			% CERES native space output 

%Do not change anything here: 
clear matlabbatch
matlabbatch{1}.spm.spatial.coreg.estimate.ref = cellstr(SUIT_template); 		% SUIT template--not moved around ("assumed to remain stationary")
matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(CERES_native);	% CERES native space mask--jiggle around to fit with SUIT template 
matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};		
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
	
spm_jobman('run',matlabbatch);