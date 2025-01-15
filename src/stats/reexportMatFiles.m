clearvars
close all
clc

% Script 5
% This script does the following things :-
% Truncates time series trials are greater than 600 seconds. It
% recalculates the averages if a trial needs truncating.


% %% Load dataset
addpath("E:\PreliminaryAnalysisGrandCanyon\data\aggregatedMatlabFiles");
load subjectData.mat
load subjectEEGdata.mat
load subjectGazedata.mat
load subjectTrajdata.mat
%
% %%
temp = subjectData.subject;
subjectData = temp;
clear temp

%%
timeLimit = 601;
%% Process time
subjectDataModified = subjectData;

for i = 1:numel(subjectDataModified)
    for j = 1:numel(subjectDataModified(i).trial)
        if (subjectDataModified(i).trial(j).duration > timeLimit)
            subjectDataModified(i).trial(j).duration = timeLimit;
        end
    end

end

%% Process EEG
subjectEEGDataModified = subjectEEGdata;
samplerate = 256;
eegChannelWeighting = [ 0.0398,    0.370,    0.1741 ,   0.6393 ,  ...
    0   ,      0   ,      0   ,      0 ,        0  ,       0  , ...
    0.6393  ,  0.1741 ,0.3706,    0.0398]; % only frontal channels
for i = 1:numel(subjectEEGDataModified)
    for j = 1:numel(subjectEEGDataModified(i).EEG)
        if ~isempty(subjectEEGDataModified(i).EEG(j).time)
            if (subjectEEGDataModified(i).EEG(j).time(end) > timeLimit)
                for k = 1:numel(subjectEEGDataModified(i).EEG(j).time)
                    if (subjectEEGDataModified(i).EEG(j).time(k) > timeLimit)
                        break
                    end
                end
                subjectEEGDataModified(i).EEG(j).time = subjectEEGDataModified(i).EEG(j).time(1:k);
                subjectEEGDataModified(i).EEG(j).rawEEG = subjectEEGDataModified(i).EEG(j).rawEEG(1:k,:);
                subjectEEGDataModified(i).EEG(j).filteredEEG = bandpass_filter_1ch_test(subjectEEGDataModified(i).EEG(j).rawEEG);
                [~,~,~,~,~,temp] = cogload(subjectEEGdata(i).EEG(j).baseline', subjectEEGdata(i).EEG(j).filteredEEG', ...
                    1/samplerate,eegChannelWeighting/sum(eegChannelWeighting),'alphaDiff','fft');
                subjectEEGdata(i).EEG(j).cognitiveLoad= temp;
            end
        end

    end
end

%% Process Gaze
subjectGazeDataModified = subjectGazedata;
for i = 1:numel(subjectGazeDataModified)
    for j = 1:numel(subjectGazeDataModified(i).gaze)
        if (numel(subjectGazeDataModified(i).gaze(j).rawgaze) < 6)
            subjectGazeDataModified(i).gaze(j).rawgaze = [];
            subjectGazeDataModified(i).gaze(j).calibratedgaze = [];
            subjectGazeDataModified(i).gaze(j).avgDistanceCorner = [];
        end
    end
end

%% Process traj data
subjectTrajDataModified = subjectTrajdata;
for i = 1:numel(subjectTrajDataModified)
    for j = 1:numel(subjectTrajDataModified(i).trial)
        tempDiff = diff(subjectTrajDataModified(i).trial(j).time);
        for k1 = 5:numel(tempDiff)
            if(tempDiff(k1) > 0)
                break;
            end
        end
        for k2 = k1+1:numel(tempDiff)
            if(tempDiff(k2) == 0)
                break;
            end
        end
        if (subjectTrajDataModified(i).trial(j).time(k2)-subjectTrajDataModified(i).trial(j).time(k1)> timeLimit)
            for k2 = k1+1:numel(tempDiff)
                if(subjectTrajDataModified(i).trial(j).time(k2)-subjectTrajDataModified(i).trial(j).time(k1) >=  timeLimit)
                    break;
                end
            end
        end


        subjectTrajDataModified(i).trial(j).durationModified =   subjectTrajDataModified(i).trial(j).time(k2)-subjectTrajDataModified(i).trial(j).time(k1);
        subjectTrajDataModified(i).trial(j).time =  subjectTrajDataModified(i).trial(j).time(k1:k2);
        subjectTrajDataModified(i).trial(j).xPos =  subjectTrajDataModified(i).trial(j).xPos(k1:k2);
        subjectTrajDataModified(i).trial(j).yPos =  subjectTrajDataModified(i).trial(j).yPos(k1:k2);
        subjectTrajDataModified(i).trial(j).zPos =  subjectTrajDataModified(i).trial(j).zPos(k1:k2);
        subjectTrajDataModified(i).trial(j).heading =  subjectTrajDataModified(i).trial(j).heading(k1:k2);

        subjectXPos = subjectTrajDataModified(i).trial(j).xPos;
        subjectYPos = subjectTrajDataModified(i).trial(j).yPos;
        subjectZPos = subjectTrajDataModified(i).trial(j).zPos;
        subjectHeading = subjectTrajDataModified(i).trial(j).heading;
        ttime = subjectTrajDataModified(i).trial(j).time;

        subjectDelDistance = [];
        subjectSpeed = [];
        subjectTurnRate = [];
        for dNo = 1:numel(subjectXPos)-1
            subjectDelDistance(dNo) = ((subjectXPos(dNo) - subjectXPos(dNo+1))^2 + (subjectYPos(dNo) - subjectYPos(dNo+1))^2 + (subjectZPos(dNo) - subjectZPos(dNo+1))^2)^0.5;
            subjectSpeed(dNo) = subjectDelDistance(dNo)/(ttime(dNo+1)-ttime(dNo));
            subjectTurnRate(dNo) = abs(subjectHeading(dNo+1)-subjectHeading(dNo))/(ttime(dNo+1)-ttime(dNo));
        end
        subjectTrajDataModified(i).trial(j).avgSpeed = mean(subjectSpeed);
        subjectTrajDataModified(i).trial(j).avgTurnRate = mean(subjectTurnRate);



    end
end
%% Save the new datasets
save('..\data\aggregatedMatlabFiles\subjectDataModified','subjectDataModified','-v7.3');
save('..\data\aggregatedMatlabFiles\subjectEEGDataModified','subjectEEGDataModified','-v7.3');
save('..\data\aggregatedMatlabFiles\subjectGazeDataModified','subjectGazeDataModified','-v7.3');
save('..\data\aggregatedMatlabFiles\subjectTrajDataModified','subjectTrajDataModified','-v7.3');





