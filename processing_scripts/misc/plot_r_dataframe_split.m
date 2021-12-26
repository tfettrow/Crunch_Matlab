% take specifically named dataframes from split_mocap folder and plot CIs

% for each result.mat (1) split_stp.mat, 2) split_mag.mat, 3) after_mag.mat) (in G:\Shared drives\GABA_Aging_MoCap), read and order the group/variables in the order of the
% variable presentation in paper
% (https://www.overleaf.com/project/607de5f7071ab023d5ce9f15).. plot the
% CIs while removing negatives for rate of plateau..

clear,clc
close all
load('split_stp.mat')

results_cell = struct2cell(results);

% Step Length 
ordered_results_variables{1} = [results_cell{1}{11} ' ' results_cell{2}{11}];
ordered_results_variables{2} = [results_cell{1}{12} ' ' results_cell{2}{12}];
ordered_results_mean(1) = results_cell{3}(11);
ordered_results_mean(2) = results_cell{3}(12);
ordered_results_ci(1,:) = [results_cell{6}(11) results_cell{7}(11)];
ordered_results_ci(2,:) = [results_cell{6}(12) results_cell{7}(12)];

% Step Width 
ordered_results_variables{3} = [results_cell{1}{13} ' ' results_cell{2}{13}];
ordered_results_variables{4} = [results_cell{1}{14} ' ' results_cell{2}{14}];
ordered_results_mean(3) = results_cell{3}(13);
ordered_results_mean(4) = results_cell{3}(14);
ordered_results_ci(3,:) = [results_cell{6}(13) results_cell{7}(13)];
ordered_results_ci(4,:) = [results_cell{6}(14) results_cell{7}(14)];

% SS time
ordered_results_variables{5} = [results_cell{1}{7} ' ' results_cell{2}{7}];
ordered_results_variables{6} = [results_cell{1}{8} ' ' results_cell{2}{8}];
ordered_results_mean(5) = results_cell{3}(7);
ordered_results_mean(6) = results_cell{3}(8);
ordered_results_ci(5,:) = [results_cell{6}(7) results_cell{7}(7)];
ordered_results_ci(6,:) = [results_cell{6}(8) results_cell{7}(8)];

% DS time
ordered_results_variables{7} = [results_cell{1}{5} ' ' results_cell{2}{5}];
ordered_results_variables{8} = [results_cell{1}{6} ' ' results_cell{2}{6}];
ordered_results_mean(7) = results_cell{3}(5);
ordered_results_mean(8) = results_cell{3}(6);
ordered_results_ci(7,:) = [results_cell{6}(5) results_cell{7}(5)];
ordered_results_ci(8,:) = [results_cell{6}(6) results_cell{7}(6)];

% CoM
ordered_results_variables{9} = [results_cell{1}{1} ' ' results_cell{2}{1}];
ordered_results_variables{10} = [results_cell{1}{2} ' ' results_cell{2}{2}];
ordered_results_mean(9) = results_cell{3}(1);
ordered_results_mean(10) = results_cell{3}(2);
ordered_results_ci(9,:) = [results_cell{6}(1) results_cell{7}(1)];
ordered_results_ci(10,:) = [results_cell{6}(2) results_cell{7}(2)];

% CoM-CoP
ordered_results_variables{11} = [results_cell{1}{3} ' ' results_cell{2}{3}];
ordered_results_variables{12} = [results_cell{1}{4} ' ' results_cell{2}{4}];
ordered_results_mean(11) = results_cell{3}(3);
ordered_results_mean(12) = results_cell{3}(4);
ordered_results_ci(11,:) = [results_cell{6}(3) results_cell{7}(3)];
ordered_results_ci(12,:) = [results_cell{6}(4) results_cell{7}(4)];

% Step-CoM
ordered_results_variables{13} = [results_cell{1}{9} ' ' results_cell{2}{9}];
ordered_results_variables{14} = [results_cell{1}{10} ' ' results_cell{2}{10}];
ordered_results_mean(13) = results_cell{3}(9);
ordered_results_mean(14) = results_cell{3}(10);
ordered_results_ci(13,:) = [results_cell{6}(9) results_cell{7}(9)];
ordered_results_ci(14,:) = [results_cell{6}(10) results_cell{7}(10)];

negative_indices = find(ordered_results_ci<0);
ordered_results_ci(negative_indices,1) = 0;

T = table(ordered_results_variables', ordered_results_mean', ordered_results_ci(:,1),ordered_results_ci(:,2), 'VariableNames', { 'name', 'OR', 'L95', 'U95'});
% Write data to text file
writetable(T, 'split_stp.txt')

blobbogram('split_stp.txt')




clear,clc
close all
load('split_mag.mat')

results_cell = struct2cell(results);

% Step Length 
ordered_results_variables{1} = [results_cell{1}{11} ' ' results_cell{2}{11}];
ordered_results_variables{2} = [results_cell{1}{12} ' ' results_cell{2}{12}];
ordered_results_mean(1) = results_cell{3}(11);
ordered_results_mean(2) = results_cell{3}(12);
ordered_results_ci(1,:) = [results_cell{6}(11) results_cell{7}(11)];
ordered_results_ci(2,:) = [results_cell{6}(12) results_cell{7}(12)];

% Step Width 
ordered_results_variables{3} = [results_cell{1}{13} ' ' results_cell{2}{13}];
ordered_results_variables{4} = [results_cell{1}{14} ' ' results_cell{2}{14}];
ordered_results_mean(3) = results_cell{3}(13);
ordered_results_mean(4) = results_cell{3}(14);
ordered_results_ci(3,:) = [results_cell{6}(13) results_cell{7}(13)];
ordered_results_ci(4,:) = [results_cell{6}(14) results_cell{7}(14)];


% SS time
ordered_results_variables{5} = [results_cell{1}{7} ' ' results_cell{2}{7}];
ordered_results_variables{6} = [results_cell{1}{8} ' ' results_cell{2}{8}];
ordered_results_mean(5) = results_cell{3}(7);
ordered_results_mean(6) = results_cell{3}(8);
ordered_results_ci(5,:) = [results_cell{6}(7) results_cell{7}(7)];
ordered_results_ci(6,:) = [results_cell{6}(8) results_cell{7}(8)];

% DS time
ordered_results_variables{7} = [results_cell{1}{5} ' ' results_cell{2}{5}];
ordered_results_variables{8} = [results_cell{1}{6} ' ' results_cell{2}{6}];
ordered_results_mean(7) = results_cell{3}(5);
ordered_results_mean(8) = results_cell{3}(6);
ordered_results_ci(7,:) = [results_cell{6}(5) results_cell{7}(5)];
ordered_results_ci(8,:) = [results_cell{6}(6) results_cell{7}(6)];

% CoM
ordered_results_variables{9} = [results_cell{1}{1} ' ' results_cell{2}{1}];
ordered_results_variables{10} = [results_cell{1}{2} ' ' results_cell{2}{2}];
ordered_results_mean(9) = results_cell{3}(1);
ordered_results_mean(10) = results_cell{3}(2);
ordered_results_ci(9,:) = [results_cell{6}(1) results_cell{7}(1)];
ordered_results_ci(10,:) = [results_cell{6}(2) results_cell{7}(2)];

% CoM-CoP
ordered_results_variables{11} = [results_cell{1}{3} ' ' results_cell{2}{3}];
ordered_results_variables{12} = [results_cell{1}{4} ' ' results_cell{2}{4}];
ordered_results_mean(11) = results_cell{3}(3);
ordered_results_mean(12) = results_cell{3}(4);
ordered_results_ci(11,:) = [results_cell{6}(3) results_cell{7}(3)];
ordered_results_ci(12,:) = [results_cell{6}(4) results_cell{7}(4)];

% Step-CoM
ordered_results_variables{13} = [results_cell{1}{9} ' ' results_cell{2}{9}];
ordered_results_variables{14} = [results_cell{1}{10} ' ' results_cell{2}{10}];
ordered_results_mean(13) = results_cell{3}(9);
ordered_results_mean(14) = results_cell{3}(10);
ordered_results_ci(13,:) = [results_cell{6}(9) results_cell{7}(9)];
ordered_results_ci(14,:) = [results_cell{6}(10) results_cell{7}(10)];

T = table(ordered_results_variables', ordered_results_mean', ordered_results_ci(:,1),ordered_results_ci(:,2), 'VariableNames', { 'name', 'OR', 'L95', 'U95'});
% Write data to text file
writetable(T, 'split_mag.txt')

blobbogram('split_mag.txt')



clear,clc
close all
load('after_mag.mat')

results_cell = struct2cell(results);

% Step Length 
ordered_results_variables{1} = [results_cell{1}{11} ' ' results_cell{2}{11}];
ordered_results_variables{2} = [results_cell{1}{12} ' ' results_cell{2}{12}];
ordered_results_mean(1) = results_cell{3}(11);
ordered_results_mean(2) = results_cell{3}(12);
ordered_results_ci(1,:) = [results_cell{6}(11) results_cell{7}(11)];
ordered_results_ci(2,:) = [results_cell{6}(12) results_cell{7}(12)];

% Step Width 
ordered_results_variables{3} = [results_cell{1}{13} ' ' results_cell{2}{13}];
ordered_results_variables{4} = [results_cell{1}{14} ' ' results_cell{2}{14}];
ordered_results_mean(3) = results_cell{3}(13);
ordered_results_mean(4) = results_cell{3}(14);
ordered_results_ci(3,:) = [results_cell{6}(13) results_cell{7}(13)];
ordered_results_ci(4,:) = [results_cell{6}(14) results_cell{7}(14)];


% SS time
ordered_results_variables{5} = [results_cell{1}{7} ' ' results_cell{2}{7}];
ordered_results_variables{6} = [results_cell{1}{8} ' ' results_cell{2}{8}];
ordered_results_mean(5) = results_cell{3}(7);
ordered_results_mean(6) = results_cell{3}(8);
ordered_results_ci(5,:) = [results_cell{6}(7) results_cell{7}(7)];
ordered_results_ci(6,:) = [results_cell{6}(8) results_cell{7}(8)];

% DS time
ordered_results_variables{7} = [results_cell{1}{5} ' ' results_cell{2}{5}];
ordered_results_variables{8} = [results_cell{1}{6} ' ' results_cell{2}{6}];
ordered_results_mean(7) = results_cell{3}(5);
ordered_results_mean(8) = results_cell{3}(6);
ordered_results_ci(7,:) = [results_cell{6}(5) results_cell{7}(5)];
ordered_results_ci(8,:) = [results_cell{6}(6) results_cell{7}(6)];

% CoM
ordered_results_variables{9} = [results_cell{1}{1} ' ' results_cell{2}{1}];
ordered_results_variables{10} = [results_cell{1}{2} ' ' results_cell{2}{2}];
ordered_results_mean(9) = results_cell{3}(1);
ordered_results_mean(10) = results_cell{3}(2);
ordered_results_ci(9,:) = [results_cell{6}(1) results_cell{7}(1)];
ordered_results_ci(10,:) = [results_cell{6}(2) results_cell{7}(2)];

% CoM-CoP
ordered_results_variables{11} = [results_cell{1}{3} ' ' results_cell{2}{3}];
ordered_results_variables{12} = [results_cell{1}{4} ' ' results_cell{2}{4}];
ordered_results_mean(11) = results_cell{3}(3);
ordered_results_mean(12) = results_cell{3}(4);
ordered_results_ci(11,:) = [results_cell{6}(3) results_cell{7}(3)];
ordered_results_ci(12,:) = [results_cell{6}(4) results_cell{7}(4)];

% Step-CoM
ordered_results_variables{13} = [results_cell{1}{9} ' ' results_cell{2}{9}];
ordered_results_variables{14} = [results_cell{1}{10} ' ' results_cell{2}{10}];
ordered_results_mean(13) = results_cell{3}(9);
ordered_results_mean(14) = results_cell{3}(10);
ordered_results_ci(13,:) = [results_cell{6}(9) results_cell{7}(9)];
ordered_results_ci(14,:) = [results_cell{6}(10) results_cell{7}(10)];

T = table(ordered_results_variables', ordered_results_mean', ordered_results_ci(:,1),ordered_results_ci(:,2), 'VariableNames', { 'name', 'OR', 'L95', 'U95'});
% Write data to text file
writetable(T, 'after_mag.txt')

blobbogram('after_mag.txt')
