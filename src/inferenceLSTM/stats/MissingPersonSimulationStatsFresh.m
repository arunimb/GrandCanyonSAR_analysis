clearvars
%close all
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

c = 1;
time2FinishBySubject = [];
humanSuccessOrNot = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','time_to_finish.csv'];
        if isfile(fileName)
            time2FinishBySubject(ii,j) = readmatrix(fileName);
            if(time2FinishBySubject(ii,j)<599)
                humanSuccessOrNot(ii,j) = 1;
            else 
                 time2FinishBySubject(ii,j) = nan;
                 humanSuccessOrNot(ii,j) = 0;
            end
            c = c + 1;
        end
        if ~isfile(fileName)
            time2FinishBySubject(ii,j) = nan;
            humanSuccessOrNot(ii,j-1) = 0;
            c = c + 1;
        end
    end
end
time2FinishBySubject = time2FinishBySubject';
humanSuccessOrNot = humanSuccessOrNot';
targetFoundOrNotCombinedCnUC = nan*ones(4,20);
netSearchTimeCombinedCnUC = nan*ones(4,20);
for i = 1:4
    for j = 1:20
        targetFoundOrNotCombinedCnUC(i,j) = 0.5*(humanSuccessOrNot(i,j)+humanSuccessOrNot(i+4,j));
        if(~isnan(time2FinishBySubject(i,j)) && ~isnan(time2FinishBySubject(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = 0.5*(time2FinishBySubject(i,j)+time2FinishBySubject(i+4,j));
        elseif (~isnan(time2FinishBySubject(i,j)) && isnan(time2FinishBySubject(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = time2FinishBySubject(i,j);
        elseif (isnan(time2FinishBySubject(i,j)) && ~isnan(time2FinishBySubject(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = time2FinishBySubject(i+4,j);
        end
    end  
end
targetFoundOrNotCombinedCnUC = targetFoundOrNotCombinedCnUC';
netSearchTimeCombinedCnUC = netSearchTimeCombinedCnUC';

meanTargetFoundOrNotCombinedCnUC = nanmean(targetFoundOrNotCombinedCnUC);
%meanNetSearchTimeCombinedCnUC = nanmean(netSearchTimeCombinedCnUC);

fractionHumanTargetsFound = meanTargetFoundOrNotCombinedCnUC;
humanTime = netSearchTimeCombinedCnUC;

%% ClosedLoop1 Search
targetFoundBySwarm = zeros(numel(trialNum),20);
targetFoundOrNot = zeros(numel(trialNum),20);
swarmTimeGained = zeros(numel(trialNum),20);
netSearchTime = zeros(numel(trialNum),20);
swarmTimeFound = zeros(numel(trialNum),20);
preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(1)),"\");
counter = 1;

for i = 1:numel(subject)
    for j = 1:numel(trialNum)
        counter = 1;
        for k = 1:size(numRuns)         
            folder = strcat(preFolderSim,"\");
            folder = strcat(folder,cell2mat(subject(i)));
            folder = strcat(folder,"\");
            folder = strcat(folder,num2str(trialNum(j)));
            folder = strcat(folder,"\");
            folder = strcat(folder,num2str(auvNumber));
            folder = strcat(folder,"\");
            folder = strcat(folder,"run");
            folder = strcat(folder,num2str(numRuns(k)));
            folder = strcat(folder,"\");
            fileNameForTrial = strcat(folder,"swarmFoundTime.csv");
            swarmSearchLength = readmatrix(fileNameForTrial);
            humanSearchLength = readmatrix([preFolder, cell2mat(subject(i)),'\',num2str(trialNum(j)),'\','time_to_finish.csv']);
            
            minSearchTime=[];
            foundOrNot = [];
            if(swarmSearchLength < 0)
                if(humanSearchLength < 599)
                    minSearchTime = humanSearchLength;
                    foundOrNot = 1;
                else 
                    minSearchTime = nan;
                    foundOrNot = 0;
                end
            else
                if(humanSearchLength >= 599)
                    minSearchTime = swarmSearchLength;
                    foundOrNot = 1;
                elseif(humanSearchLength < swarmSearchLength)
                    minSearchTime = humanSearchLength;
                    foundOrNot = 1;
                elseif(humanSearchLength > swarmSearchLength)
                    minSearchTime = swarmSearchLength;
                    foundOrNot = 1;
                end
            end
            targetFoundOrNot(j,i) = foundOrNot;
            netSearchTime(j,i) = minSearchTime;
        end
    end
end

targetFoundOrNotCombinedCnUC = -1*ones(4,20);
netSearchTimeCombinedCnUC = -1*ones(4,20);
for i = 1:4
    for j = 1:20
        targetFoundOrNotCombinedCnUC(i,j) = 0.5*(targetFoundOrNot(i,j)+targetFoundOrNot(i+4,j));
        if(~isnan(netSearchTime(i,j)) && ~isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = 0.5*(netSearchTime(i,j)+netSearchTime(i+4,j));
        elseif (~isnan(netSearchTime(i,j)) && isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = netSearchTime(i,j);
        elseif (isnan(netSearchTime(i,j)) && ~isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = netSearchTime(i+4,j);
        end
    end  
end
targetFoundOrNotCombinedCnUC = targetFoundOrNotCombinedCnUC';
netSearchTimeCombinedCnUC = netSearchTimeCombinedCnUC';

meanTargetFoundOrNotCombinedCnUC = nanmean(targetFoundOrNotCombinedCnUC);
%meanNetSearchTimeCombinedCnUC = nanmean(netSearchTimeCombinedCnUC);

fractionClosedLoop1TargetsFound = meanTargetFoundOrNotCombinedCnUC;
swarmTimeClosedLoop1 = netSearchTimeCombinedCnUC;


%%  %% closed loop 2

targetFoundBySwarm = zeros(numel(trialNum),20);
targetFoundOrNot = zeros(numel(trialNum),20);
swarmTimeGained = zeros(numel(trialNum),20);
netSearchTime = zeros(numel(trialNum),20);
swarmTimeFound = zeros(numel(trialNum),20);
preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(2)),"\");
counter = 1;

for i = 1:numel(subject)
    for j = 1:numel(trialNum)
        counter = 1;
        for k = 1:size(numRuns)         
            folder = strcat(preFolderSim,"\");
            folder = strcat(folder,cell2mat(subject(i)));
            folder = strcat(folder,"\");
            folder = strcat(folder,num2str(trialNum(j)));
            folder = strcat(folder,"\");
            folder = strcat(folder,num2str(auvNumber));
            folder = strcat(folder,"\");
            folder = strcat(folder,"run");
            folder = strcat(folder,num2str(numRuns(k)));
            folder = strcat(folder,"\");
            fileNameForTrial = strcat(folder,"swarmFoundTime.csv");
            swarmSearchLength = readmatrix(fileNameForTrial);
            humanSearchLength = readmatrix([preFolder, cell2mat(subject(i)),'\',num2str(trialNum(j)),'\','time_to_finish.csv']);

            minSearchTime=[];
            foundOrNot = [];
            if(swarmSearchLength < 0)
                if(humanSearchLength < 599)
                    minSearchTime = humanSearchLength;
                    foundOrNot = 1;
                else 
                    minSearchTime = nan;
                    foundOrNot = 0;
                end
            else
                if(humanSearchLength >= 599)
                    minSearchTime = swarmSearchLength;
                    foundOrNot = 1;
                elseif(humanSearchLength < swarmSearchLength)
                    minSearchTime = humanSearchLength;
                    foundOrNot = 1;
                elseif(humanSearchLength > swarmSearchLength)
                    minSearchTime = swarmSearchLength;
                    foundOrNot = 1;
                end
            end
            targetFoundOrNot(j,i) = foundOrNot;
            netSearchTime(j,i) = minSearchTime;
        end
    end
end

targetFoundOrNotCombinedCnUC = -1*ones(4,20);
netSearchTimeCombinedCnUC = -1*ones(4,20);
for i = 1:4
    for j = 1:20
        targetFoundOrNotCombinedCnUC(i,j) = 0.5*(targetFoundOrNot(i,j)+targetFoundOrNot(i+4,j));
        if(~isnan(netSearchTime(i,j)) && ~isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = 0.5*(netSearchTime(i,j)+netSearchTime(i+4,j));
        elseif (~isnan(netSearchTime(i,j)) && isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = netSearchTime(i,j);
        elseif (isnan(netSearchTime(i,j)) && ~isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = netSearchTime(i+4,j);
        end
    end  
end
targetFoundOrNotCombinedCnUC = targetFoundOrNotCombinedCnUC';
netSearchTimeCombinedCnUC = netSearchTimeCombinedCnUC';

meanTargetFoundOrNotCombinedCnUC = nanmean(targetFoundOrNotCombinedCnUC);
%meanNetSearchTimeCombinedCnUC = nanmean(netSearchTimeCombinedCnUC);

fractionClosedLoop2TargetsFound = meanTargetFoundOrNotCombinedCnUC;
swarmTimeClosedLoop2 = netSearchTimeCombinedCnUC;

%%  %% closed loop 3

targetFoundBySwarm = zeros(numel(trialNum),20);
targetFoundOrNot = zeros(numel(trialNum),20);
swarmTimeGained = zeros(numel(trialNum),20);
netSearchTime = zeros(numel(trialNum),20);
swarmTimeFound = zeros(numel(trialNum),20);
preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(3)),"\");
counter = 1;

for i = 1:numel(subject)
    for j = 1:numel(trialNum)
        counter = 1;
        for k = 1:size(numRuns)         
            folder = strcat(preFolderSim,"\");
            folder = strcat(folder,cell2mat(subject(i)));
            folder = strcat(folder,"\");
            folder = strcat(folder,num2str(trialNum(j)));
            folder = strcat(folder,"\");
            folder = strcat(folder,num2str(auvNumber));
            folder = strcat(folder,"\");
            folder = strcat(folder,"run");
            folder = strcat(folder,num2str(numRuns(k)));
            folder = strcat(folder,"\");
            fileNameForTrial = strcat(folder,"swarmFoundTime.csv");
            swarmSearchLength = readmatrix(fileNameForTrial);
            humanSearchLength = readmatrix([preFolder, cell2mat(subject(i)),'\',num2str(trialNum(j)),'\','time_to_finish.csv']);

            minSearchTime=[];
            foundOrNot = [];
            if(swarmSearchLength < 0)
                if(humanSearchLength < 599)
                    minSearchTime = humanSearchLength;
                    foundOrNot = 1;
                else 
                    minSearchTime = nan;
                    foundOrNot = 0;
                end
            else
                if(humanSearchLength >= 599)
                    minSearchTime = swarmSearchLength;
                    foundOrNot = 1;
                elseif(humanSearchLength < swarmSearchLength)
                    minSearchTime = humanSearchLength;
                    foundOrNot = 1;
                elseif(humanSearchLength > swarmSearchLength)
                    minSearchTime = swarmSearchLength;
                    foundOrNot = 1;
                end
            end
            targetFoundOrNot(j,i) = foundOrNot;
            netSearchTime(j,i) = minSearchTime;
        end
    end
end

targetFoundOrNotCombinedCnUC = -1*ones(4,20);
netSearchTimeCombinedCnUC = -1*ones(4,20);
for i = 1:4
    for j = 1:20
        targetFoundOrNotCombinedCnUC(i,j) = 0.5*(targetFoundOrNot(i,j)+targetFoundOrNot(i+4,j));
        if(~isnan(netSearchTime(i,j)) && ~isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = 0.5*(netSearchTime(i,j)+netSearchTime(i+4,j));
        elseif (~isnan(netSearchTime(i,j)) && isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = netSearchTime(i,j);
        elseif (isnan(netSearchTime(i,j)) && ~isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = netSearchTime(i+4,j);
        end
    end  
end
targetFoundOrNotCombinedCnUC = targetFoundOrNotCombinedCnUC';
netSearchTimeCombinedCnUC = netSearchTimeCombinedCnUC';

meanTargetFoundOrNotCombinedCnUC = nanmean(targetFoundOrNotCombinedCnUC);
%meanNetSearchTimeCombinedCnUC = nanmean(netSearchTimeCombinedCnUC);

fractionClosedLoop3TargetsFound = meanTargetFoundOrNotCombinedCnUC;
swarmTimeClosedLoop3 = netSearchTimeCombinedCnUC;
%%  %% closed loop 4

targetFoundBySwarm = zeros(numel(trialNum),20);
targetFoundOrNot = zeros(numel(trialNum),20);
swarmTimeGained = zeros(numel(trialNum),20);
netSearchTime = zeros(numel(trialNum),20);
swarmTimeFound = zeros(numel(trialNum),20);
preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(4)),"\");
counter = 1;

for i = 1:numel(subject)
    for j = 1:numel(trialNum)
        counter = 1;
        for k = 1:size(numRuns)         
            folder = strcat(preFolderSim,"\");
            folder = strcat(folder,cell2mat(subject(i)));
            folder = strcat(folder,"\");
            folder = strcat(folder,num2str(trialNum(j)));
            folder = strcat(folder,"\");
            folder = strcat(folder,num2str(auvNumber));
            folder = strcat(folder,"\");
            folder = strcat(folder,"run");
            folder = strcat(folder,num2str(numRuns(k)));
            folder = strcat(folder,"\");
            fileNameForTrial = strcat(folder,"swarmFoundTime.csv");
            swarmSearchLength = readmatrix(fileNameForTrial);
            humanSearchLength = readmatrix([preFolder, cell2mat(subject(i)),'\',num2str(trialNum(j)),'\','time_to_finish.csv']);

                        minSearchTime=[];
            foundOrNot = [];
            if(swarmSearchLength < 0)
                if(humanSearchLength < 599)
                    minSearchTime = humanSearchLength;
                    foundOrNot = 1;
                else 
                    minSearchTime = nan;
                    foundOrNot = 0;
                end
            else
                if(humanSearchLength >= 599)
                    minSearchTime = swarmSearchLength;
                    foundOrNot = 1;
                elseif(humanSearchLength < swarmSearchLength)
                    minSearchTime = humanSearchLength;
                    foundOrNot = 1;
                elseif(humanSearchLength > swarmSearchLength)
                    minSearchTime = swarmSearchLength;
                    foundOrNot = 1;
                end
            end
            targetFoundOrNot(j,i) = foundOrNot;
            netSearchTime(j,i) = minSearchTime;
        end
    end
end

targetFoundOrNotCombinedCnUC = -1*ones(4,20);
netSearchTimeCombinedCnUC = -1*ones(4,20);
for i = 1:4
    for j = 1:20
        targetFoundOrNotCombinedCnUC(i,j) = 0.5*(targetFoundOrNot(i,j)+targetFoundOrNot(i+4,j));
        if(~isnan(netSearchTime(i,j)) && ~isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = 0.5*(netSearchTime(i,j)+netSearchTime(i+4,j));
        elseif (~isnan(netSearchTime(i,j)) && isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = netSearchTime(i,j);
        elseif (isnan(netSearchTime(i,j)) && ~isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = netSearchTime(i+4,j);
        end
    end  
end
targetFoundOrNotCombinedCnUC = targetFoundOrNotCombinedCnUC';
netSearchTimeCombinedCnUC = netSearchTimeCombinedCnUC';

meanTargetFoundOrNotCombinedCnUC = nanmean(targetFoundOrNotCombinedCnUC);
%meanNetSearchTimeCombinedCnUC = nanmean(netSearchTimeCombinedCnUC);

fractionClosedLoop4TargetsFound = meanTargetFoundOrNotCombinedCnUC;
swarmTimeClosedLoop4 = netSearchTimeCombinedCnUC;
%%  %% random search

targetFoundBySwarm = zeros(numel(trialNum),20);
targetFoundOrNot = zeros(numel(trialNum),20);
swarmTimeGained = zeros(numel(trialNum),20);
netSearchTime = zeros(numel(trialNum),20);
swarmTimeFound = zeros(numel(trialNum),20);
preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(5)),"\");
counter = 1;

for i = 1:numel(subject)
    for j = 1:numel(trialNum)
        counter = 1;
        for k = 1:size(numRuns)         
            folder = strcat(preFolderSim,"\");
            folder = strcat(folder,cell2mat(subject(i)));
            folder = strcat(folder,"\");
            folder = strcat(folder,num2str(trialNum(j)));
            folder = strcat(folder,"\");
            folder = strcat(folder,num2str(auvNumber));
            folder = strcat(folder,"\");
            folder = strcat(folder,"run");
            folder = strcat(folder,num2str(numRuns(k)));
            folder = strcat(folder,"\");
            fileNameForTrial = strcat(folder,"swarmFoundTime.csv");
            swarmSearchLength = readmatrix(fileNameForTrial);
            humanSearchLength = readmatrix([preFolder, cell2mat(subject(i)),'\',num2str(trialNum(j)),'\','time_to_finish.csv']);

            minSearchTime=[];
            foundOrNot = [];
            if(swarmSearchLength < 0)
                minSearchTime = nan;
                foundOrNot = 0;
            else
                minSearchTime = swarmSearchLength;
                foundOrNot = 1;
            end
            targetFoundOrNot(j,i) = foundOrNot;
            netSearchTime(j,i) = minSearchTime;
        end
    end
end

targetFoundOrNotCombinedCnUC = -1*ones(4,20);
netSearchTimeCombinedCnUC = -1*ones(4,20);
for i = 1:4
    for j = 1:20
        targetFoundOrNotCombinedCnUC(i,j) = 0.5*(targetFoundOrNot(i,j)+targetFoundOrNot(i+4,j));
        if(~isnan(netSearchTime(i,j)) && ~isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = 0.5*(netSearchTime(i,j)+netSearchTime(i+4,j));
        elseif (~isnan(netSearchTime(i,j)) && isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = netSearchTime(i,j);
        elseif (isnan(netSearchTime(i,j)) && ~isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = netSearchTime(i+4,j);
        end
    end  
end
targetFoundOrNotCombinedCnUC = targetFoundOrNotCombinedCnUC';
netSearchTimeCombinedCnUC = netSearchTimeCombinedCnUC';

meanTargetFoundOrNotCombinedCnUC = nanmean(targetFoundOrNotCombinedCnUC);
%meanNetSearchTimeCombinedCnUC = nanmean(netSearchTimeCombinedCnUC);

fractionRandomSearchTargetsFound = meanTargetFoundOrNotCombinedCnUC;
swarmTimeRandomSearch = netSearchTimeCombinedCnUC;
%%  %% spiral search

targetFoundBySwarm = zeros(numel(trialNum),20);
targetFoundOrNot = zeros(numel(trialNum),20);
swarmTimeGained = zeros(numel(trialNum),20);
netSearchTime = zeros(numel(trialNum),20);
swarmTimeFound = zeros(numel(trialNum),20);
preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(6)),"\");
counter = 1;

for i = 1:numel(subject)
    for j = 1:numel(trialNum)
        counter = 1;
        for k = 1:size(numRuns)         
            folder = strcat(preFolderSim,"\");
            folder = strcat(folder,cell2mat(subject(i)));
            folder = strcat(folder,"\");
            folder = strcat(folder,num2str(trialNum(j)));
            folder = strcat(folder,"\");
            folder = strcat(folder,num2str(auvNumber));
            folder = strcat(folder,"\");
            folder = strcat(folder,"run");
            folder = strcat(folder,num2str(numRuns(k)));
            folder = strcat(folder,"\");
            fileNameForTrial = strcat(folder,"swarmFoundTime.csv");
            swarmSearchLength = readmatrix(fileNameForTrial);
            humanSearchLength = readmatrix([preFolder, cell2mat(subject(i)),'\',num2str(trialNum(j)),'\','time_to_finish.csv']);

            minSearchTime=[];
            foundOrNot = [];
            if(swarmSearchLength < 0)
                minSearchTime = nan;
                foundOrNot = 0;
            else
                minSearchTime = swarmSearchLength;
                foundOrNot = 1;
            end
            targetFoundOrNot(j,i) = foundOrNot;
            netSearchTime(j,i) = minSearchTime;
        end
    end
end
targetFoundOrNotCombinedCnUC = -1*ones(4,20);
netSearchTimeCombinedCnUC = -1*ones(4,20);
for i = 1:4
    for j = 1:20
        targetFoundOrNotCombinedCnUC(i,j) = 0.5*(targetFoundOrNot(i,j)+targetFoundOrNot(i+4,j));
        if(~isnan(netSearchTime(i,j)) && ~isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = 0.5*(netSearchTime(i,j)+netSearchTime(i+4,j));
        elseif (~isnan(netSearchTime(i,j)) && isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = netSearchTime(i,j);
        elseif (isnan(netSearchTime(i,j)) && ~isnan(netSearchTime(i+4,j)))
            netSearchTimeCombinedCnUC(i,j) = netSearchTime(i+4,j);
        end
    end  
end
targetFoundOrNotCombinedCnUC = targetFoundOrNotCombinedCnUC';
netSearchTimeCombinedCnUC = netSearchTimeCombinedCnUC';

meanTargetFoundOrNotCombinedCnUC = nanmean(targetFoundOrNotCombinedCnUC);
%meanNetSearchTimeCombinedCnUC = nanmean(netSearchTimeCombinedCnUC);

fractionSpiralSearchTargetsFound = meanTargetFoundOrNotCombinedCnUC;
swarmTimeSpiralSearch = netSearchTimeCombinedCnUC;

%% %%%%%%%%%%%%%%%%%%%%%% Plotssssss %%%%%%%%%%%%%%%%%%%%%%%%
%trialNames = {'NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'};
%%% fract found
figure(1)
clf;
%subplot(1,2,1)
scatter(1:1:4,fractionClosedLoop1TargetsFound,200,'d','filled','MarkerFaceColor',[1 .2 .2]);
hold on
scatter(1:1:4,fractionClosedLoop2TargetsFound,200,'s','filled','MarkerFaceColor',[0.2 0.5 1.0]);
scatter(1:1:4,fractionClosedLoop3TargetsFound,200,'d','filled','MarkerFaceColor',[0.5 0.5 0.5]);
scatter(1:1:4,fractionClosedLoop4TargetsFound,200,'^','filled','MarkerFaceColor',[1 0.5 0.1]);
scatter(1:1:4,fractionRandomSearchTargetsFound,200,'d','filled','MarkerFaceColor',[0.2 1.0 0.2]);
scatter(1:1:4,fractionSpiralSearchTargetsFound,200,'s','filled','MarkerFaceColor',[0.5 0.5 0.5]);
scatter(1:1:4,fractionHumanTargetsFound,200,'s','MarkerEdgeColor',[0.5 0.5 0.5]);
grid on
legend("Closed Loop type 1","Closed Loop type 2","Closed Loop type 3","Closed Loop type 4","Random Search","Spiral Search","Human Search",'NumColumns',2)
% legend("Follow Search","Closed Loop","Random Search")
%ylabel("Fraction of trials target found by swarm")
ylabel("Fraction of trials target found by Swarm")
xlabel("Conditions")
set(gca,'xtick',1:8,'xticklabel',trialNames)
ylim([0, 1]);

%%%%%%%%% Search time
figure(2)
clf;
cats = [ones(size(swarmTimeClosedLoop1,1),1);2*ones(size(swarmTimeClosedLoop1,1),1); ...
    3*ones(size(swarmTimeClosedLoop1,1),1);4*ones(size(swarmTimeClosedLoop1,1),1) ...
    ;5*ones(size(swarmTimeClosedLoop1,1),1);6*ones(size(swarmTimeClosedLoop1,1),1);7*ones(size(swarmTimeClosedLoop1,1),1)];
aggData = [swarmTimeClosedLoop1;swarmTimeClosedLoop2;swarmTimeClosedLoop3;swarmTimeClosedLoop4;swarmTimeRandomSearch; ...
   swarmTimeSpiralSearch;humanTime ];
categories = categorical(cats,[1 2 3 4 5 6 7],{'Closed Loop type 1','Closed Loop type 2','Closed Loop type 3','Closed Loop type 4','Random Search','Spiral Search','Human Search'});
c = 1;
l = [];
for i = 1:4
    l(i) = c;
    h = boxchart(c*ones(size(aggData(:,i))),aggData(:,i),'GroupByColor',categories);
    c = c + 1.5;
    hold on
    h(1).BoxFaceColor='r';
    h(2).BoxFaceColor='b';
    h(3).BoxFaceColor='g';
    h(4).BoxFaceColor='m';
    h(5).BoxFaceColor='c';
    h(6).BoxFaceColor='k';
    h(7).BoxFaceColor='y';
    % if(i == 1)
    %     legend('Follow Search','Closed Loop','Random Search','Spiral');
    % end

end
ylabel("Average time taken to find \newline missing person by H-S team")
xlabel("Conditions")
xticks(l);
xticklabels(trialNames)
legend('Closed Loop type 1','Closed Loop type 2','Closed Loop type 3','Closed Loop type 4','Random Search','Spiral Search','Human Search', ...
    '','','','','','','','','','','','','','','','','','','','','');
ylim([0, 600]);