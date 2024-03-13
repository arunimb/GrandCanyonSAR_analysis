clear all
close all
clc

% This script exports time to finish (max time is limited to 600s), Speed
% and turn rate information of human operated drone. Speed and turn rate
% data are truncated to 600s from the press of f2 key
% Adding noise std of 1
%https://www.ingentaconnect.com/contentone/asprs/pers/2005/00000071/00000009/art00006?crawler=true&mimetype=application/pdf
%Piedallu, Christian, and Jean-Claude Gégout. "Effects of forest environment and survey protocol on GPS accuracy." Photogrammetric Engineering & Remote Sensing 71.9 (2005): 1071-1078.

% Read subject id list
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\'; % location of subject data folders
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [0,111,211,121,221,112,212,122,222];
trialName = {'Fam','NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'};
% Window size for smoothing speed and turn rate
smoothWindow = 6;
outlierRemove = 1;
smoothing  = 1; % To smooth or not
interpolating = 1; % To interpolate or not
unwrapOrNot = 1; % Unwrap heading data or not, 1 = yes
regularizationDt = 1/24;
for ii = 1:numel(subject)
    % Import trial order
    trialOrder = readmatrix([preFolder, cell2mat(subject(ii)),'\','trialOrder.txt']);
    h1 = figure(1); %create empty figure
    h2 = figure(2); %create empty figure
    %figure(1);
    %clf;
    for j = 1:numel(trialOrder)
        % Import Trajectory
        % Trajectory data columns: time(s), xPos, yPos, zPos, xRot (deg),
        % yRot (deg), zRot (deg), camera pitch (deg)
        % xPos, yPos, zPos are in unity and y is pointing up
        % xRot, yRot, zRot are in fixed frame
        % camera pitch is positive pointing down


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
        if(time2finish>600)
            time2finish = 600;
            for k = pause2:-1:pause1
                time2finishTemp = timeStamps(k)-timeStamps(pause1);
                if(time2finishTemp <= 600)
                    pause2 = k; % Update the end of trial index to 600th second
                    time2finish = timeStamps(pause2)-timeStamps(pause1); % update time to finish
                    break;
                end
            end
        end


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
        regTimeStamps = timeStamps(1):regularizationDt:timeStamps(end); % resample timestamps to regularly spaced timestamps

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

        %         if outlierRemove == 1
        % %             subjectSpeed = rmoutliers(subjectSpeed,"mean");
        % %             subjectTurnRate = rmoutliers(subjectTurnRate,"mean");
        %             for kk = 2:7
        %                 %trajFile(:,kk) = rmoutliers(trajFile(:,kk),"mean");
        %                 trajFile(:,kk) = filloutliers(trajFile(:,kk),"linear","mean");
        %             end
        %
        %         end
        %
        %         if smoothing
        %             tempTraj = trajFile;
        %             for kk = 2:7
        %                 tempTraj(:,kk) = sma(trajFile(:,kk),smoothWindow);
        %             end
        %             trajFile = tempTraj;
        %         end


        % Because unity y is real world z
        subjectXPos = trajFile(:,2);subjectYPos = trajFile(:,4);subjectZPos = trajFile(:,3);
        % Calculate heading using position vectors
        subjectHeading = trajFile(:,6); % rotation about z axis (y in unity)



        subjectDelDistance = [];
        subjectDelGroundDistance = [];
        subjectSpeed = [];
        xDot = [];
        yDot =[];
        zDot = [];
        subjectTurnRate = [];
        subjectGroundSpeed = [];
        subjectHeightDot = [];
        time = 1;

        for dNo = 1:numel(subjectXPos)-1
            % Calculate distance travelled every time step
            subjectDelDistance(dNo) = ((subjectXPos(dNo) - subjectXPos(dNo+1))^2 + ...
                (subjectYPos(dNo) - subjectYPos(dNo+1))^2 + (subjectZPos(dNo) - subjectZPos(dNo+1))^2)^0.5;

            subjectDelGroundDistance(dNo) = ((subjectXPos(dNo) - subjectXPos(dNo+1))^2 + (subjectYPos(dNo) - subjectYPos(dNo+1))^2)^0.5;

            % Calculate instantaneous speed
            subjectSpeed(dNo) = abs(subjectDelDistance(dNo))/(regTimeStamps(dNo+1)-regTimeStamps(dNo));


            % Calculate Turn rate
            subjectTurnRate(dNo) = abs(subjectHeading(dNo+1)-subjectHeading(dNo))/(regTimeStamps(dNo+1)-regTimeStamps(dNo));
            subjectTurn(dNo) = abs(subjectHeading(dNo+1)-subjectHeading(dNo));
            % Calculate Height Rate

        end


        subjectSpeed=subjectSpeed(~isnan(subjectSpeed)); % remove NaN values from speed
        subjectSpeed=subjectSpeed(~isinf(subjectSpeed)); % remove undefined values from speed
        subjectTurnRate=subjectTurnRate(~isnan(subjectTurnRate));  % remove NaN values from turn rate
        subjectTurnRate=subjectTurnRate(~isinf(subjectTurnRate));  % remove undefined values from turn rate

        if outlierRemove
            subjectSpeed = filloutliers(subjectSpeed,"linear","mean");
            subjectTurnRate = filloutliers(subjectTurnRate,"linear","mean");
        end

        if smoothing
            subjectSpeed = sma(subjectSpeed,smoothWindow);
            subjectTurnRate = sma(subjectTurnRate,smoothWindow);
        end


        figure(1)
        subplot(3,3,j)
        plot(regTimeStamps(1:numel(subjectSpeed)),subjectSpeed)
        xlabel("Time (s)");
        ylabel("Regularised Speed (m/s)");
        title(trialName{j});
        grid on
        sgtitle(subject(ii))

        % Routine to plot Turn rate vs time
        figure(2)
        subplot(3,3,j)
        plot(regTimeStamps(1:numel(subjectTurnRate)),subjectTurnRate)
        xlabel("Time (s)");
        ylabel("Regularised Turn rate (deg/s)");
        %ylim([0,30])
        title(trialName{j});
        grid on
        sgtitle(subject(ii))
    end

    folderr = ['plots\speedAndTurnRateBySubject\', cell2mat(subject(ii))];
    mkdir(folderr);
    %     saveas(h1,['plots\speedAndTurnRateBySubject','\', cell2mat(subject(ii)),'\','SmoothedRegularisedSpeed.png']);
    %     saveas(h2,['plots\speedAndTurnRateBySubject','\', cell2mat(subject(ii)),'\','SmoothedRegularisedTurnRate.png']);
    saveas(h1,['plots\speedAndTurnRateBySubject','\', cell2mat(subject(ii)),'\','SmoothedRegularisedSpeed_rmoutlier.png']);
    saveas(h2,['plots\speedAndTurnRateBySubject','\', cell2mat(subject(ii)),'\','SmoothedRegularisedTurnRate_rmoutlier.png']);

end