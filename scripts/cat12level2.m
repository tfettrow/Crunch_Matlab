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

matlabbatch{1}.spm.stats.factorial_design.dir = {'\\cifs.rc.ufl.edu\ufrc\rachaelseidler\share\FromExternal\Research_Projects_UF\CRUNCH\Pilot_Study_Data\CrunchPilot01\Processed\MRI_files\02_T1\CAT12_2\Level2'};
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.name = 'Repetition';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.levels = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell.levels = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell.scans = {'\\cifs.rc.ufl.edu\ufrc\rachaelseidler\share\FromExternal\Research_Projects_UF\CRUNCH\Pilot_Study_Data\CrunchPilot01\Processed\MRI_files\02_T1\CAT12_2\T1.nii,1'};
matlabbatch{1}.spm.stats.factorial_design.des.fd.contrasts = 1;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
% Run SPM batch
spm_jobman('run',matlabbatch);
clear matlabbatch