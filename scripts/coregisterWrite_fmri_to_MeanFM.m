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

all_files_to_coregister = spm_select('FPList', data_path, '^slicetimed_fMRI.*\.nii$');

merged_distortion_map = spm_select('ExtFPList', data_path, 'Mean_AP_PA_merged.nii');
% merged_distortion_map = convertCharsToStrings(merged_distortion_map);

if size(merged_distortion_map,1) >= 2 
    error('check the images being grabbed!!')
end

% for i_file = 1 : size(all_files_to_coregister,1)
%     string_files_to_coregister_volumes(i_file, :) = convertCharsToStrings(all_files_to_coregister(i_file, :));
%     files_to_coregister_path_components(i_file, :) = strsplit(string_files_to_coregister_volumes(i_file, :),'/');
%     files_to_coregister_filenames_and_volumes(i_file, :) = strsplit(files_to_coregister_path_components(i_file,end),',');
% end
% 
% files_to_coregister_time_filenames = unique(files_to_coregister_filenames_and_volumes(:, 1));
for i_file = 1 : size(all_files_to_coregister,1)
    
    this_file_path_with_volumes = spm_select('expand', all_files_to_coregister(i_file,:));
    
    matlabbatch{1}.spm.spatial.coreg.estwrite.ref = cellstr(merged_distortion_map);
    matlabbatch{1}.spm.spatial.coreg.estwrite.source = cellstr(this_file_path_with_volumes(1,:));
    matlabbatch{1}.spm.spatial.coreg.estwrite.other = cellstr(this_file_path_with_volumes);
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 1 0];
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'coregistered2vdm_';
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end