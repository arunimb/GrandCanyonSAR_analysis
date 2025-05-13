clearvars
close all
clc

addpath("..\..\..\src\Simulation\trajData\simulationRecord\")
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
strategyName = {'AsPkTk','AsPk','AsPkTkSA','AsPkSA','Rs','Ss'};


participant = 63579;
numSwarm = 5;
trial = 111;
numRun = "run1";
offsetAx = 1500;
figNum = 1;
%% closedLoop1
imageFolder = 'videoFrames\';
h = figure('visible','off');
for mn = 1:numel(simulationMode)
    preFolderSim1 = strcat("..\..\..\src\Simulation\trajData\simulationRecord\",cell2mat(simulationMode(mn)),"\");
    preFolderSim1 = strcat(preFolderSim1,num2str(participant),"\",num2str(trial),"\",num2str(numSwarm),"\",numRun,"\");
    preFolderSim2 = strcat("..\..\..\src\Simulation\trajData\",num2str(participant),"\");
    preFolderSim2 = strcat(preFolderSim2,num2str(trial),"\");
    operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));

    swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"));
    missingPersonPos = readmatrix(strcat(preFolderSim2,"ethanPos.csv"));



    for ii = 2:size(operatorTraj,1)
        clf;

        viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.36*1e3,'Color',[0.6 0.6 0.6])
        viscircles([operatorTraj(1,1),operatorTraj(1,3)],0.72*1e3,'Color',[0.6 0.6 0.6])
        viscircles([operatorTraj(1,1),operatorTraj(1,3)],1.08*1e3,'Color',[0.6 0.6 0.6])
        hold on
        scatter(missingPersonPos(1),missingPersonPos(3),100,'blue','filled')

        playerPositionX = operatorTraj(1:ii,1);
        playerPositionY = operatorTraj(1:ii,3);
        plot(playerPositionX,playerPositionY,'Color','r',LineWidth=1.5);

        for jj = 1:3:floor(size(swarmTrajectory,2))
            sX = swarmTrajectory(1:ii,jj);
            sY = swarmTrajectory(1:ii,jj+2);
            plot(sX,sY,'Color','g',LineWidth=1.5);
        end
        grid on
        xlim([operatorTraj(1,1)-offsetAx,operatorTraj(1,1)+offsetAx]);
        ylim([operatorTraj(1,3)-offsetAx,operatorTraj(1,3)+offsetAx]);
        xlabel("X coordinate (m)")
        ylabel("Y coordinate (m)")
        title(strategyName(mn))

        pbaspect([1 1 1])
        if (rem(ii,10)==0 || ii == 2 || ii == size(operatorTraj,1))
            % set(gcf, 'Position', [10, 10, 600, 600]);
            fontsize(gcf, 16,"points")
            imgName = sprintf('%05d.png', figNum);

            set(gcf,'PaperPositionMode','auto');
            set(h, 'Position', [0 0 600 600]);
            saveas(gcf,[imageFolder imgName]);
            figNum = figNum + 1;

        end
    end
    clf;
    for lmn = 1:10
        % set(gcf, 'Position', [10, 10, 600, 600]);

        fontsize(gcf, 16,"points")
        imgName = sprintf('%05d.png', figNum);

        set(gcf,'PaperPositionMode','auto');
        set(h, 'Position', [0 0 600 600]);
        saveas(gcf,[imageFolder imgName]);
        figNum = figNum + 1;

    end
end