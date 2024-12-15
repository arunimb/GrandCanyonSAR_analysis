%% housekeeping
clearvars
%close all
clc

% This file plots filtered EEG and cognitive load

subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\';
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
cogWindow = 1:3; % Cognitive load calculation window
samplingRate = 256; % EEG sampling rate (Hz)
windowStartTime = 0;
EEGThreshold = 1000; % Max allowable EEG muV
threshold2 = 5/100; % fraction of data allowed to be over EEGThreshold value

baselineWindow = 5;
for mm = 1:numel(cogWindow)
    for ii = 1:numel(subject)
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

                %Calculate cognitive load
                cogLoad = [];
                cogLoadTime = [];
                cogLoadIndexer = 1;
                baselineEEG = readmatrix(fileName2);


                if ((windowStartTime*samplingRate + cogWindow(mm)*samplingRate <= size(eeg,1)))
                    baseEEG = baselineEEG(end-baselineWindow*samplingRate:end,2:end)';
                    taskEEG = eeg((windowStartTime*samplingRate)+1:(windowStartTime*samplingRate)+cogWindow(mm)*samplingRate,2:end)';
                    tempEEG = taskEEG(:);
                    testEEG = [eeg(:,2:5),eeg(:,12:15)];
                    testEEG = testEEG(:);
                    %frontalEEG = [eeg(:,2:5),eeg(:,12:15)];
                    %frontalEEG = frontalEEG(:);
                    totOverthresh = find(testEEG>EEGThreshold);
                    percentOverThreshold = numel(totOverthresh)/numel(testEEG);
                    if percentOverThreshold <= threshold2
                        [~,~,~,~,~,cogLoad] = cogload(baseEEG,taskEEG, ...
                            1/samplingRate,eegChannelWeighting/sum(eegChannelWeighting), ...
                            'alphaDiff','fft');
                        saveFolder = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\', ...
                            'cogload_First',num2str(cogWindow(mm)),'s','_from',num2str(windowStartTime),'s.csv'];
                        writematrix("uV^2/Hz",saveFolder);
                        writematrix(cogLoad,saveFolder,'WriteMode','append');
                    else
                        cogLoad = nan;
                        saveFolder = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\', ...
                            'cogload_First',num2str(cogWindow(mm)),'s','_from',num2str(windowStartTime),'s.csv'];
                        writematrix("uV^2/Hz",saveFolder);
                        writematrix(cogLoad,saveFolder,'WriteMode','append');
                    end
                else
                    cogLoad = nan;
                    saveFolder = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\', ...
                        'cogload_First',num2str(cogWindow(mm)),'s','_from',num2str(windowStartTime),'s.csv'];
                    writematrix("uV^2/Hz",saveFolder);
                    writematrix(cogLoad,saveFolder,'WriteMode','append');
                end

                %                 if(windowStartTime*samplingRate + cogWindow(mm)*samplingRate <= size(eeg,1))
                %                     [~,~,~,~,~,cogLoad] = cogload(baselineEEG(end-baselineWindow*samplingRate:end,2:end)', eeg((windowStartTime*samplingRate)+1:(windowStartTime*samplingRate)+cogWindow(mm)*samplingRate,2:end)', ...
                %                         1/samplingRate,eegChannelWeighting/sum(eegChannelWeighting),'alphaDiff','fft');
                %                     saveFolder = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','cogload_First',num2str(cogWindow(mm)),'s','_from',num2str(windowStartTime),'s.csv'];
                %                     writematrix("uV^2/Hz",saveFolder);
                %                     writematrix(cogLoad,saveFolder,'WriteMode','append');
                %                 end

                %             if(windowStartTime*samplingRate + cogWindow*samplingRate > size(eeg,1))
                %                 [~,~,~,~,~,cogLoad] = cogload(baselineEEG(end-baselineWindow*samplingRate:end,2:end)', eeg(:,2:end)', ...
                %                     1/samplingRate,eegChannelWeighting/sum(eegChannelWeighting),'alphaDiff','fft');
                %                 saveFolder = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','cogload_First',num2str(cogWindow),'s','_from',num2str(windowStartTime),'s.csv'];
                %                 writematrix("uV^2/Hz",saveFolder);
                %                 writematrix(cogLoad,saveFolder,'WriteMode','append');
                %             end
            end
        end
    end
end
