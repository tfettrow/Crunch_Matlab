
% data_path = fileparts(mfilename('fullpath'));
% data_path = pwd;
data_path = '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/CRUNCH/Pilot_Study_Data/CrunchPilot01';

% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GLM SPECIFICATION, ESTIMATION, INFERENCE, RESULTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

smooth_normalized_unwarped_functional_imagery_files = spm_select('ExtFPList', fullfile(data_path,'Processed/MRI_files/05_MotorImagery'), '^smooth_wslicetimed_unwarped.*\.nii$');
art_regression_outlier_files  = spm_select('FPList',  fullfile(data_path,'Processed/MRI_files/05_MotorImagery'),'art_regression_outliers_and_movement.*.mat');

smooth_normalized_unwarped_functional_imagery_files1 = smooth_normalized_unwarped_functional_imagery_files(1:168,:);
smooth_normalized_unwarped_functional_imagery_files2 = smooth_normalized_unwarped_functional_imagery_files(169:336,:);

art_regression_outlier_files1 = art_regression_outlier_files(1,:);
art_regression_outlier_files2 = art_regression_outlier_files(2,:);

% Output Directory
%--------------------------------------------------------------------------
% matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = cellstr(fullfile(data_path,'05_MotorImagery'));
% matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'GLM';

% Model Specification
%--------------------------------------------------------------------------
% TO DO: specify proper directory
matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(fullfile(data_path,'Processed/MRI_files/05_MotorImagery'));
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 1.5;


% Run 1
matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = cellstr(smooth_normalized_unwarped_functional_imagery_files1);

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = 'Flat_Terrain';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = [73.5 211.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = 18;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name = 'Low_Terrain';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = [39 142.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = 18;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).name = 'Moderate_Terrain';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).onset = [4.5 246];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).duration = 18;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).name = 'Difficult_Terrain';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).onset = [108 177];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).duration = 18;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = cellstr(art_regression_outlier_files1); % ART file goes here
matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;

% Run 2
matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = cellstr(smooth_normalized_unwarped_functional_imagery_files2);

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).name = 'Flat_Terrain';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).onset = [73.5 246];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).duration = 18;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).name = 'Low_Terrain';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).onset = [108 211.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).duration = 18;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).name = 'Moderate_Terrain';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).onset = [39 142.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).duration = 18;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).name = 'Difficult_Terrain';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).onset = [4.5 177];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).duration = 18;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).orth = 1;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = cellstr(art_regression_outlier_files2); % ART file goes here
matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;

matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = -inf;  % check for issues (-inf removes "holes")
matlabbatch{1}.spm.stats.fmri_spec.mask = {'C:\Matlab_toolboxes\spm12\spm12\tpm\mask_ICV.nii,1'};  % mask available on M drive as well
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';


spm_jobman('run',matlabbatch);
clear matlabbatch

% Model Estimation
%--------------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr(fullfile(data_path,'Processed/MRI_files/05_MotorImagery','SPM.mat'));
% Contrasts
%--------------------------------------------------------------------------

% Where do we get SPM.mat??
design_matrix_file = spm_select('FPList', fullfile(data_path,'Processed/MRI_files/05_MotorImagery'),'SPM.mat');%design matrix 
matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr(design_matrix_file);
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

spm_jobman('run',matlabbatch);
clear matlabbatch

%  Need names to reflect different imagination conditions 
%001 = Tap Activation [1 0 0 0 0 0 0 0 0 0 0 0 0 1]

design_matrix_file = spm_select('FPList', fullfile(data_path,'Processed/MRI_files/05_MotorImagery'),'SPM.mat');%design matrix 
matlabbatch{1}.spm.stats.con.spmmat = cellstr(design_matrix_file);

matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Difficult_Terrain>Flat_Terrain';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [0 0 -1 1 0 1 -1 0 0 0 0 0 0 0 0 1 0 -1 0 0 1 0 -1 ];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

%002 = Tap Deactivation [-1 0 0 0 0 0 0 0 0 0 0 0 0 -1]
matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Difficult_Terrain>Lowest_Terrain';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 -1 0 1 -1 1 0 0 0 0 0 0 0 0 0 1 0 0 -1 0 1 -1 0 ];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

%003 = Count Activation [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1] 
matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Lowest_Terrain>Flat_Terrain';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 1 -1 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 -1 1 0 0 1 -1 ];
matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.delete = 0; %this deletes the previously exisiting contrasts; set to 0 if you do not want to delete previous contrasts! 


% 
% % Inference Results
% %--------------------------------------------------------------------------
% matlabbatch{1}.spm.stats.results.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
% matlabbatch{1}.spm.stats.results.conspec.contrasts = 1;
% matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'FWE';
% matlabbatch{1}.spm.stats.results.conspec.thresh = 0.05;
% matlabbatch{1}.spm.stats.results.conspec.extent = 0;
% matlabbatch{1}.spm.stats.results.print = false;
% 
% % Rendering
% %--------------------------------------------------------------------------
% matlabbatch{1}.spm.util.render.display.rendfile = {fullfile(spm('Dir'),'canonical','cortex_20484.surf.gii')};
% matlabbatch{1}.spm.util.render.display.conspec.spmmat = cellstr(fullfile(data_path,'GLM','SPM.mat'));
% matlabbatch{1}.spm.util.render.display.conspec.contrasts = 1;
% matlabbatch{1}.spm.util.render.display.conspec.threshdesc = 'FWE';
% matlabbatch{1}.spm.util.render.display.conspec.thresh = 0.05;
% matlabbatch{1}.spm.util.render.display.conspec.extent = 0;

spm_jobman('run',matlabbatch);
clear matlabbatch
