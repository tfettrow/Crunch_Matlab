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

% condition_names = ["medium"; "low"; "flat"; "hard"; "low"; "hard"; "flat"; "medium"];
condition_names = ["hard"; "medium"; "flat"; "low"; "medium"; "hard"; "low"; "flat"];

% 
% condition_onset_run1 = [4.5; 39; 73.5; 108; 142.5; 177; 211.5; 246];

% video_onset = [0; 36000; 72000; 108000; 144000; 180000; 216000; 252000];
%static_onset = video_onset + 6000;
% rest_onset = static_onset + 18000;


% % for subjects EEG: 1009,... ; fMRI: 1012
% condition_onset = [0; 33000; 66000; 99000; 132000; 165000; 198000; 231000];
condition_onset = [0; 33000; 72000; 105000; 144000; 177000; 210000; 246000];
% rest_onset = condition_onset + 18000;
rest_onset = [18000; 57000; 90000; 129000; 162000; 195000; 234000; 270000];

% condition_timing_table_run1 = table(condition_onset, rest_onset, condition_names);
condition_timing_table_run2 = table(condition_onset, rest_onset, condition_names);

% writetable(condition_timing_table_run1, 'Condition_Onsets_Run1.csv');
writetable(condition_timing_table_run2, 'Condition_Onsets_Run2.csv');