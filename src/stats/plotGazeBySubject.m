%% housekeeping
clearvars
%close all
clc

% This file plots Gaze scatter plot and marks limits of computer screen

subject = cellstr(num2str(readmatrix('..\data\participantID1.csv'))); % Get subject id list
preFolder = '..\data\';
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
preFolder = '..\data\'; % location of subject data folders
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [0,111,211,121,221,112,212,122,222];
sigma = 1;

for ii = 1:numel(subject)
    h1 = figure(1);
    clf;
    for j = 1:numel(trialNum)
        fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','calibratedGaze.csv'];
        if isfile(fileName1)
            disp(cell2mat(subject(ii)));
            gaze = readmatrix(fileName1);                        
            figure(1)
            subplot(3,3,j)
            scatter(gaze(:,1),gaze(:,2),2,'+')
            hold on
            plot([0,2560,2560,0,0],[0,0,1080,1080,0],LineWidth=2,Color=[1.0,0.7,0])
            %axis image

            pbaspect([2.37 1 1])
            xlabel("x position (pixel)")
            ylabel("y position (pixel)")
            title(num2str(trialNum(j)))
            sgtitle(cell2mat(subject(ii)))


           
        end

    end
%      saveas(h1,[preFolder, cell2mat(subject(ii)),'\','gazeScatter.fig']);
%      saveas(h1,[preFolder, cell2mat(subject(ii)),'\','gazeScatter.png']);
    %close all
end