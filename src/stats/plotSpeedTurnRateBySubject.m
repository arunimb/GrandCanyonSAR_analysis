%% housekeeping
clearvars
close all
clc

% This file plots speed and turn rate by trial for every subject and saves them in
% data folder
subject = cellstr(num2str(readmatrix('..\data\participantID1.csv')));
preFolder = '..\data\';
% Trial names are in the order Missing Person Prior knowledge Y or N,
% Terrain knowledge Y or N, Swarm Cohesion L or H.
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
preFolder = '..\data\'; % location of subject data folders
trialNum = [0,111,211,121,221,112,212,122,222];
figure
for ii = 1:numel(subject)
    h1 = figure(1); %create empty figure
    h2 = figure(2); %create empty figure
    for j = 1:numel(trialNum)
        
        fileNameSpeed = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','speed*.csv']);        
        fileNameTrajectory = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','Trajectory*.csv']);       
        fileNameTurnRate = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','turnRate*.csv']); 
        
        % Read untruncated trajectory data exported by Unity
        trajFile = readmatrix([fileNameTrajectory.folder,'\',fileNameTrajectory.name]);
        % Read truncated speed values exported from timeToFinishSpeedTurnRateByTrial.m
        speedFile = readmatrix([fileNameSpeed.folder,'\',fileNameSpeed.name]);
        % Read truncated turn rate values exported from timeToFinishSpeedTurnRateByTrial.m
        turnRateFile = readmatrix([fileNameTurnRate.folder,'\',fileNameTurnRate.name]);
        
        % Routine to plot speed vs time
        figure(1)
        subplot(3,3,j)
        plot(speedFile)       
        xlabel("Time (s)");
        ylabel("Speed (m/s)");
        title(trialName{j});
        grid on
        sgtitle(subject(ii))

        % Routine to plot Turn rate vs time
        figure(2)
        subplot(3,3,j)
        plot(turnRateFile)       
        xlabel("Time (s)");
        ylabel("Turn rate (deg/s)");
        ylim([0,30])
        title(trialName{j});
        grid on
        sgtitle(subject(ii))
    end
    % Save plots
    saveas(h1,[preFolder, cell2mat(subject(ii)),'\','Speed.fig']);
    saveas(h2,[preFolder, cell2mat(subject(ii)),'\','TurnRate.fig']);
    saveas(h1,[preFolder, cell2mat(subject(ii)),'\','Speed.png']);
    saveas(h2,[preFolder, cell2mat(subject(ii)),'\','TurnRate.png']);
end