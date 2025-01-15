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
            % Save mapped gaze
            fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialOrder(j)),'\','uncalibratedGaze.csv'];
            writematrix(["Time (s)","x (pixels)", "y (pixels)"],fileName);
            writematrix([gazeTime, rawGaze(:,2:3)],fileName,'WriteMode','append');
        end

    end
end
