clearvars
close all
clc

% This script exports trajectory data for the first X seconds.

% Read subject id list
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\'; % location of subject data folders
addpath('..\..\');
trialNum = [111,211,121,221,112,212,122,222];
%trialUnclustered = [111,211,121,221];
%trialClustered = [112,212,122,222];
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
dFromCentreClustered = [];
aggX = [];
aggY = [];
figure(1);
c = 1;
for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        % Get Trajectory file name

        fileName = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','Trajectory*.csv']);
        % Get swarm position
        fileName = [fileName.folder,'\',fileName.name];
        trajFile = readmatrix(fileName); % Get Trajectory data
        swarmCentreX = trajFile(2,2);
        swarmCentreY = trajFile(2,4);
        swarmCentreZ = trajFile(2,3);
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


        subjectXPos = trajFile(:,2);
        hold on
        subjectYPos = trajFile(:,4);        
        h1 = plot(subjectXPos,subjectYPos,Color=[0.7,0.7,0.7],LineWidth=0.2);
        xlabel("X position (m)");
        ylabel("Y position (m)");
        h2 = viscircles([trajFile(2,2),trajFile(2,4)],0.36*1000,'Color',"green");
        viscircles([trajFile(2,2),trajFile(2,4)],0.72*1000,'Color',"green")
        viscircles([trajFile(2,2),trajFile(2,4)],1.08*1000,'Color',"green")
        viscircles([trajFile(2,2),trajFile(2,4)],1,'Color',"green")
        grid on
        
        c = c + 1;
    end
end
legend([h1,h2],"Trajectory","POA marker")
axis equal
saveas(gcf,"E:\GrandCanyonSAR_analysis\src\plots\trajWithPOA.png")
figure(2)
% ind1 = find(abs(aggX)<=5);
% ind2 = find(abs(aggY)<=5);
% ind = [ind1,ind2];
% aggX(ind)=[];
% aggY(ind)=[];
c = 1;
ind = [];
for iii = 1:numel(aggX)
    if((aggX(iii)^2+aggY(iii)^2)^0.5<=50)
        ind(c) = iii;
        c = c+1;
    end
end
aggX(ind)=[];
aggY(ind)=[];
h = histogram2(aggX,aggY,[300 300],'DisplayStyle','tile','FaceColor','flat');
xlabel("X position (m)");
ylabel("Y position (m)")
title("Unclustered")
axis equal
colorbar
saveas(gcf,"E:\GrandCanyonSAR_analysis\src\plots\unclusteredHistogram.png")