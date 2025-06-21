clearvars
close all
clc

%Cognitive Load
windowSize = 15;
% Get cognitive load
fileName = "outputTables\outputForCogLoadGLMM_GrandCanyon.csv";
table = readtable(fileName);
requiredTable = table(table.CogWindow == windowSize, :);

subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\';
trialNum = [111,211,121,221,112,212,122,222];
allTrial = [];

meanSpeedBySubject = [];
meanTurnRateBySubject = [];
mc = 1;
lc = 1;
cogload = [];
allFreeze = readmatrix('outputTables/outputForFracCompleteStops.csv');
semiFreeze = readmatrix('outputTables/outputForFracPartialStops.csv');
freezeFrac = [];
turnWhileStillFrac = [];
for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        fileName1 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','speed.csv'];
        fileName2 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','regTime.csv'];
        fileName3 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','turnRate.csv'];

        speed = readmatrix(fileName1);
        time = readmatrix(fileName2);
        turnRate = readmatrix(fileName3);
        [val, requiredTimeIndex] = min(abs(time-windowSize));
        c = 1;
        speedBySubject = [];
        turnRateBySubject = [];
        for l = 1:requiredTimeIndex:numel(speed)-requiredTimeIndex
            speedBySubject(c,1) = mean(speed(l:l+requiredTimeIndex-1));
            turnRateBySubject(c,1) = mean(turnRate(l:l+requiredTimeIndex-1));
            c = c + 1;
        end
        meanSpeedBySubject(mc,1) = mean(speedBySubject);
        meanTurnRateBySubject(mc,1) = mean(turnRateBySubject);
        freezeFrac(mc,1) = allFreeze(lc,1);
        turnWhileStillFrac(mc,1) = semiFreeze(lc,1);
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','cogLoad_win=',num2str(windowSize),'s','.csv'];
        if isfile(fileName)
            cogload(mc,1) = readmatrix(fileName);
            mc = mc + 1;
        end
        lc = lc + 1;
    end
end
subplot(1,4,1)
scatter(meanSpeedBySubject,cogload)
ylim([-2,2])

subplot(1,4,2)
scatter(meanTurnRateBySubject,cogload)
ylim([-2,2])

subplot(1,4,3)
scatter(freezeFrac,cogload)
ylim([-2,2])

subplot(1,4,4)
scatter(turnWhileStillFrac, cogload)
ylim([-2,2])