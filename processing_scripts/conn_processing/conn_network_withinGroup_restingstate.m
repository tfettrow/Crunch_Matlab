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

function conn_network(varargin)
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

functional_file_name = 'smoothed_warpedToMNI_unwarpedRealigned_slicetimed_RestingState.nii';
structural_file_name = 'warpedToMNI_biascorrected_SkullStripped_T1.nii';

    
for this_subject_index = 1:length(varargin)
    this_subject = varargin(this_subject_index);
    cd(strcat([this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep '04_rsfMRI' filesep 'ANTS_Normalization']))    
    data_path = pwd;
    this_restingstate_functional = spm_select('FPList', data_path, strcat('^',functional_file_name,'$'));
    this_structural = spm_select('FPList', data_path, strcat('^',structural_file_name,'$'));
    
    BATCH.Setup.nsubjects=length(varargin);
    
    BATCH.Setup.structurals{this_subject_index} = this_structural;
    
    BATCH.Setup.functionals{this_subject_index}{1} = this_restingstate_functional;
    
    cd('..')
    
    data_path = pwd;
    BATCH.Setup.covariates.names = {'head_movement'};
    
    this_outlier_and_movement_file = spm_select('FPList', data_path, strcat('^','art_regression_outliers_and_movement_unwarpedRealigned_slicetimed_RestingState.mat','$'))
  
    BATCH.Setup.covariates.files{1}{this_subject_index}{1} = this_outlier_and_movement_file;
     
%  BATCH.Setup.subjects.effect_names
%  BATCH.Setup.subjects.group_names
    
    cd(strcat(['..' filesep '..' filesep '..' filesep '..' ]))    
end


% BATCH.New.steps = {'initialization'};
BATCH.filename = 'conn_project_Ugrant';
BATCH.Setup.isnew=1;
BATCH.Setup.done=1;
BATCH.Setup.overwrite=1;
BATCH.Setup.RT=1.5;
BATCH.Setup.acquisitiontype=1
 
 BATCH.Setup.analyses=[1,2,3];
 BATCH.Setup.outputfiles=[0,0,0,0,0,0];
 
BATCH.Denoising.done=1;

% BATCH.Analysis.measure = 1; % 1 = 'correlation (bivariate)', 2 = 'correlation (semipartial)', 3 = 'regression (bivariate)', 4 = 'regression (multivariate)'; [1]
% BATCH.Analysis.type = 3;
% 
% BATCH.vvAnalysis.done=1;
% 
% BATCH.dynAnalysis.done=1;

conn_batch(BATCH)
end