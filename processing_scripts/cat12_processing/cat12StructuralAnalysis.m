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
  
function cat12StructuralAnalysis(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'subjects', '')
addParameter(parser, 't1_folder', '')
addParameter(parser, 't1_filename', '')
addParameter(parser, 'template_dir' , '')
addParameter(parser, 'steps_to_run_vector', '')
parse(parser, varargin{:})
subjects = parser.Results.subjects;
t1_folder = parser.Results.t1_folder;
t1_filename = parser.Results.t1_filename;
template_dir = parser.Results.template_dir;
steps_to_run_vector = parser.Results.steps_to_run_vector; %steps_to_run_vector should be a vector the length of the number of steps that are present in this function

% Example: cat12StructuralAnalysis('subjects',{'1002','1004','1007','1009','1010','1011','1013','1020','1022','1024','1027','2002','2007','2008','2012','2013','2015','2017','2018','2020','2021','2022','2023','2025','2026','2033','2034','2037','2042','2052','3004','3006','3007','3008'},'t1_folder','02_T1','t1_filename','T1.nii','steps_to_run_vector',[0 0 0 0 0 0 0 1 1 1],'template_dir','\\exasmb.rc.ufl.edu\blue\rachaelseidler\tfettrow\Crunch_Code\MR_Templates')


%steps to run
%1) segmentation
%2) display segmentation slices
%3) estimate tiv
%4) check VBM homogeneity

% so if wanting to run steps 1,3,and 5 the vector would be [1 0 1 0 1]

if isempty(subjects)
    error('need subjects for this one')
end
if isempty(steps_to_run_vector)
    error('need to specify which steps to run')
end

study_dir = pwd;

clear matlabbatch
spm_jobman('initcfg');

if (steps_to_run_vector(1) == 1)
    for this_subject_index = 1:length(subjects)
        this_subject = subjects(this_subject_index);
        %WARNING: this assumes a particular folder structure
        this_t1_path = strcat([study_dir filesep this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep t1_folder]);
        this_cat12_path = strcat([this_t1_path filesep 'CAT12_Analysis']);
        if ~exist(this_cat12_path, 'dir')
            mkdir(this_cat12_path);
        end
        copyfile(fullfile(this_t1_path,'T1*'), fullfile(this_t1_path,'CAT12_Analysis'));
%         copyfile(fullfile(this_t1_path,'T1.json'), fullfile(this_t1_path,'CAT12_Analysis'));
        this_subject_structural_file = spm_select('ExtFPList', this_cat12_path, strcat('^',t1_filename,'$'));
        cd(this_cat12_path)
        
        matlabbatch{1}.spm.tools.cat.estwrite.data = cellstr(this_subject_structural_file);
        matlabbatch{1}.spm.tools.cat.estwrite.data_wmh = {''};
        matlabbatch{1}.spm.tools.cat.estwrite.nproc = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.useprior = '';
        matlabbatch{1}.spm.tools.cat.estwrite.opts.tpm = {fullfile(template_dir,'TPM.nii')};
        matlabbatch{1}.spm.tools.cat.estwrite.opts.affreg = 'mni';
        matlabbatch{1}.spm.tools.cat.estwrite.opts.biasacc = 0.5;
        matlabbatch{1}.spm.tools.cat.estwrite.extopts.APP = 1070;
        matlabbatch{1}.spm.tools.cat.estwrite.extopts.spm_kamap = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.extopts.LASstr = 0.5;
        matlabbatch{1}.spm.tools.cat.estwrite.extopts.gcutstr = 2;
        matlabbatch{1}.spm.tools.cat.estwrite.extopts.WMHC = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.shooting.shootingtpm =  {fullfile(template_dir,'Template_0_IXI555_MNI152_GS.nii')};
        matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.shooting.regstr = 0.5;
        matlabbatch{1}.spm.tools.cat.estwrite.extopts.vox = 1.5;
        matlabbatch{1}.spm.tools.cat.estwrite.extopts.restypes.optimal = [1 0.1];
        matlabbatch{1}.spm.tools.cat.estwrite.extopts.ignoreErrors = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.surface = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.surf_measures = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.neuromorphometrics = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.lpba40 = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.cobra = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.hammers = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.ownatlas = {''};
        matlabbatch{1}.spm.tools.cat.estwrite.output.GM.native = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.GM.mod = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.GM.dartel = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.WM.native = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.WM.mod = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.WM.dartel = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.CSF.native = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.CSF.warped = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.CSF.mod = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.CSF.dartel = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.ct.native = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.ct.warped = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.ct.dartel = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.pp.native = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.pp.warped = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.pp.dartel = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.WMH.native = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.WMH.warped = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.WMH.mod = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.WMH.dartel = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.SL.native = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.SL.warped = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.SL.mod = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.SL.dartel = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.TPMC.native = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.TPMC.warped = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.TPMC.mod = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.TPMC.dartel = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.atlas.native = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.atlas.warped = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.atlas.dartel = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.label.native = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.label.warped = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.label.dartel = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.labelnative = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.bias.warped = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.las.native = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.las.warped = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.las.dartel = 0;
        matlabbatch{1}.spm.tools.cat.estwrite.output.jacobianwarped = 1;
        matlabbatch{1}.spm.tools.cat.estwrite.output.warps = [0 0];
        matlabbatch{1}.spm.tools.cat.estwrite.output.rmat = 0;
        spm_jobman('run',matlabbatch);
        clear matlabbatch
        cd(study_dir)
    end
end

%% display slices
if (steps_to_run_vector(2) == 1)
    % need a way to view in HG
    for this_subject_index = 1:length(subjects)
        this_subject = subjects(this_subject_index);
        study_dir = pwd;
        %WARNING: this assumes a particular folder structure
        this_cat12_path = strcat([study_dir filesep this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep t1_folder filesep 'CAT12_Analysis']);
        normalized_biascorrected_T1_files{this_subject_index,:} = spm_select('ExtFPList', strcat(this_cat12_path,filesep,'mri',filesep), strcat('^','wmT1.nii','$'));
    end
    matlabbatch{1}.spm.tools.cat.tools.showslice.data_vol = cellstr(normalized_biascorrected_T1_files);
    matlabbatch{1}.spm.tools.cat.tools.showslice.scale = 1;
    matlabbatch{1}.spm.tools.cat.tools.showslice.orient = 3;
    matlabbatch{1}.spm.tools.cat.tools.showslice.slice = 0;
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end

if (steps_to_run_vector(3) == 1)
    for this_subject_index = 1:length(subjects)
        this_subject = subjects(this_subject_index);
        study_dir = pwd;
        %WARNING: this assumes a particular folder structure
        this_cat12_path = strcat([study_dir filesep this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep t1_folder filesep 'CAT12_Analysis']);
        this_subject_xml_files = spm_select('FPList', strcat(this_cat12_path,filesep,'report',filesep), strcat('^','cat_T1.xml','$'));
        cd(this_cat12_path)
        %% calculate TIV and other volumes
        matlabbatch{1}.spm.tools.cat.tools.calcvol.data_xml = cellstr(this_subject_xml_files);
        matlabbatch{1}.spm.tools.cat.tools.calcvol.calcvol_TIV = 0; % 0 is TIV, GM, WM, CSF, WMH
        matlabbatch{1}.spm.tools.cat.tools.calcvol.calcvol_name = 'TIV.txt';
        spm_jobman('run',matlabbatch);
        clear matlabbatch
        cd(study_dir)
     end
end

%% check VBM homogeneity
if (steps_to_run_vector(4) == 1)
    %  need a way to view in HG
    for this_subject_index = 1:length(subjects)
        this_subject = subjects(this_subject_index);
        study_dir = pwd;
        %WARNING: this assumes a particular folder structure
        this_cat12_path = strcat([study_dir filesep this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep t1_folder filesep 'CAT12_Analysis']);
        grey_matter_segments{this_subject_index,:} = spm_select('ExtFPList', strcat(this_cat12_path,filesep,'mri',filesep), strcat('^','mwp1T1.nii','$'));
    end
    matlabbatch{1}.spm.tools.cat.tools.check_cov.data_vol = {grey_matter_segments};
    matlabbatch{1}.spm.tools.cat.tools.check_cov.data_xml = {''};
    matlabbatch{1}.spm.tools.cat.tools.check_cov.gap = 2;
    matlabbatch{1}.spm.tools.cat.tools.check_cov.c = {};
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end

%% smooth segments
if (steps_to_run_vector(5) == 1)
    for this_subject_index = 1:length(subjects)
        this_subject = subjects(this_subject_index);
        study_dir = pwd;
        %WARNING: this assumes a particular folder structure
        this_cat12_path = strcat([study_dir filesep this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep t1_folder filesep 'CAT12_Analysis']);
        grey_matter_segments{this_subject_index,:} = spm_select('ExtFPList', strcat(this_cat12_path,filesep,'mri',filesep), strcat('^','mwp1T1.nii','$'));
    end
    for i_file = 1 : size(grey_matter_segments,1)
        this_file_with_volumes = spm_select('expand', grey_matter_segments(i_file,:));
        matlabbatch{1}.spm.spatial.smooth.data = cellstr(this_file_with_volumes);
        matlabbatch{1}.spm.spatial.smooth.fwhm = [4 4 4];
        matlabbatch{1}.spm.spatial.smooth.prefix = 'smoothed_';
        spm_jobman('run',matlabbatch);
        clear matlabbatch
    end
end

%% resample and smooth thickness images
if (steps_to_run_vector(6) == 1)
    for this_subject_index = 1:length(subjects)
        this_subject = subjects(this_subject_index);
        study_dir = pwd;
        %WARNING: this assumes a particular folder structure
        this_cat12_path = strcat([study_dir filesep this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep t1_folder filesep 'CAT12_Analysis']);
        %         thickness_images{this_subject_index,:} = spm_select('FPList', strcat(this_cat12_path,filesep,'surf',filesep), strcat('^','lh.thickness.T1','$'));
        thickness_images{this_subject_index,:} = fullfile(this_cat12_path,'surf','lh.thickness.T1');
    end
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.data_surf = thickness_images;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.merge_hemi = 1;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.mesh32k = 1;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.fwhm_surf = 15;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.lazy = 0;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.nproc = 0;
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end

%% cortical complexity
if (steps_to_run_vector(7) == 1)
    for this_subject_index = 1:length(subjects)
        this_subject = subjects(this_subject_index);
        study_dir = pwd;
        %WARNING: this assumes a particular folder structure
        this_cat12_path = strcat([study_dir filesep this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep t1_folder filesep 'CAT12_Analysis']);
        %         thickness_images{this_subject_index,:} = spm_select('FPList', strcat(this_cat12_path,filesep,'surf',filesep), strcat('^','lh.thickness.T1','$'));
        central_images{this_subject_index,:} = fullfile(this_cat12_path,'surf','lh.central.T1.gii');
    end
    matlabbatch{1}.spm.tools.cat.stools.surfextract.data_surf = central_images;
    matlabbatch{1}.spm.tools.cat.stools.surfextract.area = 0;
    matlabbatch{1}.spm.tools.cat.stools.surfextract.gmv = 0;
    matlabbatch{1}.spm.tools.cat.stools.surfextract.GI = 1;
    matlabbatch{1}.spm.tools.cat.stools.surfextract.SD = 1;
    matlabbatch{1}.spm.tools.cat.stools.surfextract.FD = 1;
    matlabbatch{1}.spm.tools.cat.stools.surfextract.tGI = 0;
    matlabbatch{1}.spm.tools.cat.stools.surfextract.lGI = 0;
    matlabbatch{1}.spm.tools.cat.stools.surfextract.GIL = 0;
    matlabbatch{1}.spm.tools.cat.stools.surfextract.surfaces.IS = 0;
    matlabbatch{1}.spm.tools.cat.stools.surfextract.surfaces.OS = 0;
    matlabbatch{1}.spm.tools.cat.stools.surfextract.norm = 0;
    matlabbatch{1}.spm.tools.cat.stools.surfextract.nproc = 0;
    matlabbatch{1}.spm.tools.cat.stools.surfextract.lazy = 0;
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end

% %% resample and smooth depth images
if (steps_to_run_vector(8) == 1)
    for this_subject_index = 1:length(subjects)
        this_subject = subjects(this_subject_index);
        study_dir = pwd;
        %WARNING: this assumes a particular folder structure
        this_cat12_path = strcat([study_dir filesep this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep t1_folder filesep 'CAT12_Analysis']);
        %         thickness_images{this_subject_index,:} = spm_select('FPList', strcat(this_cat12_path,filesep,'surf',filesep), strcat('^','lh.thickness.T1','$'));
        depth_images{this_subject_index,:} = fullfile(this_cat12_path,'surf','lh.depth.T1');
    end
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.data_surf = depth_images;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.merge_hemi = 1;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.mesh32k = 1;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.fwhm_surf = 20;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.lazy = 0;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.nproc = 0;
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end

% %% resample and smooth gyrification images
if (steps_to_run_vector(9) == 1)
    for this_subject_index = 1:length(subjects)
        this_subject = subjects(this_subject_index);
        study_dir = pwd;
        %WARNING: this assumes a particular folder structure
        this_cat12_path = strcat([study_dir filesep this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep t1_folder filesep 'CAT12_Analysis']);
        %         thickness_images{this_subject_index,:} = spm_select('FPList', strcat(this_cat12_path,filesep,'surf',filesep), strcat('^','lh.thickness.T1','$'));
        depth_images{this_subject_index,:} = fullfile(this_cat12_path,'surf','lh.gyrification.T1');
    end
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.data_surf = depth_images;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.merge_hemi = 1;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.mesh32k = 1;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.fwhm_surf = 20;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.lazy = 0;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.nproc = 0;
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end


% %% resample and smooth gyrification images
if (steps_to_run_vector(10) == 1)
    for this_subject_index = 1:length(subjects)
        this_subject = subjects(this_subject_index);
        study_dir = pwd;
        %WARNING: this assumes a particular folder structure
        this_cat12_path = strcat([study_dir filesep this_subject{1} filesep 'Processed' filesep 'MRI_files' filesep t1_folder filesep 'CAT12_Analysis']);
        %         thickness_images{this_subject_index,:} = spm_select('FPList', strcat(this_cat12_path,filesep,'surf',filesep), strcat('^','lh.thickness.T1','$'));
        depth_images{this_subject_index,:} = fullfile(this_cat12_path,'surf','lh.fractaldimension.T1');
    end
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.data_surf = depth_images;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.merge_hemi = 1;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.mesh32k = 1;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.fwhm_surf = 20;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.lazy = 0;
    matlabbatch{1}.spm.tools.cat.stools.surfresamp.nproc = 0;
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end
end