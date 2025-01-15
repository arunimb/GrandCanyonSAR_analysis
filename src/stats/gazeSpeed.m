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
for i = 1:numel(subject)
    trialOrder = readmatrix([preFolder, cell2mat(subject(i)),'\','trialOrder.txt']);
    for j = 1:numel(trialOrder)
        fileName1 = [preFolder, cell2mat(subject(i)),'\',num2str(trialOrder(j)),'\','rawGaze.csv'];
        fileName2 = [preFolder, cell2mat(subject(i)),'\',num2str(trialOrder(j)),'\','calibratedGaze.csv'];
        if (isfile(fileName2))
            rawGaze = readmatrix(fileName1);
            calibratedGaze = readmatrix(fileName2);
            gazeXPos = calibratedGaze(:,1);
            gazeYPos = calibratedGaze(:,2);
            time = rawGaze(:,1)-rawGaze(1,1);
            subjectGazeSpeed = [];
            gazeDelDist = [];
            for dNo = 1:numel(gazeXPos)-1
                % Calculate distance travelled every time step
                gazeDelDist(dNo) = ((gazeXPos(dNo) - gazeXPos(dNo+1))^2 + ...
                    (gazeYPos(dNo) - gazeYPos(dNo+1))^2)^0.5;

                % Calculate instantaneous speed
                 subjectGazeSpeed(dNo) = abs(gazeDelDist(dNo)/(time(dNo+1)-time(dNo)));

%                 if isinf(subjectGazeSpeed(dNo))
%                     pause
%                 end
% 
%                 if isnan(subjectGazeSpeed(dNo))
%                     pause
%                 end

            end
            subjectGazeSpeed=subjectGazeSpeed(~isinf(subjectGazeSpeed));  % remove undefined values from turn rate
            subjectGazeSpeed=subjectGazeSpeed(~isnan(subjectGazeSpeed));  % remove undefined values from turn rate
            avgGazeSpeed = mean(subjectGazeSpeed); % calc mean
            

            fileName = [preFolder, cell2mat(subject(i)),'\',num2str(trialNum(j)),'\','avgGazeSpeed.csv'];
            writematrix("px/s",fileName);
            writematrix(avgGazeSpeed,fileName,'WriteMode','append');

        end
    end

end