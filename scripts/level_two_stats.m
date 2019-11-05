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

addpath /ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/spm12
spm('Defaults','fMRI');
spm_jobman('initcfg')


matlabbatch{1}.spm.stats.factorial_design.dir = {'/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/SWM_AS/Second_level'};
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'Subject';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).name = 'Repetition';
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).variance = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fac(2).ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(1).scans = {
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/A/01/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/A/02/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/A/03/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/A/04/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/A/05/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/A/06/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(1).conds = [1 2 3 4 5 6];
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(2).scans = {
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/B/01/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/B/02/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/B/03/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/B/04/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/B/05/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/B/06/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(2).conds = [1 2 3 4 5 6];
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(3).scans = {
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/C/02/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/C/03/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/C/04/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/C/05/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/C/06/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(3).conds = [2 3 4 5 6];
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(4).scans = {
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/D/01/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/D/02/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/D/03/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/D/04/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/D/05/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/D/06/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(4).conds = [1 2 3 4 5 6];
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(5).scans = {
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/E/01/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/E/02/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/E/03/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/E/04/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/E/05/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/E/06/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(5).conds = [1 2 3 4 5 6];
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(6).scans = {
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/G/01/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/G/02/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/G/03/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/G/04/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/G/05/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/G/06/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(6).conds = [1 2 3 4 5 6];
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(7).scans = {
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/H/01/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/H/02/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/H/03/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/H/04/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/H/05/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/H/06/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(7).conds = [1 2 3 4 5 6];
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(8).scans = {
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/J/01/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/J/02/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/J/03/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/J/04/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/J/05/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/J/06/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(8).conds = [1 2 3 4 5 6];
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(9).scans = {
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/K/01/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/K/02/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/K/03/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/K/04/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/K/05/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/K/06/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(9).conds = [1 2 3 4 5 6];
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(10).scans = {
                                                                                   '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/L/02/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                   '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/L/03/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                   '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/L/04/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                   '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/L/05/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                   '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/L/06/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                   };
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(10).conds = [2 3 4 5 6];
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(11).scans = {
                                                                                   '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/M/01/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                   '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/M/02/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                   '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/M/03/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                   '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/M/04/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                   '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/M/05/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                   '/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/Nifti/M/06/06_SWM/FirstLevel_2/con_0001.nii,1'
                                                                                   };
matlabbatch{1}.spm.stats.factorial_design.des.fblock.fsuball.fsubject(11).conds = [1 2 3 4 5 6];
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fblock.maininters{2}.fmain.fnum = 1;
%%
matlabbatch{1}.spm.stats.factorial_design.cov(1).c = [35.08
                                                      35.08
                                                      35.08
                                                      35.08
                                                      35.08
                                                      35.08
                                                      33.27
                                                      33.27
                                                      33.27
                                                      33.27
                                                      33.27
                                                      33.27
                                                      44.89
                                                      44.89
                                                      44.89
                                                      44.89
                                                      44.89
                                                      26.04
                                                      26.04
                                                      26.04
                                                      26.04
                                                      26.04
                                                      26.04
                                                      38.61
                                                      38.61
                                                      38.61
                                                      38.61
                                                      38.61
                                                      38.61
                                                      25.33
                                                      25.33
                                                      25.33
                                                      25.33
                                                      25.33
                                                      25.33
                                                      50.28
                                                      50.28
                                                      50.28
                                                      50.28
                                                      50.28
                                                      50.28
                                                      27.1
                                                      27.1
                                                      27.1
                                                      27.1
                                                      27.1
                                                      27.1
                                                      27.46
                                                      27.46
                                                      27.46
                                                      27.46
                                                      27.46
                                                      27.46
                                                      30.83
                                                      30.83
                                                      30.83
                                                      30.83
                                                      30.83
                                                      34.07
                                                      34.07
                                                      34.07
                                                      34.07
                                                      34.07
                                                      34.07];
%%
matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = 'age';
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
%%
matlabbatch{1}.spm.stats.factorial_design.cov(2).c = [0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      0
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1
                                                      1];

matlabbatch{1}.spm.stats.factorial_design.cov(2).cname = 'sex';
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov(2).iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_mean = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

spm_jobman('run',matlabbatch);
clear matlabbatch




%%

data_path = ['/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/SWM_AS/Second_level'];
a = spm_select('FPList', data_path,'SPM.mat');%SPM.mat file 
matlabbatch{1}.spm.stats.fmri_est.spmmat = cellstr(a);
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

spm_jobman('run',matlabbatch);
clear matlabbatch

%%

data_path = ['/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/SWM_AS/Second_level'];
b = spm_select('FPList', data_path,'SPM.mat');%SPM.mat file 
matlabbatch{1}.spm.stats.con.spmmat = cellstr(b);

%001 = SWM>SWMc 
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Baseline->Increase->Recover';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [-0.33 -0.33 0.08 0.72 0.2 -0.34];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

%002 = SWM>SWMc
matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Baseline->Decrease->Recover';
matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0.33 0.33 -0.08 -0.72 -.2 0.34];
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.delete = 1; %this deletes the previously existing contrasts; set to 0 if you do not want to delete previous contrasts! 

spm_jobman('run',matlabbatch);
clear matlabbatch

%v%%%%%%% Main Effect
% data_path = ['/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/NASA_Vaper/SWM_AS/Cerebellum/CB/maineffect'];
% b = spm_select('FPList', data_path,'SPM.mat');%SPM.mat file 
% matlabbatch{1}.spm.stats.con.spmmat = cellstr(b);
% 
% %001 = ACTIVATION  
% matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Main effect activation';
% matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 1 1 1 1 1];
% matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
% 
% %002 = DEACTIVATION
% matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Main effect deactivation';
% matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [-1 -1 -1 -1 -1 -1];
% matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
% 
% matlabbatch{1}.spm.stats.con.delete = 1; %this deletes the previously existing contrasts; set to 0 if you do not want to delete previous contrasts! 
% 
% spm_jobman('run',matlabbatch);
