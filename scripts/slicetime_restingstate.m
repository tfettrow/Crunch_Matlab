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


% Slice timing: Temporal interpolation: use information from nearby time points to estimate the
% amplitude of the MR signal at the onset of each TR. Put all volumes at the same time.
% Like each slice had been acquired at the same time.
clear, clc
data_path = pwd;
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

json_path_names =spm_select('FPList', data_path, '^RestingState.*\.json$');

all_files_to_slicetime = spm_select('FPList', data_path, '^RestingState.*\.nii$');

for i_file = 1 : size(all_files_to_slicetime,1)
    this_file_with_volumes = spm_select('expand', all_files_to_slicetime(i_file,:));
    all_scans_fullpath_scan_cell{1, i_file} = cellstr(this_file_with_volumes);
end    
matlabbatch{1}.spm.temporal.st.scans = all_scans_fullpath_scan_cell;

[stMsec, TRsec] = bidsSliceTiming(json_path_names(i_file,:));
if isempty(stMsec) || isempty(TRsec), error('Update dcm2niix? Unable determine slice timeing or TR from BIDS file %s', BIDSname); end;

reftime = max(stMsec)/2;

timing = [0 TRsec];
matlabbatch{1}.spm.temporal.st.nslices = length(stMsec);
matlabbatch{1}.spm.temporal.st.tr = TRsec;
matlabbatch{1}.spm.temporal.st.ta = 0;
matlabbatch{1}.spm.temporal.st.so = stMsec;
matlabbatch{1}.spm.temporal.st.refslice = reftime;
matlabbatch{1}.spm.temporal.st.prefix = 'slicetimed_';

spm_jobman('run',matlabbatch);

