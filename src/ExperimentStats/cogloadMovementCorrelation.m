clearvars
close all
clc

%Cognitive Load
windowSize = 20;
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
avgSpeed = [];
avgTurnRate = [];
for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','cogLoad_win=',num2str(windowSize),'s','.csv'];
        fileName2 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','freeze_win=',num2str(windowSize),'s','.csv'];
        if isfile(fileName1)


            cogLoad = readmatrix(fileName1);
            speedTurnRateFreeze = readmatrix(fileName2);

            if(numel(cogLoad)>size(speedTurnRateFreeze,1))
                cogLoad = cogLoad(numel(cogLoad)-size(speedTurnRateFreeze,1)+1:end);
            end
            if(numel(cogLoad)<size(speedTurnRateFreeze,1))
                speedTurnRateFreeze = speedTurnRateFreeze(size(speedTurnRateFreeze,1)- numel(cogLoad)+1:end,:);
            end
            if(~isempty(speedTurnRateFreeze(:)) && ~sum(isnan(speedTurnRateFreeze(:))))
                cogload = [cogload ; cogLoad];
                freezeFrac = [freezeFrac; speedTurnRateFreeze(:,3)];
                turnWhileStillFrac = [turnWhileStillFrac; speedTurnRateFreeze(:,4)];
                avgSpeed = [avgSpeed; speedTurnRateFreeze(:,1)];
                avgTurnRate = [avgTurnRate; speedTurnRateFreeze(:,2)];
            end
        end
        % lc = lc + 1;
    end
end


[RR1,pp1 ] = corrcoef(cogload,avgTurnRate);
[RR2,pp2 ] = corrcoef(cogload,avgSpeed);
[RR3,pp3 ] = corrcoef(cogload,freezeFrac);
[RR4,pp4 ] = corrcoef(cogload,turnWhileStillFrac);

RR = [RR1(1,2),RR2(1,2),RR3(1,2),RR4(1,2)];
pp = [pp1(1,2),pp2(1,2),pp3(1,2),pp4(1,2)];