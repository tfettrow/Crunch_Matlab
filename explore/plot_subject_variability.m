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


function conn_setup_taskbased(images_to_plot)

images_to_plot={'YAnsDartelNoBS_subject_normalized_intensity_variability.nii', 'YAnsANTS_subject_normalized_intensity_variability.nii', 'OAnsDartelNoBS_subject_normalized_intensity_variability.nii', 'OAnsANTS_subject_normalized_intensity_variability.nii'};
labels={'YA dartel', 'YA ants', 'OA dartel', 'OA ants'};

mask=('SUIT_Nobrainstem_2mm.nii');
% images_to_plot={'YAnsDartelNoBS_subject_normalized_intensity_variability.nii', 'OAnsDartelNoBS_subject_normalized_intensity_variability.nii'};
% labels={'YA dartel', 'OA dartel'};



% close all
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

data_path = pwd;

images_to_plot = split(images_to_plot,",");
labels = split(labels,",");

vector_img=[];
vector_labels=[];

for this_image_index = 1 : length(images_to_plot)
    V = spm_vol(images_to_plot{this_image_index});
    img = spm_read_vols(V);
    img=img;
    img=img(find((img>.01)));
    
    vector_img = [vector_img; img(:)];
    vector_labels =  [vector_labels; cellstr(repmat(labels{this_image_index}, [length(img(:)),1]))];
    
    
end
    figure
    violinplot(vector_img, vector_labels, 'ShowData', false, 'ShowMean', true, 'MedianColor', [0 0 0]) %  Fill color of the median and notch indicators.
%                    Defaults to [1 1 1]) 
    title('Variability of Normalization Methods', 'FontSize', 16)
    
    ylabel('Between Subject Variability', 'FontSize', 16)
    gca
    set(gca, 'FontSize', 16)
    
end