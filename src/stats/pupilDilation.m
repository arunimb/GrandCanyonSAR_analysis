clearvars
close all
clc

% This file plots Gaze scatter plot and marks limits of computer screen

subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv'))); % Get subject id list
preFolder = '..\..\data\';
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
preFolder = '..\..\data\'; % location of subject data folders
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [111,211,121,221,112,212,122,222];
sigma = 1;

for ii = 1:numel(subject)
    %h1 = figure(1);
    %clf;
    for j = 1:numel(trialNum)
        fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','rawGaze.csv'];
        if isfile(fileName1)
            disp(cell2mat(subject(ii)));
            data = readmatrix(fileName1);
%             pupilDiaLeft = filloutliers(data(:,22),"linear");  %mm
%             pupilDiaRight = filloutliers(data(:,21),"linear");  %mm
            
            pupilDiaLeft = fillmissing(data(:,22),'linear');  %mm
            pupilDiaRight = fillmissing(data(:,21),'linear');  %mm
            
            figure(1)
            clf;
            plot(pupilDiaLeft)
            hold on
            plot(pupilDiaRight)
            %avgPupilDia = nanmean(pupilDiaRight);
            fileName = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','avgPupilDilation.csv'];
            %writematrix("Pupil Dia (mm)",fileName);
            %writematrix(avgPupilDia,fileName,'WriteMode','append');

        end
    end
end