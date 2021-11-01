% what do we want this to do?
% 1) open TabDat
% 2) identify the 3 biggest clusters via {'equivk'} (col 5 of TabDat)
% 3) extract raw y at each of the coordinates identified (see extraction
% below)
% 4) identify the highest probablity label of peak cluster (that is not
% unknown)

% image_type = 'cortical_thickness';
% image_type = 'cerebellum';
image_type = 'whole_brain';

% cov_filename = 'covs_split_stp_mag_allVars';
% cov_filename = 'covs_split_stp_mag_groupdiff_allVars';
% cov_filename = 'covs_split_stp_mag_4var';
% cov_filename = 'covs_split_stp_mag_4var_tiv';
cov_filename = 'covs_split_stp_mag_4varSEX';
% cov_filename = 'covs_split_stp_mag_4varSEX_tiv';
% cov_filename = 'covs_split_stp_mag_groupdiff_4varSEX_tiv';

% contrast_name = 'positive_steplength';
contrast_name = 'negative_steplength';
% contrast_name = 'negative_mpsi';
% contrast_name = 'negative_mpsicop';
% contrast_name = 'ya_gt_oa_steplength';
% contrast_name = 'ya_gt_oa_mpsicop';
% contrast_name = 'ya_gt_oa_mpsi';

cov_of_interest = 'step_length_percent';
% cov_of_interest = 'step_placement_from_mpsis_x_percent_sym';
% cov_of_interest = 'mpsis_x_perc_end_sym';
% cov_of_interest = 'mpsis_from_cop_x_integratedStretch_singlestance_percent_sym_response';
save_figures = 1;
plot_groups_and_gender = 0;
plot_groups = 0;
plot_all = 1;

results_path = pwd;
results_path_split = strsplit(results_path,'\');
resuls_foldername = results_path_split{end};

project_path = '\\exasmb.rc.ufl.edu\blue\rachaelseidler\share\FromExternal\Research_Projects_UF\CRUNCH\GABA_Data';
%   project_path = 'G:\Shared drives\GABA_Aging_MoCap';
  
ya_sex = [1 1 1 1 -1 -1 1 -1 1 -1 1 1 -1 1 -1 1 -1 1 1 1 1 -1 -1 -1 1 1 1 -1 -1 -1 -1];
oa_sex = [zeros(1,length(ya_sex)) 1 1 -1 -1 1 1 1 -1 1 1 -1 -1 1 -1 1 -1 -1 -1 1];
ya_subject_indices = 1:31;
oa_subject_indices = 32:50;

ya_male_subject_indices = ya_sex == -1;
ya_female_subject_indices = ya_sex == 1;
oa_male_subject_indices = oa_sex == -1;
oa_female_subject_indices = oa_sex == 1;
% ya_steplength_mag = [15.4911531819477;10.6340689994505;16.3579535678089;9.68714888484488;8.84985558972483;18.6530201706469;10.0213599540034;10.7283628162797;9.74407833966906;26.8036101819941;14.5890270589781;25.9545430220918;5.17677453585836;14.0490911976111;17.6452293049914;17.6396764368266;13.0133828794058;8.10048205881441;4.84495093836877;6.06323150178461;11.7571497041788;13.5369295732645;10.6887600545738;8.59072815370773;26.1137374140713;-3.16777522683955;5.01872633915659;11.5753890632484;-3.34249074527401;-5.27879704145155;22.8778380898384]];
% oa_steplength_mag = [21.7714632950242;-0.494567897074258;33.2178856485469;-8.94382981351176;6.58010334319997;9.93154963765706;9.73663959115259;36.2552601407704;13.0630854737524;6.20700441147760;13.5828812154986;40.7787678721403;7.01381213382597;5.46796687543011;9.58659427210774;24.0121630572389;35.8049208055845;43.7101856550716;8.38197889369162];
% 
% ya_stepmpsi_mag = [29.6841535458676;37.8903386270041;22.1088622112350;18.7177028967621;17.1005985489580;33.1719883329690;20.1843671701891;6.01231519903764;47.2354835620874;25.7745814134151;81.9467698594328;8.89633400288925;7.77407468440987;40.1597383166435;17.3939557655639;17.9999032171293;24.3009571301929;60.3203658918199;45.1632456952992;27.9873448814534;31.2606218973147;24.1752831896097;36.5048811115243;27.2720259599608;24.8670750789228;10.1141547456139;33.0177769999365;14.7643087660647;32.5619972123208;46.4506820296046;28.1053883585086];
% oa_stepmpsi_mag = [-16.6174832171910;34.2539997471566;21.7244961863665;-5.35238431187778;-16.2194880267416;-3.10246226429304;-15.1578646019206;28.2018968224881;-0.913276590522448;33.6574225865981;-10.2042735323554;-52.1701135675263;-7.70538369266613;18.1713876564068;-0.522497360788986;12.6401721153782;28.7675841862261;31.9730659581671;-20.9738496578554];


covs = load(fullfile(project_path, cov_filename));

if strcmp(resuls_foldername, 'Results_gmv_splitmag') || strcmp(resuls_foldername, 'Results_gmv_splitmag_4var') || strcmp(resuls_foldername, 'Results_gmv_splitmag_4varSEX') || strcmp(resuls_foldername, 'Results_gmv_splitmag_4var_ct') || strcmp(resuls_foldername, 'Results_gmv_splitmag_4varSEX_ct') || strcmp(resuls_foldername, 'Results_gmv_splitmag_4var_cb') ...
        || strcmp(resuls_foldername, 'Results_gmv_splitmag_4varSEX_ct') || strcmp(resuls_foldername, 'Results_gmv_splitmag_4varSEX_cb') || strcmp(resuls_foldername, 'Results_gmv_splitmag_4var_tiv') || ...
        strcmp(resuls_foldername, 'Results_gmv_splitmag_4var_tiv_cb') || strcmp(resuls_foldername, 'Results_gmv_splitmag_4varSEX_tiv_wb') || strcmp(resuls_foldername, 'Results_gmv_splitmag_4varSEX_tiv_cb') ...
        || strcmp(resuls_foldername, 'Results_gmv_splitmag_4varSEX_wm')
    group_ids = covs.R(:,1);
    cov_data = covs.R(:,contains(covs.names,cov_of_interest));
elseif strcmp(resuls_foldername, 'Results_gmv_splitmag_groupdiff_4varSEX_tiv_cb')
    cov_data_ya = covs.R(:,contains(covs.names,strcat(cov_of_interest,'_YA')));
    cov_data_ya(cov_data_ya==0) = [];
    cov_data_oa = covs.R(:,contains(covs.names,strcat(cov_of_interest,'_OA')));
    cov_data_oa(cov_data_oa==0) = [];
    cov_data = [cov_data_ya; cov_data_oa];
    if length(cov_data) ~= 50
       error('problem with length of covariates') 
    end
else
    error('need to be in proper results folder')
end


if strcmp(image_type, 'cortical_thickness')
    peak_coord_indices = [1 2 3];
    
    % hacked this.. if running for first time use nii, and uncomment
    % vol2surf... otherwise use gii and comment on vol2surf
%     roi_images_nii = spm_select('FPList', '\\exasmb.rc.ufl.edu\blue\rachaelseidler\share\FromExternal\Research_Projects_UF\CRUNCH\GABA_Data\ROIs\', '^roi.*\.nii$');
    roi_images_gii = spm_select('FPList', '\\exasmb.rc.ufl.edu\blue\rachaelseidler\share\FromExternal\Research_Projects_UF\CRUNCH\GABA_Data\ROIs\', '^mesh.intensity_roi.*\.gii$');
    
    % need to spm_select this image from ROIs folder
    for this_roi_index = 1:size(roi_images_gii,1)
        clear matlabbatch
        matlabbatch{1}.spm.tools.cat.stools.vol2surftemp.data_vol = cellstr(roi_images_nii(this_roi_index,:));
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
        
%            
        for this_subject_index = 1:length(SPM.xY.VY)
            surface_file_data= spm_data_read(spm_data_hdr_read(SPM.xY.VY(this_subject_index).fname));
            roi_file_data = spm_data_read(spm_data_hdr_read(roi_images_gii(this_roi_index,:)));
            raw_y_voxeldata(this_subject_index,this_roi_index) = nanmean(surface_file_data(find(roi_file_data)));
        end
    end
end


if strcmp(image_type, 'cerebellum') || strcmp(image_type, 'whole_brain')
        peak_coord_indices = find(~cellfun(@isempty,TabDat.dat(:,5)));
    peak_coordinates = TabDat.dat(:,12);
end

for this_peak_coord = 1:length(peak_coord_indices)
    XYZmm = peak_coordinates{peak_coord_indices(this_peak_coord)};
    
    atlas_info = spm_atlas('load','AAL3');
    [labk,P] = spm_atlas('query',atlas_info,...
        struct('def','sphere','spec',10,'xyz',XYZmm));
end
    num_of_voxels = cell2mat(TabDat.dat(peak_coord_indices(:),5));
    pvalue = cell2mat(TabDat.dat(peak_coord_indices(:),7));
    tfce = cell2mat(TabDat.dat(peak_coord_indices(:),9));
    mni_coords = cell2mat(TabDat.dat(peak_coord_indices(:),12)');
    
    input.data = [num_of_voxels pvalue tfce mni_coords(1,:)' mni_coords(2,:)' mni_coords(3,:)'];
    
    latexTable(input)
% end
    
figure; hold on;
t = tiledlayout(1,1);
for this_peak_coord = 1:length(peak_coord_indices)
    XYZmm = peak_coordinates{peak_coord_indices(this_peak_coord)};
    
    % Label coordinate
    %--------------------------------------------------------------
    %%% pulled from cg_tfce_list.m (within tfce toolbox folder) %%%
%     if 
    atlas_info = spm_atlas('load','AAL3'); % could also load neuromorphometrics here? or potentially any other atlas.. cool stuff
%     atlas_info = spm_atlas('load','lh.aparc_a2009s.freesurfer.annot');
    %-Consider peak only
    labk  = spm_atlas('query',atlas_info,XYZmm);
    %  %-Consider a 10mm sphere around the peak
%      [labk,P] = spm_atlas('query',atlas_info,...
%          struct('def','sphere','spec',10,'xyz',XYZmm));

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
   
    
    
 
    group_color_matrix = distinguishable_colors(5);
    
    nexttile; hold on;
    
    if plot_groups_and_gender
        ya_male_x = linspace(min(raw_y_voxeldata(ya_male_subject_indices)), max(raw_y_voxeldata(ya_male_subject_indices)), 100);
        ya_male_coef = polyfit(raw_y_voxeldata(ya_male_subject_indices), cov_data(ya_male_subject_indices),1);
        ya_male_fit = polyval(ya_male_coef,ya_male_x);
        
        ya_female_x = linspace(min(raw_y_voxeldata(ya_female_subject_indices)), max(raw_y_voxeldata(ya_female_subject_indices)), 100);
        ya_female_coef = polyfit(raw_y_voxeldata(ya_female_subject_indices), cov_data(ya_female_subject_indices),1);
        ya_female_fit = polyval(ya_female_coef,ya_female_x);
        
        ya_m_p = scatter(raw_y_voxeldata(ya_male_subject_indices), cov_data(ya_male_subject_indices), 24,'o', 'MarkerFaceColor', group_color_matrix(1,:), 'MarkerEdgeColor', group_color_matrix(1,:));
        ya_f_p = scatter(raw_y_voxeldata(ya_female_subject_indices), cov_data(ya_female_subject_indices), 24, 'o', 'MarkerFaceColor',  group_color_matrix(5,:), 'MarkerEdgeColor',  group_color_matrix(5,:));
        alpha(ya_m_p,.5)
        alpha(ya_f_p,.5)
        
        ya_m_l = plot(ya_male_x, ya_male_fit, 'Color', group_color_matrix(1,:), 'LineWidth', 5);
        ya_f_l = plot(ya_female_x, ya_female_fit, 'Color', group_color_matrix(5,:), 'LineWidth', 5);
        
        % plot oa
        oa_male_x = linspace(min(raw_y_voxeldata(oa_male_subject_indices)), max(raw_y_voxeldata(oa_male_subject_indices)), 100);
        oa_male_coef = polyfit(raw_y_voxeldata(oa_male_subject_indices), cov_data(oa_male_subject_indices),1);
        oa_male_fit = polyval(oa_male_coef,oa_male_x);
        
        oa_female_x = linspace(min(raw_y_voxeldata(oa_female_subject_indices)), max(raw_y_voxeldata(oa_female_subject_indices)),100);
        oa_female_coef = polyfit(raw_y_voxeldata(oa_female_subject_indices), cov_data(oa_female_subject_indices),1);
        oa_female_fit = polyval(oa_female_coef,oa_female_x);
        
        oa_m_p = scatter(raw_y_voxeldata(oa_male_subject_indices), cov_data(oa_male_subject_indices), 24,'o', 'MarkerFaceColor', group_color_matrix(3,:), 'MarkerEdgeColor', group_color_matrix(3,:));
        oa_f_p = scatter(raw_y_voxeldata(oa_female_subject_indices), cov_data(oa_female_subject_indices), 24, 'o', 'MarkerFaceColor',  group_color_matrix(4,:), 'MarkerEdgeColor',  group_color_matrix(4,:));
        alpha(oa_m_p,.5)
        alpha(oa_f_p,.5)
        
        oa_m_l = plot(oa_male_x, oa_male_fit, 'Color', group_color_matrix(3,:), 'LineWidth', 5);
        oa_f_l = plot(oa_female_x, oa_female_fit,  'Color', group_color_matrix(4,:), 'LineWidth', 5);
        
        legend([ya_m_l ya_f_l oa_m_l oa_f_l],'YA male','YA female','OA male', 'OA female');
        x0=10;
        y0=10;
        width=560;
        height=420;
        set(gcf,'position',[x0,y0,width,height])
    end
    if plot_groups
        ya_x = linspace(min(raw_y_voxeldata(ya_subject_indices)), max(raw_y_voxeldata(ya_subject_indices)), 100);
        ya_coef = polyfit(raw_y_voxeldata(ya_subject_indices), cov_data(ya_subject_indices),1);
        ya_fit = polyval(ya_coef,ya_x);
        
        oa_x = linspace(min(raw_y_voxeldata(oa_subject_indices)), max(raw_y_voxeldata(oa_subject_indices)), 100);
        oa_coef = polyfit(raw_y_voxeldata(oa_subject_indices), cov_data(oa_subject_indices),1);
        oa_fit = polyval(oa_coef,oa_x);
        
        ya_p = scatter(raw_y_voxeldata(ya_subject_indices), cov_data(ya_subject_indices), 24,'o', 'MarkerFaceColor', group_color_matrix(1,:), 'MarkerEdgeColor', group_color_matrix(1,:));
        oa_p = scatter(raw_y_voxeldata(oa_subject_indices), cov_data(oa_subject_indices), 24, 'o', 'MarkerFaceColor',  group_color_matrix(5,:), 'MarkerEdgeColor',  group_color_matrix(5,:));
        alpha(ya_p,.5)
        alpha(oa_p,.5)
        
        ya_l = plot(ya_x, ya_fit, 'Color', group_color_matrix(1,:), 'LineWidth', 5);
        oa_l = plot(oa_x, oa_fit, 'Color', group_color_matrix(5,:), 'LineWidth', 5);
        
        legend([ya_l oa_l],'YA', 'OA');
        x0=10;
        y0=10;
        width=560;
        height=420;
        set(gcf,'position',[x0,y0,width,height])
    end
    if plot_all
        x = linspace(min(raw_y_voxeldata([ya_subject_indices oa_subject_indices])), max(raw_y_voxeldata([ya_subject_indices oa_subject_indices])), 100);
        coef = polyfit(raw_y_voxeldata([ya_subject_indices oa_subject_indices]), cov_data([ya_subject_indices oa_subject_indices]),1);
        fit = polyval(coef,x);
        
        p = scatter(raw_y_voxeldata([ya_subject_indices oa_subject_indices]), cov_data([ya_subject_indices oa_subject_indices]), 24,'o', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
        alpha(p,.5)
        
        l = plot(x, fit, 'Color', 'k', 'LineWidth', 5);
    end
    
    if this_peak_coord ==1
        break;
    end
end


% set(gcf, 'Position', [0 200 800 800]);

% xlabel(t, 'GMV')
% ylabel(t, strcat(cov_of_interest, ' asymmetry'),'interpreter','none')
% set(gcf,'Color',[0 0 0]);
if save_figures 
    fig = gcf;
    fig.Color = 'white';
    fig.InvertHardcopy = 'off';
    mkdir(fullfile('figures',filesep,'noLabels'))
    fig_title = strcat(contrast_name, '_vs_', cov_of_interest);
    filename =  fullfile(results_path, 'figures', fig_title);
    saveas(gca, filename, 'tiff')
    
    set(get(gca, 'xaxis'), 'visible', 'off');
    set(get(gca, 'yaxis'), 'visible', 'off');
    set(get(gca, 'xlabel'), 'visible', 'off');
    set(get(gca, 'ylabel'), 'visible', 'off');
    set(get(gca, 'title'), 'visible', 'off');
    set(gca, 'xticklabel', '');
    set(gca, 'yticklabel', '');
    set(gca, 'position', [0 0 1 1]);
    legend(gca, 'hide');
%     zero_plot = plot([0 xlimits(end)], [0 0], 'color', [0 0 0], 'linewidth',2);
%     uistack(zero_plot, 'bottom')
   
    filename =  [results_path filesep 'figures' filesep 'noLabels' filesep strcat(fig_title)];
    saveas(gca, filename, 'tiff')
end

