clearvars
%close all
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
smoothWindow = 3;
smoothing  = 1; % To smooth or not
interpolating = 1; % To interpolate or not
interpolationSampleRate = 24;
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

for windowSize = 5:20
    trajectoryExportWindow = windowSize * interpolationSampleRate;
    s1 = ["================== Window ", num2str(windowSize), "s ==================" ];
    disp(s1);
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
            trajFile = trajFile(pause1:pause2,:);
            dataLength = size(trajFile,1);
            clipLength = round(dataLength*0.9);
            trajFile = trajFile(1:clipLength,:);
            timeStamps = trajFile(:,1); % 1st column of trajectory data is time stamps
            kkkkkkk =10;




            

            % Trim time to 600 seconds. subjects who do not search within 600
            % seconds are truncated.
%             time2finish = timeStamps(pause2)-timeStamps(pause1); % guess time to finish
%             if(time2finish>600)
%                 time2finish = 600;
%                 for k = pause2:-1:pause1
%                     time2finishTemp = timeStamps(k)-timeStamps(pause1);
%                     if(time2finishTemp <= 600)
%                         pause2 = k; % Update the end of trial index to 600th second
%                         time2finish = timeStamps(pause2)-timeStamps(pause1); % update time to finish
%                         break;
%                     end
%                 end
%             end
% 
% 
% 
% 
%             % truncate the trajectory data
%             trajFile = trajFile(pause1:pause2,:);
%             trajFile2 = trajFile;
%             timeStamps = trajFile(:,1)-trajFile(1,1);

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
            lastSegmentIndex = 0;
            for koi = 1:1:size(trajFile,1)-trajectoryExportWindow+1-2
                try
                    temp = trajFile(koi:koi+trajectoryExportWindow,:);
                    lastSegmentIndex = lastSegmentIndex + 1;
                catch 
                    warning('End of array');
                end
                
            end

            %leftoverSegments = (size(trajFile,1)/trajectoryExportWindow - numSegments)*trajectoryExportWindow;
            endIndex = numSegments*trajectoryExportWindow;% Set end index for trajctory export
            endIndex = endIndex+2;

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
            
%             maxSpeed
%             subjectGroundSpeed
%             subjectTurnRate
%             subjectHeightDot
            for dNo = 1:numel(subjectXPos)-1
                % Calculate distance travelled every time step
                subjectDelDistance(dNo) = ((subjectXPos(dNo) - subjectXPos(dNo+1))^2 + ...
                    (subjectYPos(dNo) - subjectYPos(dNo+1))^2 + (subjectZPos(dNo) - subjectZPos(dNo+1))^2)^0.5;

                subjectDelGroundDistance(dNo) = ((subjectXPos(dNo) - subjectXPos(dNo+1))^2 + (subjectYPos(dNo) - subjectYPos(dNo+1))^2)^0.5;

                xDot(dNo) = (subjectXPos(dNo) - subjectXPos(dNo+1))/(regTimeStamps(dNo+1)-regTimeStamps(dNo));

                yDot(dNo) = (subjectYPos(dNo) - subjectYPos(dNo+1))/(regTimeStamps(dNo+1)-regTimeStamps(dNo));

                zDot(dNo) = (subjectZPos(dNo) - subjectZPos(dNo+1))/(regTimeStamps(dNo+1)-regTimeStamps(dNo));

                % Calculate instantaneous speed
                subjectSpeed(dNo) = abs(subjectDelDistance(dNo))/(regTimeStamps(dNo+1)-regTimeStamps(dNo))/maxSpeed;

                subjectGroundSpeed(dNo) = abs(subjectDelGroundDistance(dNo))/(regTimeStamps(dNo+1)-regTimeStamps(dNo))/maxGroundSpeed;

                % Calculate Turn rate
                subjectTurnRate(dNo) = abs(subjectHeading(dNo+1)-subjectHeading(dNo))/(regTimeStamps(dNo+1)-regTimeStamps(dNo))/maxTurnRate;

                % Calculate Height Rate
                subjectHeightDot(dNo) = abs(subjectZPos(dNo+1)-subjectZPos(dNo))/(regTimeStamps(dNo+1)-regTimeStamps(dNo))/maxHeightDot;                
            end
%             accumulateAllValues=[accumulateAllValues; [max(abs(subjectSpeed)),max(abs(subjectGroundSpeed)), max(abs(subjectTurnRate)), max(abs(subjectHeightDot)) ] ];
            subjectHeading = subjectHeading(1:end-2);
            subjectZPos = subjectZPos(1:end-2);
            subjectTurnRate = subjectTurnRate(1:end-1);
            subjectHeightDot = subjectHeightDot(1:end-1);
            subjectGroundSpeed = subjectGroundSpeed(1:end-1);

            subjectCumulativeDistance= zeros(size(subjectDelDistance)-1);
            %trajectoryExportWindow = windowSize*interpolationSampleRate;
            for iii = 1:trajectoryExportWindow:numel(subjectDelDistance)-1
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
            % File save location
            saveTrajFile = [saveFolder,'trajFile_mmWin.csv'];
            saveWindowFile = [saveFolder,'segmentSize.csv'];
            % Write trajectory to location
            trajectoryExportWindow = windowSize*samplingRate;
            if ~isempty(trajFile)
                %temp = [xDot',yDot',zDot',subjectTurnRate',subjectHeading,subjectGroundSpeed', subjectSpeed', subjectAccel', subjectZPos, subjectHeightDot'];
                temp = [subjectSpeed',subjectTurnRate',subjectCumulativeDistance'];
                %writematrix(temp,saveTrajFile);
                %writematrix(trajectoryExportWindow,saveWindowFile);
            end

            if isempty(trajFile)
                disp("wtf?!")
 
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

% [max(abs(subjectSpeed)),max(abs(subjectGroundSpeed)), max(abs(subjectTurnRate)), max(abs(subjectHeightDot)) ]
% maxSpeed = max(accumulateAllValues(:,1));
% subjectGroundSpeed = max(accumulateAllValues(:,2));
% subjectTurnRate = max(accumulateAllValues(:,3));
% subjectHeightDot = max(accumulateAllValues(:,4));
