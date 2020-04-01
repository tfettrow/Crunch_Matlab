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

clear, clc
data_path = pwd;
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

data_path = pwd;

affine = spm_select('FPList', data_path,'Affine.*.mat'); 				% Affine transformation 
flowfield = spm_select('FPList', data_path,'u_.*.nii'); 				% Non-linear flowfield 
% flowfield = spm_select('FPList', data_path,'^m.*.mat');
funcImages = spm_select('FPList', fullfile(data_path),'^vol.*\.nii$'); 	% All of the con images (8 images) 
mask = spm_select('FPList', data_path,'^CB_mask.nii'); 	% The CB isolation mask

%---------------------------------------------------------------------------------------------------------------------------------------------
% Run the reslicing  
%---------------------------------------------------------------------------------------------------------------------------------------------
for i_file = 1 : size(funcImages,1)
    clear matlabbatch 
    this_file_path_with_volumes = spm_select('expand', funcImages(i_file,:));
    
    %     suit_reslice(this_file_path_with_volumes,flowfield, 'mask', mask)
    
    % matlabbatch{1}.spm.tools.suit.reslice.subj.paramfile = cellstr(flowfield);
    % matlabbatch{1}.spm.tools.suit.reslice.subj.resample = cellstr(this_file_path_with_volumes);
    % matlabbatch{1}.spm.tools.suit.reslice.subj.mask = cellstr(mask);
    % matlabbatch{1}.spm.tools.suit.reslice.smooth_mask = 2;
    % matlabbatch{1}.spm.tools.suit.reslice.preserve = 0;
    % matlabbatch{1}.spm.tools.suit.reslice.bb = [-70 -100 -75
    %                                             70 -6 11];
    % matlabbatch{1}.spm.tools.suit.reslice.vox = [2 2 2];
    % matlabbatch{1}.spm.tools.suit.reslice.interp = 1;
    % matlabbatch{1}.spm.tools.suit.reslice.prefix = 'wc';
    
    matlabbatch{1}.spm.tools.suit.reslice_dartel.subj.affineTr = cellstr(affine);
    matlabbatch{1}.spm.tools.suit.reslice_dartel.subj.flowfield = cellstr(flowfield);
    matlabbatch{1}.spm.tools.suit.reslice_dartel.subj.resample = cellstr(funcImages(i_file,:)); %cellstr(this_file_path_with_volumes);
    matlabbatch{1}.spm.tools.suit.reslice_dartel.subj.mask = cellstr(mask);
    matlabbatch{1}.spm.tools.suit.reslice_dartel.jactransf = 0;
    matlabbatch{1}.spm.tools.suit.reslice_dartel.K = 6;
    matlabbatch{1}.spm.tools.suit.reslice_dartel.bb = [-70 -100 -75
        70 -6 11];
    matlabbatch{1}.spm.tools.suit.reslice_dartel.vox = [2 2 2];
    matlabbatch{1}.spm.tools.suit.reslice_dartel.interp = 1;
    matlabbatch{1}.spm.tools.suit.reslice_dartel.prefix = 'wc_';

%     matlabbatch{1}.spm.tools.suit.reslice_dartel.subj.affineTr = cellstr(affine);
%     matlabbatch{1}.spm.tools.suit.reslice_dartel.subj.flowfield = cellstr(flowfield);
%     matlabbatch{1}.spm.tools.suit.reslice_dartel.subj.resample = cellstr(this_file_path_with_volumes);
%     matlabbatch{1}.spm.tools.suit.reslice_dartel.subj.mask = cellstr(mask);
%     matlabbatch{1}.spm.tools.suit.reslice_dartel.jactransf = 0;
%     matlabbatch{1}.spm.tools.suit.reslice_dartel.K = 6;
%     matlabbatch{1}.spm.tools.suit.reslice_dartel.bb = [-70 -100 -75
%         70 -6 11];
%     matlabbatch{1}.spm.tools.suit.reslice_dartel.vox = [2 2 2];
%     matlabbatch{1}.spm.tools.suit.reslice_dartel.interp = 1;
%     matlabbatch{1}.spm.tools.suit.reslice_dartel.prefix = 'wc_';
spm_jobman('run',matlabbatch);
end

