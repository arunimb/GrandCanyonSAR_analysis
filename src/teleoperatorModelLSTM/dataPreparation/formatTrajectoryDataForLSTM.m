clearvars
close all
clc

% This script exports trajectory data for the first X seconds.

% Read subject id list
subject = cellstr(num2str(readmatrix('..\..\..\data\participantID1.csv')));
preFolder = '..\..\..\data\'; % location of subject data folders
addpath('..\..\');
saveFolder = '..\exportedTrajectoryTeleoperatorModelling\';
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [111,211,121,221,112,212,122,222];
%trialNum Aliases
trialAliases = [1,2,3,4,5,6,7,8];
% Window size for smoothing speed and turn rate
smoothWindow = 6;
smoothing  = 0; % To smooth or not
outlierRemove = 1;
interpolating = 1; % To interpolate or not
interpolationSampleRate = 24;
unwrapOrNot = 1; % Unwrap heading data or not, 1 = yes
samplingRate = 24; % Average sampling rate for unity
%windowSize = 15;
maxSubjectSpeed = 50; % m/s
maxSubjectTurnRate = 25; % deg/s
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
accumulateAllsamples = [];
subjectSpeed1 = [];
%for windowSize = 5:5:20
for windowSize = 5
    trajectoryExportWindow = windowSize * interpolationSampleRate;
    s1 = ["================== Window ", num2str(windowSize), "s ==================" ];
    disp(s1);
    tempSample = [];
    for ii = 1:numel(subject)
        s2 = ["============ Subject ", cell2mat(subject(ii)), " ============" ];
        disp(s2);
        for j = 1:numel(trialNum)
            % Import Trajectory
            % Trajectory data columns: time(s), xPos, yPos, zPos, xRot (deg),
            % yRot (deg), zRot (deg), camera pitch (deg)
            % xPos, yPos, zPos are in unity and y is pointing up
            % xRot, yRot, zRot are in fixed frame
            % camera pitch is positive pointing down
            s3 = ["======== Trial ", num2str(trialNum(j)), " ========" ];
            disp(s3);

            fileName = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','Trajectory*.csv']);
            fileName = [fileName.folder,'\',fileName.name];
            trajFile = readmatrix(fileName); % Get Trajectory data
            timeStamps = trajFile(:,1); % 1st column of trajectory data is time stamps

            % Routine to identify paused simulation, f2 key marks the beginning
            % of the trial, also unpauses the simulation for the subject. F11
            % key marks the end of the trial, pauses the trial for the subject.
            % When the simulation is paused, the recorded timestamps do not
            % change, so the diff function lets us identify beginning and
            % ending of a trial.
            diffTimeStamps = diff(timeStamps(2:end));

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

            % Trim time to 600 seconds. subjects who do not search within 600
            % seconds are truncated.
            time2finish = timeStamps(pause2)-timeStamps(pause1); % guess time to finish


            % truncate the trajectory data
            trajFile = trajFile(pause1:pause2,:);
            trajFile2 = trajFile;
            timeStamps = trajFile(:,1)-trajFile(1,1);

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
            else
                regTimeStamps = timeStamps;
            end


            numSegments = fix(size(trajFile,1)/trajectoryExportWindow);
            leftoverSegments = (size(trajFile,1)/trajectoryExportWindow - numSegments)*trajectoryExportWindow;
            endIndex = numSegments*trajectoryExportWindow;% Set end index for trajctory export
            endIndex = endIndex+2;

            if numSegments>0
                %Truncate Trajectory for export LSTM
                if(endIndex<=size(trajFile,1))
                    trajFile = trajFile(1:endIndex,:);
                else
                    endIndex = endIndex - trajectoryExportWindow;
                    trajFile = trajFile(1:endIndex,:);
                end
                % folder where to save trajectory file
                saveFolder = ['exportedTrajectory_',num2str(windowSize),'\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\',];

                % If folder exists, do not create a folder
                if ~exist(saveFolder, 'dir')
                    mkdir(saveFolder)
                end

                % Because unity y is real world z
                subjectXPos = trajFile(:,2);% + normrnd(mu,sigma,size(trajFile(:,2)));
                subjectYPos = trajFile(:,4);% + normrnd(mu,sigma,size(trajFile(:,4)));
                subjectZPos = trajFile(:,3);% + normrnd(mu,sigma,size(trajFile(:,3)));
                % Calculate heading using position vectors
                subjectHeading = trajFile(:,6);% + normrnd(mu,5,size(trajFile(:,6))); % rotation about z axis (y in unity)

                subjectDelDistance = [];
                subjectDelGroundDistance = [];
                subjectSpeed = [];
                subjectTurnRate = [];
                subjectGroundSpeed = [];
                time = 1;
                xDot = [];
                yDot = [];
                zDot = [];
                thetaDot = [];
                subjectAccel = [];
                subjectHeightDot = [];

                for dNo = 1:numel(subjectXPos)-1
                    subjectHeightDot(dNo) = abs(subjectZPos(dNo+1)-subjectZPos(dNo))/(regTimeStamps(dNo+1)-regTimeStamps(dNo))/maxHeightDot;
                    % Calculate distance travelled every time step
                    subjectDelDistance(dNo) = ((subjectXPos(dNo) - subjectXPos(dNo+1))^2 + ...
                        (subjectYPos(dNo) - subjectYPos(dNo+1))^2 + (subjectZPos(dNo) - subjectZPos(dNo+1))^2)^0.5;

                    % Calculate instantaneous speed
                    subjectSpeed(dNo) = abs(subjectDelDistance(dNo))/(regTimeStamps(dNo+1)-regTimeStamps(dNo))/maxSpeed;

                    % Calculate Turn rate
                    subjectTurnRate(dNo) = abs(subjectHeading(dNo+1)-subjectHeading(dNo))/(regTimeStamps(dNo+1)-regTimeStamps(dNo))/maxTurnRate;

                    if(subjectSpeed(dNo)>400)
                        hkff = 0;
                    end


                end

                %             accumulateAllValues=[accumulateAllValues; [max(abs(subjectSpeed)),max(abs(subjectGroundSpeed)), max(abs(subjectTurnRate)), max(abs(subjectHeightDot)) ] ];

                subjectSpeed1 = [subjectSpeed1, subjectSpeed];
                subjectHeading = subjectHeading(1:end-2);
                subjectZPos = subjectZPos(1:end-2);
                subjectTurnRate = subjectTurnRate(1:end-1);
                subjectHeightDot = subjectHeightDot(1:end-1);
                subjectGroundSpeed = subjectGroundSpeed(1:end-1);
                subjectDelDistance = subjectDelDistance(1:end-1);

                subjectCumulativeDistance= zeros(size(subjectDelDistance));
                trajectoryExportWindow = windowSize*interpolationSampleRate;
                for iii = 1:trajectoryExportWindow:numel(subjectDelDistance)
                    subjectDelDistanceTemp = subjectDelDistance(iii:iii+trajectoryExportWindow-1);
                    subjectCumulativeDistance(iii:iii+trajectoryExportWindow-1)= cumsum(subjectDelDistanceTemp);
                end

                xDot = xDot(1:end-1);
                yDot = yDot(1:end-1);
                zDot = zDot(1:end-1);

                for dNo = 1:numel(subjectSpeed)-1
                    subjectAccel(dNo) = subjectSpeed(dNo+1)-subjectSpeed(dNo)/(regTimeStamps(dNo+1)-regTimeStamps(dNo));
                end
                subjectAccel = subjectAccel(1:end);
                subjectSpeed = subjectSpeed(1:end-1);
                if outlierRemove
                    %                 subjectSpeed = rmoutliers(subjectSpeed,"center","mean");
                    %                 subjectTurnRate = rmoutliers(subjectTurnRate,"center","mean");
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
                % File save location
                saveTrajFile = [saveFolder,'trajFile_nonNorm.csv'];
                saveWindowFile = [saveFolder,'segmentSize.csv'];
                % Write trajectory to location
                temp = [];
                if ~isempty(trajFile)
                    %temp = [abs(xDot'),abs(yDot'),abs(zDot'),abs(subjectTurnRate'),abs(subjectHeading),abs(subjectGroundSpeed'), subjectSpeed', abs(subjectAccel'),  abs(subjectZPos),  abs(subjectHeightDot'), subjectCumulativeDistance'];
                    temp = [subjectSpeed', subjectTurnRate'];
                    writematrix(temp,saveTrajFile);
                    writematrix(trajectoryExportWindow,saveWindowFile);
                end

                tempSample1 = [];
                tempSample2 = [];
                for sizeup = 1:trajectoryExportWindow:size(temp,1)-trajectoryExportWindow
                    tempSample1 = temp(sizeup:sizeup+trajectoryExportWindow-1,:);
                    tempSample2 = reshape(tempSample1,[1,trajectoryExportWindow,size(temp,2)]);
                    tempSample = [tempSample ; tempSample2];
                end

                totSamples = totSamples + numSegments;
                totSamplesByCondition(j) = totSamplesByCondition(j) + numSegments;
                unusedSamplesByCondition(j) = unusedSamplesByCondition(j) + leftoverSegments/24;
                s4 = ["Number of segments: ", num2str(numSegments) ];
                disp(s4);
                s5 = ["Number of rows: ", num2str(numel(subjectSpeed)) ];
                disp(s5);
                s6 = ["Number of trajectory samples in a segment: ", num2str(trajectoryExportWindow) ];
                disp(s6);
            end
        end
    end
end
% [max(abs(subjectSpeed)),max(abs(subjectGroundSpeed)), max(abs(subjectTurnRate)), max(abs(subjectHeightDot)) ]
% maxSpeed = max(accumulateAllValues(:,1));
% subjectGroundSpeed = max(accumulateAllValues(:,2));
% subjectTurnRate = max(accumulateAllValues(:,3));
% subjectHeightDot = max(accumulateAllValues(:,4));
sampleSpeed = tempSample(:,:,1);
sampleSpeed = sampleSpeed(:);

sampleThetaDot = tempSample(:,:,2);
sampleThetaDot = sampleThetaDot(:);

save("segmented.mat","sampleSpeed","sampleThetaDot")
h1 = histogram(sampleSpeed, 50,'Normalization','probability');
ylabel("Normalized frequency")
xlabel("Value")
title("Segmented Window Speed")
figure
h2 = histogram(sampleThetaDot, 50,'Normalization','probability');
ylabel("Normalized frequency")
xlabel("Value")
title("Segmented Window Turn rate")
