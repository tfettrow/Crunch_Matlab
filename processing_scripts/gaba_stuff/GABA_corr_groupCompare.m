function GABA_corr_groupCompare(varargin)
% plot_CAT12_results('task_folder', '05_MotorImagery', 'subjects',
% plot_CAT12_results('task_folder', '02_T1', 'subjects', {'1002','1004','1007','1009','1010','1011','1013','1020','1022','1027','1024','2021','2015','2002','2018','2017','2012','2025','2020','2026','2023','2022','2007','2013','2008','2033','2034','2037','2052','2042','3004','3006','3007','3008'},'group_names',{'YA' 'hOA' 'lOA'},'group_ids',[1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3],'save_figures',0, 'no_labels', 0)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'subjects', '')
addParameter(parser, 'cov_filename', '');
addParameter(parser, 'output_dir', '');
addParameter(parser, 'tfce_only', 0);
addParameter(parser, 'image_type', '');
parse(parser, varargin{:})
subjects = parser.Results.subjects;
cov_filename = parser.Results.cov_filename;
output_dir = parser.Results.output_dir;
tfce_only = parser.Results.tfce_only;
image_type = parser.Results.image_type;
data_path = pwd;

% results_drive = 'G:\Shared drives\GABA_Aging_MoCap';
% image_drive = 'G:\Shared drives\GABA_Aging_Brain_Structure\BRAIN_DATA';

%% Set output dir
% MAKE SURE THIS IS SET PROPERLY TO INTENDED FOLDER
full_output_dir = fullfile(data_path, output_dir);
% full_output_dir = fullfile(results_drive, output_dir);

% Select covariate *.mat file based on output directory
% cov_file = spm_select('FPList', data_path, strcat(cov_filename,'.mat'));
cov_file = spm_select('FPList', data_path, strcat(cov_filename,'.mat'));

%% Specify the model
clear matlabbatch


       
% Set output dir
matlabbatch{1}.spm.stats.factorial_design.dir = cellstr(full_output_dir);

scans = {};
for this_subject_index = 1 : length(subjects)
    if strcmp(image_type, 'whole_brain')
        %     this_subject_t1_path = fullfile(image_drive, subjects{this_subject_index}, '\01_CAT12_v1725\mri', strcat('s8_mwp1T1_',subjects{this_subject_index},'.nii'));
         this_subject_t1_path = fullfile(data_path, subjects{this_subject_index}, 'structural_metrics', strcat('s8_mwp1T1_',subjects{this_subject_index},'.nii'));
    elseif strcmp(image_type, 'cerebellum')
        this_subject_t1_path = fullfile(data_path, subjects{this_subject_index}, 'structural_metrics', strcat('p0_',subjects{this_subject_index},'_SUIT_Mod_S2.nii'));
    elseif strcmp(image_type, 'cortical_thickness')
        this_subject_t1_path = fullfile(data_path, subjects{this_subject_index}, 'structural_metrics', strcat('s15.mesh.thickness.resampled_32k.T1_',subjects{this_subject_index},'.gii'));
    elseif strcmp(image_type, 'sulcal_depth')
        this_subject_t1_path = fullfile(data_path, subjects{this_subject_index}, 'structural_metrics', strcat('s20.mesh.depth.resampled_32k.T1_',subjects{this_subject_index},'.gii'));
    elseif strcmp(image_type, 'fractal_dimension')
        this_subject_t1_path = fullfile(data_path, subjects{this_subject_index}, 'structural_metrics', strcat('s20.mesh.fractaldimension.resampled_32k.T1_',subjects{this_subject_index},'.gii'));
    elseif strcmp(image_type, 'gyrification')
        this_subject_t1_path = fullfile(data_path, subjects{this_subject_index}, 'structural_metrics', strcat('s20.mesh.gyrification.resampled_32k.T1_',subjects{this_subject_index},'.gii'));
    elseif strcmp(image_type, 'tbss_fa')
        this_subject_t1_path = fullfile(data_path, subjects{this_subject_index}, 'structural_metrics', strcat('FAt_skeleton_',subjects{this_subject_index},'.nii'));
    end
    scans = [scans; this_subject_t1_path];
end

% copyfile('/blue/rachaelseidler/tfettrow/Crunch_Code/MR_Templates/Template_1_IXI555_MNI152_bin_noCB_clean2_bin.nii','/blue/rachaelseidler/share/FromExternal/Research_Projects_UF/CRUNCH/GABA_Data')


matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = scans;

% Do not enter covariates individually; instead use covs.mat file
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov.files = cellstr(cov_file);
matlabbatch{1}.spm.stats.factorial_design.multi_cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.multi_cov.iCC = 1;

% Don't change anything below; defaults & run the model spec:
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tma.athresh = 0.1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
if strcmp(image_type, 'whole_brain')
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {'Template_1_IXI555_MNI152_bin_noCB_clean2_bin.nii'};
elseif strcmp(image_type, 'cerebellum')
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {'SUIT_Nobrainstem_1mm.nii'};
else
     matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
end
% matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
if ~tfce_only
    spm_jobman('run',matlabbatch);
end

%% Estimate the SPM model
clear matlabbatch
if strcmp(image_type, 'whole_brain') || strcmp(image_type, 'cerebellum' ) || strcmp(image_type, 'tbss_fa') || strcmp(image_type, 'cortical_thickness' )
    SPMfile = spm_select('FPList', full_output_dir, 'SPM.mat');
    matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr(SPMfile);
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
elseif strcmp(image_type, 'sulcal_depth') || strcmp(image_type, 'gyrification') || strcmp(image_type, 'fractal_dimension')
     SPMfile = spm_select('FPList', full_output_dir, 'SPM.mat');
    matlabbatch{1}.spm.tools.cat.tools.check_SPM.spmmat(1) = cellstr(SPMfile); %cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{1}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.use_unsmoothed_data = 1;
    matlabbatch{1}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.adjust_data = 1;
    matlabbatch{1}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.outdir = {''};
    matlabbatch{1}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.fname = 'CATcheckdesign_';
    matlabbatch{1}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.save = 1;
    matlabbatch{1}.spm.tools.cat.tools.check_SPM.check_SPM_ortho = 1;
end
if ~tfce_only
    spm_jobman('run',matlabbatch);
end
%% Set up the SPM contrasts

if tfce_only
    clear matlabbatch
    SPMfile = spm_select('FPList', full_output_dir,'SPM.mat');
    matlabbatch{1}.spm.stats.con.spmmat = cellstr(SPMfile);
% % % % % ALL VARS
%     matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Step Length YA > OA';
%     matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [0 0 0 1 0 0 0 0 0 0 -1 0 0 0 0 ];
%     matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
%     
%     matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Step Length YA < OA';
%     matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 0 0 -1 0 0 0 0 0 0 1 0 0 0 0 ];
%     matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
%     
%     matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Step-MPSI YA > OA';
%     matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 0 0 0 0 1 0 0 0 0 0 0 -1 0 0 ];
%     matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
%     
%     matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Step-MPSI YA < OA';
%     matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 0 0 -1 0 0 0 0 0 0 1 0 0 ];
%     matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
%     
%     matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'MPSI-CoP YA > OA';
%     matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 0 0 0 1 0 0 0 0 0 0 -1 ];
%     matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
%     
%     matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'MPSI-CoP YA < OA';
%     matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = [0 0 0 0 0 0 0 -1 0 0 0 0 0 0 1 ];
%     matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';

% % % % % %  4var
if strcmp(cov_filename,'covs_split_stp_groupdiff_4var') || strcmp(cov_filename,'covs_split_stp_mag_groupdiff_4var')
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Step Length YA > OA';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [0 0 1 0 0 0 -1 0 0 0];
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Step Length YA < OA';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 0 -1 0 0 0 1 0 0 0];
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Step-MPSI YA > OA';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 0 0 1 0 0 0 -1 0 0];
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Step-MPSI YA < OA';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 -1 0 0 0 1 0 0];
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'MPSI YA > OA';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 1 0 0 0 -1 0];
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'MPSI YA < OA';
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = [0 0 0 0 -1 0 0 0 1 0];
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'MPSI-CoP YA > OA';
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = [0 0 0 0 0 1 0 0 0 -1];
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'MPSI-CoP YA < OA';
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = [0 0 0 0 0 -1 0 0 0 1];
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.delete = 1; % Set to 1 to delete the previously existing contrasts
    spm_jobman('run',matlabbatch);
end

 % % % % % %  4varsSEX or tiv
if strcmp(cov_filename,'covs_split_stp_groupdiff_4varSEX') || strcmp(cov_filename,'covs_split_stp_mag_groupdiff_4varSEX') || strcmp(cov_filename,'covs_split_stp_groupdiff_4var_tiv') || strcmp(cov_filename,'covs_split_stp_mag_groupdiff_4var_tiv') || strcmp(cov_filename,'covs_split_stp_mag_groupdiff_4varSEX_WMonly')
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Step Length YA > OA';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [0 0 0 1 0 0 0 -1 0 0 0];
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Step Length YA < OA';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 0 0 -1 0 0 0 1 0 0 0];
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Step-MPSI YA > OA';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 0 0 0 1 0 0 0 -1 0 0];
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Step-MPSI YA < OA';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 0 -1 0 0 0 1 0 0];
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'MPSI YA > OA';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 0 1 0 0 0 -1 0];
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'MPSI YA < OA';
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = [0 0 0 0 0 -1 0 0 0 1 0];
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'MPSI-CoP YA > OA';
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = [0 0 0 0 0 0 1 0 0 0 -1];
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'MPSI-CoP YA < OA';
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = [0 0 0 0 0 0 -1 0 0 0 1];
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';

    matlabbatch{1}.spm.stats.con.delete = 1; % Set to 1 to delete the previously existing contrasts
    spm_jobman('run',matlabbatch);
end

% % % % % %  4varsSEX_tiv
if strcmp(cov_filename,'covs_split_stp_groupdiff_4varSEX_tiv') || strcmp(cov_filename,'covs_split_stp_mag_groupdiff_4varSEX_tiv')
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Step Length YA > OA';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [0 0 0 0 1 0 0 0 -1 0 0 0];
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Step Length YA < OA';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 0 0 0 -1 0 0 0 1 0 0 0];
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Step-MPSI YA > OA';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 0 0 0 0 1 0 0 0 -1 0 0];
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Step-MPSI YA < OA';
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 0 0 -1 0 0 0 1 0 0];
    matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'MPSI YA > OA';
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 0 0 0 1 0 0 0 -1 0];
    matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'MPSI YA < OA';
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = [0 0 0 0 0 0 -1 0 0 0 1 0];
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = 'MPSI-CoP YA > OA';
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = [0 0 0 0 0 0 0 1 0 0 0 -1];
    matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.name = 'MPSI-CoP YA < OA';
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.weights = [0 0 0 0 0 0 0 -1 0 0 0 1];
    matlabbatch{1}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
    
    matlabbatch{1}.spm.stats.con.delete = 1; % Set to 1 to delete the previously existing contrasts
    spm_jobman('run',matlabbatch);
end

    %% Re-estimate the model using the TFCE toolbox
    clear matlabbatch
    SPMfile = spm_select('FPList', full_output_dir,'SPM.mat');
    matlabbatch{1}.spm.tools.tfce_estimate.spmmat = cellstr(SPMfile);
    matlabbatch{1}.spm.tools.tfce_estimate.nproc = 0;
    matlabbatch{1}.spm.tools.tfce_estimate.mask = '';
    matlabbatch{1}.spm.tools.tfce_estimate.conspec.titlestr = '';
    matlabbatch{1}.spm.tools.tfce_estimate.conspec.contrasts = [1 2 3 4 5 6 7 8];
    matlabbatch{1}.spm.tools.tfce_estimate.conspec.n_perm = 5000;
    matlabbatch{1}.spm.tools.tfce_estimate.nuisance_method = 2;
    if strcmp(image_type, 'tbss_fa')
        matlabbatch{1}.spm.tools.tfce_estimate.tbss = 1; % Set to 0 for GMv; set to 1 if TBSS data
    else
        matlabbatch{1}.spm.tools.tfce_estimate.tbss = 0; % Set to 0 for GMv; set to 1 if TBSS data
    end
    matlabbatch{1}.spm.tools.tfce_estimate.E_weight = 0.5;
    matlabbatch{1}.spm.tools.tfce_estimate.singlethreaded = 1;
    spm_jobman('run',matlabbatch);
end
