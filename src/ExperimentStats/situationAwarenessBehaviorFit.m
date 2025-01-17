clearvars
close all
clc

% calculates fit between alpha power and moving while still behavior

fileName = 'outputTables\alphaPowerPartialFreezeSA_15s.csv';
data = readmatrix(fileName);
data2 = data;
data2(:,2) = data(:,1);
data2(:,1) = data(:,2);

dataTable = array2table(data2,"VariableNames",["PartialFreeze","AlphaPower"]);
mdll = fitlm(dataTable);

plot(mdll)