%% housekeeping
clearvars
close all
clc

% This file plots trajectory, swarm location, missing person location, by trial for every subject and saves them in

% Get subject id list
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\';  % location of subject data folders
trialName = {'Fam','NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'}; % Person, Terrain, Swarm cohesion
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


        subplot(3,3,j)
        plot3(xPos,yPos,zPos) % Plot trajectory of human controlled drone
        hold on
        scatter3 (xPos(1),yPos(1),zPos(1),"green","filled","o") % Plot Drone start position
        hold on
        scatter3 (xPos(end),yPos(end),zPos(end),"red","filled","o")% Plot Drone end position
        hold on
        scatter3 (swarmPosition(:,1),swarmPosition(:,3),swarmPosition(:,2),"k","filled","o")% Plot swarm drone locations
        hold on
        scatter3 (ethanPos(1),ethanPos(3),ethanPos(2),12,"r","+"); % Plot missing person position
        hold on
        xlabel("X location (m)");
        ylabel("Y location (m)");
        zlabel("Z location (m)");
        title(trialName{j});
        grid on
        hold off
        view(2)
        % Only Plot legend for the first plot
        if j==1
            legend("Trajectory","Start","End","Swarm","Missing Person");
        end
    end
    sgtitle(subject(ii))
    % save plots
    saveas(gcf,[preFolder, cell2mat(subject(ii)),'\','Trajectory.png']);
    saveas(gcf,[preFolder, cell2mat(subject(ii)),'\','Trajectory.fig']);
end