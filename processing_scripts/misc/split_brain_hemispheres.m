% 1) Load a whole brain mask (such as one shipped with Conn)
% 2) read in the xyz coordinates (see spm_read_vols function)
% 3) find all entries with x <= 0 and set them to 1 [this become the left brain mask]
% 4) write the file
% 5) similarly find all entries with x > 0 and set them to 1 [this becomes the right brain mask]
% 6) write this out (see spm_write_vol function to write these files)
function split_brain_hemispheres(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
addParameter(parser, 'image', '')
parse(parser, varargin{:})
image = parser.Results.image;

this_heaaderInfo_data = spm_vol(strcat('ROIs',filesep,image));
this_contrast_betas = spm_read_vols(this_heaaderInfo_data);

image_x_width = size(this_contrast_betas,1);
image_x_midpoint = image_x_width/2;

this_contrast_betas_right = zeros(size(this_contrast_betas)-1);
this_contrast_betas_right(1:round(image_x_midpoint),:,:) = this_contrast_betas(1:round(image_x_midpoint),1:end-1,1:end-1);

this_contrast_betas_left = zeros(size(this_contrast_betas)-1);
this_contrast_betas_left(round(image_x_midpoint):end,:,:) = this_contrast_betas(round(image_x_midpoint):end-1,1:end-1,1:end-1);

% this_contrast_betas_right = 
image_split = strsplit(image,'.');

this_heaaderInfo_data.fname = strcat(image_split{1},'_right.', image_split{2}); 
this_heaaderInfo_data.dim = size(this_contrast_betas)-1;
cd('ROIs')
spm_write_vol(this_heaaderInfo_data,this_contrast_betas_right);

this_heaaderInfo_data.fname = strcat(image_split{1},'_left.', image_split{2}); 
spm_write_vol(this_heaaderInfo_data,this_contrast_betas_left);  
cd('..')
end