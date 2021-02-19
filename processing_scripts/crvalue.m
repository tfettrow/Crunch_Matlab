function crvalue(subjects,task_folder,matfile)
cr_roi = {'cr_LDLPFC' 'cr_RDLPFC' 'cr_ACC'};
cr_roi_1500 = {'cr_1500_LDLPFC' 'cr_1500_RDLPFC' 'cr_1500_ACC'};
cr_roi_500 = {'cr_500_LDLPFC' 'cr_500_RDLPFC' 'cr_500_ACC'};
maxbeta_roi = {'max_LDLPFC' 'max_RDLPFC' 'max_ACC'};
maxbeta_roi_1500 = {'max_1500_LDLPFC' 'max_1500_RDLPFC' 'max_1500_ACC'};
maxbeta_roi_500 = {'max_500_LDLPFC' 'max_500_RDLPFC' 'max_500_ACC'};

for i = 1:length(subjects)
    subj_results_dir = fullfile(pwd, subjects{i}, 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain');
    
    if any(strcmp(task_folder, '05_MotorImagery'))
        task='MotorImagery';
        fid1 = [task_folder '_cr_score.csv'];
        fid2 = [task_folder '_maxbeta_score.csv'];
        load(char(strcat(subj_results_dir,filesep,strcat(subjects{i},'_',task,'_',matfile))));
        t1 = cell2table([subjects{i} cr],'VariableNames',['subject' cr_roi]);
        writetable(t1,fid1,'WriteMode','Append');
        t2 = cell2table([subjects{i} max_beta_cr],'VariableNames',['subject' maxbeta_roi]);
        writetable(t2,fid2,'WriteMode','Append');
    elseif any(strcmp(task_folder, '06_Nback'))
        task='Nback';
        fid1 = [task_folder '_cr_score.csv'];
        fid2 = [task_folder '_maxbeta_score.csv'];
        load(char(strcat(subj_results_dir,filesep,strcat(subjects{i},'_',task,'_',matfile))));
        t1 = cell2table([subjects{i} cr_1500 cr_500],'VariableNames',['subject' cr_roi_1500 cr_roi_500]);
        writetable(t1,fid1,'WriteMode','Append');
        t1 = cell2table([subjects{i} max_beta_cr_1500 max_beta_cr_500],'VariableNames',['subject' maxbeta_roi_1500 maxbeta_roi_500]);
        writetable(t1,fid2,'WriteMode','Append');
    end
end
end