clearvars
close all
clc

subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
preFolder = '..\..\data\'; % location of subject data folders
trialNum = [111,211,121,221,112,212,122,222];
regularizationDt = 1/24;
eegChannelWeighting = [ 0.0398,    0.370,    0.1741 ,   0.6393 ,  ...
    0   ,      0   ,      0   ,      0 ,        0  ,       0  , ...
    0.6393  ,  0.1741 ,0.3706,    0.0398];

aggFracCompleteStops= [];
aggFracPartialStops = [];
aggSaccadeFreq = [];
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

        trajTimeEnd = floor(timeStamps(end));
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

        % fracCompleteStops = numCompleteStops/ numel(subjectTurnRate);
            % fracPartialStops = numPartialStops/ numel(subjectTurnRate);
            fracCompleteStops = [];
            fracPartialStops = [];
            for k = 1:windowSize*1/regularizationDt:trajTimeEnd*(1/regularizationDt)-(windowSize*1/regularizationDt)
                numCompleteStops = 0;
                numPartialStops = 0;
                for dd = k:k+windowSize*1/regularizationDt-1
                    if(abs(subjectTurnRate(dd)) <= 1 && abs(subjectSpeed(dd)) <= 0.1)
                        numCompleteStops = numCompleteStops + 1;
                    end
                    if(abs(subjectSpeed(dd)) <= 0.1)
                        numPartialStops = numPartialStops + 1;
                    end
                end
                fracCompleteStops = [fracCompleteStops numCompleteStops/(windowSize*1/regularizationDt)];
                fracPartialStops = [fracPartialStops numPartialStops/(windowSize*1/regularizationDt)];
            end
        fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','saccadicFrequency_window',num2str(5),'.csv'];
        fileName2 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','time_to_finish.csv'];
        if isfile(fileName1)

            data = readmatrix(fileName1);
            saccadicFrequency = data;
            saccadicFrequency(saccadicFrequency<0)=0;
            saccadicFrequency(isnan(saccadicFrequency))=0;
            time2Finish = readmatrix(fileName2);
            
        end
        if(numel(saccadicFrequency)<numel(fracCompleteStops))
            fracCompleteStops=fracCompleteStops(1:numel(saccadicFrequency));
            fracPartialStops=fracPartialStops(1:numel(saccadicFrequency));
        elseif (numel(saccadicFrequency)> numel(fracCompleteStops))
            saccadicFrequency=saccadicFrequency(1:numel(fracCompleteStops));
        end

        aggSaccadeFreq = [aggSaccadeFreq,saccadicFrequency'];
        aggFracCompleteStops= [aggFracCompleteStops fracCompleteStops];
        aggFracPartialStops = [aggFracPartialStops fracPartialStops];
    end
end
[RR1,pp1 ] = corrcoef(aggSaccadeFreq,aggFracCompleteStops);
RfracCompleteStops = RR1(1,2);
pfracCompleteStops = pp1(1,2);

[RR2,pp2 ] = corrcoef(aggSaccadeFreq,aggFracPartialStops);
RfracPartialStops = RR2(1,2);
pfracPartialStops = pp2(1,2);