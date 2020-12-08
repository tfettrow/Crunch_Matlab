function remove_a_slice(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
addParameter(parser, 'image', '')
parse(parser, varargin{:})
image = parser.Results.image;

this_heaaderInfo_data = spm_vol(strcat('ROIs',filesep,image));
this_contrast_betas = spm_read_vols(this_heaaderInfo_data);
this_contrast_betas_reduced = this_contrast_betas(1:end-1,1:end-1,1:end-1);

this_heaaderInfo_data.fname = image; 
this_heaaderInfo_data.dim = size(this_contrast_betas)-1;
cd('ROIs')
spm_write_vol(this_heaaderInfo_data,this_contrast_betas_reduced);
cd('..')
end