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
windowSizes = 5; %[5 10 15 20]; % Cognitive load calculation window
samplingRate = 256; % EEG sampling rate (Hz)
regularizationDt = 1/24;



AggCorrelationsR = zeros(numel(windowSizes),4);
AggCorrelationsP = zeros(numel(windowSizes),4);
for ll = 1:numel(windowSizes)
    windowSize = windowSizes(ll);
    aggAlphaPower = [];
    aggAvgTurnRate = [];
    aggAvgSpeed = [];
    aggFreeze = [];
    aggPartialFreeze = [];
    for ii = 1:numel(subject)
        for j = 1:numel(trialNum)
            % Get filtered EEG filename for the trial section
            fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','eegFiltered.csv'];
            % Get baseline filtered EEG filename for the trial section
            fileName2 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','eegBaselineFiltered.csv'];

            if isfile(fileName1)
                % disp(cell2mat(subject(ii)));
                gaze = readmatrix(fileName1);

                fileName3 = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','Trajectory*.csv']);
                fileName3 = [fileName3.folder,'\',fileName3.name];
                trajFile = readmatrix(fileName3);
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


                eeg = readmatrix(fileName1);
                eegTime = eeg(:,1);
                eegTime = eegTime-eegTime(1); % set start time to 0
                eegTimeEnd = eegTime(end);

                if(trajTimeEnd < eegTimeEnd)
                    eegTimeEnd = trajTimeEnd;
                elseif (trajTimeEnd > eegTimeEnd)
                    trajTimeEnd = eegTimeEnd;
                end
                cogLoadTime = [];
                cogLoadIndexer = 1;
                baselineEEG = readmatrix(fileName2);

                c = 1;
                alphaPower=[];
                for k = 1:windowSize*256:eegTimeEnd*256-(windowSize*256)
                    [~,~,~,~,~,alphaPower(c)] = eegAlphaPower(baselineEEG(:,2:end)', eeg(k:k+windowSize*256-1,2:end)', ...
                        1/256,eegChannelWeighting/sum(eegChannelWeighting),'alphaDiff','fft');
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

            if(numel(alphaPower)>numel(avgTurnRate))
                alphaPower = alphaPower(1:numel(avgTurnRate));
            elseif (numel(alphaPower)<numel(avgTurnRate))
                avgTurnRate = avgTurnRate(1:numel(alphaPower));
                avgSpeed = avgSpeed(1:numel(alphaPower));
                fracCompleteStops = fracCompleteStops(1:numel(alphaPower));
                fracPartialStops = fracPartialStops(1:numel(alphaPower));
            end
            aggAlphaPower = [aggAlphaPower,alphaPower];
            aggAvgTurnRate = [aggAvgTurnRate,avgTurnRate];
            aggAvgSpeed = [aggAvgSpeed,avgSpeed];
            aggFreeze = [aggFreeze,fracCompleteStops];
            aggPartialFreeze = [aggPartialFreeze,fracPartialStops];
        end
    end

    [RR,pp ] = corrcoef(aggAlphaPower,aggAvgTurnRate);
    AggCorrelationsR(ll,1)  = RR(1,2);
    AggCorrelationsP(ll,1) = pp(1,2);

    [RR,pp ] = corrcoef(aggAlphaPower,aggAvgSpeed);
    AggCorrelationsR(ll,2) = RR(1,2);
    AggCorrelationsP(ll,2) = pp(1,2);

    [RR,pp ] = corrcoef(aggAlphaPower,aggFreeze);
    AggCorrelationsR(ll,3)  = RR(1,2);
    AggCorrelationsP(ll,3) = pp(1,2);
    % fileName = ['outputTables\', 'alphaPowerFreezeSA_',num2str(windowSizes(ll)),'s','.csv'];
    % writematrix(["AlphaPower","freezeFraction"],fileName);
    % writematrix([aggCogload',aggFreeze'],fileName,'WriteMode','append');

    [RR,pp ] = corrcoef(aggAlphaPower,aggPartialFreeze);
    AggCorrelationsR(ll,4) = RR(1,2);
    AggCorrelationsP(ll,4) = pp(1,2);
    % fileName = ['outputTables\', 'alphaPowerPartialFreezeSA_',num2str(windowSizes(ll)),'s','.csv'];
    % writematrix(["AlphaPower","partialFreezeFraction"],fileName);
    % writematrix([aggCogload',aggPartialFreeze'],fileName,'WriteMode','append');
end
figure(1)
subplot(2,2,1)
scatter(aggAlphaPower, aggAvgSpeed,'.')
ylabel("Average Speed (m/s)")
xlabel("Alpha Power")

subplot(2,2,2)
scatter(aggAlphaPower,aggAvgTurnRate,'.')
ylabel("Average Turn rate (deg/s)")
xlabel("Alpha Power")

subplot(2,2,3)
scatter(aggAlphaPower,aggFreeze,'.')
ylabel("Freeze Fraction (hz)")
xlabel("Alpha Power")

subplot(2,2,4)
scatter(aggAlphaPower, aggPartialFreeze,'.' )
ylabel("Turn while still fraction (hz)")
xlabel("Alpha Power")
