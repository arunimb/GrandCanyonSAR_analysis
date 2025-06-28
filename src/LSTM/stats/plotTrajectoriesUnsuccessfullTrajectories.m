clearvars
close all
clc

addpath("..\..\src\Simulation\trajData\simulationRecord")
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
adaptiveSearch = {'AsPkTk','AsPk','AsPkTkSA','AsPkSA'};
targetFoundBySwarm = zeros(numel(trialNum),20);
targetFoundOrNot = zeros(numel(trialNum),20);
swarmTimeGained = zeros(numel(trialNum),20);
netSearchTime = zeros(numel(trialNum),20);
swarmTimeFound = zeros(numel(trialNum),20);
preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(1)),"\");
counter = 1;

participant = 77028;
numSwarm = 5;
trial = 112;
numRun = "run1";
offsetAx = 1500;
%% closedLoop1
subplot(2,2,1)
for ii = 1:numel(subject)
        preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(1)),"\");
        preFolderSim1 = strcat(preFolderSim1,subject(ii),"\",num2str(trial),"\",num2str(numSwarm),"\",numRun,"\");
        preFolderSim2 = strcat("H:\testingGround\trajData\",subject(ii),"\");
        preFolderSim2 = strcat(preFolderSim2,num2str(trial),"\");
        operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));

        swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"));
        missingPersonPos = readmatrix(strcat(preFolderSim2,"ethanPos.csv"));
        swarmFoundOrNot = readmatrix(strcat(preFolderSim1,"swarmFoundTime.csv"));
        if(swarmFoundOrNot<0)
            viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.36*1e3,'Color',[0.8 0.8 0.8])
            viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.72*1e3,'Color',[0.8 0.8 0.8])
            viscircles([operatorTraj(1,1),operatorTraj(1,3)],1.08*1e3,'Color',[0.8 0.8 0.8])
            hold on
            plot(operatorTraj(:,1),operatorTraj(:,3),'b')
            grid on

            scatter(missingPersonPos(1),missingPersonPos(3),100,'blue','filled')
            for i = 1:3:floor(size(swarmTrajectory,2))
                plot(swarmTrajectory(:,i),swarmTrajectory(:,i+2),Color=[23/255,126/255,7/255]);
                %pbaspect([1 1 1])
            end
            xlim([operatorTraj(1,1)-offsetAx,operatorTraj(1,1)+offsetAx])
            ylim([operatorTraj(1,3)-offsetAx,operatorTraj(1,3)+offsetAx])
            xlabel({" ","(a)"})
            ylabel("Y coordinate (m)")
            title(adaptiveSearch(1))
            pbaspect([1,1,1])
            break;
        end
end

%% closedLoop2
subplot(2,2,2)
for ii = 1:numel(subject)
    preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(2)),"\");
    preFolderSim1 = strcat(preFolderSim1,subject(ii),"\",num2str(trial),"\",num2str(numSwarm),"\",numRun,"\");
    preFolderSim2 = strcat("H:\testingGround\trajData\",subject(ii),"\");
    preFolderSim2 = strcat(preFolderSim2,num2str(trial),"\");
    operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));

    swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"));
    missingPersonPos = readmatrix(strcat(preFolderSim2,"ethanPos.csv"));
    swarmFoundOrNot = readmatrix(strcat(preFolderSim1,"swarmFoundTime.csv"));
    if(swarmFoundOrNot<0)
        viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.36*1e3,'Color',[0.8 0.8 0.8])
        viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.72*1e3,'Color',[0.8 0.8 0.8])
        viscircles([operatorTraj(1,1),operatorTraj(1,3)],1.08*1e3,'Color',[0.8 0.8 0.8])
        hold on
        scatter(missingPersonPos(1),missingPersonPos(3),100,'blue','filled')

        plot(operatorTraj(:,1),operatorTraj(:,3),'b')
        grid on

        for i = 1:3:floor(size(swarmTrajectory,2))
            plot(swarmTrajectory(:,i),swarmTrajectory(:,i+2),Color=[23/255,126/255,7/255]);
            %pbaspect([1 1 1])
        end
        xlim([operatorTraj(1,1)-offsetAx,operatorTraj(1,1)+offsetAx])
        ylim([operatorTraj(1,3)-offsetAx,operatorTraj(1,3)+offsetAx])
        xlabel({"X coordinate (m)","(b)"})
        ylabel("Y coordinate (m)")
        pbaspect([1,1,1])
        title(adaptiveSearch(1))
        break;
    end

end

%% closedLoop3
subplot(2,2,3)
for ii = 1:numel(subject)
    preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(3)),"\");
    preFolderSim1 = strcat(preFolderSim1,subject(ii),"\",num2str(trial),"\",num2str(numSwarm),"\",numRun,"\");
    preFolderSim2 = strcat("H:\testingGround\trajData\",subject(ii),"\");
    preFolderSim2 = strcat(preFolderSim2,num2str(trial),"\");
    operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));

    swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"));
    missingPersonPos = readmatrix(strcat(preFolderSim2,"ethanPos.csv"));
    swarmFoundOrNot = readmatrix(strcat(preFolderSim1,"swarmFoundTime.csv"));
    if(swarmFoundOrNot<0)
        viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.36*1e3,'Color',[0.8 0.8 0.8])
        viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.72*1e3,'Color',[0.8 0.8 0.8])
        viscircles([operatorTraj(1,1),operatorTraj(1,3)],1.08*1e3,'Color',[0.8 0.8 0.8])
        hold on
        scatter(missingPersonPos(1),missingPersonPos(3),100,'blue','filled')

        plot(operatorTraj(:,1),operatorTraj(:,3),'b')
        grid on

        for i = 1:3:floor(size(swarmTrajectory,2))
            plot(swarmTrajectory(:,i),swarmTrajectory(:,i+2),Color=[23/255,126/255,7/255]);
            %pbaspect([1 1 1])
        end
        xlim([operatorTraj(1,1)-offsetAx,operatorTraj(1,1)+offsetAx])
        ylim([operatorTraj(1,3)-offsetAx,operatorTraj(1,3)+offsetAx])
        xlabel({"X coordinate (m)","(b)"})
        ylabel("Y coordinate (m)")
        pbaspect([1,1,1])
        title(adaptiveSearch(1))
        break;
    end

end

%% closedLoop4
subplot(2,2,4)
for ii = 1:numel(subject)
    preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(4)),"\");
    preFolderSim1 = strcat(preFolderSim1,subject(ii),"\",num2str(trial),"\",num2str(numSwarm),"\",numRun,"\");
    preFolderSim2 = strcat("H:\testingGround\trajData\",subject(ii),"\");
    preFolderSim2 = strcat(preFolderSim2,num2str(trial),"\");
    operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));

    swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"));
    missingPersonPos = readmatrix(strcat(preFolderSim2,"ethanPos.csv"));
    swarmFoundOrNot = readmatrix(strcat(preFolderSim1,"swarmFoundTime.csv"));
    if(swarmFoundOrNot<0)
        viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.36*1e3,'Color',[0.8 0.8 0.8])
        viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.72*1e3,'Color',[0.8 0.8 0.8])
        viscircles([operatorTraj(1,1),operatorTraj(1,3)],1.08*1e3,'Color',[0.8 0.8 0.8])
        hold on
        scatter(missingPersonPos(1),missingPersonPos(3),100,'blue','filled')

        plot(operatorTraj(:,1),operatorTraj(:,3),'b')
        grid on

        for i = 1:3:floor(size(swarmTrajectory,2))
            plot(swarmTrajectory(:,i),swarmTrajectory(:,i+2),Color=[23/255,126/255,7/255]);
            %pbaspect([1 1 1])
        end
        xlim([operatorTraj(1,1)-offsetAx,operatorTraj(1,1)+offsetAx])
        ylim([operatorTraj(1,3)-offsetAx,operatorTraj(1,3)+offsetAx])
        xlabel({"X coordinate (m)","(b)"})
        ylabel("Y coordinate (m)")
        pbaspect([1,1,1])
        title(adaptiveSearch(1))
        break;
    end

end