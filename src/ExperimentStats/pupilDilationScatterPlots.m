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
windowSize = 15;
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

            pupilDilAgg = [pupilDilAgg; avgPupilDil];
            freezeFrac = [freezeFrac; speedTurnRateFreeze(:,3)];
            turnWhileStillFrac = [turnWhileStillFrac; speedTurnRateFreeze(:,4)];
            avgSpeed = [avgSpeed; speedTurnRateFreeze(:,1)];
            avgTurnRate = [avgTurnRate; speedTurnRateFreeze(:,2)];

            

        end


    end
end
subplot(3,4,5)
scatter(pupilDilAgg,avgSpeed,'.')
ylabel("Average Speed (m/s)")
xlabel("Average Pupil Dilation")
xlim([-2,2])

subplot(3,4,6)
scatter(pupilDilAgg,avgTurnRate,'.')
ylabel("Average Turn rate (deg/s)")
xlabel("Average Pupil Dilation")
xlim([-2,2])

subplot(3,4,7)
scatter(pupilDilAgg,freezeFrac,'.')
ylabel("Freeze Fraction (hz)")
xlabel("Average Pupil Dilation")
xlim([-2,2])

subplot(3,4,8)
scatter(pupilDilAgg,turnWhileStillFrac, '.')
ylabel("Turn while still fraction (hz)")
xlabel("Average Pupil Dilation")
xlim([-2,2])