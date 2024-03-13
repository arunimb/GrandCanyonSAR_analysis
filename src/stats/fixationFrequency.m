clear all
close all
clc
% Plots gaze fixation and saccades and also exports them to csv files. Also
% calculates percent of gaze saccades and fixation
% Fixation and saccades are calculated using Velocity thresholding method
% as described in:
% Salvucci, Dario D., and Joseph H. Goldberg. "Identifying fixations and saccades
% in eye-tracking protocols." Proceedings of the 2000 symposium on Eye tracking
% research & applications. 2000.

distanceFromScreen = 24.5*2.54; %mm
screenWidth = 795; %mm
subject = cellstr(num2str(readmatrix('..\data\participantID1.csv')));  % Get subject id list
preFolder = '..\data\';
trialName = {'Fam','NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'}; % Person, Terrain, Swarm cohesion
preFolder = '..\data\'; % location of subject data folders

% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [0,111,211,121,221,112,212,122,222];

%% gaze LSL data format
% confidence, norm_pos_x, norm_pos_y, gaze_point_3d_x, gaze_point_3d_y, gaze_point_3d_z,
% eye_center0_3d_x, eye_center0_3d_y, eye_center0_3d_z, eye_center1_3d_x, eye_center1_3d_y,
% eye_center1_3d_z, gaze_normal0_x, gaze_normal0_y, gaze_normal0_z, gaze_normal1_x,
% gaze_normal1_y, gaze_normal1_z, diameter0_2d, diameter1_2d, diameter0_3d, diameter1_3d

% hold Gaze
sigma1 = 100;
sigma2 = 100;
mu1 = 2560/2;
mu2 = 1080/2;
for i = 1:numel(subject)
    trialOrder = readmatrix([preFolder, cell2mat(subject(i)),'\','trialOrder.txt']);
    for j = 1:numel(trialOrder)
        fileName1 = [preFolder, cell2mat(subject(i)),'\',num2str(trialOrder(j)),'\','rawGaze.csv'];
        fileName2 = [preFolder, cell2mat(subject(i)),'\',num2str(trialOrder(j)),'\','calibratedGaze.csv'];
        if (isfile(fileName1))
            rawGaze = readmatrix(fileName1);
            calibratedGaze = readmatrix(fileName2);
            calibratedGaze = calibratedGaze(:,2:3);
            time = rawGaze(:,1)-rawGaze(1,1);
            % mark Gaze point either saccade or fixation or neither.
            gazeEventIdentifier = saccadesOrFixation3D(double(calibratedGaze)*screenWidth,time, distanceFromScreen);
            gazeEventIdentifier = gazeEventIdentifier';
            [fixationTimeRatio,totalFixationTime] = findFixationTime(gazeEventIdentifier,time(1:end-1));
            fileName = [preFolder, cell2mat(subject(i)),'\',num2str(trialOrder(j)),'\','fixationTimeRatio.csv'];          
            writematrix(fixationTimeRatio,fileName);
            fileName = [preFolder, cell2mat(subject(i)),'\',num2str(trialOrder(j)),'\','totalFixationTime.csv'];          
            writematrix(totalFixationTime,fileName);
        end
    end
end

function [timeRatio,totalFixationTime] = findFixationTime(gazeEventIdentifier,time)
    fixationTime = [];
    startIndex = [];
    endIndex = [];
    k = 1;
    m = 1;
    while (m<=size(gazeEventIdentifier,1)-1)
            c = 0;
        for j = m:size(gazeEventIdentifier,1)
            if (gazeEventIdentifier(j) == 0)
                c = c + 1;
            end
            if (gazeEventIdentifier(j) ~= 0)
                break;
            end
        end
        if c>0
            startIndex(k) = m;
            endIndex(k) = m+c-1;
            fixationTime(k) = time(m+c-1) - time(m);
            m = m+c;
            k = k + 1;
        end
        m = m + 1;
    end
    
    totalFixationTime = sum(fixationTime);
    timeRatio = totalFixationTime/time(end);
    
end





