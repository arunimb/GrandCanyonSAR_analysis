%% housekeeping
clearvars
close all
clc

% This file plots filtered EEG and cognitive load

subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
preFolder = '..\..\data\'; % location of subject data folders
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [111,211,121,221,112,212,122,222];
% Bhattacharya, Arunim, and Sachit Butail. "Measurement and Analysis of Cognitive Load
% Associated with Moving Object Classification in Underwater Environments."
% International Journal of Human–Computer Interaction (2023): 1-11.
eegChannelWeighting = [ 0.0398,    0.370,    0.1741 ,   0.6393 ,  ...
    0   ,      0   ,      0   ,      0 ,        0  ,       0  , ...
    0.6393  ,  0.1741 ,0.3706,    0.0398];
windowSizes = [5 10 15 20]; % Cognitive load calculation window
samplingRate = 256; % EEG sampling rate (Hz)
regularizationDt = 1/24;


AOI1coord = [[2560-635,1080-260],[2560+200, 1080+200]]; %top right, coordinates for bottom left and top right corners
AOI2coord = [[-200,1080-260],[635,1080+200]]; %top left
AOI3coord = [[-200,-200],[635,260]];%bottom left
AOI4coord = [[2560-635,-200],[2560+200,260]]; %bottom right
AOI5coord = [[-200,-200],[2560+200, 1080+200]]; %whole screen
AOI6coord = [[-200,-200],[2560+200, 540+200]]; %bottom half of screen

AggCorrelationsR = zeros(numel(windowSizes),4);
AggCorrelationsP = zeros(numel(windowSizes),4);
for ll = 1:numel(windowSizes)
    windowSize = windowSizes(ll);
    aggDwellTime = [];
    aggAvgTurnRate = [];
    aggAvgSpeed = [];
    aggFreeze = [];
    aggPartialFreeze = [];
    for ii = 1:numel(subject)
        for j = 1:numel(trialNum)
            % Get filtered EEG filename for the trial section
            fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','calibratedGaze.csv'];

            if isfile(fileName1)
                % disp(cell2mat(subject(ii)));
                gaze = readmatrix(fileName1);

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
                trajTimeEnd= floor(trajTime(end));
                % wrap to pi heading data
                if (1)
                    trajFile(:,6) = unwrap(trajFile(:,6)*2*pi/360); % [in radians]
                    trajFile(:,6) = trajFile(:,6)*180/pi; % [deg]
                end

                gazeTime = gaze(:,1);


                gazeTime = gazeTime-gazeTime(1); % set start time to 0
                gazeTimeEnd = floor(gazeTime(end));
                if (gazeTimeEnd < trajTimeEnd)
                    trajTimeEnd = gazeTimeEnd;
                elseif (gazeTimeEnd > trajTimeEnd)
                    gazeTimeEnd = trajTimeEnd;
                end

                dwellTime = [];
                numSamples = floor(windowSize/mean(diff(gazeTime)));
                c = 1;
                for k = 1:numSamples:numel(gazeTime)-numSamples
                    [~,temp1] = funcIdt(gaze(k:k+numSamples,:),AOI1coord);
                    [~,temp2] = funcIdt(gaze(k:k+numSamples,:),AOI2coord);
                    [~,temp3] = funcIdt(gaze(k:k+numSamples,:),AOI3coord);
                    [~,temp4] = funcIdt(gaze(k:k+numSamples,:),AOI4coord);
                    [~,temp5] = funcIdt(gaze(k:k+numSamples,:),AOI5coord);
                    [~,temp6] = funcIdt(gaze(k:k+numSamples,:),AOI6coord);
                    %dwellTime(c) = temp5-temp2-temp3-temp4;
                    dwellTime(c) = temp1+temp6;
                    % dwellTime(c) = temp1;
                    c = c + 1;
                end


                % Regularize timestamps, trajectory, heading
                regTimeStamps = trajTime(1):regularizationDt:trajTime(end); % resample timestamps to regularly spaced timestamps

                % Resample trajectory data, heading, to new timestamps
                tempTraj = zeros(numel(regTimeStamps),7);
                for kk = 2:7
                    tempTraj(:,kk) = interp1(trajTime,trajFile(:,kk),regTimeStamps);
                end
                trajFile = tempTraj;
                trajFile(:,6) = unwrap(trajFile(:,6)*2*pi/360); % [in radians]
                trajFile(:,6) = trajFile(:,6)*180/pi; % [deg]

                avgTurnRate = [];
                avgSpeed = [];
                fracCompleteStops = [];
                fracPartialStops = [];
                c1 = 1;
                subjectXPos = trajFile(:,2);subjectYPos = trajFile(:,4);subjectZPos = trajFile(:,3);
                for k = 1:windowSize*(1/regularizationDt):trajTimeEnd*(1/regularizationDt)-(windowSize*(1/regularizationDt))+1
                    c = 1;
                    turnRate = [];
                    subjectSpeed = [];
                    for kk = k:k+windowSize*(1/regularizationDt)-1
                        turnRate(c)= (trajFile(kk+1,6)-trajFile(kk,6))/regularizationDt;
                        subjectDelDistance = ((subjectXPos(kk) - subjectXPos(kk+1))^2 + ...
                            (subjectYPos(kk) - subjectYPos(kk+1))^2 + (subjectZPos(kk) - subjectZPos(kk+1))^2)^0.5;
                        subjectSpeed(c) = abs(subjectDelDistance)/regularizationDt;
                        c = c + 1;
                    end
                    numCompleteStops = 0;
                    numPartialStops = 0;

                    for dd = 1:numel(turnRate)
                        if(abs(turnRate(dd)) <= 1 && abs(subjectSpeed(dd)) <= 0.1)
                            numCompleteStops = numCompleteStops + 1;
                        end
                        if(abs(subjectSpeed(dd)) <= 0.1)
                            numPartialStops = numPartialStops + 1;
                        end
                    end
                    fracCompleteStops(c1) = numCompleteStops/ numel(turnRate);
                    fracPartialStops(c1) = numPartialStops/ numel(turnRate);
                    avgTurnRate(c1)= mean(turnRate);
                    avgSpeed(c1)= mean(subjectSpeed);
                    c1 = c1 + 1;
                end
            end

            if(numel(dwellTime)>numel(avgTurnRate))
                dwellTime = dwellTime(1:numel(avgTurnRate));
            elseif (numel(dwellTime)<numel(avgTurnRate))
                avgTurnRate = avgTurnRate(1:numel(dwellTime));
                avgSpeed = avgSpeed(1:numel(dwellTime));
                fracCompleteStops = fracCompleteStops(1:numel(dwellTime));
                fracPartialStops = fracPartialStops(1:numel(dwellTime));
            end
            aggDwellTime = [aggDwellTime,dwellTime];
            aggAvgTurnRate = [aggAvgTurnRate,avgTurnRate];
            aggAvgSpeed = [aggAvgSpeed,avgSpeed];
            aggFreeze = [aggFreeze,fracCompleteStops];
            aggPartialFreeze = [aggPartialFreeze,fracPartialStops];
        end
    end

    [RR,pp ] = corrcoef(aggDwellTime,aggAvgTurnRate);
    AggCorrelationsR(ll,1)  = RR(1,2);
    AggCorrelationsP(ll,1) = pp(1,2);

    [RR,pp ] = corrcoef(aggDwellTime,aggAvgSpeed);
    AggCorrelationsR(ll,2) = RR(1,2);
    AggCorrelationsP(ll,2) = pp(1,2);

    [RR,pp ] = corrcoef(aggDwellTime,aggFreeze);
    AggCorrelationsR(ll,3)  = RR(1,2);
    AggCorrelationsP(ll,3) = pp(1,2);

    [RR,pp ] = corrcoef(aggDwellTime,aggPartialFreeze);
    AggCorrelationsR(ll,4) = RR(1,2);
    AggCorrelationsP(ll,4) = pp(1,2);

end

% d1=dataset(aggDwellTime, aggAvgTurnRate);
% % mdl=fitlm(d, 'cognitiveLoad~reactionTime+ageYrs') % use this only if the alpha range is set by age
% mdl=fitlm(d1, 'aggAvgTurnRate~aggDwellTime')
% figure(1); gcf; clf;
% subplot(121)
% plot(mdl);
% xlabel('Average Turn Rate (deg/s)');
% ylabel('Dwell Time (s)');