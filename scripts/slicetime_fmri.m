

% Slice timing: Temporal interpolation: use information from nearby time points to estimate the
% amplitude of the MR signal at the onset of each TR. Put all volumes at the same time.
% Like each slice had been acquired at the same time.
clear, clc
data_path = pwd;
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

json_path_names =spm_select('FPList', data_path, '^fMRI.*\.json$');

all_files_to_slicetime_volumes = spm_select('ExtFPList', data_path, '^fMRI.*\.nii$');

for i_file = 1 : size(all_files_to_slicetime_volumes,1)
    string_files_to_slicetime_volumes(i_file, :) = convertCharsToStrings(all_files_to_slicetime_volumes(i_file, :));
    files_to_slicetime_path_components(i_file, :) = strsplit(string_files_to_slicetime_volumes(i_file, :),'/');
    files_to_slicetime_filenames_and_volumes(i_file, :) = strsplit(files_to_slicetime_path_components(i_file,end),',');
end

files_to_slice_time_filenames = unique(files_to_slicetime_filenames_and_volumes(:, 1));
for i_unique_filename= 1 : length(files_to_slice_time_filenames)
   this_file_path_with_volumes = spm_select('ExtFPList', data_path, files_to_slice_time_filenames(i_unique_filename));
   all_scans_fullpath_scan_cell{1, i_unique_filename} = cellstr(this_file_path_with_volumes);
end

matlabbatch{1}.spm.temporal.st.scans = all_scans_fullpath_scan_cell;


[stMsec, TRsec] = bidsSliceTiming(json_path_names(1,:));
if isempty(stMsec) || isempty(TRsec), error('Update dcm2niix? Unable determine slice timeing or TR from BIDS file %s', BIDSname); end;

unique_slicetimes = unique(stMsec);
if length(unique_slicetimes) == length(stMsec)/3
    % multiband by 3s (UF Siemens 3T)
    refslice = median(stMsec);
    if ~any(stMsec == refslice)
        difference_from_median = (stMsec - refslice);
        refslice = min(stMsec(difference_from_median > 0));
    end
elseif length(unique_slicetimes) == length(stMsec)
    % ascending or descending
    refslice = max(stMsec)/2;
    fprintf('Setting reference slice as %g ms (slice ordering assumed to be from foot to head)\n', refslice);
else
    error('Something is not right with slice order, check whether multiband not equal to 3')
end

timing = [0 TRsec];
matlabbatch{1}.spm.temporal.st.nslices = length(stMsec);
matlabbatch{1}.spm.temporal.st.tr = TRsec;
matlabbatch{1}.spm.temporal.st.ta = 0;
matlabbatch{1}.spm.temporal.st.so = stMsec;
matlabbatch{1}.spm.temporal.st.refslice = refslice;
matlabbatch{1}.spm.temporal.st.prefix = 'slicetimed_';

spm_jobman('run',matlabbatch);
clear matlabbatch

