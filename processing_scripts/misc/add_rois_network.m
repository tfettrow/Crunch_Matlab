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
  
function add_rois_network(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
addParameter(parser, 'roi_settings_filename', '')
parse(parser, varargin{:})
roi_settings_filename = parser.Results.roi_settings_filename;


%% read roi settings file
if ~isempty(roi_settings_filename)
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
    
    roi_dir = dir([strcat('ROIs', filesep,'*.nii')]);
    clear roi_file_name_list;
    [available_roi_file_name_list{1:length(roi_dir)}] = deal(roi_dir.name);
    
    for this_roi_index = 1:length(settings_cell)
         this_roi_settings_split(this_roi_index,:) = strsplit(settings_cell{this_roi_index}, ',');
    end
    
    % 1) find the unique networks           
    this_file_unique_networks = unique(this_roi_settings_split(:,5))
    for this_unique_network_index = 1:length(this_file_unique_networks)-4
        these_rois_unique_network_bool = contains(this_roi_settings_split(:,5), this_file_unique_networks(this_unique_network_index));
        these_rois_unique_network_indices = find(these_rois_unique_network_bool);
        this_roi_core_name = this_roi_settings_split(these_rois_unique_network_indices,4);
        this_roi_file_name = strcat(this_roi_core_name, '.nii');
        [fda, this_roi_index_in_available_files, asdf] = intersect(available_roi_file_name_list, this_roi_file_name);
        % 2) for each netowk, fin the rois within that network assign it to the files for
        % imcalc an add them all together
        % Make GM mask. i1==1.  
        
        expression = '';
        for this_roi_index = 1:length(this_roi_index_in_available_files)
            these_rois_file_names{this_roi_index,:} = strcat('ROIs', filesep, available_roi_file_name_list{this_roi_index_in_available_files(this_roi_index)});
            % assumming just want to add whatever comes through this
            % function
            
            expression = strcat(expression,'i',num2str(this_roi_index));
            if this_roi_index ~= length(this_roi_index_in_available_files)
                expression = strcat(expression,'+');
            end
        end
        % create an expresion i1 + i2 ... length of this_roi_index_in_available_files
        
        matlabbatch{1}.spm.util.imcalc.input = these_rois_file_names;
        matlabbatch{1}.spm.util.imcalc.output = strcat(this_file_unique_networks{this_unique_network_index}, '_mask');
        matlabbatch{1}.spm.util.imcalc.outdir = {''};
        matlabbatch{1}.spm.util.imcalc.expression = expression;
        matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
        matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{1}.spm.util.imcalc.options.mask = 0;
        matlabbatch{1}.spm.util.imcalc.options.interp = 1;
        matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
        
        spm_jobman('run',matlabbatch);
        clear matlabbatch
    end
end
end