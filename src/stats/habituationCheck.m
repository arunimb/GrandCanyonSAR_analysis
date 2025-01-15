clear all
close all
clc

% This script checks for habituation effects and effectiveness of
% familiarization trials

subject = cellstr(num2str(readmatrix('..\data\participantID1.csv')));
preFolder = '..\data\'; % location of subject data folders
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [0,111,211,121,221,112,212,122,222];
trialName = {'Fam','NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'}; % Person, Terrain, Swarm cohesion

time2finish = zeros(20,9);
for i = 1:numel(subject)
    trialOrder = readmatrix([preFolder, cell2mat(subject(i)),'\','trialOrder.txt']);
    for j = 1:numel(trialOrder)
        time2finish(i,j) = readmatrix([preFolder, cell2mat(subject(i)),'\', num2str(trialOrder(j)),'\','time_to_finish.csv']);       
    end
end

xLabel=[1,2,3,4,5,6,7,8,9];
meanTime = mean(time2finish); % Calculate mean time to finish trial over 20 subjects
stdTime = std(time2finish); % Calculate std of time to finish trial over 20 subjects

bar(meanTime);
ylabel("Time to finish (s)")
hold on
er = errorbar(xLabel,meanTime,stdTime);
er.Color = [0,0,0];
er.LineStyle = 'none'; 
