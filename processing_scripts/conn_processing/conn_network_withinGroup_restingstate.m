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

function conn_network_withinGroup_restingstate(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'project_name', 'conn_project')
addParameter(parser, 'primary', 'smoothed_warpedToMNI_unwarpedRealigned_slicetimed_RestingState.nii')
addParameter(parser, 'secondary', ' ')
addParameter(parser, 'structural', 'warpedToMNI_biascorrected_SkullStripped_T1.nii')
addParameter(parser, 'roi_templates', ' ')
addParameter(parser, 'TR', 1.5)
addParameter(parser, 'subjects', ' ')
parse(parser, varargin{:})
TR = parser.Results.TR;
subjects = parser.Results.subjects;
primary = parser.Results.primary;
structural = parser.Results.structural;
secondary = parser.Results.secondary;
roi_templates = parser.Results.roi_templates;
project_name = parser.Results.project_name;

disp(strcat(['Primary: ', primary, ' Structural: ', structural, ' Secondary: ', secondary]));

clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

for this_subject_index = 1:length(subjects)
    this_subject = subjects(this_subject_index);
    cd(strcat([this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep '04_rsfMRI' filesep 'ANTS_Normalization']))
    data_path = pwd;
    
    primary_path = spm_select('FPList', data_path, strcat('^',primary,'$'));
    structural_path = spm_select('FPList', data_path, strcat('^',structural,'$'));
    secondary_path = spm_select('FPList', data_path, strcat('^',secondary,'$'));
    
    BATCH.Setup.nsubjects=length(subjects);
    BATCH.Setup.structurals{this_subject_index} = structural_path;
    BATCH.Setup.functionals{this_subject_index}{1} = primary_path;
    BATCH.Setup.secondarydatasets{this_subject_index}{1} = secondary_path;
    
    cd('..')
    
    data_path = pwd;
    BATCH.Setup.covariates.names = {'head_movement'};
    
    this_outlier_and_movement_file = spm_select('FPList', data_path, strcat('^','art_regression_outliers_and_movement_unwarpedRealigned_slicetimed_RestingState.mat','$'));
  
    BATCH.Setup.covariates.files{1}{this_subject_index}{1} = this_outlier_and_movement_file;
    
    cd(strcat(['..' filesep '..' filesep '..' filesep '..' ]))    
end

BATCH.filename = project_name;
BATCH.Setup.isnew=1;
BATCH.Setup.done=1;
BATCH.Setup.overwrite=1;
BATCH.Setup.RT=TR;
BATCH.Setup.acquisitiontype=1;
    
for this_roi_index = 1:length(roi_templates)
    roi_path_split = strsplit(roi_templates{this_roi_index},filesep);
    roi_name = roi_path_split{end};
    roi_core_name = strsplit(roi_name, '.')
    roi_final_name = strrep(roi_core_name{1},'-', '_');
    BATCH.Setup.rois.names{this_roi_index} = roi_final_name;
    BATCH.Setup.rois.files{this_roi_index} = roi_templates{this_roi_index};
    BATCH.Setup.rois.multiplelabels(1) = 1;
    BATCH.Setup.rois.dataset(this_roi_index) = 1;
    BATCH.Setup.rois.add = 1;
end

BATCH.Setup.analyses=[1,2,3];
BATCH.Setup.outputfiles=[0,0,0,0,0,0];

BATCH.Denoising.done=1;

BATCH.Analysis.done =1;
BATCH.Analysis.measure = 1; % 1 = 'correlation (bivariate)', 2 = 'correlation (semipartial)', 3 = 'regression (bivariate)', 4 = 'regression (multivariate)'; [1]
BATCH.Analysis.type = 3;

conn_batch(BATCH)
end