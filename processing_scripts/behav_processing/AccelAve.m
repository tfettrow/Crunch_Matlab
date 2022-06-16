a1=ls('*csv');
for file = 1:length(a1)
    t=readtable(a1(file,:),'FileType','spreadsheet'); %read in csv data
    peak1med(file,1) = median(table2array(t(2:7,1)));
    peak30med(file,1) = median(table2array(t(2:7,2)));
    boutsmed(file,1) = median(table2array(t(2:7,3)));
    peak1mean(file,1) = mean(table2array(t(2:7,1)));
    peak30mean(file,1) = mean(table2array(t(2:7,2)));
    boutsmean(file,1) = mean(table2array(t(2:7,3)));
    clearvars t
end
t1 = table(a1,peak1med,peak30med,boutsmed,peak1mean,peak30mean,boutsmean,'VariableNames',{'Sub';'Peak1Median';'Peak30Median';'BoutsMedian';'Peak1Mean';'Peak30Mean';'BoutsMean'});
writetable(t1,'AccelAve.csv');