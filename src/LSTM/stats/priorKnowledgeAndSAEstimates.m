clearvars
%close all
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
subplotNum = ["(a)","(b)","(c)","(d)"];
participant = 11940;
numSwarm = 5;
%trialNum = 122;
numRun = "run1";
offsetAx = 0.15;
figure(1)
clf 
for i = 1:numel(trialNum)
    preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(3)),"\");
    preFolderSim1 = strcat(preFolderSim1,num2str(participant),"\",num2str(trialNum(i)),"\",num2str(numSwarm),"\",numRun,"\");
    preFolderSim2 = strcat("H:\testingGround\trajData\",num2str(participant),"\");
    preFolderSim2 = strcat(preFolderSim2,num2str(trialNum(i)),"\");
    operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));
    operatorTime = readmatrix(strcat(preFolderSim1,"operatorTime.csv"));
    operatorInference = readmatrix(strcat(preFolderSim1,"inference.csv"));
    inferenceTime = readmatrix(strcat(preFolderSim1,"predictedDataReceiveTimeStamps.csv"));
    situationalAwareness = readmatrix(strcat(preFolderSim1,"situationalAwareness.csv"));
    situationalAwarenessTime = situationalAwareness(:,2);
    sa = situationalAwareness(:,1);
    subplot(2,2,i)
    dt = 15/360;
    time1 = 0:dt:15+(dt*numel(operatorInference(:,1))-dt);
    %yyaxis left
    % plot(time1,[zeros(numel(0:dt:15-dt),1);operatorInference(:,1)])
    % hold on
    % plot(time1,[zeros(numel(0:dt:15-dt),1);operatorInference(:,2)])
    
    plot([(0:dt:inferenceTime(1)-dt)' ;inferenceTime],[zeros(numel(0:dt:inferenceTime(1)-dt),1);operatorInference(:,1)])
    hold on
    plot([(0:dt:inferenceTime(1)-dt)' ;inferenceTime],[zeros(numel(0:dt:inferenceTime(1)-dt),1);operatorInference(:,2)])
    
    % sa = [];
    % time2 = [];
    % time2(1) = inferenceTime(1);
    % for j = 1:size(operatorTraj)-360
    %     takeWindow = operatorTraj(j:j+360,:);
    %     fracFreeze = calcFracFreeze(takeWindow);
    %     sa(j)= 0.34698 + 11.2288*fracFreeze;
    %     time2(j+1) = time2(j)+dt;
    % end
    ylabel("Estimated value")
    yyaxis right
    % time2 = 0:dt:15+(dt*numel(sa)-dt);
    % 
    % plot([(0:dt:time2(1)-dt),time2(2:end)],[zeros(1,numel(0:dt:inferenceTime(1)-dt)),sa],LineWidth=2)
    % plot(situationalAwarenessTime,sa,LineWidth=2)
    plot([(0:dt:situationalAwarenessTime(1)-dt)' ;situationalAwarenessTime],[zeros(numel(0:dt:situationalAwarenessTime(1)-dt),1);sa],LineWidth=2)
    if (i ==1)
        legend(["Person Knowledge","Terrain Knowledge", "Situational Awareness"])
    end
    xlim([0 60])
    % 
    % xlim([0 time1(end)])
    % if(time1(end)>60)
    %     xlim([0 60])
    % end
    % 
    ylabel("Estimated value")
    xlabel({"Time (s)",subplotNum(i)})
    title(trialName{i});
    % grid on

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
