clearvars
close all
clc

% This script exports trajectory data for the first X seconds.

% Read subject id list
subject = cellstr(num2str(readmatrix('..\..\..\data\participantID1.csv')));
preFolder = '..\..\..\data\'; % location of subject data folders
addpath('..\');
saveFolder = 'exportedTrajectory\';
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [111,211,121,221,112,212,122,222];
%trialNum Aliases
trialAliases = [1,2,3,4,5,6,7,8];
% Window size for smoothing speed and turn rate
outlierRemove = 1;
smoothWindow = 6;
smoothing  = 1; % To smooth or not
interpolating = 1; % To interpolate or not
interpolationSampleRate = 24;
maxSubjectSpeed = 50; % m/s
maxSubjectTurnRate = 25; % deg/s
unwrapOrNot = 1; % Unwrap heading data or not, 1 = yes
samplingRate = 24; % Average sampling rate for unity
%windowSize = 15;

totSamples = 0;
totSamplesByCondition = zeros(1,numel(trialNum));
unusedSamplesByCondition = zeros(1,numel(trialNum));
sigma = 1.00;
mu = 0;



%Max Values for normalizing

% maxSpeed =  155.6935;
% maxGroundSpeed =  150.9025;
% maxTurnRate =   2.2301e+03;
% maxHeightDot =   81.9882;

% accumulateAllValues = [];

maxSpeed =  1;
maxGroundSpeed = 1;
maxTurnRate =   1;
maxHeightDot =   1;

for windowSize = 10
    trajectoryExportWindow = windowSize * interpolationSampleRate;
    s1 = ["================== Window ", num2str(windowSize), "s ==================" ];
    disp(s1);
    tempSample  = zeros(1e6,240,2);
    sampleIndex = 1;
    for ii = 1:numel(subject)
        s2 = ["============ Subject ", cell2mat(subject(ii)), " ============" ];
        disp(s2);
        for j = 1:numel(trialNum)
            % Get file path of trajectory file
            fileName = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','Trajectory*.csv']);
            fileName = [fileName.folder,'\',fileName.name];
            trajFile = readmatrix(fileName); % Get Trajectory data
            timeStamps = trajFile(:,1); % 1st column of trajectory data is time stamps

            % Identify paused simulation
            diffTimeStamps = diff(timeStamps(2:end)); % a value of 0 indicates paused simulation

            pause1 = 0; % start of trial index (guess)
            for k = 1:numel(diffTimeStamps)
                if (diffTimeStamps(k) ~= 0)
                    pause1 = k+1;
                    break; % Break when encountering a non zero diff value
                end
            end

            pause2 = 0; % end of trial index (guess)
            for k = pause1+1:numel(diffTimeStamps)
                if (diffTimeStamps(k) == 0)
                    pause2 = k; % Break when encountering a zero diff value
                    break;
                end
            end

            trajFile = trajFile(pause1:pause2,:); % Trim the data so as to remove the paused portions
            dataLength = size(trajFile,1);
            clipLength = round(dataLength*0.9); %Clip last 10 percent of the data
            trajFile = trajFile(1:clipLength,:);
            timeStamps = trajFile(:,1); % 1st column of trajectory data is time stamps
            timeStamps = timeStamps-timeStamps(1);

            % wrap to pi heading data
            if (unwrapOrNot)
                trajFile(:,6) = unwrap(trajFile(:,6)*2*pi/360); % [in radians]
                trajFile(:,6) = trajFile(:,6)*180/pi; % [deg]
            end

            % Regularize timestamps, trajectory, heading
            regTimeStamps = timeStamps(1):1/interpolationSampleRate:timeStamps(end); % resample timestamps to regularly spaced timestamps

            % Resample trajectory data, heading, to new timestamps
            if interpolating
                tempTraj = zeros(numel(regTimeStamps),7);
                for kk = 2:7
                    tempTraj(:,kk) = interp1(timeStamps,trajFile(:,kk),regTimeStamps);
                end
                trajFile = tempTraj;
            end

            % Calculate speed, turnrate
            subjectXPos = trajFile(:,2);
            subjectYPos = trajFile(:,4);
            subjectZPos = trajFile(:,3);
            subjectHeading = trajFile(:,6);

            subjectDelDistance = [];
            subjectSpeed = [];
            subjectTurnRate = [];

            for dNo = 1:numel(subjectXPos)-1
                % Calculate distance travelled every time step
                subjectDelDistance(dNo) = ((subjectXPos(dNo) - subjectXPos(dNo+1))^2 + ...
                    (subjectYPos(dNo) - subjectYPos(dNo+1))^2 + (subjectZPos(dNo) - subjectZPos(dNo+1))^2)^0.5;

                % Calculate instantaneous speed
                subjectSpeed(dNo) = abs(subjectDelDistance(dNo))/(regTimeStamps(dNo+1)-regTimeStamps(dNo))/maxSpeed;

                % Calculate Turn rate
                subjectTurnRate(dNo) = abs(subjectHeading(dNo+1)-subjectHeading(dNo))/(regTimeStamps(dNo+1)-regTimeStamps(dNo))/maxTurnRate;

                if(subjectSpeed(dNo)<0)
                    hkff = 0;
                end

            end


            lastSegmentIndex = 0;
            endIndex = 0;
            %   -trajectoryExportWindow+1
            if numel(subjectSpeed)>trajectoryExportWindow+1
                for koi = 1:1:numel(subjectSpeed)
                    try
                        temp = subjectSpeed(koi:koi+trajectoryExportWindow-1);
                        lastSegmentIndex = lastSegmentIndex + 1;
                    catch
                        warning('End of array');
                        lastSegmentIndex = lastSegmentIndex;
                        endIndex = lastSegmentIndex + trajectoryExportWindow-1;
                        break;
                    end
                end
            end
            if numel(subjectSpeed)<trajectoryExportWindow+1
                hnbh = 1;
            end


            trajFile = trajFile(1:endIndex,:);
            subjectSpeed = subjectSpeed(1:endIndex);
            subjectTurnRate = subjectTurnRate(1:endIndex);

            if outlierRemove
%                 tempSpeed = subjectSpeed;
%                 subjectSpeed = filloutliers(subjectSpeed,"center","mean");
%                 subjectTurnRate = filloutliers(subjectTurnRate,"center","mean");
                meanSubjectSpeed = mean(subjectSpeed);
                meanSubjectTurnRate = mean(subjectTurnRate);
                
                stdSubjectSpeed = std(subjectSpeed);
                stdSubjectTurnRate = std(subjectTurnRate);
                
                idx = subjectSpeed>meanSubjectSpeed + 3*stdSubjectSpeed;
                subjectSpeed(idx) = maxSubjectSpeed;

                idx = subjectTurnRate>meanSubjectTurnRate + 3*stdSubjectTurnRate;
                subjectTurnRate(idx) = maxSubjectTurnRate;
            end

            if smoothing
                
                subjectSpeed = sma(subjectSpeed,smoothWindow);
                subjectTurnRate = sma(subjectTurnRate,smoothWindow);
            end

            % folder where to save trajectory file
            saveFolder = ['exportedTrajectory_',num2str(windowSize),'\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\',];

            % If folder exists, do not create a folder
            if ~exist(saveFolder, 'dir')
                mkdir(saveFolder)
            end

            % File save location
            saveTrajFile = [saveFolder,'trajFile_MvWin.csv'];
            saveWindowFile = [saveFolder,'windowSize.csv'];
            % Write trajectory to location
            trajectoryExportWindow = windowSize*samplingRate;
            if ~isempty(trajFile)
                temp = [subjectSpeed',subjectTurnRate'];
                writematrix(temp,saveTrajFile);
                writematrix(trajectoryExportWindow,saveWindowFile);
            end

            tempSample1 = [];
            tempSample2 = [];
            for sizeup = 1:1:size(temp,1)-trajectoryExportWindow+1
                tempSample1 = temp(sizeup:sizeup+trajectoryExportWindow-1,:);
                tempSample2 = reshape(tempSample1,[1,trajectoryExportWindow,size(temp,2)]);
                tempSample(sampleIndex,:,:) = tempSample2;
                sampleIndex = sampleIndex + 1;
            end

            if isempty(trajFile)
                disp("wtf?!")
            end
        end
    end
end
sampleIndex = sampleIndex-1;
tempSample= tempSample(1:sampleIndex,:,:);
sampleSpeed = tempSample(:,:,1);
sampleSpeed = sampleSpeed(:);

sampleThetaDot = tempSample(:,:,2);
sampleThetaDot = sampleThetaDot(:);


save("sliding.mat","sampleSpeed","sampleThetaDot")
histogram(sampleSpeed, 50,'Normalization','probability')
ylabel("Normalized frequency")
xlabel("Value")
title("Sliding window Speed")
figure
histogram(sampleThetaDot, 50,'Normalization','probability')
ylabel("Normalized frequency")
xlabel("Value")
title("Sliding window Turn rate")