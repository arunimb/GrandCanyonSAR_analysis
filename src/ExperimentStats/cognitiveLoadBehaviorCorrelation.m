clearvars
close all
clc

tarKnowledge = [1,2,1,2,1,2,1,2];
terKnowledge = [1,1,2,2,1,1,2,2];
cKnowledge = [1,1,1,1,2,2,2,2]; % cohesion knowledge
windowSize = 5;
% Get cognitive load
fileName = "outputTables\outputForGLMM_GrandCanyon_test.csv";
table = readtable(fileName);
requiredTable = table(table.CogWindow == windowSize, :);

% Get Speed and turn rate

subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\';
trialNum = [111,211,121,221,112,212,122,222];
meanSpeedBySubject = [];
meanTurnRateBySubject = [];
allTrial = [];
c = 1;
for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        fileName1 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','speed.csv'];
        fileName2 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','regTime.csv'];
        fileName3 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','turnRate.csv'];

        speed = readmatrix(fileName1);
        time = readmatrix(fileName2);
        turnRate = readmatrix(fileName3);
        [val, requiredTimeIndex] = min(abs(time-windowSize));
        meanSpeedBySubject(c,1) = mean(speed(1:requiredTimeIndex));
        meanTurnRateBySubject(c,1) = mean(turnRate(1:requiredTimeIndex));
        allTrial(c,1) = trialNum(j);
        c = c + 1;
    end
end

%% Get Correlation
% Match cog trial to speed and turn rate trial

cogLoadArray = table2array(requiredTable);
mixedArray = []; %[cogload, speed,turnrate]
c = 1;
m = 1;
for i = 1:size(cogLoadArray,1)
    checkTrial = cogLoadArray(c,3)*100 + cogLoadArray(c,4)*10 + cogLoadArray(c,2);
    if(checkTrial == allTrial(m))
        mixedArray(c,1)= cogLoadArray(c,1);
        mixedArray(c,2)= meanSpeedBySubject(m);
        mixedArray(c,3)= meanTurnRateBySubject(m);
        c = c + 1;
        m = m + 1;
    elseif(checkTrial ~= allTrial(m))
        m = m + 1;
    end
end


% speed correlation
subplot(1,2,1)
scatter(mixedArray(:,2),mixedArray(:,1));
title(num2str(corr(mixedArray(:,2),mixedArray(:,1))));
xlabel("Speed")
ylabel("Cognitive Load")
% turn rate correlation
subplot(1,2,2)
scatter(mixedArray(:,3),mixedArray(:,1));
title(num2str(corr(mixedArray(:,3),mixedArray(:,1))));
xlabel("Turn Rate")
ylabel("Cognitive Load")