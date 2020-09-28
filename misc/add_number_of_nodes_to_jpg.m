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
  
function add_number_of_nodes_to_jpg(varargin)
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
    this_file_unique_networks = strtrim(unique(this_roi_settings_split(:,5)));
    
    for this_unique_network_index = 1:length(this_file_unique_networks)
        % 1) for each network identify how many nodes there are (number of
        % rows where network name is present)
        % 2) read in mask jpg
        % 3) write the num of nodes in white with green background (see
        % history in command line) https://www.mathworks.com/help/vision/ref/inserttext.html
        
        number_of_nodes_this_network = find(contains(this_roi_settings_split(:,5),this_file_unique_networks{this_unique_network_index}));
        summed_number_of_nodes_this_network = length(number_of_nodes_this_network);
        
        % hard hack for settings file issues
        if strcmp(roi_settings_filename, 'ROI_settings_Gordon2016.txt')
            image_filename = ['ROIs' filesep 'Gordon2016_' this_file_unique_networks{this_unique_network_index} '_mask.png'];
        else
            image_filename = ['ROIs' filesep this_file_unique_networks{this_unique_network_index} '_mask.png'];
        end
        
        image_data=imread(image_filename);
        text = strcat(num2str(summed_number_of_nodes_this_network), {' '}, 'nodes');
        
        image_data_with_text = insertText(image_data,[5 5],text,'FontSize',18,'BoxColor',...
            'green','BoxOpacity',0.4,'TextColor','white');
        
        figure
%         imshow(image_data_with_text)
        imshow(image_data_with_text, 'Border', 'tight')
%         f=getframe; imwrite(f.cdata,image_filename);
        
        
        saveas(gca, image_filename)

    end

end
end