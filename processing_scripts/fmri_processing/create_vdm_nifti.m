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

function create_vdm_nifti(functional_file_name)

data_path = pwd; % assuming the shell command places the wd to: ('Processed/MRI_files/03_Fieldmaps/Fieldmap_nback' or /Fieldmap_motorImagery' or /DTI) 
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

fieldmap_file = spm_select('ExtFPList',data_path, '^my_fieldmap_nifti.*\.nii$');
epi_file = spm_select('FPList', data_path, strcat('^',functional_file_name,'$'));
magnitude_file = spm_select('FPList',data_path, '^se.*\.nii$');

matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.precalcfieldmap.precalcfieldmap = {fieldmap_file};
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session.epi = {epi_file};
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.precalcfieldmap.magfieldmap ={magnitude_file};
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsfile = {'vdm_defaults.m'};
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchvdm = 1;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.sessname = 'session';
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.anat = '';
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchanat = 0;
matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.writeunwarped = 0;
spm_jobman('run',matlabbatch);
clear matlabbatch

end