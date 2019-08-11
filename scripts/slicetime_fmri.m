% Slice timing: Temporal interpolation: use information from nearby time points to estimate the
% amplitude of the MR signal at the onset of each TR. Put all volumes at the same time.
% Like each slice had been acquired at the same time.

% If you use multi-band acquisition, you cannot use the slice order as an input to slice timing correction, 
% since a slice order cannot represent multiple slices acquired at the same time (if it was a matrix it would be possible,
% but SPM only accepts a vector). However, you can use the slice timing instead of slice order when using a multi-band EPI acquisition[30] ·[31].
% If you do know your slice order but not your slice timing, you can artificially create a slice timing manually, 
% by generating artificial values from the slice order with equal temporal spacing, and then scale the numbers on the TR, so that the last temporal slices timings = TR - TR/(nslices/multiband_channels).


data_path = pwd;

spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

files_to_slicetime = spm_select('ExtFPList', data_path, '^fMRI.*\.nii$');

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
% matlabbatch{1}.spm.temporal.st.so = [];
matlabbatch{1}.spm.temporal.st.so = [1075.00000001000;0;740.000000020000;67.5000000000000;807.500000000000;135.000000010000;875;202.500000010000; ...
    940;267.500000020000;1007.50000001000;402.500000000000;1142.50000002000;470;1210.00000002000;537.500000010000;1277.50000000000;605.000000010000; ...
    1345;672.500000020000;1412.50000001000;335.000000020000;1075.00000001000;0;740.000000020000;67.5000000000000;807.500000000000;135.000000010000; ...
    875;202.500000010000;940;267.500000020000;1007.50000001000;402.500000000000;1142.50000002000;470;1210.00000002000;537.500000010000;1277.50000000000; ...
    605.000000010000;1345;672.500000020000;1412.50000001000;335.000000020000;1075.00000001000;0;740.000000020000;67.5000000000000;807.500000000000; ...
    135.000000010000;875;202.500000010000;940;267.500000020000;1007.50000001000;402.500000000000;1142.50000002000;470;1210.00000002000;537.500000010000; ...
    1277.50000000000;605.000000010000;1345;672.500000020000;1412.50000001000;335.000000020000] /1000;



% matlabbatch{1}.spm.temporal.st.so = [1    3     5     7     9    11    13    15    17    19    21    23    25    27    29    31    33    35    37 ...
%     39    41    43    45    47    49    51    53    55    57    59    61    63    65  2     4     6     8    10    12    14    16    18    20    22 ...
%     24    26    28    30    32    34    36    38    40    42    44    46    48    50    52    54    56    58    60    62    64    66];
matlabbatch{1}.spm.temporal.st.refslice = 12;
matlabbatch{1}.spm.temporal.st.prefix = 'slicetimedMBtiming_';

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
% matlabbatch{1}.spm.temporal.st.so = [];
matlabbatch{1}.spm.temporal.st.so = [1075.00000001000;0;740.000000020000;67.5000000000000;807.500000000000;135.000000010000;875;202.500000010000; ...
    940;267.500000020000;1007.50000001000;402.500000000000;1142.50000002000;470;1210.00000002000;537.500000010000;1277.50000000000;605.000000010000; ...
    1345;672.500000020000;1412.50000001000;335.000000020000;1075.00000001000;0;740.000000020000;67.5000000000000;807.500000000000;135.000000010000; ...
    875;202.500000010000;940;267.500000020000;1007.50000001000;402.500000000000;1142.50000002000;470;1210.00000002000;537.500000010000;1277.50000000000; ...
    605.000000010000;1345;672.500000020000;1412.50000001000;335.000000020000;1075.00000001000;0;740.000000020000;67.5000000000000;807.500000000000; ...
    135.000000010000;875;202.500000010000;940;267.500000020000;1007.50000001000;402.500000000000;1142.50000002000;470;1210.00000002000;537.500000010000; ...
    1277.50000000000;605.000000010000;1345;672.500000020000;1412.50000001000;335.000000020000] /1000;
% matlabbatch{1}.spm.temporal.st.so = [1.0750 0 0.7400 0.0675 0.8075 0.1350 0.8750 0.2025 0.9400 0.2675 1.0075 0.4025 1.1425 0.4700 1.2100 0.5375 1.2775 0.6050 1.3450 0.6725 1.4125 0.3350 1.0750 ...
%     0 0.7400 0.0675 0.8075 0.1350 0.8750 0.2025 0.9400 0.2675 1.0075 0.4025 1.1425 0.4700 1.2100 0.5375 1.2775 0.6050 1.3450 0.6725 1.4125 0.3350 1.0750  0.740 0.067 0.807 0.1350 0.8750 0.2025 ....
%     0.940 0.2675 1.0075 0.4025 1.1425 0.4700 1.2100 0.5375 1.2775 0.6050 1.3450 0.6725 1.4125 0.3350];
% matlabbatch{1}.spm.temporal.st.so = [1     3     5     7     9    11    13    15    17    19    21    23    25    27    29    31    33    35    37 ...
%     39    41    43    45    47    49    51    53    55    57    59    61    63    65  2     4     6     8    10    12    14    16    18    20    22 ...
%     24    26    28    30    32    34    36    38    40    42    44    46    48    50    52    54    56    58    60    62    64    66];
matlabbatch{1}.spm.temporal.st.refslice = 12;
matlabbatch{1}.spm.temporal.st.prefix = 'slicetimedMBtiming_';

spm_jobman('run',matlabbatch);
clear matlabbatch