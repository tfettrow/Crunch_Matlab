% create function that requires input of 1) xlsx file name .. and... 
% close all
% 
% spm_results_ui
% 
% 
% gin_dlabels
% gin_clusters_plabels

% insert pause to extract table data
aal_table_info = ans;

for this_row = 1: length(aal_table_info.dat)
    x(this_row,1) = aal_table_info.dat{this_row,1}(1);
    y(this_row,1) = aal_table_info.dat{this_row,1}(2);
    z(this_row,1) = aal_table_info.dat{this_row,1}(3);
    roi_name{this_row,:} = aal_table_info.dat{this_row,2};
    distance(this_row,1) = aal_table_info.dat{this_row,3};
end

T = table(x, y, z, distance, roi_name)

writetable(T, 'interaction_ya_gt_oa_rois.xlsx')
