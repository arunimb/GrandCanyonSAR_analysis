clearvars
close all
clc

% This script exports trajectory data for the first X seconds.

% Read subject id list
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\'; % location of subject data folders
addpath('..\..\');
%trialNum = [111,211,121,221,112,212,122,222];
trialUnclustered = [111,211,121,221];
trialClustered = [112,212,122,222];
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
dFromCentreClustered = [];
aggX = [];
aggY = [];
figure(1);
c = 1;
for ii = 1:numel(subject)
    for j = 1:numel(trialUnclustered)
        % Get Trajectory file name

        fileName = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialUnclustered(j)),'\','Trajectory*.csv']);
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


        subjectXPos = trajFile(:,2)-trajFile(2,2);
        subjectYPos = trajFile(:,4)-trajFile(2,4);

        aggX= [aggX,subjectXPos'];
        aggY= [aggY,subjectYPos'];
        % plot(subjectXPos,subjectYPos,Color=[0.7,0.7,0.7],LineWidth=0.2);
        xlabel("X position (m)");
        ylabel("Y position (m)")
        title("Unclustered")
        xlim([-1500 1500])
        ylim([-1500 1500])
        grid on
        hold on
        c = c + 1;
    end
end
% viscircles([0,0],0.36*1000,'Color',"yellow")
% viscircles([0,0],0.72*1000,'Color',"yellow")
% viscircles([0,0],1.08*1000,'Color',"yellow")
% axis equal
% saveas(gcf,"E:\GrandCanyonSAR_analysis\src\plots\unclusteredTrajectory.png")
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
hold on
viscircles([0,0],0.36*1000,'Color',"black")
viscircles([0,0],0.72*1000,'Color',"black")
viscircles([0,0],1.08*1000,'Color',"black")
axis equal
xlim([-1500 1500])
ylim([-1500 1500])
xlabel("X position (m)");
ylabel("Y position (m)")
title("Unclustered")
%axis equal
colormap sky
colorbar
clim([10 50])
% figure(10)
% subplot(121)
% xV = h.XBinEdges(1:end-1);
% yV = h.YBinEdges(1:end-1);
% [XV, YV] = meshgrid(xV,yV);
% plot(sqrt(XV(:).^2+YV(:).^2),h.Values(:))

saveas(gcf,"E:\GrandCanyonSAR_analysis\src\plots\unclusteredHistogram.png")

figure(3)
aggX= [];
aggY=  [];
c = 1;
for ii = 1:numel(subject)

    for j = 1:numel(trialClustered)
        % Get Trajectory file name

        fileName = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialClustered(j)),'\','Trajectory*.csv']);
        fileName2 = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialClustered(j)),'\','SwarmPosition*.csv']);
        % Get swarm position
        fileName = [fileName.folder,'\',fileName.name];
        fileName2 = [fileName2.folder,'\',fileName2.name];
        trajFile = readmatrix(fileName); % Get Trajectory data

        swarmPos = readmatrix(fileName2);
        swarmPosX = swarmPos(:,1);
        swarmPosY = swarmPos(:,3);
        swarmCentreX = mean(swarmPosX);
        swarmCentreY = mean(swarmPosY);
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


        subjectXPos = trajFile(:,2)-trajFile(2,2);
        subjectYPos = trajFile(:,4)-trajFile(2,4);
        aggX= [aggX,subjectXPos'];
        aggY= [aggY,subjectYPos'];
        % plot(subjectXPos,subjectYPos,Color=[0.7,0.7,0.7],LineWidth=0.2);

        xlabel("X position (m)");
        ylabel("Y position (m)")
        title("Clustered")
        xlim([-1500 1500])
        ylim([-1500 1500])
        grid on
        hold on
        c = c + 1;
    end
end
% viscircles([0,0],0.36*1000,'Color',"yellow")
% viscircles([0,0],0.72*1000,'Color',"yellow")
% viscircles([0,0],1.08*1000,'Color',"yellow")
% axis equal
% saveas(gcf,"E:\GrandCanyonSAR_analysis\src\plots\clusteredTrajectory.png")


figure(4)
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
h = histogram2(aggX,aggY,[300 300],'DisplayStyle','tile');
hold on
viscircles([0,0],0.36*1000,'Color',"black")
viscircles([0,0],0.72*1000,'Color',"black")
viscircles([0,0],1.08*1000,'Color',"black")
axis equal
xlim([-1500 1500])
ylim([-1500 1500])
xlabel("X position (m)");
ylabel("Y position (m)")
title("Clustered")
%axis equal
colorbar
colormap sky
clim([10 50])
% figure(5)
% subplot(122)
% xV = h.XBinEdges(1:end-1);
% yV = h.YBinEdges(1:end-1);
% [XV, YV] = meshgrid(xV,yV);
% plot(sqrt(XV(:).^2+YV(:).^2),h.Values(:))
% saveas(gcf,"E:\GrandCanyonSAR_analysis\src\plots\clusteredHistogram.png")