%% housekeeping
clearvars
%close all
clc

% This file calculates cognitive load over the first X seconds and saves to a file

subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\';
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
windowSize = 1:25; % Cognitive load calculation window
samplingRate = 256; % EEG sampling rate (Hz)
windowStartTime = 0;
baselineWindow = 4;
for mm = 1:numel(windowSize)
    for ii = 1:numel(subject)
        for j = 1:numel(trialNum)

            fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','rawGaze.csv'];
            if isfile(fileName1)
                disp(cell2mat(subject(ii)));
                data = readmatrix(fileName1);
                %             pupilDiaLeft = filloutliers(data(:,22),"linear");  %mm
                %             pupilDiaRight = filloutliers(data(:,21),"linear");  %mm

                pupilDiaLeft = fillmissing(data(:,22),'linear');  %mm
                pupilDiaRight = fillmissing(data(:,21),'linear');  %mm
                time = data(:,1);
                time = time - time(1);
                [val, requiredTimeIndex] = min(abs(time-windowSize(mm)));
                meanPupilDia = 0.5*(pupilDiaLeft + pupilDiaRight);
                meanPupilDiaWindow = mean(meanPupilDia(1:requiredTimeIndex));
                saveFolder = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','pupilDia_First',num2str(windowSize(mm)),'s','_from',num2str(windowStartTime),'s.csv'];
                writematrix("mm",saveFolder);
                writematrix(meanPupilDiaWindow,saveFolder,'WriteMode','append');                


            end
        end
    end
end