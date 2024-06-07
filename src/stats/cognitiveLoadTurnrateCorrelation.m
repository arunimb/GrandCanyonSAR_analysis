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
cogWindow = 5; % Cognitive load calculation window
samplingRate = 256; % EEG sampling rate (Hz)
regularizationDt = 1/24;
aggCogLoad = [];
aggAvgTurnRate = [];
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
            for k = 1:cogWindow*samplingRate:eegTimeEnd*samplingRate-(cogWindow*samplingRate)+1
                [~,~,~,~,~,cogLoad(cogLoadIndex)] = cogload(baselineEEG(:,2:end)', eeg(k:k+cogWindow*samplingRate,2:end)', ...
                    1/samplingRate,eegChannelWeighting/sum(eegChannelWeighting),'alphaDiff','fft');
                cogLoadIndex = cogLoadIndex + 1;
            end
            % k1 = 1;
            % k2 = 1;
            % %trajFile(:,6)
            % turnRate = [];

            % c1 = 1;
            % t = 0;
            % while(t<=trajTimeEnd)
            %     for i=k1:numel(trajFile(:,6))
            %         if(abs(trajFile(i,1)-trajFile(k1,1))-cogWindow < 0.1)
            %             k2 = i;
            %             break;
            %         end
            %     end
            %     turnRate = [];
            %     c = 1;
            %     for i=k1:k2-1
            %         turnRate(c)= (trajFile(i+1,6)-trajFile(i,6))/abs(trajFile(i+1,1)-trajFile(i,1));
            %         c = c + 1;
            %     end
            %
            %     t = trajFile(k2,1);
            %     avgTurnRate(c1)=mean(turnRate);
            %     k1 = k2+1;
            %     c1 = c1+ 1;
            % end

            % Regularize timestamps, trajectory, heading
            regTimeStamps = trajTime(1):regularizationDt:trajTime(end); % resample timestamps to regularly spaced timestamps

            % Resample trajectory data, heading, to new timestamps
            tempTraj = zeros(numel(regTimeStamps),7);
            for kk = 2:7
                tempTraj(:,kk) = interp1(trajTime,trajFile(:,kk),regTimeStamps);
            end
            trajFile = tempTraj;
            avgTurnRate = [];
            c1 = 1;
            for k = 1:cogWindow*(1/regularizationDt):trajTimeEnd*(1/regularizationDt)-(cogWindow*(1/regularizationDt))+1
                c = 1;
                turnRate = [];
                for kk = k:k+cogWindow*(1/regularizationDt)-1
                    turnRate(c)= (trajFile(kk+1,6)-trajFile(kk,6))/regularizationDt;
                    c = c + 1;
                end
                avgTurnRate(c1)= mean(turnRate);
                c1 = c1 + 1;
            end
        end
        aggCogLoad = [aggCogLoad,cogLoad];
        aggAvgTurnRate = [aggAvgTurnRate,avgTurnRate];
    end
end


d1=dataset(aggCogLoad, aggAvgTurnRate);
% mdl=fitlm(d, 'cognitiveLoad~reactionTime+ageYrs') % use this only if the alpha range is set by age
mdl=fitlm(d1, 'aggAvgTurnRate~aggCogLoad')
figure(1); gcf; clf;
subplot(121)
plot(mdl);
xlabel('Average Turn Rate (deg/s)');
ylabel('Cognitive load (v)');