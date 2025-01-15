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
aggSaccadeFreq = [];
aggTime2Finish = [];
for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        % Get filtered EEG filename for the trial section
        fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','saccadicFrequency_window',num2str(5),'.csv'];
        fileName2 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','time_to_finish.csv'];
        if isfile(fileName1)

            data = readmatrix(fileName1);
            saccadicFrequency = data;
            saccadicFrequency(saccadicFrequency<0)=0;
            saccadicFrequency(isnan(saccadicFrequency))=0;
            time2Finish = readmatrix(fileName2);
            
        end

        aggSaccadeFreq = [aggSaccadeFreq,mean(saccadicFrequency)];
        aggTime2Finish = [aggTime2Finish,time2Finish];
    end

end

outlierSaccadeFreq = mean(aggSaccadeFreq) + 3*std(aggSaccadeFreq);

indRej = abs(aggSaccadeFreq) <= outlierSaccadeFreq ;
aggSaccadeFreq = aggSaccadeFreq(indRej);
aggTime2Finish = aggTime2Finish(indRej);

[RR,pp ] = corrcoef(aggSaccadeFreq,aggTime2Finish);
RTime2Finish = RR(1,2);
pTime2Finish = pp(1,2);