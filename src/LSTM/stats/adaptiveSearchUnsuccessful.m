clearvars
close all
clc

addpath("..\..\src\Simulation\trajData\simulationRecord")
subject = cellstr(num2str(readmatrix('..\..\..\data\participantID1.csv')));
%subject = cell2mat(subject);
preFolder = '..\..\..\data\';
trialNames = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
trialNames = {'NN','YN','NY','YY'};  % Person, Terrain, Swarm cohesion
trialNum = [111,211,121,221,112,212,122,222];
trialNumToPlot = 3;
simulationMode = {'closedLoopType1','closedLoopType2','closedLoopType3','closedLoopType4','randomSearch','spiralSearch'};
numSwarm = 5;
numRun = "run1";
accelMegaAggClosedLoop1 = [];
speedMegaAggClosedLoop1 = [];

adaptiveSearch = {'AsPkTk','AsPk','AsPkTkSA','AsPkSA'};



figure(1)
c = ['r','g','b'];
ll = 1;
subplot(2,2,1)
for ii = 1:numel(subject)
    %for jj = 1:numel(trialNum)
        if (ll<=3)
            %% closedLoop1
            preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(1)),"\");
            preFolderSim1 = strcat(preFolderSim1,num2str( cell2mat(subject(ii))),"\",num2str(trialNum(trialNumToPlot)),"\",num2str(numSwarm),"\",numRun,"\");
            operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));
            swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"));
            swarmFoundOrNot = readmatrix(strcat(preFolderSim1,"swarmFoundTime.csv"));
            if(swarmFoundOrNot<0)


                for l = 1:3:size(swarmTrajectory,2)-2
                    xTraj = swarmTrajectory(:,l);
                    yTraj = swarmTrajectory(:,l+2);
                    plot(xTraj,yTraj,c(ll))
                    hold on
                end


                ll = ll+1;
            end
        end

    %end
end
title(adaptiveSearch(1))
xlabel("X coordinate")
ylabel("Y coordinate")


ll = 1;
subplot(2,2,2)
for ii = 1:numel(subject)
    %for jj = 1:numel(trialNum)
        if (ll<=3)
            %% closedLoop1
            preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(2)),"\");
            preFolderSim1 = strcat(preFolderSim1,num2str( cell2mat(subject(ii))),"\",num2str(trialNum(trialNumToPlot)),"\",num2str(numSwarm),"\",numRun,"\");
            operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));
            swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"));
            swarmFoundOrNot = readmatrix(strcat(preFolderSim1,"swarmFoundTime.csv"));
            if(swarmFoundOrNot<0)


                for l = 1:3:size(swarmTrajectory,2)-2
                    xTraj = swarmTrajectory(:,l);
                    yTraj = swarmTrajectory(:,l+2);
                    plot(xTraj,yTraj,c(ll))
                    hold on
                end


                ll = ll+1;
            end
        end

    %end
end
title(adaptiveSearch(2))
xlabel("X coordinate")
ylabel("Y coordinate")


ll = 1;
subplot(2,2,3)
for ii = 1:numel(subject)
    %for jj = 1:numel(trialNum)
        if (ll<=3)
            %% closedLoop1
            preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(3)),"\");
            preFolderSim1 = strcat(preFolderSim1,num2str( cell2mat(subject(ii))),"\",num2str(trialNum(trialNumToPlot)),"\",num2str(numSwarm),"\",numRun,"\");
            operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));
            swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"));
            swarmFoundOrNot = readmatrix(strcat(preFolderSim1,"swarmFoundTime.csv"));
            if(swarmFoundOrNot<0)


                for l = 1:3:size(swarmTrajectory,2)-2
                    xTraj = swarmTrajectory(:,l);
                    yTraj = swarmTrajectory(:,l+2);
                    plot(xTraj,yTraj,c(ll))
                    hold on
                end


                ll = ll+1;
            end
        end

    %end
end
title(adaptiveSearch(3))
xlabel("X coordinate")
ylabel("Y coordinate")


ll = 1;
subplot(2,2,4)
for ii = 1:numel(subject)
    %for jj = 1:numel(trialNum)
        if (ll<=3)
            %% closedLoop1
            preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(4)),"\");
            preFolderSim1 = strcat(preFolderSim1,num2str( cell2mat(subject(ii))),"\",num2str(trialNum(trialNumToPlot)),"\",num2str(numSwarm),"\",numRun,"\");
            operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));
            swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"));
            swarmFoundOrNot = readmatrix(strcat(preFolderSim1,"swarmFoundTime.csv"));
            if(swarmFoundOrNot<0)


                for l = 1:3:size(swarmTrajectory,2)-2
                    xTraj = swarmTrajectory(:,l);
                    yTraj = swarmTrajectory(:,l+2);
                    plot(xTraj,yTraj,c(ll))
                    hold on
                end


                ll = ll+1;
            end
        end

    %end
end
title(adaptiveSearch(4))
xlabel("X coordinate")
ylabel("Y coordinate")