function grey_matter_mask(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
addParameter(parser, 'image_relative_to_study_folder', '')
parse(parser, varargin{:})
image_relative_to_study_folder = parser.Results.image_relative_to_study_folder;

spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

% Results_fmri_loadModulation\MRI_files\05_MotorImagery\OA\ess_0001.nii,1

image_split = strsplit(image_relative_to_study_folder, filesep);
image_prefix = strsplit(image_split{end},'.');

matlabbatch{1}.spm.util.imcalc.input = {
                                        strcat('\\exasmb.rc.ufl.edu\blue\rachaelseidler\share\FromExternal\Research_Projects_UF\CRUNCH\MiM_Data\',image_relative_to_study_folder,',1')
                                        '\\exasmb.rc.ufl.edu\blue\rachaelseidler\share\FromExternal\Research_Projects_UF\CRUNCH\MiM_Data\ROIs\MNI_2mm_gmMask.nii,1'
                                        };
matlabbatch{1}.spm.util.imcalc.output = strcat(image_prefix{1},'_GMmasked');
matlabbatch{1}.spm.util.imcalc.outdir = {fullfile(image_split{1:end-1})};
matlabbatch{1}.spm.util.imcalc.expression = 'i1.*i2';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

spm_jobman('run',matlabbatch);
clear matlabbatch
end