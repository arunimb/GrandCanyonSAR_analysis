clearvars
close all
clc

subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
preFolder = '..\..\data\'; % location of subject data folders
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [111,211,121,221,112,212,122,222];

windowSize = [5, 10, 15, 20]; % Cognitive load calculation window
samplingRate = 256; % EEG sampling rate (Hz)
regularizationDt = 1/24;
RAvgSpeed = [];
pAvgSpeed = [];
RAvgTurnrate = [];
pAvgTurnrate = [];
overLordPupilDil = [];
overLordAvgSpeed = [];
overLordAvgTurnRate = [];
for ll = 1:numel(windowSize)
    aggPupilDilation = [];
    aggAvgTurnRate = [];
    aggAvgSpeed = [];
    c2 = 1;
    for ii = 1:numel(subject)
        for j = 1:numel(trialNum)
            % Get filtered EEG filename for the trial section
            fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','rawGaze.csv'];
            if isfile(fileName1)
                %disp([num2str(cell2mat(subject(ii))),', ', num2str(trialNum(j))])

                data = readmatrix(fileName1);
                %             pupilDiaLeft = filloutliers(data(:,22),"linear");  %mm
                %             pupilDiaRight = filloutliers(data(:,21),"linear");  %mm
                % pupilDiaLeft = fillmissing(data(:,22),'linear');  %mm
                % pupilDiaRight = fillmissing(data(:,21),'linear');  %mm
                pupilDiaLeft = data(:,22);  %mm
                pupilDiaRight = data(:,21);  %mm
                pupilTime = data(:,1);
                pupilTime = pupilTime - pupilTime(1);
                pupilDiaAvg = 0.5*(pupilDiaRight + pupilDiaLeft);
                pupilDiaAvg = fillmissing(pupilDiaAvg,'linear');
                pupilDiaAvg = filloutliers(pupilDiaAvg,'linear');

                fileName2 = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','Trajectory*.csv']);
                fileName2 = [fileName2.folder,'\',fileName2.name];
                trajFile = readmatrix(fileName2);
                trajTime = trajFile(:,1); % 1st column of trajectory data is time stamps

                % Routine to identify paused simulation, f2 key marks the beginning
                % of the trial, also unpauses the simulation for the subject. F11
                % key marks the end of the trial, pauses the trial for the subject.
                % When the simulation is paused, the recorded timestamps do not
                % change, so the diff function lets us identify beginning and
                % ending of a trial.
                diffTimeStamps = diff(trajTime(2:end));

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
                % truncate the trajectory data
                trajFile = trajFile(pause1:pause2,:);
                trajFile2 = trajFile;
                trajTime = trajFile(:,1)-trajFile(1,1);
                %disp([num2str(trajTime(end)),', ', num2str(pupilTime(end))])

                trajTimeEnd = floor(trajTime(end));
                pupilTimeEnd = floor(pupilTime(end));
                if (pupilTimeEnd < trajTimeEnd)
                    trajTimeEnd = pupilTimeEnd;
                end
                if (pupilTimeEnd >= trajTimeEnd)
                    pupilTimeEnd = trajTimeEnd;
                end


                % Regularize timestamps, trajectory, heading
                regTimeStamps = trajTime(1):regularizationDt:trajTimeEnd; % resample timestamps to regularly spaced timestamps
                regTimeStampsPupil = pupilTime(1):regularizationDt:pupilTimeEnd; % resample timestamps to regularly spaced timestamps
                [val,first_idx,tt] = unique(pupilTime,'stable');
                pupilTime(:) = NaN;
                pupilTime(first_idx) = val;
                pupilTime = fillmissing(pupilTime,'linear');
                % Resample trajectory data, heading, to new timestamps
                tempTraj = zeros(numel(regTimeStamps),7);
                pupilDiaAvgTemp = interp1(pupilTime,pupilDiaAvg,regTimeStampsPupil);
                pupilDiaAvg = pupilDiaAvgTemp;
                for kk = 2:7
                    tempTraj(:,kk) = interp1(trajTime,trajFile(:,kk),regTimeStamps);
                end
                trajFile = tempTraj;
                avgTurnRate = [];
                avgSpeed = [];
                totalDistanceMovedSegment = [];
                totalAngleMovedSegment = [];
                % wrap to pi heading data
                if (1)
                    trajFile(:,6) = unwrap(trajFile(:,6)*2*pi/360); % [in radians]
                    trajFile(:,6) = trajFile(:,6)*180/pi; % [deg]
                end
                % % % % %
                c1 = 1;
                avgTurnRate = [];
                avgSpeed = [];
                avgPupilDilation =[];
                subjectXPos = trajFile(:,2);subjectYPos = trajFile(:,4);subjectZPos = trajFile(:,3);
                for k = 1:windowSize(ll)*(1/regularizationDt):trajTimeEnd*(1/regularizationDt)-(windowSize(ll)*(1/regularizationDt))+1
                    c = 1;
                    turnRate = [];
                    subjectSpeed = [];
                    pupilDia = [];
                    for kk = k:k+windowSize(ll)*(1/regularizationDt)-1
                        turnRate(c)= (trajFile(kk+1,6)-trajFile(kk,6))/regularizationDt;
                        subjectDelDistance = ((subjectXPos(kk) - subjectXPos(kk+1))^2 + ...
                            (subjectYPos(kk) - subjectYPos(kk+1))^2 + (subjectZPos(kk) - subjectZPos(kk+1))^2)^0.5;
                        subjectSpeed(c) = abs(subjectDelDistance)/regularizationDt;
                        pupilDia(c) = pupilDiaAvg(kk);
                        c = c + 1;
                    end
                    avgTurnRate(c1)= mean(turnRate);
                    avgSpeed(c1)= mean(subjectSpeed);
                    avgPupilDilation(c1)= mean(pupilDiaAvg);
                    c1 = c1 + 1;
                end
            end
            overLordPupilDil(c2,j) = mean(pupilDiaAvg);
            overLordAvgSpeed(c2,j) = mean(subjectSpeed);
            overLordAvgTurnRate(c2,j) = mean(turnRate);
        end
        c2 = c2 + 1;
        aggPupilDilation = [aggPupilDilation,avgPupilDilation];
        aggAvgTurnRate = [aggAvgTurnRate,avgTurnRate];
        aggAvgSpeed = [aggAvgSpeed,avgSpeed];
    end

    stdPupilDilation = std(aggPupilDilation);
    meanPupilDilation = mean(aggPupilDilation);

    indRej = abs(aggPupilDilation) < 4 ;
    aggPupilDilation = aggPupilDilation(indRej);

    aggAvgTurnRate = aggAvgTurnRate(indRej);
    aggAvgSpeed = aggAvgSpeed(indRej);
    % aggTotalDistance = aggTotalDistance(indRej);
    % aggTotalAngle = aggTotalAngle(indRej);
    [RR,pp ] = corrcoef(aggPupilDilation,aggAvgSpeed);
    RAvgSpeed(ll) = RR(1,2);
    pAvgSpeed(ll) = pp(1,2);
    [RR,pp ] = corrcoef(aggPupilDilation,aggAvgTurnRate);
    RAvgTurnrate(ll)  = RR(1,2);
    pAvgTurnrate(ll) = pp(1,2);
end
figure(1)
subplot(221)
plot(windowSize,RAvgSpeed);
xlabel("Window size")
ylabel("Coefficient (avg speed)")
grid on

subplot(222)
plot(windowSize,RAvgTurnrate);
xlabel("Window size")
ylabel("Coefficient (avg turn rate)")
grid on

subplot(223)
plot(windowSize,pAvgSpeed);
xlabel("Window size")
ylabel("pVal (avg speed)")
grid on

subplot(224)
plot(windowSize,pAvgTurnrate);
xlabel("Window size")
ylabel("pVal (avg turn rate)")
grid on


%overLordPupilDil(c2,j) = mean(pupilDiaAvg);
%overLordAvgSpeed(c2,j) = mean(subjectSpeed);
%overLordAvgTurnRate(c2,j) = mean(turnRate);

%% Run this section
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\';
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion

% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [111,211,121,221,112,212,122,222];

%% time to finish
figure
c = 1;
time2FinishBySubject = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','time_to_finish.csv'];
        if isfile(fileName)
            time2FinishBySubject(ii,j) = readmatrix(fileName);
            c = c + 1;
        end
        if ~isfile(fileName)
            time2FinishBySubject(ii,j) = nan;
            c = c + 1;
        end
    end
end
time2FinishBySubject(any(isnan(time2FinishBySubject),2),:) = [];
%overLordPupilDil(c2,j) = mean(pupilDiaAvg);
%overLordAvgSpeed(c2,j) = mean(subjectSpeed);
%overLordAvgTurnRate(c2,j) = mean(turnRate);
[RR1,pp1 ] = corrcoef(overLordPupilDil(:),time2FinishBySubject(:));
[RR2,pp2 ] = corrcoef(overLordAvgSpeed(:),time2FinishBySubject(:));
[RR3,pp3 ] = corrcoef(overLordAvgTurnRate(:),time2FinishBySubject(:));

