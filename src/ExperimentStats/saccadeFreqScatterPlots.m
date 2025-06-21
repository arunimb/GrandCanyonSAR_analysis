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


windowSize = 15;
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

            saccadeFreq = [saccadeFreq ; saccadicFreq];
            freezeFrac = [freezeFrac; speedTurnRateFreeze(:,3)];
            turnWhileStillFrac = [turnWhileStillFrac; speedTurnRateFreeze(:,4)];
            avgSpeed = [avgSpeed; speedTurnRateFreeze(:,1)];
            avgTurnRate = [avgTurnRate; speedTurnRateFreeze(:,2)];

            
        end
    end

end
subplot(3,4,9)
scatter(saccadeFreq,avgSpeed,'.')
ylabel("Average Speed (m/s)")
xlabel("Average Saccade Frequency (hz)")
% ylim([-2,2])
%pbaspect([1 1 1])

subplot(3,4,10)
scatter(saccadeFreq,avgTurnRate,'.')
ylabel("Average Turn rate (deg/s)")
xlabel("Average Saccade Frequency (hz)")
%pbaspect([1 1 1])

subplot(3,4,11)
scatter(saccadeFreq,freezeFrac,'.')
ylabel("Freeze Fraction (hz)")
xlabel("Average Saccade Frequency (hz)")
%pbaspect([1 1 1])

subplot(3,4,12)
scatter(saccadeFreq,turnWhileStillFrac, '.')
ylabel("Turn while still fraction (hz)")
xlabel("Average Saccade Frequency (hz)")
%pbaspect([1 1 1])