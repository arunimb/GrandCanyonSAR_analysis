clear all
close all
clc

% This file calculates cognitive load over an experiment and saves to a file

subject = cellstr(num2str(readmatrix('..\data\participantID1.csv')));
preFolder = '..\data\'; % location of subject data folders
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
trialNum = [111,211,121,221,112,212,122,222];
samplerate = 256; % Hz
baselineWindow = 5; % in second
EEGThreshold = 1000; % Max allowable EEG muV
threshold2 = 5/100; % fraction of data allowed to be over EEGThreshold value

% Bhattacharya, Arunim, and Sachit Butail. "Measurement and Analysis of Cognitive Load 
% Associated with Moving Object Classification in Underwater Environments." 
% International Journal of Human–Computer Interaction (2023): 1-11.
eegChannelWeighting = [ 0.0398,    0.370,    0.1741 ,   0.6393 ,  ...
    0   ,      0   ,      0   ,      0 ,        0  ,       0  , ...
    0.6393  ,  0.1741 ,0.3706,    0.0398]; 

cognitiveLoad = [];
for ii = 1:numel(subject)
    % Import trial order
    %trialOrder = readmatrix([preFolder, cell2mat(subject(ii)),'\','trialOrder.txt']);
    for j = 1:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','eegBaselineFiltered.csv'];
        if isfile(fileName)
            baselineEEG = readmatrix(fileName); % read trajectory file
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','eegFiltered.csv'];

        eeg = readmatrix(fileName); % read trajectory file
        frontalEEG = [eeg(:,2:5),eeg(:,12:15)];
        frontalEEG = frontalEEG(:);
        totOverthresh = find(frontalEEG>EEGThreshold);
        percentOverThreshold = numel(totOverthresh)/numel(frontalEEG);
        if percentOverThreshold<=threshold2
            % Calculate cogntive load using alphaDiff method over all the trial
            [~,~,~,~,~,cognitiveLoad] = cogload(baselineEEG(:,2:end)', eeg(:,2:end)', ...
                1/samplerate,eegChannelWeighting/sum(eegChannelWeighting),'alphaDiff','fft');
            fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','cogLoad_win=',num2str(baselineWindow),'s','.csv'];
            writematrix("uV^2/Hz",fileName);
            writematrix(cognitiveLoad,fileName,'WriteMode','append');
        end
        end
    end
end

