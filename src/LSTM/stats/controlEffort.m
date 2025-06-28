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

simulationMode = {'closedLoopType1','closedLoopType2','closedLoopType3','closedLoopType4','randomSearch','spiralSearch'};
numSwarm = 5;
numRun = "run1";
accelMegaAggClosedLoop1 = [];
speedMegaAggClosedLoop1 = [];

for ii = 1:numel(subject)
    for jj = 1:numel(trialNum)
        %% closedLoop1
        preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(1)),"\");
        preFolderSim1 = strcat(preFolderSim1,num2str( cell2mat(subject(ii))),"\",num2str(trialNum(jj)),"\",num2str(numSwarm),"\",numRun,"\");
        operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));
        swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"));
        swarmTime = readmatrix(strcat(preFolderSim1,"swarmTime.csv"));

        timeDiff = diff(swarmTime);
        meanDt = mean(timeDiff);

        swarmVelocity = diff(swarmTrajectory,1)/meanDt; % Divide by time
        swarmAcceleration = diff(swarmVelocity,1)/meanDt; % Divide by time

        accelerationAgg = zeros(1,size(swarmAcceleration,2)/3);
        speedAgg = zeros(1,size(swarmVelocity,2)/3);

        for ll = 1:size(swarmAcceleration,1)
            c = 1;
            for l = 1:3:size(swarmAcceleration,2)-2
                accelerationAgg(ll,c) = norm(swarmAcceleration(ll,l:l+2));
                c = c + 1;
            end
        end

        for ll = 1:size(swarmVelocity,1)
            c = 1;
            for l = 1:3:size(swarmVelocity,2)-2
                speedAgg(ll,c) = norm(swarmVelocity(ll,l:l+2));
                c = c + 1;
            end
        end
        accelMegaAggClosedLoop1(ii,jj) = mean(mean(accelerationAgg));
        speedMegaAggClosedLoop1(ii,jj) = mean(mean(speedAgg));
    end
end

accelMegaAggClosedLoop2 = [];
speedMegaAggClosedLoop2 = [];
for ii = 1:numel(subject)
    for jj = 1:numel(trialNum)
        %% closedLoop1
        preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(2)),"\");
        preFolderSim1 = strcat(preFolderSim1,num2str( cell2mat(subject(ii))),"\",num2str(trialNum(jj)),"\",num2str(numSwarm),"\",numRun,"\");
        operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));
        swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"));
        swarmTime = readmatrix(strcat(preFolderSim1,"swarmTime.csv"));

        timeDiff = diff(swarmTime);
        meanDt = mean(timeDiff);

        swarmVelocity = diff(swarmTrajectory,1)/meanDt; % Divide by time
        swarmAcceleration = diff(swarmVelocity,1)/meanDt; % Divide by time

        accelerationAgg = zeros(1,size(swarmAcceleration,2)/3);
        speedAgg = zeros(1,size(swarmVelocity,2)/3);

        for ll = 1:size(swarmAcceleration,1)
            c = 1;
            for l = 1:3:size(swarmAcceleration,2)-2
                accelerationAgg(ll,c) = norm(swarmAcceleration(ll,l:l+2));
                c = c + 1;
            end
        end

        for ll = 1:size(swarmVelocity,1)
            c = 1;
            for l = 1:3:size(swarmVelocity,2)-2
                speedAgg(ll,c) = norm(swarmVelocity(ll,l:l+2));
                c = c + 1;
            end
        end
        accelMegaAggClosedLoop2(ii,jj) = mean(mean(accelerationAgg));
        speedMegaAggClosedLoop2(ii,jj) = mean(mean(speedAgg));
    end
end

accelMegaAggClosedLoop3 = [];
speedMegaAggClosedLoop3 = [];

for ii = 1:numel(subject)
    for jj = 1:numel(trialNum)
        %% closedLoop1
        preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(3)),"\");
        preFolderSim1 = strcat(preFolderSim1,num2str( cell2mat(subject(ii))),"\",num2str(trialNum(jj)),"\",num2str(numSwarm),"\",numRun,"\");
        operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));
        swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"));
        swarmTime = readmatrix(strcat(preFolderSim1,"swarmTime.csv"));

        timeDiff = diff(swarmTime);
        meanDt = mean(timeDiff);

        swarmVelocity = diff(swarmTrajectory,1)/meanDt; % Divide by time
        swarmAcceleration = diff(swarmVelocity,1)/meanDt; % Divide by time

        accelerationAgg = zeros(1,size(swarmAcceleration,2)/3);
        speedAgg = zeros(1,size(swarmVelocity,2)/3);

        for ll = 1:size(swarmAcceleration,1)
            c = 1;
            for l = 1:3:size(swarmAcceleration,2)-2
                accelerationAgg(ll,c) = norm(swarmAcceleration(ll,l:l+2));
                c = c + 1;
            end
        end

        for ll = 1:size(swarmVelocity,1)
            c = 1;
            for l = 1:3:size(swarmVelocity,2)-2
                speedAgg(ll,c) = norm(swarmVelocity(ll,l:l+2));
                c = c + 1;
            end
        end
        accelMegaAggClosedLoop3(ii,jj) = mean(mean(accelerationAgg));
        speedMegaAggClosedLoop3(ii,jj) = mean(mean(speedAgg));
    end
end

accelMegaAggClosedLoop4 = [];
speedMegaAggClosedLoop4 = [];

for ii = 1:numel(subject)
    for jj = 1:numel(trialNum)
        %% closedLoop1
        preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(4)),"\");
        preFolderSim1 = strcat(preFolderSim1,num2str( cell2mat(subject(ii))),"\",num2str(trialNum(jj)),"\",num2str(numSwarm),"\",numRun,"\");
        operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));
        swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"));
        swarmTime = readmatrix(strcat(preFolderSim1,"swarmTime.csv"));

        timeDiff = diff(swarmTime);
        meanDt = mean(timeDiff);

        swarmVelocity = diff(swarmTrajectory,1)/meanDt; % Divide by time
        swarmAcceleration = diff(swarmVelocity,1)/meanDt; % Divide by time

        accelerationAgg = zeros(1,size(swarmAcceleration,2)/3);
        speedAgg = zeros(1,size(swarmVelocity,2)/3);

        for ll = 1:size(swarmAcceleration,1)
            c = 1;
            for l = 1:3:size(swarmAcceleration,2)-2
                accelerationAgg(ll,c) = norm(swarmAcceleration(ll,l:l+2));
                c = c + 1;
            end
        end

        for ll = 1:size(swarmVelocity,1)
            c = 1;
            for l = 1:3:size(swarmVelocity,2)-2
                speedAgg(ll,c) = norm(swarmVelocity(ll,l:l+2));
                c = c + 1;
            end
        end
        accelMegaAggClosedLoop4(ii,jj) = mean(mean(accelerationAgg));
        speedMegaAggClosedLoop4(ii,jj) = mean(mean(speedAgg));
    end
end
%%
accelMegaAggRandomSearch = [];
speedMegaAggRandomSearch = [];
for ii = 1:numel(subject)
    for jj = 1:numel(trialNum)
        %% closedLoop1
        preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(5)),"\");
        preFolderSim1 = strcat(preFolderSim1,num2str( cell2mat(subject(ii))),"\",num2str(trialNum(jj)),"\",num2str(numSwarm),"\",numRun,"\");
        operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));
        swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"));
        swarmTime = readmatrix(strcat(preFolderSim1,"swarmTime.csv"));

        timeDiff = diff(swarmTime);
        meanDt = mean(timeDiff);

        swarmVelocity = diff(swarmTrajectory,1)/meanDt; % Divide by time
        swarmAcceleration = diff(swarmVelocity,1)/meanDt; % Divide by time

        accelerationAgg = zeros(1,size(swarmAcceleration,2)/3);
        speedAgg = zeros(1,size(swarmVelocity,2)/3);

        for ll = 1:size(swarmAcceleration,1)
            c = 1;
            for l = 1:3:size(swarmAcceleration,2)-2
                accelerationAgg(ll,c) = norm(swarmAcceleration(ll,l:l+2));
                c = c + 1;
            end
        end

        for ll = 1:size(swarmVelocity,1)
            c = 1;
            for l = 1:3:size(swarmVelocity,2)-2
                speedAgg(ll,c) = norm(swarmVelocity(ll,l:l+2));
                c = c + 1;
            end
        end
        accelMegaAggRandomSearch(ii,jj) = mean(mean(accelerationAgg));
        speedMegaAggRandomSearch(ii,jj) = mean(mean(speedAgg));
    end
end
%%
accelMegaAggSpiralSearch = [];
speedMegaAggSpiralSearch = [];
for ii = 1:numel(subject)
    for jj = 1:numel(trialNum)
        %% closedLoop1
        preFolderSim1 = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(6)),"\");
        preFolderSim1 = strcat(preFolderSim1,num2str( cell2mat(subject(ii))),"\",num2str(trialNum(jj)),"\",num2str(numSwarm),"\",numRun,"\");
        operatorTraj = readmatrix(strcat(preFolderSim1,"operatorTrajectory.csv"));
        swarmTrajectory = readmatrix(strcat(preFolderSim1,"swarmTrajectory.csv"));
        swarmTime = readmatrix(strcat(preFolderSim1,"swarmTime.csv"));

        timeDiff = diff(swarmTime);
        meanDt = mean(timeDiff);

        swarmVelocity = diff(swarmTrajectory,1)/meanDt; % Divide by time
        swarmAcceleration = diff(swarmVelocity,1)/meanDt; % Divide by time

        accelerationAgg = zeros(1,size(swarmAcceleration,2)/3);
        speedAgg = zeros(1,size(swarmVelocity,2)/3);

        for ll = 1:size(swarmAcceleration,1)
            c = 1;
            for l = 1:3:size(swarmAcceleration,2)-2
                accelerationAgg(ll,c) = norm(swarmAcceleration(ll,l:l+2));
                c = c + 1;
            end
        end

        for ll = 1:size(swarmVelocity,1)
            c = 1;
            for l = 1:3:size(swarmVelocity,2)-2
                speedAgg(ll,c) = norm(swarmVelocity(ll,l:l+2));
                c = c + 1;
            end
        end
        accelMegaAggSpiralSearch(ii,jj) = mean(mean(accelerationAgg));
        speedMegaAggSpiralSearch(ii,jj) = mean(mean(speedAgg));
    end
end




%% %%%%%%%%%%%%%%%%%%%%%% Plotssssss %%%%%%%%%%%%%%%%%%%%%%%%
%trialNames = {'NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'};
%%% fract found

figure(1)

meanAggData = [nanmean(accelMegaAggClosedLoop1);nanmean(accelMegaAggClosedLoop2);nanmean(accelMegaAggClosedLoop3);nanmean(accelMegaAggClosedLoop4);
    nanmean(accelMegaAggRandomSearch);nanmean(accelMegaAggSpiralSearch)];
stdAggData = [nanstd(accelMegaAggClosedLoop1);nanstd(accelMegaAggClosedLoop2);nanstd(accelMegaAggClosedLoop3);nanstd(accelMegaAggClosedLoop4);
    nanstd(accelMegaAggRandomSearch);nanstd(accelMegaAggSpiralSearch)];
xaaxxis = [1,4,7,10,13,16,19,22];
scatter(xaaxxis-0.9,meanAggData(1,:),300,'d','filled','MarkerFaceColor',[1 .2 .2],'MarkerFaceAlpha',0.6);
hold on
bnmy = errorbar(xaaxxis-0.9,meanAggData(1,:),stdAggData(1,:),'.','Color',[1 .2 .2]);
alpha(bnmy,0.4)

scatter(xaaxxis-0.6,meanAggData(2,:),300,'s','filled','MarkerFaceColor',[0.2 0.5 1.0],'MarkerFaceAlpha',0.6);
errorbar(xaaxxis-0.6,meanAggData(2,:),stdAggData(2,:),'.','Color',[0.2 0.5 1.0]);


scatter(xaaxxis-0.3,meanAggData(3,:),300,'o','filled','MarkerFaceColor',[0.5 0.5 0.5],'MarkerFaceAlpha',0.6);
errorbar(xaaxxis-0.3,meanAggData(3,:),stdAggData(3,:),'.','Color',[0.5 0.5 0.5]);


scatter(xaaxxis+0,meanAggData(4,:),300,'^','filled','MarkerFaceColor',[1 0.5 0.1],'MarkerFaceAlpha',0.6);
errorbar(xaaxxis+0,meanAggData(4,:),stdAggData(4,:),'.','Color',[1 0.5 0.1]);


scatter(xaaxxis+0.3,meanAggData(5,:),300,'v','filled','MarkerFaceColor',[0.2 1.0 0.2],'MarkerFaceAlpha',0.6);
errorbar(xaaxxis+0.3,meanAggData(5,:),stdAggData(5,:),'.','Color',[0.2 1.0 0.2]);


scatter(xaaxxis+0.6,meanAggData(6,:),300,'h','filled','MarkerFaceColor',[0.5 0.5 0.5],'MarkerFaceAlpha',0.6);
hold on
errorbar(xaaxxis+0.6,meanAggData(6,:),stdAggData(6,:),'.','Color',[0.5 0.5 0.5]);


grid on

xlabel({"Conditions (Person know Y/N, Terrain Know. Y/N)","(b)"})
trialNames = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
set(gca,'xtick',1:8,'xticklabel',trialNames)
xticks([1,4,7,10,13,16,19,22]);
xticklabels(trialNames)

legend('AsPkTk','','AsPk','','AsPkTkSA','','AsPkSA','','Rs','','Ss','');
xlabel("Conditions (Person know Y/N, Terrain Know. Y/N, Clustered. U/C)")
ylabel("Acceleration (m/s^2)")



figure(2)

meanAggData = [nanmean(speedMegaAggClosedLoop1);nanmean(speedMegaAggClosedLoop2);nanmean(speedMegaAggClosedLoop3);nanmean(speedMegaAggClosedLoop4);
    nanmean(speedMegaAggRandomSearch);nanmean(speedMegaAggSpiralSearch)];
stdAggData = [nanstd(speedMegaAggClosedLoop1);nanstd(speedMegaAggClosedLoop2);nanstd(speedMegaAggClosedLoop3);nanstd(speedMegaAggClosedLoop4);
    nanstd(speedMegaAggRandomSearch);nanstd(speedMegaAggSpiralSearch)];
xaaxxis = [1,4,7,10,13,16,19,22];
scatter(xaaxxis-0.9,meanAggData(1,:),300,'d','filled','MarkerFaceColor',[1 .2 .2],'MarkerFaceAlpha',0.6);
hold on
bnmy = errorbar(xaaxxis-0.9,meanAggData(1,:),stdAggData(1,:),'.','Color',[1 .2 .2]);
alpha(bnmy,0.4)

scatter(xaaxxis-0.6,meanAggData(2,:),300,'s','filled','MarkerFaceColor',[0.2 0.5 1.0],'MarkerFaceAlpha',0.6);
errorbar(xaaxxis-0.6,meanAggData(2,:),stdAggData(2,:),'.','Color',[0.2 0.5 1.0]);


scatter(xaaxxis-0.3,meanAggData(3,:),300,'o','filled','MarkerFaceColor',[0.5 0.5 0.5],'MarkerFaceAlpha',0.6);
errorbar(xaaxxis-0.3,meanAggData(3,:),stdAggData(3,:),'.','Color',[0.5 0.5 0.5]);


scatter(xaaxxis+0,meanAggData(4,:),300,'^','filled','MarkerFaceColor',[1 0.5 0.1],'MarkerFaceAlpha',0.6);
errorbar(xaaxxis+0,meanAggData(4,:),stdAggData(4,:),'.','Color',[1 0.5 0.1]);


scatter(xaaxxis+0.3,meanAggData(5,:),300,'v','filled','MarkerFaceColor',[0.2 1.0 0.2],'MarkerFaceAlpha',0.6);
errorbar(xaaxxis+0.3,meanAggData(5,:),stdAggData(5,:),'.','Color',[0.2 1.0 0.2]);


scatter(xaaxxis+0.6,meanAggData(6,:),300,'h','filled','MarkerFaceColor',[0.5 0.5 0.5],'MarkerFaceAlpha',0.6);
hold on
errorbar(xaaxxis+0.6,meanAggData(6,:),stdAggData(6,:),'.','Color',[0.5 0.5 0.5]);


grid on

xlabel({"Conditions (Person know Y/N, Terrain Know. Y/N)","(b)"})
trialNames = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
set(gca,'xtick',1:8,'xticklabel',trialNames)
xticks([1,4,7,10,13,16,19,22]);
xticklabels(trialNames)

legend('AsPkTk','','AsPk','','AsPkTkSA','','AsPkSA','','Rs','','Ss','');
xlabel("Conditions (Person know Y/N, Terrain Know. Y/N, Clustered. U/C)")
ylabel("Speed (m/s)")