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

data_path = pwd;
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);


files_to_smooth = spm_select('FPList', data_path, '^warpedToMNI_unwarped.*\.nii$');

for i_file = 1 : size(files_to_smooth,1)
    this_file_with_volumes = spm_select('expand', files_to_smooth(i_file,:));

    matlabbatch{1}.spm.spatial.smooth.data = cellstr(this_file_with_volumes);
    matlabbatch{1}.spm.spatial.smooth.fwhm = [4 4 4];
    matlabbatch{1}.spm.spatial.smooth.prefix = 'smoothed_';
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end