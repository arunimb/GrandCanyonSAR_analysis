clearvars
close all
clc

addpath("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\")
subject = cellstr(num2str(readmatrix('..\..\..\data\participantID1.csv')));
preFolder = '..\..\..\data\';
trialNames = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
trialNames = {'NN','YN','NY','YY'};  % Person, Terrain, Swarm cohesion
trialNum = [111,211,121,221,112,212,122,222];
trialNumPairs = [111,112;211,212;121,122;221,222];
trialNumIndices = [1,5;2,6;3,7;4,8];
auvNumber = 15; %[5 10 15]
numRuns = [1];
humanTimeToLand = 15;
simulationMode = {'closedLoopType1','closedLoopType2','closedLoopType3','closedLoopType4','randomSearch','spiralSearch'};

targetFoundBySwarm = zeros(numel(trialNum),20);
targetFoundOrNot = zeros(numel(trialNum),20);
swarmTimeGained = zeros(numel(trialNum),20);
netSearchTime = zeros(numel(trialNum),20);
swarmTimeFound = zeros(numel(trialNum),20);
preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(1)),"\");
counter = 1;

participant = 90112;
numSwarm = 15;
trial = 112;
numRun = "run1";
offsetAx = 0.15;
%% closedLoop1
preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(1)),"\");
preFolderSim1 = strcat(preFolderSim1,num2str(participant),"\",num2str(trial),"\",num2str(numSwarm),"\",numRun,"\");
preFolderSim2 = strcat("H:\testingGround\trajData\",num2str(participant),"\");
preFolderSim2 = strcat(preFolderSim2,num2str(trial),"\");
operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"))/1e4;

swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"))/1e4;
missingPersonPos = readmatrix(strcat(preFolderSim2,"ethanPos.csv"))/1e4;
subplot(2,3,1)
viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.36/10,'Color',[0.8 0.8 0.8])
viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.72/10,'Color',[0.8 0.8 0.8])
viscircles([operatorTraj(1,1),operatorTraj(1,3)],1.08/10,'Color',[0.8 0.8 0.8])
hold on
plot(operatorTraj(:,1),operatorTraj(:,3),'r')
grid on

scatter(missingPersonPos(1),missingPersonPos(3),100,'blue','filled')
for i = 1:3:floor(size(swarmTrajectory,2))
    plot(swarmTrajectory(:,i),swarmTrajectory(:,i+2),'g');
    %pbaspect([1 1 1])
end
xlim([operatorTraj(1,1)-offsetAx,operatorTraj(1,1)+offsetAx])
ylim([operatorTraj(1,3)-offsetAx,operatorTraj(1,3)+offsetAx])
axis image
%% closedLoop2
preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(2)),"\");
preFolderSim1 = strcat(preFolderSim1,num2str(participant),"\",num2str(trial),"\",num2str(numSwarm),"\",numRun,"\");
preFolderSim2 = strcat("H:\testingGround\trajData\",num2str(participant),"\");
preFolderSim2 = strcat(preFolderSim2,num2str(trial),"\");
operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"))/1e4;

swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"))/1e4;
missingPersonPos = readmatrix(strcat(preFolderSim2,"ethanPos.csv"))/1e4;
subplot(2,3,2)
viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.36/10,'Color',[0.8 0.8 0.8])
viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.72/10,'Color',[0.8 0.8 0.8])
viscircles([operatorTraj(1,1),operatorTraj(1,3)],1.08/10,'Color',[0.8 0.8 0.8])
hold on
scatter(missingPersonPos(1),missingPersonPos(3),100,'blue','filled')

plot(operatorTraj(:,1),operatorTraj(:,3),'r')
grid on

for i = 1:3:floor(size(swarmTrajectory,2))
    plot(swarmTrajectory(:,i),swarmTrajectory(:,i+2),'g');
    %pbaspect([1 1 1])
end
xlim([operatorTraj(1,1)-offsetAx,operatorTraj(1,1)+offsetAx])
ylim([operatorTraj(1,3)-offsetAx,operatorTraj(1,3)+offsetAx])
axis image
%% closedLoop3
preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(3)),"\");
preFolderSim1 = strcat(preFolderSim1,num2str(participant),"\",num2str(trial),"\",num2str(numSwarm),"\",numRun,"\");
preFolderSim2 = strcat("H:\testingGround\trajData\",num2str(participant),"\");
preFolderSim2 = strcat(preFolderSim2,num2str(trial),"\");
operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"))/1e4;

swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"))/1e4;
missingPersonPos = readmatrix(strcat(preFolderSim2,"ethanPos.csv"))/1e4;
subplot(2,3,3)
viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.36/10,'Color',[0.8 0.8 0.8])
viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.72/10,'Color',[0.8 0.8 0.8])
viscircles([operatorTraj(1,1),operatorTraj(1,3)],1.08/10,'Color',[0.8 0.8 0.8])
hold on
scatter(missingPersonPos(1),missingPersonPos(3),100,'blue','filled')
hold on
grid on
plot(operatorTraj(:,1),operatorTraj(:,3),'r')
for i = 1:3:floor(size(swarmTrajectory,2))
    plot(swarmTrajectory(:,i),swarmTrajectory(:,i+2),'g');
    %pbaspect([1 1 1])
end
xlim([operatorTraj(1,1)-offsetAx,operatorTraj(1,1)+offsetAx])
ylim([operatorTraj(1,3)-offsetAx,operatorTraj(1,3)+offsetAx])
axis image
%% closedLoop4
preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(4)),"\");
preFolderSim1 = strcat(preFolderSim1,num2str(participant),"\",num2str(trial),"\",num2str(numSwarm),"\",numRun,"\");
preFolderSim2 = strcat("H:\testingGround\trajData\",num2str(participant),"\");
preFolderSim2 = strcat(preFolderSim2,num2str(trial),"\");
operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"))/1e4;

swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"))/1e4;
missingPersonPos = readmatrix(strcat(preFolderSim2,"ethanPos.csv"))/1e4;
subplot(2,3,4)
viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.36/10,'Color',[0.8 0.8 0.8])
viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.72/10,'Color',[0.8 0.8 0.8])
viscircles([operatorTraj(1,1),operatorTraj(1,3)],1.08/10,'Color',[0.8 0.8 0.8])
hold on
scatter(missingPersonPos(1),missingPersonPos(3),100,'blue','filled')
plot(operatorTraj(:,1),operatorTraj(:,3),'r')
grid on

for i = 1:3:floor(size(swarmTrajectory,2))
    plot(swarmTrajectory(:,i),swarmTrajectory(:,i+2),'g');
    %pbaspect([1 1 1])
end
xlim([operatorTraj(1,1)-offsetAx,operatorTraj(1,1)+offsetAx])
ylim([operatorTraj(1,3)-offsetAx,operatorTraj(1,3)+offsetAx])
axis image
%% random
preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(5)),"\");
preFolderSim1 = strcat(preFolderSim1,num2str(participant),"\",num2str(trial),"\",num2str(numSwarm),"\",numRun,"\");
preFolderSim2 = strcat("H:\testingGround\trajData\",num2str(participant),"\");
preFolderSim2 = strcat(preFolderSim2,num2str(trial),"\");
operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"))/1e4;

swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"))/1e4;
missingPersonPos = readmatrix(strcat(preFolderSim2,"ethanPos.csv"))/1e4;
subplot(2,3,5)
viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.36/10,'Color',[0.8 0.8 0.8])
viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.72/10,'Color',[0.8 0.8 0.8])
viscircles([operatorTraj(1,1),operatorTraj(1,3)],1.08/10,'Color',[0.8 0.8 0.8])
hold on
scatter(missingPersonPos(1),missingPersonPos(3),100,'blue','filled')
plot(operatorTraj(:,1),operatorTraj(:,3),'r')
grid on
for i = 1:3:floor(size(swarmTrajectory,2))
    plot(swarmTrajectory(:,i),swarmTrajectory(:,i+2),'g');
    %pbaspect([1 1 1])
end
xlim([operatorTraj(1,1)-offsetAx,operatorTraj(1,1)+offsetAx])
ylim([operatorTraj(1,3)-offsetAx,operatorTraj(1,3)+offsetAx])
axis image
%% spiral
preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(6)),"\");
preFolderSim1 = strcat(preFolderSim1,num2str(participant),"\",num2str(trial),"\",num2str(numSwarm),"\",numRun,"\");
preFolderSim2 = strcat("H:\testingGround\trajData\",num2str(participant),"\");
preFolderSim2 = strcat(preFolderSim2,num2str(trial),"\");
operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"))/1e4;

swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"))/1e4;
missingPersonPos = readmatrix(strcat(preFolderSim2,"ethanPos.csv"))/1e4;
subplot(2,3,6)
viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.36/10,'Color',[0.8 0.8 0.8])
viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.72/10,'Color',[0.8 0.8 0.8])
viscircles([operatorTraj(1,1),operatorTraj(1,3)],1.08/10,'Color',[0.8 0.8 0.8])
hold on
scatter(missingPersonPos(1),missingPersonPos(3),100,'blue','filled')
plot(operatorTraj(:,1),operatorTraj(:,3),'r')
grid on
for i = 1:3:floor(size(swarmTrajectory,2))
    plot(swarmTrajectory(:,i),swarmTrajectory(:,i+2),'g');
    %pbaspect([1 1 1])
end
xlim([operatorTraj(1,1)-offsetAx,operatorTraj(1,1)+offsetAx])
ylim([operatorTraj(1,3)-offsetAx,operatorTraj(1,3)+offsetAx])
axis image