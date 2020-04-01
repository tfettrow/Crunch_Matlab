peak_coord_indices = find(~cellfun(@isempty,TabDat.dat(:,4)));

fid = fopen('ROIs.txt','wt');
% fprintf(fid, 'Happy\nNew\nYear');

for this_roi = 1:5
    fprintf(fid, strcat('roi',num2str(this_roi),', '));
    this_peak_coordinates = TabDat.dat{peak_coord_indices(this_roi),12};
    for this_coord = 1:3
        fprintf(fid, strcat(num2str(this_peak_coordinates(this_coord)), ', '));
    %     disp(this_peak_coord')
    end
     fprintf(fid, '\n');
end

fclose(fid);