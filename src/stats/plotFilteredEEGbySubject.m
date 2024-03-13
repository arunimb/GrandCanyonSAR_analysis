%% housekeeping
clearvars
close all
clc

% This file plots filtered EEG and cognitive load

subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
trialName = {'Fam','NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'};  % Person, Terrain, Swarm cohesion
preFolder = '..\..\data\'; % location of subject data folders
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [0,111,211,121,221,112,212,122,222];
% Bhattacharya, Arunim, and Sachit Butail. "Measurement and Analysis of Cognitive Load
% Associated with Moving Object Classification in Underwater Environments."
% International Journal of Human–Computer Interaction (2023): 1-11.
eegChannelWeighting = [ 0.0398,    0.370,    0.1741 ,   0.6393 ,  ...
    0   ,      0   ,      0   ,      0 ,        0  ,       0  , ...
    0.6393  ,  0.1741 ,0.3706,    0.0398];
cogWindow = 5; % Cognitive load calculation window
samplingRate = 256; % EEG sampling rate (Hz)

for ii = 1:numel(subject)
    h1 = figure(1);
    h2 = figure(2);

    for j = 1:numel(trialNum)
        % Get filtered EEG filename for the trial section
        fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','eegFiltered.csv'];
        % Get baseline filtered EEG filename for the trial section
        fileName2 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','eegBaselineFiltered.csv'];
        if isfile(fileName1)
            disp(cell2mat(subject(ii)));
            eeg = readmatrix(fileName1);
            time = eeg(:,1);
            time = time-time(1); % set start time to 0
            % Frontal EEG cannels
            eegChannels = ["AF3","F7","F3","FC5","FC6","F4","F8","AF4"];
            % Extract frontal EEG samples
            frontalEEG = [eeg(:,2:5),eeg(:,12:15)];

            % plotting filtered EEG
            separation = 0; % variable to separate channel plots

            figure(1)
            subplot(3,3,j)
            for k = 1:size(frontalEEG,2)
                plot(time,separation + frontalEEG(:,k))
                separation = separation + 200; % Increase Channel separation
                hold on;
            end
            hold off
            xlabel("Time (s)")
            ylabel("EEG (uV)")
            title(num2str(trialNum(j)))
            % Only put legend on the 1st plot
            if(j==1)
                legend(eegChannels);
            end
            sgtitle(cell2mat(subject(ii)))

            % plotting windowed cognitive Load
            figure(2)
            subplot(3,3,j)

            %Calculate cognitive load
            cogLoad = [];
            cogLoadTime = [];
            cogLoadIndexer = 1;
            baselineEEG = readmatrix(fileName2);


            for k = 1:cogWindow*samplingRate:size(frontalEEG,1)-(cogWindow*samplingRate)

                [~,~,~,~,~,cogLoad(cogLoadIndexer)] = cogload(baselineEEG(:,2:end)', eeg(k:k+cogWindow*samplingRate,2:end)', ...
                    1/samplingRate,eegChannelWeighting/sum(eegChannelWeighting),'alphaDiff','fft');
                cogLoadTime(cogLoadIndexer) = time(k);
                cogLoadIndexer = cogLoadIndexer + 1;
                % Print calculation progess
                disp(k/(size(frontalEEG,1)-(cogWindow*samplingRate)));

            end
            clc
            figure(2)
            plot(cogLoadTime,cogLoad)
            title(num2str(trialNum(j)))
            xlabel("Time (s)")
            ylabel("Cognitive Load (uV^2/Hz)")
            sgtitle([cell2mat(subject(ii)),', Window = ',num2str(cogWindow),'s'])
        end
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','eegTime.csv'];
        writematrix("s",fileName);
        writematrix(time,fileName,'WriteMode','append');

    end
    % Save plots
    saveas(h1,[preFolder, cell2mat(subject(ii)),'\','EEG.fig']);
    saveas(h2,[preFolder, cell2mat(subject(ii)),'\','CognitiveLoad.fig']);
    saveas(h1,[preFolder, cell2mat(subject(ii)),'\','EEG.png']);
    saveas(h2,[preFolder, cell2mat(subject(ii)),'\','CognitiveLoad.png']);
end