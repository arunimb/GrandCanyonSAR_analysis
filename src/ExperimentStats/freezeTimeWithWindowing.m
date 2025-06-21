clearvars
close all
clc

subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
preFolder = '..\..\data\'; % location of subject data folders
trialNum = [111,211,121,221,112,212,122,222];
regularizationDt = 1/24;
windowSize = 20;
for ii = 1:numel(subject)
    % Import trial order


    for j = 1:numel(trialNum)

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
        trajFile(:,6) = unwrap(trajFile(:,6)*2*pi/360); % [in radians]
        trajFile(:,6) = trajFile(:,6)*180/pi; % [deg]


        % Regularize timestamps, trajectory, heading
        regTimeStamps = timeStamps(1):regularizationDt:timeStamps(end); % resample timestamps to regularly spaced timestamps
        if 1
            tempTraj = zeros(numel(regTimeStamps),7);
            for kk = 2:7
                tempTraj(:,kk) = interp1(timeStamps,trajFile(:,kk),regTimeStamps);
            end
            trajFile = tempTraj;
        else
            regTimeStamps = timeStamps;
        end



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

        c = 1;
        fracCompleteStops = [];
        fracPartialStops = [];
        meanSpeed =[];
        meanTurnRateTemp =[];
        for ddl = 1:windowSize/regularizationDt:numel(subjectTurnRate)-(windowSize/regularizationDt)+1
            numCompleteStops = 0;
            numPartialStops = 0;
            subjectTurnRateTemp = subjectTurnRate(ddl:ddl+(windowSize/regularizationDt)-1);
            subjectSpeedTemp = subjectSpeed(ddl:ddl+(windowSize/regularizationDt)-1);
            for dd = 1:windowSize/regularizationDt
                if(abs(subjectTurnRateTemp(dd)) <= 1 && abs(subjectSpeedTemp(dd)) <= 0.1)
                    numCompleteStops = numCompleteStops + 1;
                end
                if(abs(subjectSpeedTemp(dd)) <= 0.1)
                    numPartialStops = numPartialStops + 1;
                end
            end
            fracCompleteStops(c,1) = numCompleteStops/ (windowSize/regularizationDt);
            fracPartialStops(c,1) = numPartialStops/ (windowSize/regularizationDt);
            meanSpeed(c,1) = mean(subjectSpeedTemp);
            meanTurnRateTemp(c,1) = mean(subjectTurnRateTemp);
            c = c + 1;
        end


        

        % subjectSpeed=subjectSpeed(~isnan(subjectSpeed)); % remove NaN values from speed
        % subjectSpeed=subjectSpeed(~isinf(subjectSpeed)); % remove undefined values from speed
        % subjectTurnRate=subjectTurnRate(~isnan(subjectTurnRate));  % remove NaN values from turn rate
        % subjectTurnRate=subjectTurnRate(~isinf(subjectTurnRate));  % remove undefined values from turn rate
        saveFolder = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','freeze_win=',num2str(windowSize),'s','.csv'];
        writematrix('Speed, TurnRate, Frac Complete Stop, Frac Partial Stops',saveFolder);
        writematrix([meanSpeed,meanTurnRateTemp,fracCompleteStops,fracPartialStops],saveFolder,'WriteMode','append');
    end
end