%%% extract somatosensory scores based on when the test ends
%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 17);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["record_id", "redcap_event_name", "somat_10g_1", "somat_10g_2", "somat_10g_3", "somat_4g_1", "somat_4g_2", "somat_4g_3", "somat_2g_1", "somat_2g_2", "somat_2g_3", "somat_04g_1", "somat_04g_2", "somat_04g_3", "somat_007g_1", "somat_007g_2", "somat_007g_3"];
opts.VariableTypes = ["char", "char", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["record_id", "redcap_event_name"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["record_id", "redcap_event_name"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["somat_10g_1", "somat_10g_2", "somat_10g_3", "somat_4g_1", "somat_4g_2", "somat_4g_3", "somat_2g_1", "somat_2g_2", "somat_2g_3", "somat_04g_1", "somat_04g_2", "somat_04g_3", "somat_007g_1", "somat_007g_2", "somat_007g_3"], "FillValue", 0);

% Import the data ##### CHANGE THE FILENAME TO YOUR FILE NAME AND LOCATION######
filename="C:\Users\APK-User\Downloads\MindInMotion-MicroFilamentTest_DATA_2021-12-14_1157";
test = readtable(filename, opts);


%% Clear temporary variables
clear opts

%% final score extraction
for i = 1:length(test.record_id)
    if table2array(test(i,3))~=0 && table2array(test(i,end))~=2
        last(i,1)=find(table2array(test(i,3:end))==1,1,'last')+2;
        nam{i,1}=extractBetween(cellstr(test.Properties.VariableNames{last(i,1)}),'somat_','g_');
    elseif table2array(test(i,end))==2
        last(i,1)=find(table2array(test(i,3:end))==2,1,'last')+2;
        nam{i,1}=extractBetween(cellstr(test.Properties.VariableNames{last(i,1)}),'somat_','g_');
    end
end
test=[test table(nam)];
test.Properties.VariableNames{18} = 'somat_filament_score';
writetable(test(:,{'record_id','redcap_event_name','somat_filament_score'}),'MicroFilamentScores.csv')
