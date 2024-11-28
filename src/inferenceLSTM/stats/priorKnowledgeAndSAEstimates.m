clearvars
close all
clc


trajPath = "D:\UWmonitoring\MissingPersonSearchSim\Assets\trajData\";
speedFilePath = 'D:\UWmonitoring\MissingPersonSearchSim\Assets\trajData\';
% Read subject id list
subject = cellstr(num2str(readmatrix(strcat(trajPath,'participantID1.csv'))));
% Standard order of trials, which is different from subjectwise trial
% order
% trialNum = [111,211,121,221,112,212,122,222];
% trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'}; % Person, Terrain, Swarm cohesion
trialNum = [111,121,212,222];
trialName = {'NNU','NYU','YNC','YYC'}; % Person, Terrain, Swarm cohesion
ii = 14;
plotWindow = 60;
simulationMode = {'closedLoopType1','closedLoopType2','closedLoopType3','closedLoopType4','randomSearch','spiralSearch'};
participant = 11940;
numSwarm = 5;
%trialNum = 122;
numRun = "run1";
offsetAx = 0.15;
figure
for i = 1:numel(trialNum)
    preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(1)),"\");
    preFolderSim1 = strcat(preFolderSim1,num2str(participant),"\",num2str(trialNum(i)),"\",num2str(numSwarm),"\",numRun,"\");
    preFolderSim2 = strcat("H:\testingGround\trajData\",num2str(participant),"\");
    preFolderSim2 = strcat(preFolderSim2,num2str(trialNum(i)),"\");
    operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));
    operatorTime = readmatrix(strcat(preFolderSim1,"operatorTime.csv"));
    operatorInference = readmatrix(strcat(preFolderSim1,"inference.csv"));

    subplot(2,2,i)
    %yyaxis left
    plot(operatorInference(:,1))
    hold on
    plot(operatorInference(:,2))
    
    sa = [];
    for j = 1:size(operatorTraj)-360
        takeWindow = operatorTraj(j:j+360,:);
        fracFreeze = calcFracFreeze(takeWindow);
        sa(j)= 0.34698 + 11.2288*fracFreeze;
    end
    ylabel("Inference value")
    yyaxis right
    plot(sa)
    if (i ==1)
        legend(["Person Knowledge","Terrain Knowledge", "Situational Awareness"])
    end
    xlim([0 numel(operatorInference(:,2))])
    ylabel("Inference value")
    xlabel("Sample")
    title(trialName{i});
    grid on

    % swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"))/1e4;
    % missingPersonPos = readmatrix(strcat(preFolderSim2,"ethanPos.csv"))/1e4;
    % subplot(2,3,1)
    % viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.36/10,'Color',[0.8 0.8 0.8])
    % viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.72/10,'Color',[0.8 0.8 0.8])
    % viscircles([operatorTraj(1,1),operatorTraj(1,3)],1.08/10,'Color',[0.8 0.8 0.8])
    % hold on
    % plot(operatorTraj(:,1),operatorTraj(:,3),'r')
    % grid on
    % 
    % scatter(missingPersonPos(1),missingPersonPos(3),100,'blue','filled')
    % for i = 1:3:floor(size(swarmTrajectory,2))
    %     plot(swarmTrajectory(:,i),swarmTrajectory(:,i+2),'g');
    %     %pbaspect([1 1 1])
    % end
    % xlim([operatorTraj(1,1)-offsetAx,operatorTraj(1,1)+offsetAx])
    % ylim([operatorTraj(1,3)-offsetAx,operatorTraj(1,3)+offsetAx])
    % axis image
end

function y = calcFracFreeze(takeWindow)
dt = 15/360;
speed = [];
magss = vecnorm(takeWindow,2,2);
speed = diff(magss)/dt;
c = 0;
for i = 1:numel(speed)
    if(speed(i)<=0.1)
        c = c + 1;
    end
end

y = c/360;
end
