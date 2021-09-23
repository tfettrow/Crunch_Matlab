%this function intends to extract readable sheets from 'ds_all_rows_all_fields'
%this function only extract subjects that have valid measurements
%this function only extract one response 
%data should be downloaded with REDCapR and save as 't1.csv'.

%to run this function, enter: output=redcap_process(v1,v2)
%v1 is the your target variable's name in 'ds_all_rows_all_fields'
%you can look up it in 'Mind in Motion _ REDCap.pdf'
%v2 is the name you want to assign to the variable, regards your
%downstream process script
%make sure the initial of v2 is a letter instead of a number
%don't forget the single quotation mark
%for 400m walk it's 'time_to_walk_400_meters_re'
%for MoCA it's 'moca_total'
%for SPPB it's 'sppb_12'

function output= redcap_process(v1,v2)
%% create the target table
dataset=readtable('t1');
id=[dataset.record_id];
index=strcat('dataset.',v1);
variable=eval(index);
sheet=[id variable];
%% remove the invalid rows
b=strcmp(variable,'NA');
sheet=cell2table(sheet);
sheet(b,:)=[];
sheet.Properties.VariableNames = {'subject_id',v2};

%% turn subject id to numbers
for i=1:height(sheet)
    d=sheet.subject_id(i);
    d=d{1};
    if length(d)>3
    d=d(end-3:end);
    d={d};
    sheet.subject_id(i)=d;
    end
end
%% file export
filename=strcat(v2,'.csv');
writetable(sheet,filename)
output='done';
end











