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

%--------------------------------------------------------------------------
% Spatial smoothing
%--------------------------------------------------------------------------
% Select which files you want to smooth. 

all_files_to_coregister = spm_select('FPList', fullfile(data_path),'^warpedToSUIT.*\.nii$');

for i_file = 1 : size(all_files_to_coregister,1)
    %All of the con images (8 images)
    this_file_path_with_volumes = spm_select('expand', all_files_to_coregister(i_file,:));
    
    
    clear matlabbatch
    matlabbatch{1}.spm.spatial.smooth.data = cellstr(this_file_path_with_volumes);
    matlabbatch{1}.spm.spatial.smooth.fwhm = [4 4 4];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 'smoothed_';
    
    spm_jobman('run',matlabbatch);
    
end