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

cb_mask = spm_select('FPList', data_path,'^dimMatch.*\.nii$'); 			% CERES native space output. Has now been coregistered to SUIT.nii template. 
all_func_files = spm_select('FPList', data_path,'^unwarpedRealigned_.*\.nii$');

for i_file = 1 : size(all_func_files,1)
    this_file_path_with_volumes = spm_select('expand', all_func_files(i_file,:));
    % Make GM mask. i1==1.
    for this_volume = 1 : size(this_file_path_with_volumes,1)
        matlabbatch{1}.spm.util.imcalc.input = {cb_mask; this_file_path_with_volumes(this_volume,:)};
        matlabbatch{1}.spm.util.imcalc.output = cellstr(strcat('cb', this_volume, '_'));
        matlabbatch{1}.spm.util.imcalc.outdir = {''};
        matlabbatch{1}.spm.util.imcalc.expression = 'i2.*(i1>100)';
        matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{1}.spm.util.imcalc.options.mask = 0;
        matlabbatch{1}.spm.util.imcalc.options.interp = 1;
        matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
        
        spm_jobman('run',matlabbatch);
    end
end
