% Slice timing: Temporal interpolation: use information from nearby time points to estimate the
% amplitude of the MR signal at the onset of each TR. Put all volumes at the same time.
% Like each slice had been acquired at the same time.
data_path = pwd;

spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

files_to_slicetime = spm_select('ExtFPList', data_path, '^unwarpedRealigned_.*\.nii$');

% check the folder name and specify the volumes accordingly
path_components = strsplit(data_path,'/');

if strcmp(path_components{end},"05_MotorImagery")
    files_to_slicetime1 = files_to_slicetime(1:168,:);
    files_to_slicetime2 = files_to_slicetime(169:336,:);

    matlabbatch{1}.spm.temporal.st.scans = {cellstr(files_to_slicetime1) cellstr(files_to_slicetime2)};

elseif strcmp(path_components{end},"06_Nback")
    files_to_slicetime1 = files_to_slicetime(1:200,:);
    files_to_slicetime2 = files_to_slicetime(201:400,:);
    files_to_slicetime3 = files_to_slicetime(401:602,:);
    files_to_slicetime4 = files_to_slicetime(603:804,:);

    matlabbatch{1}.spm.temporal.st.scans = {cellstr(files_to_slicetime1) cellstr(files_to_slicetime2) cellstr(files_to_slicetime3) cellstr(files_to_slicetime4)};
end


matlabbatch{1}.spm.temporal.st.nslices = 66;
matlabbatch{1}.spm.temporal.st.tr = 1.5;
matlabbatch{1}.spm.temporal.st.ta = 1.4375;
matlabbatch{1}.spm.temporal.st.so = [1     3     5     7     9    11    13    15    17    19    21    23    25    27    29    31    33    35    37 ...
    39    41    43    45    47    49    51    53    55    57    59    61    63    65  2     4     6     8    10    12    14    16    18    20    22 ...
    24    26    28    30    32    34    36    38    40    42    44    46    48    50    52    54    56    58    60    62    64    66];
matlabbatch{1}.spm.temporal.st.refslice = 12;
matlabbatch{1}.spm.temporal.st.prefix = 'slicetimed_';

spm_jobman('run',matlabbatch);
clear matlabbatch


files_to_slicetime = spm_select('ExtFPList', data_path, '^realigned_.*\.nii$');

if strcmp(path_components{end},"05_MotorImagery")
    files_to_slicetime1 = files_to_slicetime(1:168,:);
    files_to_slicetime2 = files_to_slicetime(169:336,:);

    matlabbatch{1}.spm.temporal.st.scans = {cellstr(files_to_slicetime1) cellstr(files_to_slicetime2)};

elseif strcmp(path_components{end},"06_Nback")
    files_to_slicetime1 = files_to_slicetime(1:200,:);
    files_to_slicetime2 = files_to_slicetime(201:400,:);
    files_to_slicetime3 = files_to_slicetime(401:602,:);
    files_to_slicetime4 = files_to_slicetime(603:804,:);

    matlabbatch{1}.spm.temporal.st.scans = {cellstr(files_to_slicetime1) cellstr(files_to_slicetime2) cellstr(files_to_slicetime3) cellstr(files_to_slicetime4)};
end
matlabbatch{1}.spm.temporal.st.nslices = 66;
matlabbatch{1}.spm.temporal.st.tr = 1.5;
matlabbatch{1}.spm.temporal.st.ta = 1.4375;
matlabbatch{1}.spm.temporal.st.so = [1     3     5     7     9    11    13    15    17    19    21    23    25    27    29    31    33    35    37 ...
    39    41    43    45    47    49    51    53    55    57    59    61    63    65  2     4     6     8    10    12    14    16    18    20    22 ...
    24    26    28    30    32    34    36    38    40    42    44    46    48    50    52    54    56    58    60    62    64    66];
matlabbatch{1}.spm.temporal.st.refslice = 12;
matlabbatch{1}.spm.temporal.st.prefix = 'slicetimed_';

spm_jobman('run',matlabbatch);
clear matlabbatch