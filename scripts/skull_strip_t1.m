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


% skull strip

% Segment fMRI
data_path = pwd;

spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

% TO DO: Automate the file grabbing...
matlabbatch{1}.spm.util.imcalc.input = {
    spm_select('ExtFPList',data_path, '^c1.*\.nii$')
    spm_select('ExtFPList',data_path, '^c2.*\.nii$')
    spm_select('ExtFPList',data_path, '^c3.*\.nii$')
    spm_select('ExtFPList',data_path, '^T1.*\.nii$')
    };
matlabbatch{1}.spm.util.imcalc.output = 'SkullStripped_T1';
matlabbatch{1}.spm.util.imcalc.outdir = {pwd};
matlabbatch{1}.spm.util.imcalc.expression = '(i1+i2+i3).*i4';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

spm_jobman('run',matlabbatch);
clear matlabbatch