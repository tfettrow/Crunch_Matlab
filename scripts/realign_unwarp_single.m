function realign_unwarp_single(functional_file_name)
data_path = pwd;

clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

this_file_to_realign_unwarp = spm_select('FPList', data_path, strcat('^',functional_file_name,'$'));

vdm_imagery_files = spm_select('ExtFPList', data_path, '^vdm5.*\img$');

this_file_with_volumes = spm_select('expand', this_file_to_realign_unwarp);

matlabbatch{1}.spm.spatial.realignunwarp.data.scans =  cellstr(this_file_with_volumes);
matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan = cellstr(vdm_imagery_files);
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 4;
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 2;
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 1 0];
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'First';
matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 1 0];
matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 0;
matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'unwarpedRealigned_';
spm_jobman('run',matlabbatch);
clear matlabbatch

end