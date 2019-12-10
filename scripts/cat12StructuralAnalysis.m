% (at your option) any later version.
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.


% Segment fMRI
data_path = pwd;

clear matlabbatch
% spm('Defaults','fMRI');
spm_jobman('initcfg');
% spm_get_defaults('cmdline',true);

structural_files = spm_select('ExtFPList', data_path, '^T1.*\.nii$');

%--------------------------------------------------------------------------
matlabbatch{1}.spm.tools.cat.estwrite.data = cellstr(structural_files);
matlabbatch{1}.spm.tools.cat.estwrite.nproc = 0;
matlabbatch{1}.spm.tools.cat.estwrite.opts.tpm = {'TPM.nii'};
matlabbatch{1}.spm.tools.cat.estwrite.opts.affreg = 'mni';
matlabbatch{1}.spm.tools.cat.estwrite.opts.biasstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.APP = 1070;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.LASstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.gcutstr = 0;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.darteltpm = {'Template_1_IXI555_MNI152.nii'};
matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.shootingtpm = {'Template_0_IXI555_MNI152_GS.nii'};
matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.regstr = 0;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.vox = 1.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.restypes.best = [0.5 0.3];
matlabbatch{1}.spm.tools.cat.estwrite.output.surface = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.neuromorphometrics = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.lpba40 = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.cobra = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.hammers = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.native = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.mod = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.native = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.mod = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.bias.warped = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.jacobian.warped = 0;
% Run SPM batch
spm_jobman('run',matlabbatch);
clear matlabbatch

matlabbatch{1}.spm.tools.cat.tools.calcvol.data_xml = {fullfile('report', filesep, 'cat_T1.xml')};
matlabbatch{1}.spm.tools.cat.tools.calcvol.calcvol_TIV = 0;
matlabbatch{1}.spm.tools.cat.tools.calcvol.calcvol_name = 'TIV.txt';

spm_jobman('run',matlabbatch);
clear matlabbatch

matlabbatch{1}.spm.tools.cat.stools.surfresamp.data_surf = {fullfile('surf', filesep, 'lh.thickness.T1')};
matlabbatch{1}.spm.tools.cat.stools.surfresamp.merge_hemi = 1;
matlabbatch{1}.spm.tools.cat.stools.surfresamp.mesh32k = 1;
matlabbatch{1}.spm.tools.cat.stools.surfresamp.fwhm_surf = 8;
matlabbatch{1}.spm.tools.cat.stools.surfresamp.nproc = 0;

spm_jobman('run',matlabbatch);
clear matlabbatch


% matlabbatch{1}.spm.tools.cat.tools.check_cov.data_vol = {{'\\cifs.rc.ufl.edu\ufrc\rachaelseidler\share\FromExternal\Research_Projects_UF\CRUNCH\Pilot_Study_Data\CrunchPilot01\Processed\MRI_files\02_T1\Cat12\c1T1.nii,1'}};
% matlabbatch{1}.spm.tools.cat.tools.check_cov.data_xml = {''};
% matlabbatch{1}.spm.tools.cat.tools.check_cov.gap = 3;
% matlabbatch{1}.spm.tools.cat.tools.check_cov.c = {};
% spm_jobman('initcfg');
% spm_jobman('run',matlabbatch);
