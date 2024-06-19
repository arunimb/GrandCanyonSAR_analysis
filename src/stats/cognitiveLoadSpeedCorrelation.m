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
cogWindow = [5,10, 15, 20]; % Cognitive load calculation window
samplingRate = 256; % EEG sampling rate (Hz)
regularizationDt = 1/24;
RAvgSpeed = [];
pAvgSpeed = [];
RAvgTurnrate = [];
pAvgTurnrate = [];
parfor ll = 1:numel(cogWindow)
    aggCogLoad = [];
    aggAvgTurnRate = [];
    aggAvgSpeed = [];
    aggTotalDistance = [];
    aggTotalAngle =  [];
    for ii = 1:numel(subject)
        for j = 1:numel(trialNum)
            % Get filtered EEG filename for the trial section
            fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','eegFiltered.csv'];
            % Get baseline filtered EEG filename for the trial section
            fileName2 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','eegBaselineFiltered.csv'];
            if isfile(fileName1)
                disp(cell2mat(subject(ii)));
                eeg = readmatrix(fileName1);

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

                eegTime = eeg(:,1);
                eegTime = eegTime-eegTime(1); % set start time to 0
                eegTimeEnd = floor(eegTime(end));
                if (eegTimeEnd < trajTimeEnd)
                    trajTimeEnd = eegTimeEnd;
                end
                if (eegTimeEnd > trajTimeEnd)
                    eegTimeEnd = trajTimeEnd;
                end

                % Frontal EEG cannels
                eegChannels = ["AF3","F7","F3","FC5","FC6","F4","F8","AF4"];
                % Extract frontal EEG samples
                frontalEEG = [eeg(:,2:5),eeg(:,12:15)];

                cogLoad = [];
                cogLoadTime = [];
                cogLoadIndexer = 1;
                baselineEEG = readmatrix(fileName2);

                cogLoadIndex = 1;
                cogLoad=[];
                for k = 1:cogWindow(ll)*samplingRate:eegTimeEnd*samplingRate-(cogWindow(ll)*samplingRate)+1
                    [~,~,~,~,~,cogLoad(cogLoadIndex)] = cogload(baselineEEG(:,2:end)', eeg(k:k+cogWindow(ll)*samplingRate,2:end)', ...
                        1/samplingRate,eegChannelWeighting/sum(eegChannelWeighting),'alphaDiff','fft');
                    cogLoadIndex = cogLoadIndex + 1;
                end
                
                % Regularize timestamps, trajectory, heading
                regTimeStamps = trajTime(1):regularizationDt:trajTime(end); % resample timestamps to regularly spaced timestamps

                % Resample trajectory data, heading, to new timestamps
                tempTraj = zeros(numel(regTimeStamps),7);
                for kk = 2:7
                    tempTraj(:,kk) = interp1(trajTime,trajFile(:,kk),regTimeStamps);
                end
                trajFile = tempTraj;
                avgTurnRate = [];
                avgSpeed = [];
                totalDistanceMovedSegment = [];
                totalAngleMovedSegment = [];

                c1 = 1;
                subjectXPos = trajFile(:,2);subjectYPos = trajFile(:,4);subjectZPos = trajFile(:,3);
                for k = 1:cogWindow(ll)*(1/regularizationDt):trajTimeEnd*(1/regularizationDt)-(cogWindow(ll)*(1/regularizationDt))+1
                    c = 1;
                    turnRate = [];
                    subjectSpeed = [];
                    totalDistanceMoved = 0;
                    totalAngleMoved= 0;
                    for kk = k:k+cogWindow(ll)*(1/regularizationDt)-1
                        turnRate(c)= (trajFile(kk+1,6)-trajFile(kk,6))/regularizationDt;
                        subjectDelDistance = ((subjectXPos(kk) - subjectXPos(kk+1))^2 + ...
                            (subjectYPos(kk) - subjectYPos(kk+1))^2 + (subjectZPos(kk) - subjectZPos(kk+1))^2)^0.5;
                        subjectSpeed(c) = abs(subjectDelDistance)/regularizationDt;
                        totalDistanceMoved = totalDistanceMoved + subjectDelDistance;
                        totalAngleMoved = totalAngleMoved + abs((trajFile(kk+1,6)-trajFile(kk,6)));
                        c = c + 1;
                    end
                    avgTurnRate(c1)= mean(turnRate);
                    avgSpeed(c1)= mean(subjectSpeed);
                    totalDistanceMovedSegment(c1) = totalDistanceMoved;
                    totalAngleMovedSegment(c1) = totalAngleMoved;
                    c1 = c1 + 1;
                end

            end
            aggCogLoad = [aggCogLoad,cogLoad(1:end-1)];
            aggAvgTurnRate = [aggAvgTurnRate,avgTurnRate];
            aggAvgSpeed = [aggAvgSpeed,avgSpeed];

            aggTotalDistance = [aggTotalDistance,totalDistanceMovedSegment];
            aggTotalAngle = [aggTotalAngle,totalAngleMovedSegment];
        end
    end

    stdCogLoad = std(aggCogLoad);
    meanCogLoad = mean(aggCogLoad);
    indRej = abs(aggCogLoad) < 4 ;
    aggCogLoad = aggCogLoad(indRej);
    aggAvgTurnRate = aggAvgTurnRate(indRej);
    aggAvgSpeed = aggAvgSpeed(indRej);
    aggTotalDistance = aggTotalDistance(indRej);
    aggTotalAngle = aggTotalAngle(indRej);



    [RR,pp ] = corrcoef(aggCogLoad,aggTotalDistance);
    RAvgSpeed(ll) = RR(1,2);
    pAvgSpeed(ll) = pp(1,2);
    [RR,pp ] = corrcoef(aggCogLoad,aggTotalAngle);
    RAvgTurnrate(ll)  = RR(1,2);
    pAvgTurnrate(ll) = pp(1,2);
end
figure(1)
subplot(221)
plot(cogWindow,RAvgSpeed);
xlabel("Window size")
ylabel("Coefficient (avg speed)")
grid on

subplot(222)
plot(cogWindow,RAvgTurnrate);
xlabel("Window size")
ylabel("Coefficient (avg turn rate)")
grid on

subplot(223)
plot(cogWindow,pAvgSpeed);
xlabel("Window size")
ylabel("pVal (avg speed)")
grid on

subplot(224)
plot(cogWindow,pAvgTurnrate);
xlabel("Window size")
ylabel("pVal (avg turn rate)")
grid on



% zscore them
%aggCogLoad=(aggCogLoad-mean(aggCogLoad))/std(aggCogLoad);
%aggAvgTurnRate=(aggAvgTurnRate-mean(aggAvgTurnRate))/std(aggAvgTurnRate);
%aggAvgSpeed=(aggAvgSpeed-mean(aggAvgSpeed))/std(aggAvgSpeed);

%indRej = abs(aggCogLoad)< meanCogLoad + 3*stdCogLoad;

% indRej = [];
% c = 1;
% for mm=1:numel(aggCogLoad)
%     if(abs(aggCogLoad(mm))> meanCogLoad + 3*stdCogLoad)
%         indRej(c)= mm;
%         c = c + 1;
%     end
% end
% aggCogLoad(indRej) = [];
% aggAvgTurnRate(indRej) = [];
% aggAvgSpeed(indRej) = [];



% figure(1)
% subplot(1,2,1)
% scatter(aggCogLoad, aggAvgSpeed);
% xlabel("Cognitive Load")
% ylabel("Average Speed")
% grid on
% subplot(1,2,2)
% scatter(aggCogLoad, aggAvgTurnRate);
% xlabel("Cognitive Load")
% ylabel("Average Turnrate")
% grid on



% figure(2)
% d2=dataset(aggCogLoad, aggAvgSpeed);
% % mdl=fitlm(d, 'cognitiveLoad~reactionTime+ageYrs') % use this only if the alpha range is set by age
% mdl=fitlm(d2, 'aggAvgSpeed~aggCogLoad')
% subplot(121)
% plot(mdl);
% xlabel('Average Speed (m/s)');
% ylabel('Cognitive load (v)');
%
% d1=dataset(aggCogLoad, aggAvgTurnRate);
% % mdl=fitlm(d, 'cognitiveLoad~reactionTime+ageYrs') % use this only if the alpha range is set by age
% mdl=fitlm(d1, 'aggAvgTurnRate~aggCogLoad');
% subplot(121)
% plot(mdl);
% xlabel('Average Turn Rate (deg/s)');
% ylabel('Cognitive load (v)');