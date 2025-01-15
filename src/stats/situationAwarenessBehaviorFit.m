clearvars
close all
clc

fileName = 'outputTables\alphaPowerFreezeSA_15s.csv';
data = readmatrix(fileName);


meanPower = mean(data(:,1));
stdPower = std(data(:,1));
nonOutlierIdx = [];

for i = 1:numel(data(:,2))
    if(data(i,1)< meanPower + 0.01*stdPower)
        nonOutlierIdx = [nonOutlierIdx, i];
    end
end

processedData = zeros(numel(nonOutlierIdx),2);
temp = data(:,1);
processedData(:,1) = temp(nonOutlierIdx);

temp = data(:,2);
processedData(:,2) = temp(nonOutlierIdx);


processedData(:,1) = processedData(:,1)/max(processedData(:,1));
scatter(processedData(:,2),processedData(:,1));
hold on
x = [ones(size(processedData(:,2))), processedData(:,2)];
b1 =x\processedData(:,1);
yCalc = x*b1;
plot(processedData(:,1),yCalc);

