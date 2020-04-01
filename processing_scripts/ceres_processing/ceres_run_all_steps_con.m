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


% Run CERES steps sequentially

% Manual Steps

%1) Run CERES 1.0
%2) Unzip Native Folder Output into CERES processing folder
%3) Copy functional runs, art_reg files, condition onset files, and SUIT
% template into CERES folder 
%4) Reset Origin

%% Uncomment steps you would like to run

% CERES Processing with CON Image
tic
% ceres_coreg_to_suit;
% ceres_create_binary;
ceres_normdartel_to_suit;
% ceres_coregWrite_func_to_T1; % ceres_coreg_func_to_T1;  %% need to write?
% ceres_level_one_stats;
% ceres_reslice_conImg;
% ceres_smooth_conImg;

disp(strcat('CERES Processing with CON Image took:', num2str(toc), ' secs'))

