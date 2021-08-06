function convert_nii2gii(varargin)
%  extract_cortical_thickness('roi_settings_filename', 'ROI_settings_CAT12_surface', 'subjects', {'1002','1004','1007','1009','1010','1011','1013','1020','1022','1027','1024','2021','2015','2002','2018','2017','2012','2025','2020','2026','2023','2022','2007','2013','2008','2033','2034','2037','2052','2042','3004','3006','3007','3008'},'group_names',{'YA' 'hOA' 'lOA'},'group_ids',[1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3],'save_figures',0, 'no_labels', 0)
parser = inputParser;
parser.KeepUnmatched = true;
addParameter(parser, 'roi_settings_filename', '')
parse(parser, varargin{:})
roi_settings_filename = parser.Results.roi_settings_filename;
project_path = pwd;
close all


% go into subject folder, grab the combined thickness file, and for each
% ROI in ROI_surfuace_settings.txt grab the ROI mesh, and extract the
% corresponding subject data (avg) and store in thickness_data


if isempty(roi_settings_filename)
    error('need an roi settings file for this analysis')
end
file_name = roi_settings_filename;

fileID = fopen(file_name, 'r');

% read text to cell
text_line = fgetl(fileID);
text_cell = {};
while ischar(text_line)
    text_cell = [text_cell; text_line]; %#ok<AGROW>
    text_line = fgetl(fileID);
end
fclose(fileID);

% prune lines
lines_to_prune = false(size(text_cell, 1), 1);
for i_line = 1 : size(text_cell, 1)
    this_line = text_cell{i_line};
    
    % remove initial white space
    while ~isempty(this_line) && (this_line(1) == ' ' || double(this_line(1)) == 9)
        this_line(1) = [];
    end
    settings_cell{i_line} = this_line; %#ok<AGROW>
    
    % remove comments
    if length(this_line) > 1 && any(ismember(this_line, '#'))
        lines_to_prune(i_line) = true;
    end
    
    % flag lines consisting only of white space
    if all(ismember(this_line, ' ') | double(this_line) == 9)
        lines_to_prune(i_line) = true;
    end
    
end
settings_cell(lines_to_prune) = [];

for this_roi_index = 1:length(settings_cell)
    this_roi_settings_line = strsplit(settings_cell{this_roi_index}, ',');
    roi_core_name_cell{this_roi_index} = this_roi_settings_line{1};
    roi_image_cell{this_roi_index} = strtrim(this_roi_settings_line{4});
    roi_name_cell{this_roi_index} = strtrim(this_roi_settings_line{4});
end

for this_roi_index = 1:length(roi_image_cell)
    this_roi_file = roi_image_cell{this_roi_index};
    roi_image = strcat('\\exasmb.rc.ufl.edu\blue\rachaelseidler\share\FromExternal\Research_Projects_UF\CRUNCH\MiM_Data\ROIs\',this_roi_file,'.nii');
    clear matlabbatch
    matlabbatch{1}.spm.tools.cat.stools.vol2surftemp.data_vol = cellstr(roi_image);
    matlabbatch{1}.spm.tools.cat.stools.vol2surftemp.merge_hemi = 1;
    matlabbatch{1}.spm.tools.cat.stools.vol2surftemp.mesh32k = 1;
    matlabbatch{1}.spm.tools.cat.stools.vol2surftemp.sample = {'maxabs'};
    matlabbatch{1}.spm.tools.cat.stools.vol2surftemp.interp = {'linear'};
    matlabbatch{1}.spm.tools.cat.stools.vol2surftemp.datafieldname = 'intensity';
    matlabbatch{1}.spm.tools.cat.stools.vol2surftemp.mapping.rel_mapping.class = 'GM';
    matlabbatch{1}.spm.tools.cat.stools.vol2surftemp.mapping.rel_mapping.startpoint = -0.5;
    matlabbatch{1}.spm.tools.cat.stools.vol2surftemp.mapping.rel_mapping.steps = 7;
    matlabbatch{1}.spm.tools.cat.stools.vol2surftemp.mapping.rel_mapping.endpoint = 0.5;
    spm_jobman('run',matlabbatch);
end

