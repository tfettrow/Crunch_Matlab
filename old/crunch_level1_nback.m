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

smooth_normalized_unwarped_functional_imagery_files = spm_select('ExtFPList', fullfile(data_path,'Processed/MRI_files/06_Nback'), '^smooth_wslicetimed_unwarpedRealigned.*\.nii$');
art_regression_outlier_files  = spm_select('FPList',  fullfile(data_path,'Processed/MRI_files/06_Nback'),'art_regression_outliers_and_movement.*.mat');

smooth_normalized_unwarped_functional_imagery_files1 = smooth_normalized_unwarped_functional_imagery_files(1:200,:);
smooth_normalized_unwarped_functional_imagery_files2 = smooth_normalized_unwarped_functional_imagery_files(201:400,:);
smooth_normalized_unwarped_functional_imagery_files3 = smooth_normalized_unwarped_functional_imagery_files(401:602,:);
smooth_normalized_unwarped_functional_imagery_files4 = smooth_normalized_unwarped_functional_imagery_files(603:804,:);


art_regression_outlier_files1 = art_regression_outlier_files(1,:);
art_regression_outlier_files2 = art_regression_outlier_files(2,:);
art_regression_outlier_files3 = art_regression_outlier_files(3,:);
art_regression_outlier_files4 = art_regression_outlier_files(4,:);

% Model Specification
%--------------------------------------------------------------------------
% TO DO: specify proper directory
matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(fullfile(data_path,'Processed/MRI_files/06_Nback'));
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 1.5;


% Run 1
matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = cellstr(smooth_normalized_unwarped_functional_imagery_files1);

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = 'zero_short';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = [4.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = 13.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name = 'one_short';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = [154.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = 13.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).name = 'two_short';
% matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).onset = [185];  % 186 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).onset = [186];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).duration = 13.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).name = 'three_short';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).onset = [79.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).duration = 13.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).name = 'zero_long';
% matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).onset = [215.5]; % 216 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).onset = [216];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).duration = 26;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(5).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).name = 'one_long';
% matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).onset = [109]; % 109.5 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).onset = [109.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).duration = 27;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(6).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).name = 'two_long';
% matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).onset = [35]; % 36 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).onset = [36];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).duration = 27;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(7).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(8).name = 'three_long';
% matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(8).onset = [260]; % 261 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(8).onset = [261];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(8).duration = 27;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(8).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(8).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = cellstr(art_regression_outlier_files1); % ART file goes here
matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;

% Run 2
matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = cellstr(smooth_normalized_unwarped_functional_imagery_files2);

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).name = 'zero_short';
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).onset = [140.5];  % 141 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).onset = [141];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).duration = 13.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).name = 'one_short';
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).onset = [35];  % 36 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).onset = [36];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).duration = 13.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).name = 'two_short';
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).onset = [110]; % 111 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).onset = [111];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).duration = 13.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).name = 'three_short';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).onset = [4.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).duration = 13.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).name = 'zero_long';
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).onset = [65.5];  % 66 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).onset = [66];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).duration = 27.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(5).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).name = 'one_long';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).onset = [217.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).duration = 27;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(6).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(7).name = 'two_long';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(7).onset = [171];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(7).duration = 27;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(7).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(7).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(8).name = 'three_long';
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(8).onset = [260];  % 261 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(8).onset = [261];
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(8).duration = 27;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(8).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(8).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = cellstr(art_regression_outlier_files1); % ART file goes here
matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;

% Run 3
matlabbatch{1}.spm.stats.fmri_spec.sess(3).scans = cellstr(smooth_normalized_unwarped_functional_imagery_files3);

matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).name = 'zero_short';
% matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).onset = [124];  % 124.5 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).onset = [124.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).duration = 13.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).name = 'one_short';
% matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).onset = [274];  % 274.5 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).onset = [274.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).duration = 13.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).name = 'two_short';
% matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).onset = [49];   % 49.5 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).onset = [49.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).duration = 13.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).name = 'three_short';
% matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).onset = [243.5];  % 244.5 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).onset = [244.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).duration = 13.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(5).name = 'zero_long';
% matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(5).onset = [199];    % 199.5 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(5).onset = [199.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(5).duration = 27;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(5).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(5).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(6).name = 'one_long';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(6).onset = [4.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(6).duration = 27;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(6).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(6).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(7).name = 'two_long';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(7).onset = [154.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(7).duration = 27;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(7).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(7).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(8).name = 'three_long';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(8).onset = [79.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(8).duration = 27;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(8).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(8).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi_reg = cellstr(art_regression_outlier_files3); % ART file goes here
matlabbatch{1}.spm.stats.fmri_spec.sess(3).hpf = 128;

% Run 4
matlabbatch{1}.spm.stats.fmri_spec.sess(4).scans = cellstr(smooth_normalized_unwarped_functional_imagery_files4);

matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).name = 'zero_short';
% matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).onset = [49];   % 49.5 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).onset = [49.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).duration = 13.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).name = 'one_short';
% matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).onset = [110];   % 111 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).onset = [111];
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).duration = 13.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).name = 'two_short';
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).onset = [79.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).duration = 13.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(4).name = 'three_short';
% matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(4).onset = [185];  % 186would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(4).onset = [186];
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(4).duration = 13.5;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(4).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(4).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(4).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(5).name = 'zero_long';
% matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(5).onset = [140.5];   % 141 would be next full TR... what about duration ?
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(5).onset = [141];
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(5).duration = 27;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(5).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(5).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(5).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(6).name = 'one_long';
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(6).onset = [260];
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(6).duration = 27;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(6).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(6).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(6).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(7).name = 'two_long';
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(7).onset = [215.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(7).duration = 27;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(7).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(7).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(7).orth = 1;


matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(8).name = 'three_long';
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(8).onset = [4.5];
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(8).duration = 27;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(8).tmod = 0;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(8).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(8).orth = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi = {''};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi_reg = cellstr(art_regression_outlier_files4); % ART file goes here
matlabbatch{1}.spm.stats.fmri_spec.sess(4).hpf = 128;


matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = -inf;  % check for issues (-inf removes "holes")
matlabbatch{1}.spm.stats.fmri_spec.mask = {'Code/Spm/helper/mask_ICV.nii,1'};  % mask available on M drive as well
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';


spm_jobman('run',matlabbatch);
clear matlabbatch

% Model Estimation
%--------------------------------------------------------------------------
matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr(fullfile(data_path,'Processed/MRI_files/06_Nback','SPM.mat'));
% Contrasts
%--------------------------------------------------------------------------

% Where do we get SPM.mat??
design_matrix_file = spm_select('FPList', fullfile(data_path,'Processed/MRI_files/06_Nback'),'SPM.mat');%design matrix 
matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr(design_matrix_file);
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

spm_jobman('run',matlabbatch);
clear matlabbatch

%  Need names to reflect different imagination conditions 
%001 = Tap Activation [1 0 0 0 0 0 0 0 0 0 0 0 0 1]

design_matrix_file = spm_select('FPList', fullfile(data_path,'Processed/MRI_files/06_Nback'),'SPM.mat');%design matrix 
matlabbatch{1}.spm.stats.con.spmmat = cellstr(design_matrix_file);

matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Three_short>Three_long';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [0 0 1 0 0 0 0 -1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 0 -1 0 0 0 1 0 0 0 0 0 0 0 0 -1 0 0 0 0 1 0 0];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Three_short>Zero_short';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [-1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 0 0 1 0 0 0 0 0 0 0 0 0 -1 0 0 0 1 0 0];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Three_short>Zero_long';
matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 0 1 0 0 0 -1 0 0 0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 0];
matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = 'Three_short>One_short';
matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = [0 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 -1 0 1 0 0];
matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = 'Three_short>One_long';
matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = [0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 -1 0 0 0 0 0 0 0 0 -1 0 0 0 0 0 1 0 0 0 0 0 0 0 0  0 0 0 0 0 1 0 -1];
matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';

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
