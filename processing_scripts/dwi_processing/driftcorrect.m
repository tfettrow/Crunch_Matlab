% exploreDTI drift correction MiM data


data_path = pwd;

par.f_in_nii = strcat(data_path,filesep,'DWI.nii');
par.f_in_txt = strcat(data_path,filesep,'DWI.txt');
par.f_out_nii = 'driftcorrected_DWI.nii';
par.f_out_txt = 'driftcorrected_DWI.txt';
par.method = 2; % 1 = linear, 2 = quadratic, 3 = cubic
par.bvalC = 0; % What b-value is used for the correction
par.bv_thresh = 25; % b-value margin
par.masking.do_it = 1; % 0 = no mask, 1 = use mask
par.masking.p1 = 5; % morph size [1,3,..,7]
par.masking.p2 = 1; % mask tuning [0.5 to 1.5]
par.show_summ_plot = 1;

E_DTI_signal_drift_correction(par);