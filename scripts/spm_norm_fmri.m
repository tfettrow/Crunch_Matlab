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

files_to_normalise = spm_select('FPList', data_path, '^unwarpedRealigned.*\.nii$');

for i_file = 1 : size(files_to_normalise,1)
    this_file_with_volumes = spm_select('expand', files_to_normalise(i_file,:));
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.def  = cellstr('y_T1.nii');
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(this_file_with_volumes);
    
    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox  = [2 2 2];
    matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'normalized_';
 
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
end
