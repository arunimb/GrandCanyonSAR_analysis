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

%distanceFromScreen = 24.5*2.54; %mm probably wrong
distanceFromScreen = 488.95; %mm
screenWidth = 798; %mm
screenHeight = 338;
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));  % Get subject id list
trialName = {'NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'}; % Person, Terrain, Swarm cohesion
preFolder = '..\..\data\'; % location of subject data folders

% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [111,211,121,221,112,212,122,222];

%% gaze LSL data format
% confidence, norm_pos_x, norm_pos_y, gaze_point_3d_x, gaze_point_3d_y, gaze_point_3d_z,
% eye_center0_3d_x, eye_center0_3d_y, eye_center0_3d_z, eye_center1_3d_x, eye_center1_3d_y,
% eye_center1_3d_z, gaze_normal0_x, gaze_normal0_y, gaze_normal0_z, gaze_normal1_x,
% gaze_normal1_y, gaze_normal1_z, diameter0_2d, diameter1_2d, diameter0_3d, diameter1_3d

% thresholds
timeThreshold = 200/1000; % sec 100 - 300
dispersionThreshold = 1; % degree 0.5 -1

%distance per pixel
xDpixel = screenWidth/2560;
yDpixel = screenHeight/1080;

for ii = 1:numel(subject)

    %     tiledlayout(3,3,'TileSpacing','Compact','Padding','Compact')
    figure(1);
    clf;
    for j = 1:numel(trialNum)

        fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','calibratedGaze.csv'];
        if (isfile(fileName1))
            calibratedGaze = readmatrix(fileName1);
            gazeTime = calibratedGaze(:,1);
            calibratedGaze = calibratedGaze(:,2:3);
            euclideanDispersionThreshold = distanceFromScreen * dispersionThreshold * pi/180;
            diffTime = diff(gazeTime);
            meanSampleRate = mean(diffTime);
            windowsSizeInit = ceil(timeThreshold/meanSampleRate);
            fixations = [];
            saccades = [];
            point2pointDistance = []; %mm
            for k = 1:size(calibratedGaze,1)
                %             xDistance = (calibratedGaze(k,1)-calibratedGaze(k-1,1))*xDpixel;
                %             yDistance = (calibratedGaze(k,2)-calibratedGaze(k-1,2))*yDpixel;
                %             point2pointDistance(k) =  (xDistance^2+yDistance^2)^0.5;
                point2pointDistance(k,:) =  [calibratedGaze(k,1)*xDpixel, calibratedGaze(k,2)*yDpixel];
            end
            c = 1;
            fixFlag = 0;
            k = 1;
            windowsSize = windowsSizeInit;
            while k+windowsSize-1 <= size(calibratedGaze,1)
                window = point2pointDistance(k:k+windowsSize-1,:);
                D = max(window(:,1))-min(window(:,1)) + max(window(:,2))-min(window(:,2));
                fixFlag = 0;
                while D <= euclideanDispersionThreshold && k+windowsSize <= size(calibratedGaze,1)
                    fixFlag = 1;
                    windowsSize = windowsSize + 1;
                    window = point2pointDistance(k:k+windowsSize-1,:);
                    D = max(window(:,1))-min(window(:,1)) + max(window(:,2))-min(window(:,2));
                end
                if (fixFlag == 1)
                    fixations(c,3) = mean(calibratedGaze(k:k+windowsSize-2,1));
                    fixations(c,4) = mean(calibratedGaze(k:k+windowsSize-2,2));
                    fixations(c,1) = gazeTime(k); % start of fixation time
                    fixations(c,2) = sum(diff(gazeTime(k:k+windowsSize-2))); % total time fixating
                    c = c + 1;
                    k = k+windowsSize-2;
                end
                if fixFlag == 0
                    saccades(c,1) = calibratedGaze(k,1);
                    saccades(c,2) = calibratedGaze(k,2);
                    k = k + 1;
                end

                windowsSize = windowsSizeInit;
            end
            %subplot(3,3,j)
            saccades(saccades(:,1)== 0) = [];
            %plot(calibratedGaze(:,1),calibratedGaze(:,2),'-.');
            scatter(fixations(:,3),fixations(:,4),20,'red');
            hold on
            plot(saccades(:,1),saccades(:,2),'blue');
            plot([0, 2560, 2560, 0, 0],[0, 0, 1080, 1080, 0],LineWidth=2);
            plot([2278, 2467, 2467, 2278, 2278],[291, 291, 435, 435, 291],LineWidth=2);
            plot([1919, 2560, 2560, 1919, 1919],[809, 809, 1080, 1080, 809],LineWidth=2);
            hold off
            %fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','fixations.csv'];
            %writematrix(["Start Time (sec)","Fixation Time (sec)","xPos (pixels)","yPos (pixels)"],fileName);
            %writematrix(fixations,fileName,'WriteMode','append');
        end

    end
end