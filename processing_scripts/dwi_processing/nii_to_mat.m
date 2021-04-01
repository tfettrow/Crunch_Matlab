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


f_DWI = dir('*.nii');
f_BM = 'DWI.txt';
f_mat = 'DWI.mat';
Mask_par.tune_NDWI = 0.7; % (rough range: [0.3 1.5]) % TF doesnt understand what this is
Mask_par.tune_DWI = 0.7; % (rough range: [0.3 1.5]) % TF doesnt understand what this is
Mask_par.mfs = 5; % (uneven integer) % TF doesnt understand what this is
NrB0 = 2;
perm = 1; % TF doesnt understand what this is
flip = 1; % TF doesnt understand what this is

E_DTI_quick_and_dirty_DTI_convert_from_nii_txt_to_mat(f_DWI.name, f_BM, f_mat, Mask_par, NrB0, perm, flip)