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

%%
% Define analysis path
project_name = 'conn_project_func_primary_group_newROI';

project_path = pwd;


wdir 		= strcat(project_path, filesep, project_name, filesep, 'results', filesep, 'secondlevel');% 'C:/Users/Raphael/Desktop/These/conn_example/results/secondlevel';
corr_net 	= 'SBC_01';
corr_group 	= 'old(1_0).young(0_1)';
corr_run 	= 'rest';
corr_folder = strcat(wdir, filesep, corr_net, filesep, corr_group, filesep, corr_run);

cd(corr_folder)
load(['ROI.mat']);
cd(strcat('..',filesep,'..',filesep,'..',filesep,'..',filesep,'..',filesep,'..'));

numROI  	= size(ROI, 2);
corr_name 	= ROI(1).names(1:numROI);

corr_h   	= [];   % Beta value
corr_F  	= [];   % Statistic value
corr_p   	= [];   % One-tailed p value

for i = 1:numROI
	corr_h = [ corr_h ; ROI(i).h(1:numROI) ];
	corr_F = [ corr_F ; ROI(i).F(1:numROI) ];
	corr_p = [ corr_p ; ROI(i).p(1:numROI) ];
end


%%
% array2table does not work with '-' in var names
corr_name2 	= strrep(corr_name, '-', '_');
corr_name2 	= strrep(corr_name2, '.', '_');
corr_name2 	= strrep(corr_name2, ' ', '_')
corr_name2 	= strrep(corr_name2, ')', '_')
corr_name2 	= strrep(corr_name2, '(', '_')
corr_name2 	= strrep(corr_name2, ',', '_')
T_h        	= array2table(corr_h, 'RowNames', corr_name2', 'VariableNames', corr_name2');
T_F        	= array2table(corr_F, 'RowNames', corr_name2, 'VariableNames', corr_name2);
T_p        	= array2table(corr_p, 'RowNames', corr_name2, 'VariableNames', corr_name2);

writetable( T_h, [corr_folder 'beta_' corr_net '_' corr_group '_' corr_run '.csv'], 'WriteVariableNames', true, 'WriteRowNames', true, 'delimiter', 'semi' );
writetable( T_F, [corr_folder 'F_' corr_net '_' corr_group '_' corr_run '.csv'], 'WriteVariableNames', true, 'WriteRowNames', true, 'delimiter', 'semi');
writetable( T_p, [corr_folder 'p_' corr_net '_' corr_group '_' corr_run '.csv'], 'WriteVariableNames', true, 'WriteRowNames', true, 'delimiter', 'semi');


%%
anti_corr_net = False;

% Case two or several anti-correlated networks (ex: Default and Dorsal Attention)
if anti_corr_net
    tail      = 'two-sided';
    corr_p    = 2*min(corr_p, 1-corr_p);

% Case single network
else
    tail      = 'one-sided';

end

% Compute Bonferroni and FDR correction
% conn_fdr function is in conn main folder
alpha_bonf            		= 0.05 / ((numROI)*(numROI-1)/2);
vector_fdr                      = nonzeros(triu(corr_p)');
vector_fdr(isnan(vector_fdr))   = [];
corr_p_fdr            		= conn_fdr(vector_fdr);

% WRITE OUTPUT
fprintf('\nANALYSIS INFO');
fprintf('\n--------------------------------------');
fprintf(['\nNetwork:\t ' corr_net]);
fprintf(['\nGroup:\t\t ' corr_group]);
fprintf(['\nRun:\t\t ' corr_run]);
fprintf('\nSTATISTICS');
fprintf('\n--------------------------------------');
fprintf([ '\n' num2str(numROI) ' x ' num2str(numROI-1) ' ROIs matrix ; ' tail]);
fprintf([ '\np-uncorrected:\t\t\t\t\t ' num2str(numel(corr_p(corr_p <= 0.05))/2)  ]);
fprintf([ '\np-bonferroni (alpha = ' num2str(round(alpha_bonf, 5)) '):\t ' num2str(numel(corr_p(corr_p <= alpha_bonf))/2) ]);
fprintf([ '\np-FDR corrected:\t\t\t\t ' num2str(numel(corr_p_fdr(corr_p_fdr <= 0.05))) ]);
fprintf('\n--------------------------------------\n');


%%
% Remove upper triangle + diagonal
corr = tril(corr, -1)

% Start plotting
fig = figure;
set(gcf,'Units','inches', 'Position',[0 0 6 4])

im = imagesc(corr, clim );

clim = [ 0 1 ];
colormap(flipud(hot(10)));

h = colorbar('eastoutside');
xlabel(h, 'h', 'FontSize', 14);


% Title, axis
title('Salience Network', 'FontSize', 14);
set(gca, 'XTick', (1:numROI));
set(gca, 'YTick', (1:numROI));
set(gca, 'Ticklength', [0 0])
grid off
box off

% Labels
set(gca, 'XTickLabel', corr_name, 'XTickLabelRotation', 0);
set(gca, 'YTickLabel', corr_name);

