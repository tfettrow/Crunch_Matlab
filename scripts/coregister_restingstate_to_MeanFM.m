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

file_to_coregister = spm_select('FPList', data_path, '^slicetimed_.*\.nii$');

merged_distortion_map = spm_select('ExtFPList', data_path, 'Mean_AP_PA_merged.nii');

if size(merged_distortion_map,1) >= 2 
    error('check the images being grabbed!!')
end

this_file_path_with_volumes = spm_select('expand', file_to_coregister(i_file,:));

matlabbatch{1}.spm.spatial.coreg.estimate.ref =cellstr(this_file_path_with_volumes(1,:));
matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(merged_distortion_map); % take the first volume
matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
spm_jobman('run',matlabbatch);
clear matlabbatch