clearvars
%close all
clc


% Get data
allFreeze = readmatrix('outputTables/outputForFracCompleteStops.csv');
semiFreeze = readmatrix('outputTables/outputForFracPartialStops.csv');
pupilDilation = readmatrix('outputTables/outputForPupilDilationGLMM_GrandCanyon.csv');

subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\';
trialNum = [111,211,121,221,112,212,122,222];
allTrial = [];

mc = 1;
lc = 1;
cogload = [];

meanSpeedBySubject = [];
meanTurnRateBySubject = [];
freezeFrac = [];
turnWhileStillFrac = [];
avgSpeed =[];
avgTurnRate=[];
pupilDilAgg = [];
windowSize = 20;
for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','freeze_win=',num2str(windowSize),'s','.csv'];
        fileName2 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','pupilDilation.csv'];
        if isfile(fileName1) && isfile(fileName2)

            speedTurnRateFreeze = readmatrix(fileName1);
            pupilDil = readmatrix(fileName2);

            timeStamps = pupilDil(:,1);
            pupilDil = pupilDil(:,2);
            timeDiff = diff(timeStamps);
            meanSampleRate = int32(1/mean(timeDiff));


            avgPupilDil = [];
            for k = 1:meanSampleRate*windowSize:numel(timeStamps)-meanSampleRate*windowSize+1
                avgPupilDil = [avgPupilDil, mean(pupilDil(k:k+meanSampleRate*windowSize-1)) ];
            end

            avgPupilDil = avgPupilDil';
            if(numel(avgPupilDil)>size(speedTurnRateFreeze,1))
                avgPupilDil = avgPupilDil(numel(avgPupilDil)-size(speedTurnRateFreeze,1)+1:end);
            end
            if(numel(avgPupilDil)<size(speedTurnRateFreeze,1))
                speedTurnRateFreeze = speedTurnRateFreeze(size(speedTurnRateFreeze,1)- numel(avgPupilDil)+1:end,:);
            end

            if(~isempty(speedTurnRateFreeze))
                pupilDilAgg = [pupilDilAgg; avgPupilDil];
                freezeFrac = [freezeFrac; speedTurnRateFreeze(:,3)];
                turnWhileStillFrac = [turnWhileStillFrac; speedTurnRateFreeze(:,4)];
                avgSpeed = [avgSpeed; speedTurnRateFreeze(:,1)];
                avgTurnRate = [avgTurnRate; speedTurnRateFreeze(:,2)];
            end

            if(isempty(speedTurnRateFreeze))
                lss = 1;
            end



        end
    end
end
nanIndices = find(isnan(pupilDilAgg));
pupilDilAgg(nanIndices)= [];
freezeFrac(nanIndices)= [];
turnWhileStillFrac(nanIndices)= [];
avgSpeed(nanIndices)= [];
avgTurnRate(nanIndices)= [];


[RR1,pp1 ] = corrcoef(pupilDilAgg,avgTurnRate);
[RR2,pp2 ] = corrcoef(pupilDilAgg,avgSpeed);
[RR3,pp3 ] = corrcoef(pupilDilAgg,freezeFrac);
[RR4,pp4 ] = corrcoef(pupilDilAgg,turnWhileStillFrac);

RR = [RR1(1,2),RR2(1,2),RR3(1,2),RR4(1,2)];
pp = [pp1(1,2),pp2(1,2),pp3(1,2),pp4(1,2)];