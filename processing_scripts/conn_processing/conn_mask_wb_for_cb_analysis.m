function conn_mask_wb_for_cb_analysis(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
addParameter(parser, 'conn_project_name', '')
addParameter(parser, 'seed_names', '')
parse(parser, varargin{:})

conn_project_name = parser.Results.conn_project_name;
seed_names = parser.Results.seed_names;

% expected to be run from study folder !!!
data_path=pwd;

spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

for this_seed_folder = 1:length(seed_names)
%     spmT_file =  
%     spmT_file =  spm_select('ExtFPList',strcat(data_path,filesep,'ROIs'), '^SUIT_Nobrainstem_2mm.nii$');
    disp(strcat('masking', {' '}, seed_names{this_seed_folder}))
    matlabbatch{1}.spm.util.imcalc.input = {
        spm_select('ExtFPList',strcat(data_path,filesep,conn_project_name,filesep,'results',filesep,'secondlevel',filesep,'SBC_01',filesep,'AllSubjects',filesep,'rest',filesep,seed_names{this_seed_folder}), '^spmT_0001.nii$')
        spm_select('ExtFPList',strcat(data_path,filesep,'ROIs'), '^SUIT_Nobrainstem_2mm.nii$')
        };
    matlabbatch{1}.spm.util.imcalc.output = 'masked_spmT_0001.nii';
    matlabbatch{1}.spm.util.imcalc.outdir = cellstr(strcat(data_path,filesep,conn_project_name,filesep,'results',filesep,'secondlevel',filesep,'SBC_01',filesep,'AllSubjects',filesep,'rest',filesep,seed_names{this_seed_folder}));
    matlabbatch{1}.spm.util.imcalc.expression = 'i1./(((i2>0)-1).*-1)';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = 0;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end
end
