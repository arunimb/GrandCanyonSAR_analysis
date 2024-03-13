clear all
close all
clc

trajPath = "D:\UWmonitoring\MissingPersonSearchSim\Assets\trajData\";
% Read subject id list
subject = cellstr(num2str(readmatrix(strcat(trajPath,'participantID1.csv'))));
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [111,211,121,221,112,212,122,222];

for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        fileName = strcat(trajPath,[cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','trajectory.csv']);
        ethanFile = strcat(trajPath,[cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','ethanPos.csv']);
        trajFile = readmatrix(fileName); % Get Trajectory data
        ethanPos = readmatrix(ethanFile);
        xPos = trajFile(:,2);
        yPos = trajFile(:,4);
        heading = trajFile(:,5);
        figure(1)
        clf;

        for k = 1:numel(xPos)
            scatter(xPos(k),yPos(k),100,'s','filled','MarkerFaceColor','red');
            hold on
            scatter(ethanPos(1),ethanPos(3),100,'s','filled','MarkerFaceColor','green');
            quiver(xPos(k),yPos(k),100*cosd(heading(k)),100*sind(heading(k)),"LineWidth",1.5);
            hold off
            xlim([xPos(1)-1200,xPos(1)+1200])
            ylim([yPos(1)-1200,yPos(1)+1200])
            drawnow;
            
        end

    end
end
