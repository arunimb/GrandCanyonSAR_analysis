clearvars
close all
clc

% Works on the raw gaze data and maps gaze from normalized coordinates to
% screen coordinates (pixels)

subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv'))); % Get subject id list
preFolder = '..\..\data\'; % location of subject data folders

cluster2Flag = 0;
meanAverageSampleRateAccumulator = [];
c = 1;
for ii = 1:numel(subject)
    % Import trial order
    trialOrder = readmatrix([preFolder, cell2mat(subject(ii)),'\','trialOrder.txt']);
    % Get the first trial after break
    trialAfterBreak = readmatrix([preFolder, cell2mat(subject(ii)),'\','trial_after_break.txt']); 
    cluster2Flag = 0;
    for j = 1:numel(trialOrder)
        % Get filename for raw gaze
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialOrder(j)),'\','rawGaze.csv'];

        % Check if break trial has been reached or not
        if (trialOrder(j) == trialAfterBreak)
            cluster2Flag = 1;
        end


        if (isfile(fileName))
            rawGaze = readmatrix(fileName); 
            gazeTime = rawGaze(:,1);
            gazeTime = gazeTime - gazeTime(1);
            calibGaze = zeros(size(rawGaze,1),2);

            meanAverageSampleRateAccumulator(c) = 1/mean(diff(gazeTime));
            c = c + 1;
            % Use cluster 1 for trials before break
            if (cluster2Flag == 0)
                fileName1 = [preFolder, cell2mat(subject(ii)),'\','cluster1','\','XCalib.mat'];
                fileName2 = [preFolder, cell2mat(subject(ii)),'\','cluster1','\','YCalib.mat'];
            end
            % Use cluster 2 for trials after break
            if (cluster2Flag == 1)
                fileName1 = [preFolder, cell2mat(subject(ii)),'\','cluster2','\','XCalib.mat'];
                fileName2 = [preFolder, cell2mat(subject(ii)),'\','cluster2','\','YCalib.mat'];
            end
            
            % Load calibrated coefficient values
            load(fileName1);
            load(fileName2);

            % map normalized gaze to pixel gaze
            for k = 1:size(rawGaze,1)
                calibGaze(k,1) = calcCalibratedX(XCalib,rawGaze(k,2),rawGaze(k,3));
                calibGaze(k,2) = calcCalibratedY(YCalib,rawGaze(k,2),rawGaze(k,3));
            end

            % Save mapped gaze
            fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialOrder(j)),'\','calibratedGaze.csv'];
            %writematrix(["Time (s)","x (pixels)", "y (pixels)"],fileName);
            %writematrix([gazeTime, calibGaze],fileName,'WriteMode','append');
        end

    end
end

function pos = calcCalibratedX(Calib,Xpos,Ypos)
% Function maps normalized x coordinates to x pixel location on screen
% For validation see powerpoint file in /doc/overlaidGazeImages.pptx
pos = Calib(1) + Calib(2)*Xpos + Calib(3)*Xpos^2 + Calib(4)*Xpos*Ypos;
pos = int16(pos);
end
function pos = calcCalibratedY(Calib,Xpos,Ypos)
% Function maps normalized y coordinates to y pixel location on screen
% For validation see powerpoint file in /doc/overlaidGazeImages.pptx
pos = Calib(1) + Calib(2)*Ypos + Calib(3)*Ypos^2 + Calib(4)*Ypos*Xpos;
pos = int16(pos);
end