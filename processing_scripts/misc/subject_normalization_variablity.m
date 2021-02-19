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

% WARNING: This assumes there is always a smoothed and nonsmoothed dataset also does not take into account multiple secondary
  % datasets
  
function subject_normalization_variablity(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
addParameter(parser, 'subjects', '')
addParameter(parser, 'file_to_compare', '')
addParameter(parser, 'image_folder', '')  %% fmri processing  folder
parse(parser, varargin{:})
subjects = parser.Results.subjects;
file_to_compare = parser.Results.file_to_compare;
image_folder = parser.Results.image_folder;

clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

if isempty(subjects)
    error('need to specify input for arguments "task_folder" and "subjects" ')
end

for this_subject_index = 1:length(subjects)
    this_subject = subjects(this_subject_index);
    data_path = pwd;
    this_subject_path = strcat([data_path filesep this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep image_folder filesep 'ANTS_Normalization']);
   
    file_to_compare_path = spm_select('FPList', this_subject_path, strcat('^',file_to_compare,'$'));
    
%     Mean_image_path = spm_select('FPList', this_subject_path, strcat('^Mean_',file_to_compare,'$'));
%     
%     matlabbatch{1}.spm.util.imcalc.input = {Mean_image_path};
%     matlabbatch{1}.spm.util.imcalc.output = strcat('ThresMean_',file_to_compare);
%     matlabbatch{1}.spm.util.imcalc.outdir = {this_subject_path};
%     matlabbatch{1}.spm.util.imcalc.expression = 'i1>20';
%     matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
%     matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
%     matlabbatch{1}.spm.util.imcalc.options.mask = 0;
%     matlabbatch{1}.spm.util.imcalc.options.interp = 1;
%     matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
%     
%     spm_jobman('run',matlabbatch);
%     clear matlabbatch
    
    files_to_compare_imcalc_input{1,:} = file_to_compare_path;
    files_to_compare_imcalc_input{2,:} = spm_select('FPList', this_subject_path, strcat('^ThresMean_',file_to_compare,'$'));
        
    matlabbatch{1}.spm.util.imcalc.input = files_to_compare_imcalc_input;
    matlabbatch{1}.spm.util.imcalc.output = strcat(subjects{this_subject_index}, '_normalized_intensity_for_subject_normalization_variability_analysis');
    matlabbatch{1}.spm.util.imcalc.outdir = {this_subject_path};
    matlabbatch{1}.spm.util.imcalc.expression = '(i1 ./ i2.*(i2>20)) .* 100';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end



