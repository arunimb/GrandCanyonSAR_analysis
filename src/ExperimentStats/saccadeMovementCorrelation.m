clearvars
%close all
clc


% Get data
allFreeze = readmatrix('outputTables/outputForFracCompleteStops.csv');
semiFreeze = readmatrix('outputTables/outputForFracPartialStops.csv');
%pupilDilation = readmatrix('outputTables/outputForPupilDilationGLMM_GrandCanyon.csv');
saccadeFreq = [];
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\';
trialNum = [111,211,121,221,112,212,122,222];
allTrial = [];


windowSize = 5;
mc = 1;
lc = 1;

meanSpeedBySubject = [];
meanTurnRateBySubject = [];
freezeFrac = [];
turnWhileStillFrac = [];
avgSpeed =[];
avgTurnRate=[];
for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        % fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','cogLoad_win=',num2str(windowSize),'s','.csv'];
        fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','freeze_win=',num2str(windowSize),'s','.csv'];
        fileName2 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','saccadicFrequency_window',num2str(windowSize),'.csv'];
        if isfile(fileName1) && isfile(fileName2)

            speedTurnRateFreeze = readmatrix(fileName1);
            saccadicFreq = readmatrix(fileName2);

            if(numel(saccadicFreq)>size(speedTurnRateFreeze,1))
                saccadicFreq = saccadicFreq(numel(saccadicFreq)-size(speedTurnRateFreeze,1)+1:end);
            end
            if(numel(saccadicFreq)<size(speedTurnRateFreeze,1))
                speedTurnRateFreeze = speedTurnRateFreeze(size(speedTurnRateFreeze,1)- numel(saccadicFreq)+1:end,:);
            end
            if(~isempty(speedTurnRateFreeze(:)) && ~sum(isnan(speedTurnRateFreeze(:))) && ~isempty(saccadicFreq(:)) && ~sum(isnan(saccadicFreq(:))))
                saccadeFreq = [saccadeFreq ; saccadicFreq];
                freezeFrac = [freezeFrac; speedTurnRateFreeze(:,3)];
                turnWhileStillFrac = [turnWhileStillFrac; speedTurnRateFreeze(:,4)];
                avgSpeed = [avgSpeed; speedTurnRateFreeze(:,1)];
                avgTurnRate = [avgTurnRate; speedTurnRateFreeze(:,2)];
            end

        end
    end

end
[RR1,pp1 ] = corrcoef(saccadeFreq,avgTurnRate);
[RR2,pp2 ] = corrcoef(saccadeFreq,avgSpeed);
[RR3,pp3 ] = corrcoef(saccadeFreq,freezeFrac);
[RR4,pp4 ] = corrcoef(saccadeFreq,turnWhileStillFrac);

RR = [RR1(1,2),RR2(1,2),RR3(1,2),RR4(1,2)];
pp = [pp1(1,2),pp2(1,2),pp3(1,2),pp4(1,2)];