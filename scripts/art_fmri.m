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

function art_fmri(functional_file_name)
data_path = pwd;

    clear matlabbatch
    spm('Defaults','fMRI');
    spm_jobman('initcfg');
    spm_get_defaults('cmdline',true);


    this_file_to_art = spm_select('FPList', data_path, strcat('^',functional_file_name,'$'));
    this_structural = spm_select('FPList', data_path, '^T1.*\.nii$');
    
    BATCH.New.structurals{1} = this_structural;
    
    BATCH.New.functionals{1}{1} = this_file_to_art;
    BATCH.New.steps = {'functional_art'};
    BATCH.filename = 'Conn_Art_Folder_Stuff';
    BATCH.New.art_thresholds(1)= 9;  % z threshold
    BATCH.New.art_thresholds(2)= 2.5;  % movement threshold
    
    conn_batch(BATCH)
    
    [filepath,file_name,ext] = fileparts(this_file_to_art);
    
    movefile('art_screenshot.jpg', strcat('ARTscreenshot_',file_name,'.jpg'))
end