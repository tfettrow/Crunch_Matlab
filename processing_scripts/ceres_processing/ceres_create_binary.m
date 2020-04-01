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


CERES_native = spm_select('FPList', data_path,'^native_tissue_ln_crop_mmni.*\.nii$'); 			% CERES native space output. Has now been coregistered to SUIT.nii template. 

% Make GM mask. i1==1.  
matlabbatch{1}.spm.util.imcalc.input = cellstr(CERES_native);
matlabbatch{1}.spm.util.imcalc.output = 'GM_mask';
matlabbatch{1}.spm.util.imcalc.outdir = {''};
matlabbatch{1}.spm.util.imcalc.expression = 'i1==1';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

% Make WM mask. i1==2.  
matlabbatch{2}.spm.util.imcalc.input = cellstr(CERES_native);
matlabbatch{2}.spm.util.imcalc.output = 'WM_mask';
matlabbatch{2}.spm.util.imcalc.outdir = {''};
matlabbatch{2}.spm.util.imcalc.expression = 'i1==2';
matlabbatch{2}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{2}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{2}.spm.util.imcalc.options.mask = 0;
matlabbatch{2}.spm.util.imcalc.options.interp = 1;
matlabbatch{2}.spm.util.imcalc.options.dtype = 4;

% Make full CB mask. i1>0.9.  
matlabbatch{3}.spm.util.imcalc.input = cellstr(CERES_native);
matlabbatch{3}.spm.util.imcalc.output = 'CB_mask';
matlabbatch{3}.spm.util.imcalc.outdir = {''};
matlabbatch{3}.spm.util.imcalc.expression = 'i1>0.9';
matlabbatch{3}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{3}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{3}.spm.util.imcalc.options.mask = 0;
matlabbatch{3}.spm.util.imcalc.options.interp = 1;
matlabbatch{3}.spm.util.imcalc.options.dtype = 4;
	
spm_jobman('run',matlabbatch);