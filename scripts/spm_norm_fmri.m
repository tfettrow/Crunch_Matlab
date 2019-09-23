% Normalise: Write
%--------------------------------------------------------------------------

data_path = pwd;
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);


subject_specific_template = spm_select('ExtFPList', data_path, '^mT1.*\.nii$');
files_to_normalise = spm_select('FPList', data_path, '^unwarpedRealigned.*\.nii$');
this_template = spm_select('ExtFPList', data_path, '^this_template.*\.nii$');

if size(subject_specific_template,1) >= 2 || size(this_template,1) >= 2  
    error('check the images being grabbed!!')
end

for i_file = 1 : size(files_to_normalise,1)
    this_file_with_volumes = spm_select('expand', files_to_normalise(i_file,:));
    
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = cellstr(subject_specific_template);
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = cellstr(this_file_with_volumes);
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {'TPM.nii'};
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
        78 76 85];
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.prefix = 'normalized2t1_';


    spm_jobman('run',matlabbatch);
    clear matlabbatch
   
    
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = cellstr(this_template);
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = cellstr(this_file_with_volumes);
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {'TPM.nii'};
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
        78 76 85];
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.prefix = 'normalized2MNI_';


    spm_jobman('run',matlabbatch);
    clear matlabbatch
end
