
%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 27);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["record_id", "redcap_event_name", "somat_15mm_1", "somat_15mm_2", "somat_15mm_3", "somat_15mm_4", "somat_15mm_5", "somat_13mm_1", "somat_13mm_2", "somat_13mm_3", "somat_13mm_4", "somat_13mm_5", "somat_10mm_1", "somat_10mm_2", "somat_10mm_3", "somat_10mm_4", "somat_10mm_5", "somat_7mm_1", "somat_7mm_2", "somat_7mm_3", "somat_7mm_4", "somat_7mm_5", "somat_4mm_1", "somat_4mm_2", "somat_4mm_3", "somat_4mm_4", "somat_4mm_5"];
opts.VariableTypes = ["char", "char", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["record_id", "redcap_event_name"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["record_id", "redcap_event_name"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["somat_15mm_1", "somat_15mm_2", "somat_15mm_3", "somat_15mm_4", "somat_15mm_5", "somat_13mm_1", "somat_13mm_2", "somat_13mm_3", "somat_13mm_4", "somat_13mm_5", "somat_10mm_1", "somat_10mm_2", "somat_10mm_3", "somat_10mm_4", "somat_10mm_5", "somat_7mm_1", "somat_7mm_2", "somat_7mm_3", "somat_7mm_4", "somat_7mm_5", "somat_4mm_1", "somat_4mm_2", "somat_4mm_3", "somat_4mm_4", "somat_4mm_5"], "FillValue", 0);

% Import the data
filename ="C:\Users\APK-User\Downloads\MindInMotion-2ptDisc_DATA_2021-12-14_1158";
test = readtable(filename, opts);

%% Clear temporary variables
clear opts

for i = 1:length(test.record_id)
    if table2array(test(i,3))~=0 && table2array(test(i,end))~=2
        last(i,1)=find(table2array(test(i,3:end))==1,1,'last')+2;
        nam{i,1}=extractBetween(cellstr(test.Properties.VariableNames{last(i,1)}),'somat_','mm_');
    elseif table2array(test(i,end))==2
        last(i,1)=find(table2array(test(i,3:end))==2,1,'last')+2;
        nam{i,1}=extractBetween(cellstr(test.Properties.VariableNames{last(i,1)}),'somat_','mm_');
    end
end
test=[test table(nam)];
test.Properties.VariableNames{'nam'} = 'somat_2pt_score';
writetable(test(:,{'record_id','redcap_event_name','somat_2pt_score'}),'2ptDiscScores.csv')
