function convert_to_voxel_coordinates(roi_name, roi_x, roi_y, roi_z)
% roi_name = 'caudate';
% % roi_mni_coord = [-34 -32 66];
% roi_x = '0';
% roi_y = '24'; 
% roi_z = '-4';


roi_name = strtrim(roi_name);

roi_x = str2num(roi_x);
roi_y = str2num(roi_y);
roi_z = str2num(roi_z);

this_contrast_data = spm_vol('MNI_2mm.nii');

this_roi_vox_coord = [roi_x roi_y roi_z 1] / this_contrast_data.mat' -1;
this_roi_vox_coord1 = this_roi_vox_coord(1);
this_roi_vox_coord2 = this_roi_vox_coord(2);
this_roi_vox_coord3 = this_roi_vox_coord(3);


T = cell2table({this_roi_vox_coord}, 'VariableNames', {roi_name});

writetable(T, strcat('roi_',roi_name,'.csv'))

disp([roi_name ' information converted and saved'])
% need to open MNIROIs and determine whether this roi_name exists. if so overwrite this row. 
% fileID = fopen('MNIROIs.txt','r+');

% % read text to cell
%     text_line = fgetl(fileID);
%     text_cell = {};
%     while ischar(text_line)
%         text_cell = [text_cell; text_line]; %#ok<AGROW>
%         text_line = fgetl(fileID);
%     end
   
% fclose(fileID);
%      % prune lines
% %      lines_to_prune = false(size(text_cell, 1), 1);
%      for i_line = 1 : size(text_cell, 1)
%          this_line = text_cell{i_line};
%          split_line = strsplit(this_line,',')
%          if strcmp(split_line{1}, roi_name)
%              replace_line = 1;
%              line_to_write = i_line;
%              break
%          else
%              replace_line = 0;
%              line_to_write = i_line + 1;
%          end
%      end
     
%      text_cell{line_to_write} = sprintf('%s,%s,%s,%s',  roi_name, strcat(num2str(this_roi_vox_coord(1))), strcat(num2str(this_roi_vox_coord(2))),strcat(num2str(this_roi_vox_coord(3))))
%      for this_coord = 1:3
%           text_cell{line_to_write} = strcat(num2str(this_roi_vox_coord(this_coord)), ', ')
%      end
%          
%          % remove initial white space
%          while ~isempty(this_line) && (this_line(1) == ' ' || double(this_line(1)) == 9)
%              this_line(1) = [];
%          end
%          outlier_removal_cell{i_line} = this_line; %#ok<AGROW>
%    
%      end
%      fileID = fopen('MNIROIs.txt','wt');
%     for this_roi_line_to_write = 1 : size(text_cell, 1)
%         fprintf(fileID, text_cell{this_roi_line_to_write});
%         fprintf(fileID, '\n');
%     end
% 
% fclose(fileID);

% 
% T = cell2table({this_roi_vox_coord}, 'VariableNames', {strcat('roi_',roi_name)});
% 
% writetable(T, strcat('MNIroi_',roi_name,'.csv'))
% 
% disp([roi_name ' roi converted and saved'])
% mni_roi_x = [roi_x] / this_contrast_data.mat' -1;
end