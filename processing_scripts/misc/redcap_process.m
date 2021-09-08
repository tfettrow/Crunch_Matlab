%this function intends to extract readable sheets from 'ds_all_rows_all_fields'
%this function only extract subjects that have valid measurements
%this function only extract one response 
%data should be downloaded with REDCapR and save as 't1.csv'.

%to run this function, enter: output=redcap_process(v1,v2)
%v1 is the your target variable's name in 'ds_all_rows_all_fields'
%you can look up it in 'Mind in Motion _ REDCap.pdf'
%v2 is the name you want to assign to the variable, regards your
%downstream process script
%dont forget the single quotation mark

function output= redcap_process(v1,v2)
%%
dataset=readtable('t1');
id=[dataset.record_id];
index=strcat('dataset.',v1);
variable=eval(index);
sheet=[id variable];
%%
b=strcmp(variable,'NA');
sheet=cell2table(sheet);
sheet(b,:)=[];
sheet.Properties.VariableNames = {'subject_id',v2};
filename=strcat(v2,'.csv');
writetable(sheet,filename)
output='done';
end








