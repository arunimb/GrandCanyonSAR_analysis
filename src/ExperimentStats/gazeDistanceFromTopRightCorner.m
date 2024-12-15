clear all
close all
clc

% This file plots exports distance of fixation points from top right corner
% to csv file

subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\'; % location of subject data folders
trialNum = [0,111,211,121,221,112,212,122,222]; % standard trial order
for ii = 1:numel(subject)
    % Import trial order of subject
    trialOrder = readmatrix([preFolder, cell2mat(subject(ii)),'\','trialOrder.txt']);
    for j = 1:numel(trialOrder)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialOrder(j)),'\','fixations.csv'];
        if (isfile(fileName))
            calibratedGaze = readmatrix(fileName);
            calibratedGaze = calibratedGaze(:,1:2);
            distanceCorner = zeros(size(calibratedGaze,1),1);
            % Calculate distance from top right corner (y=1080,x=2540 pixels)
            for k = 1:numel(distanceCorner)
                distanceCorner(k) = sqrt((calibratedGaze(k,1)-2560)^2 ...
                    + (calibratedGaze(k,2)-1080)^2);
            end
            % Write to distance from top right corner  to csv file            
            fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialOrder(j)),'\','distance_from_corner.csv'];
            writematrix("Gaze distance from top right corner (pixels)",fileName);
            writematrix(distanceCorner,fileName,'WriteMode','append');
        end

    end
end