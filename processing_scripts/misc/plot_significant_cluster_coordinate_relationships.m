% what do we want this to do?
% 1) open TabDat
% 2) identify the 3 biggest clusters via {'equivk'} (col 5 of TabDat)
% 3) extract raw y at each of the coordinates identified (see extraction
% below)
% 4) identify the highest probablity label of peak cluster (that is not
% unknown)

cov_filename = 'covs_split_stp_mag_allVars';
% cov_filename = 'covs_split_stp_mag_groupdiff_allVars';
% cov_filename = 'covs_split_stp_mag_4varSEX';

% contrast_name = 'negative_mpsicop';
% contrast_name = 'ya_gt_oa_steplength';
% contrast_name = 'ya_gt_oa_mpsicop';
contrast_name = 'ya_gt_oa_mpsi';

% cov_of_interest = 'step_length_percent';
% cov_of_interest = 'step_placement_from_mpsis_x_percent_sym';
cov_of_interest = 'mpsis_x_perc_end_sym';
% cov_of_interest = 'mpsis_from_cop_x_integratedStretch_singlestance_percent_sym_response';
save_figures = 1;

results_path = pwd;
results_path_split = strsplit(results_path,'\');
resuls_foldername = results_path_split{end};

project_path = '\\exasmb.rc.ufl.edu\blue\rachaelseidler\share\FromExternal\Research_Projects_UF\CRUNCH\GABA_Data';


covs = load(fullfile(project_path, cov_filename));

if strcmp(resuls_foldername, 'Results_gmv_splitmag') || strcmp(resuls_foldername, 'Results_gmv_splitmag_4varSEX')
    group_ids = covs.R(:,1);
    cov_data = covs.R(:,contains(covs.names,cov_of_interest));
elseif strcmp(resuls_foldername, 'Results_gmv_splitmag_groupdiff')
    cov_data_ya = covs.R(:,contains(covs.names,strcat(cov_of_interest,'_YA')));
    cov_data_ya(cov_data_ya==0) = [];
    cov_data_oa = covs.R(:,contains(covs.names,strcat(cov_of_interest,'_OA')));
    cov_data_oa(cov_data_oa==0) = [];
    cov_data = [cov_data_ya; cov_data_oa];
    if length(cov_data) ~= 50
       error('problem with length of covariates') 
    end
end

peak_coord_indices = find(~cellfun(@isempty,TabDat.dat(:,5)));
peak_coordinates = TabDat.dat(:,12);
 
figure; hold on;
t = tiledlayout(1,3);
for this_peak_coord = 1:length(peak_coord_indices)
    XYZmm = peak_coordinates{peak_coord_indices(this_peak_coord)};
    
    % Label coordinate
    %--------------------------------------------------------------
    %%% pulled from cg_tfce_list.m (within tfce toolbox folder) %%%
    atlas_info = spm_atlas('load','AAL3'); % could also load neuromorphometrics here? or potentially any other atlas.. cool stuff
    %-Consider peak only
    labk  = spm_atlas('query',atlas_info,XYZmm);
    %  %-Consider a 10mm sphere around the peak
    %  [labk,P] = spm_atlas('query',xA,...
    %      struct('def','sphere','spec',10,'xyz',XYZmm));
    
    % Grab voxel Y values
    %--------------------------------------------------------------
    % this is the way to convert mm (SPM default coord units) into voxel
    % coordinates (what the spm funcs need to pull values)
    % see
    % https://jacoblee.net/occamseraser/2018/01/03/extracting-rois-for-ppi-analysis-using-spm-batch/index.html
    % for functions on grabbing raw and filtered y values
    xyz_vox = xSPM.iM*[XYZmm;1]; %evalin('base','xSPM.iM*[xyz_mm;1]'); % avoid passing xSPM explicitly
    raw_y_voxeldata = spm_get_data(SPM.xY.VY,xyz_vox);
    
    % create a subfig for each peak coord
    %--------------------------------------------------------------
    % WARNING:  hard coding group stuff here
   
%     ya_subject_indices = find(group_ids==-1);
%     oa_subject_indices = find(group_ids==1);
    ya_subject_indices = 1:31;
    oa_subject_indices = 32:50;
 
    group_color_matrix = distinguishable_colors(2);
    
    nexttile; hold on;
    %     subplot(1,3,this_peak_coord); hold on;
    % plot ya
    ya_x = linspace(min(raw_y_voxeldata(ya_subject_indices)), max(raw_y_voxeldata(ya_subject_indices)), 100);
    ya_coef = polyfit(raw_y_voxeldata(ya_subject_indices), cov_data(ya_subject_indices),1);
    ya_fit = polyval(ya_coef,ya_x);
    
    plot(raw_y_voxeldata(ya_subject_indices), cov_data(ya_subject_indices), 'o', 'MarkerFaceColor', group_color_matrix(1,:), 'MarkerEdgeColor', 'w');
    plot(ya_x, ya_fit, '-', 'Color', group_color_matrix(1,:), 'LineWidth', 3)
    
    
    % plot oa
    oa_x = linspace(min(raw_y_voxeldata(oa_subject_indices)), max(raw_y_voxeldata(oa_subject_indices)), 100);
    oa_coef = polyfit(raw_y_voxeldata(oa_subject_indices), cov_data(oa_subject_indices),1);
    oa_fit = polyval(oa_coef,oa_x);
    
    plot(raw_y_voxeldata(oa_subject_indices), cov_data(oa_subject_indices), 'o', 'MarkerFaceColor', group_color_matrix(2,:), 'MarkerEdgeColor', 'w');
    plot(oa_x, oa_fit, '-', 'Color', group_color_matrix(2,:), 'LineWidth', 3)
    
    title(labk,'interpreter','none')
    subtitle(strcat('[',num2str(XYZmm(1)),',',num2str(XYZmm(2)),',',num2str(XYZmm(3)),']'),'interpreter','none')
    
    if this_peak_coord == 3
        break;
    end
end

% title(t, strcat(resuls_foldername, ' vs' 
xlabel(t, 'GMV')
ylabel(t, strcat(cov_of_interest, ' asymmetry'),'interpreter','none')

if save_figures 
    mkdir('figures')
    fig_title = strcat(contrast_name, '_vs_', cov_of_interest);
    filename =  fullfile(results_path, 'figures', fig_title);
    saveas(gca, filename, 'tiff')
end

