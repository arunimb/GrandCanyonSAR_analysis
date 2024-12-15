%% housekeeping
clearvars
close all
clc

% This file plots trajectory, swarm location, missing person location, by trial for every subject and saves them in

% Get subject id list
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\';  % location of subject data folders
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
preFolder = '..\data\'; % location of subject data folders
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [111,211,121,221,112,212,122,222];
figure
for ii = 1:numel(subject)
    clf;
    for j = 1:numel(trialNum)
        % Get Trajectory file name
        fileName = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','Trajectory*.csv']);
        % Get swarm position
        fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','calibratedGaze.csv'];
        trajFile = readmatrix(fileName); % Get Trajectory data
            timeStamps = trajFile(:,1); % 1st column of trajectory data is time stamps

            % Routine to identify paused simulation, f2 key marks the beginning
            % of the trial, also unpauses the simulation for the subject. F11
            % key marks the end of the trial, pauses the trial for the subject.
            % When the simulation is paused, the recorded timestamps do not
            % change, so the diff function lets us identify beginning and
            % ending of a trial.
            diffTimeStamps = diff(timeStamps(2:end));

            pause1 = 0; % start of trial index (guess)
            for k = 1:numel(diffTimeStamps)
                if (diffTimeStamps(k) ~= 0)
                    pause1 = k+1;
                    break; % Break when encountering a non zero diff value
                end
            end

            pause2 = 0; % end of trial index (guess)
            for k = pause1+1:numel(diffTimeStamps)
                if (diffTimeStamps(k) == 0)
                    pause2 = k; % Break when encountering a zero diff value
                    break;
                end
            end

            % Trim time to 600 seconds. subjects who do not search within 600
            % seconds are truncated.
            time2finish = timeStamps(pause2)-timeStamps(pause1); % guess time to finish


            % truncate the trajectory data
            trajFile = trajFile(pause1:pause2,:);
            trajFile2 = trajFile;
            timeStamps = trajFile(:,1)-trajFile(1,1);
    end
end