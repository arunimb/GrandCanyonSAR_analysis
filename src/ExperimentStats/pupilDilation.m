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
        fileName2 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','baselineRawGaze.csv'];
        if isfile(fileName1) && isfile(fileName2)
            disp(cell2mat(subject(ii)));
            data1 = readmatrix(fileName1); %Raw
            data2 = readmatrix(fileName2); %baseline
           
            %             pupilDiaLeft = filloutliers(data(:,22),"linear");  %mm
            %             pupilDiaRight = filloutliers(data(:,21),"linear");  %mm

            pupilDiaLeft1 = fillmissing(data1(:,22),'linear');  %mm
            pupilDiaRight1 = fillmissing(data1(:,21),'linear');  %mm
            pupilDia1 = (pupilDiaLeft1+pupilDiaRight1)*0.5;
            

            pupilDiaLeft2 = fillmissing(data2(:,21),'linear');  %mm
            pupilDiaRight2 = fillmissing(data2(:,22),'linear');  %mm
            pupilDia2 = (pupilDiaLeft2+pupilDiaRight2)*0.5;
            pupilDia2 = pupilDia1(pupilDia1<=9);
            
            idx = find(pupilDia1>9);
            if (~isempty(idx))
                pupilDia1(idx) = nan;
                pupilDia1 = fillmissing(pupilDia1,'linear');  %mm
            end

            timeStamps = data1(:,1);
            timeStamps = timeStamps-timeStamps(1);
            % % figure(1)
            % % clf;
            % % plot(pupilDiaLeft)
            % % hold on
            % % plot(pupilDiaRight)
            
            avgPupilBaseline = nanmean(pupilDia2);
            pupilDil = pupilDia1-avgPupilBaseline;

            fileName = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','pupilDilation.csv'];
            %writematrix('Time(s), Pupil Dia (mm)',fileName);
            %writematrix([timeStamps,pupilDil],fileName,'WriteMode','append');

        end
    end
end