function export_cr_scores(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
addParameter(parser, 'subjects', '') %{'1002','1004','1007','1009','1010','1011','1013','1017','1018','1019','1020','1022','1024','1025','1026','1027','2002','2007','2008','2012','2013','2015','2017','2018','2020','2021','2022','2023','2025','2026','2027','2033','2034','2037','2038','2039','2042','2052'}
addParameter(parser, 'task_folder', '') %05_MotorImagery 06_Nback
addParameter(parser, 'results_matfile', '') %'CRUNCH_discete_roi_newacc.mat'
addParameter(parser, 'crunchers_only', 1) % 
parse(parser, varargin{:})
subjects = parser.Results.subjects;
task_folder = parser.Results.task_folder;
results_matlfile = parser.Results.results_matfile;
crunchers_only = parser.Results.crunchers_only;
data_path = pwd;

cr_roi = {'cr_LDLPFC' 'cr_RDLPFC' 'cr_ACC'};
cr_roi_1500 = {'cr_1500_LDLPFC' 'cr_1500_RDLPFC' 'cr_1500_ACC'};
cr_roi_500 = {'cr_500_LDLPFC' 'cr_500_RDLPFC' 'cr_500_ACC'};
maxbeta_roi = {'max_LDLPFC' 'max_RDLPFC' 'max_ACC'};
maxbeta_roi_1500 = {'max_1500_LDLPFC' 'max_1500_RDLPFC' 'max_1500_ACC'};
maxbeta_roi_500 = {'max_500_LDLPFC' 'max_500_RDLPFC' 'max_500_ACC'};

for i = 1:length(subjects)
    subj_results_dir = fullfile(pwd, subjects{i}, 'Processed', 'MRI_files', task_folder, 'ANTS_Normalization', 'Level1_WholeBrain');
    
    if strcmp(task_folder, '05_MotorImagery')
        task='MotorImagery';
    
        load(char(strcat(subj_results_dir,filesep,strcat(subjects{i},'_',task,'_',results_matlfile))));
    
        if crunchers_only == 1
            cr_to_edit = cell2mat(cr);
            maxbeta_to_edit = cell2mat(max_beta_cr);
            
            cr_to_edit(cr_to_edit==0|cr_to_edit==3) = NaN;
        for dd = 1:3
            if isnan(cr_to_edit(:,dd))
            maxbeta_to_edit(:,dd) = NaN;
            end
        end
            
            fid1 = fullfile(data_path,'spreadsheet_data','cr_score_mi_onlyCrunch.csv');
            fid2 = fullfile(data_path,'spreadsheet_data','maxbeta_score_mi_onlyCrunch.csv');
            
            t1 = cell2table([subjects{i} num2cell(cr_to_edit)],'VariableNames',['subject' cr_roi]);
            writetable(t1,fid1,'WriteMode','Append');
            t2 = cell2table([subjects{i} num2cell(maxbeta_to_edit)],'VariableNames',['subject' maxbeta_roi]);
            writetable(t2,fid2,'WriteMode','Append');
        else
            fid1 = fullfile(data_path,'spreadsheet_data','cr_score_mi.csv');
            fid2 = fullfile(data_path,'spreadsheet_data','maxbeta_score_mi.csv');
            
            t1 = cell2table([subjects{i} cr],'VariableNames',['subject' cr_roi]);
            writetable(t1,fid1,'WriteMode','Append');
            t2 = cell2table([subjects{i} max_beta_cr],'VariableNames',['subject' maxbeta_roi]);
            writetable(t2,fid2,'WriteMode','Append');
        end
    elseif strcmp(task_folder, '06_Nback')
        task='Nback';
        load(char(strcat(subj_results_dir,filesep,strcat(subjects{i},'_',task,'_',results_matlfile))));
        if crunchers_only == 1
            cr_to_edit_1500 = cell2mat(cr_1500);
            maxbeta_to_edit_1500 = cell2mat(max_beta_cr_1500);
            cr_to_edit_500 = cell2mat(cr_500);
            maxbeta_to_edit_500 = cell2mat(max_beta_cr_500);
            
            cr_to_edit_1500(cr_to_edit_1500==0|cr_to_edit_1500==3) = NaN;
            for dd = 1:3
                if isnan(cr_to_edit_1500(:,dd))
                    maxbeta_to_edit_1500(:,dd) = NaN;
                end
            end
            cr_to_edit_500(cr_to_edit_500==0|cr_to_edit_500==3) = NaN;
            for dd = 1:3
                if isnan(cr_to_edit_500(:,dd))
                    maxbeta_to_edit_500(:,dd) = NaN;
                end
            end       
                      
            fid1 = fullfile(data_path,'spreadsheet_data','cr_score_nb_onlyCrunch.csv');
            fid2 = fullfile(data_path,'spreadsheet_data','maxbeta_score_nb_onlyCrunch.csv');
             
            t1 = cell2table([subjects{i} num2cell(cr_to_edit_1500) num2cell(cr_to_edit_500)],'VariableNames',['subject' cr_roi_1500 cr_roi_500]);
            writetable(t1,fid1,'WriteMode','Append');
            t1 = cell2table([subjects{i} num2cell(maxbeta_to_edit_1500) num2cell(maxbeta_to_edit_500)],'VariableNames',['subject' maxbeta_roi_1500 maxbeta_roi_500]);
            writetable(t1,fid2,'WriteMode','Append');
        else
             fid1 = fullfile(data_path,'spreadsheet_data','cr_score_nb.csv');
            fid2 = fullfile(data_path,'spreadsheet_data','maxbeta_score_nb.csv');
            
            t1 = cell2table([subjects{i} cr_1500 cr_500],'VariableNames',['subject' cr_roi_1500 cr_roi_500]);
            writetable(t1,fid1,'WriteMode','Append');
            t1 = cell2table([subjects{i} max_beta_cr_1500 max_beta_cr_500],'VariableNames',['subject' maxbeta_roi_1500 maxbeta_roi_500]);
            writetable(t1,fid2,'WriteMode','Append');
        end
    end
end
fclose all;
end
