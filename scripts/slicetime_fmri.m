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
matlabbatch{1}.spm.temporal.st.tr = 1500;
matlabbatch{1}.spm.temporal.st.ta = 0;
matlabbatch{1}.spm.temporal.st.so = [1075;0;740;67.5;807.5;135;875;202.5; ...
    940;267.5;1007.5;402.5;1142.5;470;1210;537.5;1277.5;605; ...
    1345;672.5;1412.5;335;1075;0;740;67.5;807.5;135; ...
    875;202.5;940;267.5;1007.5;402.5;1142.5;470;1210;537.5;1277.5; ...
    605;1345;672.5;1412.5;335;1075;0;740;67.5;807.5; ...
    135;875;202.5;940;267.5;1007.5;402.5;1142.5;470;1210;537.5; ...
    1277.5;605;1345;672.5;1412.5;335];

matlabbatch{1}.spm.temporal.st.refslice = 672.5;
matlabbatch{1}.spm.temporal.st.prefix = 'slicetimed_';

spm_jobman('run',matlabbatch);
clear matlabbatch

