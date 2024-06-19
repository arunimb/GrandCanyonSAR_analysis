clearvars
close all
clc

accuracyTable = readtable("kClusteringResult.xlsx");

window5 = accuracyTable(accuracyTable.WindowSize == 5,:);
window5 = table2array(window5(:,6));

window10 = accuracyTable(accuracyTable.WindowSize == 10,:);
window10 = table2array(window10(:,6));

window15 = accuracyTable(accuracyTable.WindowSize == 15,:);
window15 = table2array(window15(:,6));

window20 = accuracyTable(accuracyTable.WindowSize == 20,:);
window20 = table2array(window20(:,6));

accuracyByWindow = [window5,window10,window15,window20];

meanAccuracy = mean(accuracyByWindow);
stdAccuracy = std(accuracyByWindow);


scatter([5,10,15,20],meanAccuracy,40,"red","filled");
hold on
errorbar([5,10,15,20],meanAccuracy,stdAccuracy,'.');
xlim([4.5,20.5]);
ylabel("Avg. Max Accuracy")
xlabel("Window size (s)")
grid on
