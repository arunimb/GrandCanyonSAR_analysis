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
auvNumbers = [5 10 15]; %[5 10 15]
numRuns = [1];
humanTimeToLand = 15;
simulationMode = {'closedLoopType1','closedLoopType2','closedLoopType3','closedLoopType4','randomSearch','spiralSearch'};

c = 1;
time2FinishBySubject = [];
humanSuccessOrNot = [];
trials = strings;

for lmn = 1:numel(auvNumbers)
    auvNumber = auvNumbers(lmn);
    for ii = 1:numel(subject)
        for j = 1:numel(trialNum)
            fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','time_to_finish.csv'];
            if isfile(fileName)
                time2FinishBySubject(ii,j) = readmatrix(fileName);
                if(time2FinishBySubject(ii,j)<599)
                    humanSuccessOrNot(ii,j) = 1;
                    time2FinishBySubject(ii,j) = time2FinishBySubject(ii,j) - 15;
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

    targetFoundOrNotCombinedCnUC = -1*ones(4,40);
    netSearchTimeCombinedCnUC = -1*ones(4,40);
    targetFoundOrNotCombinedCnUC(1,:)=[humanSuccessOrNot(1,:),humanSuccessOrNot(5,:)];
    targetFoundOrNotCombinedCnUC(2,:)=[humanSuccessOrNot(2,:),humanSuccessOrNot(6,:)];
    targetFoundOrNotCombinedCnUC(3,:)=[humanSuccessOrNot(3,:),humanSuccessOrNot(7,:)];
    targetFoundOrNotCombinedCnUC(4,:)=[humanSuccessOrNot(4,:),humanSuccessOrNot(8,:)];

    netSearchTimeCombinedCnUC(1,:)=[time2FinishBySubject(1,:),time2FinishBySubject(5,:)];
    netSearchTimeCombinedCnUC(2,:)=[time2FinishBySubject(2,:),time2FinishBySubject(6,:)];
    netSearchTimeCombinedCnUC(3,:)=[time2FinishBySubject(3,:),time2FinishBySubject(7,:)];
    netSearchTimeCombinedCnUC(4,:)=[time2FinishBySubject(4,:),time2FinishBySubject(8,:)];

    fractionHumanTargetsFound = zeros(1,4);
    for i = 1:4
        numOnes = sum(targetFoundOrNotCombinedCnUC(i,:) == 1);
        fractionHumanTargetsFound(i) = numOnes/numel(targetFoundOrNotCombinedCnUC(i,:));

    end
    humanTime = netSearchTimeCombinedCnUC';
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
                        % reduce human search time by 15 seconds
                        minSearchTime = humanSearchLength-15;
                        foundOrNot = 1;
                    else
                        minSearchTime = nan;
                        foundOrNot = 0;
                    end
                else
                    if(humanSearchLength >= 599)
                        % reduce human search time by 15 seconds
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

    targetFoundOrNotCombinedCnUC = -1*ones(4,40);
    netSearchTimeCombinedCnUC = -1*ones(4,40);
    targetFoundOrNotCombinedCnUC(1,:)=[targetFoundOrNot(1,:),targetFoundOrNot(5,:)];
    targetFoundOrNotCombinedCnUC(2,:)=[targetFoundOrNot(2,:),targetFoundOrNot(6,:)];
    targetFoundOrNotCombinedCnUC(3,:)=[targetFoundOrNot(3,:),targetFoundOrNot(7,:)];
    targetFoundOrNotCombinedCnUC(4,:)=[targetFoundOrNot(4,:),targetFoundOrNot(8,:)];

    netSearchTimeCombinedCnUC(1,:)=[netSearchTime(1,:),netSearchTime(5,:)];
    netSearchTimeCombinedCnUC(2,:)=[netSearchTime(2,:),netSearchTime(6,:)];
    netSearchTimeCombinedCnUC(3,:)=[netSearchTime(3,:),netSearchTime(7,:)];
    netSearchTimeCombinedCnUC(4,:)=[netSearchTime(4,:),netSearchTime(8,:)];

    fractionClosedLoop1TargetsFound = zeros(1,4);
    for i = 1:4
        numOnes = sum(targetFoundOrNotCombinedCnUC(i,:) == 1);
        fractionClosedLoop1TargetsFound(i) = numOnes/numel(targetFoundOrNotCombinedCnUC(i,:));

    end
    swarmTimeClosedLoop1 = netSearchTimeCombinedCnUC';

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
                        minSearchTime = humanSearchLength-15;

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

    targetFoundOrNotCombinedCnUC = -1*ones(4,40);
    netSearchTimeCombinedCnUC = -1*ones(4,40);
    targetFoundOrNotCombinedCnUC(1,:)=[targetFoundOrNot(1,:),targetFoundOrNot(5,:)];
    targetFoundOrNotCombinedCnUC(2,:)=[targetFoundOrNot(2,:),targetFoundOrNot(6,:)];
    targetFoundOrNotCombinedCnUC(3,:)=[targetFoundOrNot(3,:),targetFoundOrNot(7,:)];
    targetFoundOrNotCombinedCnUC(4,:)=[targetFoundOrNot(4,:),targetFoundOrNot(8,:)];

    netSearchTimeCombinedCnUC(1,:)=[netSearchTime(1,:),netSearchTime(5,:)];
    netSearchTimeCombinedCnUC(2,:)=[netSearchTime(2,:),netSearchTime(6,:)];
    netSearchTimeCombinedCnUC(3,:)=[netSearchTime(3,:),netSearchTime(7,:)];
    netSearchTimeCombinedCnUC(4,:)=[netSearchTime(4,:),netSearchTime(8,:)];

    fractionClosedLoop2TargetsFound = zeros(1,4);
    for i = 1:4
        numOnes = sum(targetFoundOrNotCombinedCnUC(i,:) == 1);
        fractionClosedLoop2TargetsFound(i) = numOnes/numel(targetFoundOrNotCombinedCnUC(i,:));

    end
    swarmTimeClosedLoop2 = netSearchTimeCombinedCnUC';


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
                        minSearchTime = humanSearchLength-15;
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
    targetFoundOrNotCombinedCnUC = -1*ones(4,40);
    netSearchTimeCombinedCnUC = -1*ones(4,40);
    targetFoundOrNotCombinedCnUC(1,:)=[targetFoundOrNot(1,:),targetFoundOrNot(5,:)];
    targetFoundOrNotCombinedCnUC(2,:)=[targetFoundOrNot(2,:),targetFoundOrNot(6,:)];
    targetFoundOrNotCombinedCnUC(3,:)=[targetFoundOrNot(3,:),targetFoundOrNot(7,:)];
    targetFoundOrNotCombinedCnUC(4,:)=[targetFoundOrNot(4,:),targetFoundOrNot(8,:)];

    netSearchTimeCombinedCnUC(1,:)=[netSearchTime(1,:),netSearchTime(5,:)];
    netSearchTimeCombinedCnUC(2,:)=[netSearchTime(2,:),netSearchTime(6,:)];
    netSearchTimeCombinedCnUC(3,:)=[netSearchTime(3,:),netSearchTime(7,:)];
    netSearchTimeCombinedCnUC(4,:)=[netSearchTime(4,:),netSearchTime(8,:)];

    fractionClosedLoop3TargetsFound = zeros(1,4);
    for i = 1:4
        numOnes = sum(targetFoundOrNotCombinedCnUC(i,:) == 1);
        fractionClosedLoop3TargetsFound(i) = numOnes/numel(targetFoundOrNotCombinedCnUC(i,:));

    end
    swarmTimeClosedLoop3 = netSearchTimeCombinedCnUC';
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
                        minSearchTime = humanSearchLength-15;
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

    targetFoundOrNotCombinedCnUC = -1*ones(4,40);
    netSearchTimeCombinedCnUC = -1*ones(4,40);
    targetFoundOrNotCombinedCnUC(1,:)=[targetFoundOrNot(1,:),targetFoundOrNot(5,:)];
    targetFoundOrNotCombinedCnUC(2,:)=[targetFoundOrNot(2,:),targetFoundOrNot(6,:)];
    targetFoundOrNotCombinedCnUC(3,:)=[targetFoundOrNot(3,:),targetFoundOrNot(7,:)];
    targetFoundOrNotCombinedCnUC(4,:)=[targetFoundOrNot(4,:),targetFoundOrNot(8,:)];

    netSearchTimeCombinedCnUC(1,:)=[netSearchTime(1,:),netSearchTime(5,:)];
    netSearchTimeCombinedCnUC(2,:)=[netSearchTime(2,:),netSearchTime(6,:)];
    netSearchTimeCombinedCnUC(3,:)=[netSearchTime(3,:),netSearchTime(7,:)];
    netSearchTimeCombinedCnUC(4,:)=[netSearchTime(4,:),netSearchTime(8,:)];

    fractionClosedLoop4TargetsFound = zeros(1,4);
    for i = 1:4
        numOnes = sum(targetFoundOrNotCombinedCnUC(i,:) == 1);
        fractionClosedLoop4TargetsFound(i) = numOnes/numel(targetFoundOrNotCombinedCnUC(i,:));

    end
    swarmTimeClosedLoop4 = netSearchTimeCombinedCnUC';
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

    targetFoundOrNotCombinedCnUC = -1*ones(4,40);
    netSearchTimeCombinedCnUC = -1*ones(4,40);
    targetFoundOrNotCombinedCnUC(1,:)=[targetFoundOrNot(1,:),targetFoundOrNot(5,:)];
    targetFoundOrNotCombinedCnUC(2,:)=[targetFoundOrNot(2,:),targetFoundOrNot(6,:)];
    targetFoundOrNotCombinedCnUC(3,:)=[targetFoundOrNot(3,:),targetFoundOrNot(7,:)];
    targetFoundOrNotCombinedCnUC(4,:)=[targetFoundOrNot(4,:),targetFoundOrNot(8,:)];

    netSearchTimeCombinedCnUC(1,:)=[netSearchTime(1,:),netSearchTime(5,:)];
    netSearchTimeCombinedCnUC(2,:)=[netSearchTime(2,:),netSearchTime(6,:)];
    netSearchTimeCombinedCnUC(3,:)=[netSearchTime(3,:),netSearchTime(7,:)];
    netSearchTimeCombinedCnUC(4,:)=[netSearchTime(4,:),netSearchTime(8,:)];

    fractionRandomSearchTargetsFound = zeros(1,4);
    for i = 1:4
        numOnes = sum(targetFoundOrNotCombinedCnUC(i,:) == 1);
        fractionRandomSearchTargetsFound(i) = numOnes/numel(targetFoundOrNotCombinedCnUC(i,:));

    end
    swarmTimeRandomSearch = netSearchTimeCombinedCnUC';
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
    targetFoundOrNotCombinedCnUC = -1*ones(4,40);
    netSearchTimeCombinedCnUC = -1*ones(4,40);
    targetFoundOrNotCombinedCnUC(1,:)=[targetFoundOrNot(1,:),targetFoundOrNot(5,:)];
    targetFoundOrNotCombinedCnUC(2,:)=[targetFoundOrNot(2,:),targetFoundOrNot(6,:)];
    targetFoundOrNotCombinedCnUC(3,:)=[targetFoundOrNot(3,:),targetFoundOrNot(7,:)];
    targetFoundOrNotCombinedCnUC(4,:)=[targetFoundOrNot(4,:),targetFoundOrNot(8,:)];

    netSearchTimeCombinedCnUC(1,:)=[netSearchTime(1,:),netSearchTime(5,:)];
    netSearchTimeCombinedCnUC(2,:)=[netSearchTime(2,:),netSearchTime(6,:)];
    netSearchTimeCombinedCnUC(3,:)=[netSearchTime(3,:),netSearchTime(7,:)];
    netSearchTimeCombinedCnUC(4,:)=[netSearchTime(4,:),netSearchTime(8,:)];

    fractionSpiralSearchTargetsFound = zeros(1,4);
    for i = 1:4
        numOnes = sum(targetFoundOrNotCombinedCnUC(i,:) == 1);
        fractionSpiralSearchTargetsFound(i) = numOnes/numel(targetFoundOrNotCombinedCnUC(i,:));

    end
    swarmTimeSpiralSearch = netSearchTimeCombinedCnUC';


    %% %%%%%%%%%%%%%%%%%%%%%% Plotssssss %%%%%%%%%%%%%%%%%%%%%%%%
    %trialNames = {'NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'};
    %%% fract found
    figure(1)
    %clf;
    subplot(1,3,lmn)
    scatter(1:1:4,fractionClosedLoop1TargetsFound,400,'d','filled','MarkerFaceColor',[1 .2 .2],'MarkerFaceAlpha',0.6);
    hold on
    scatter(1:1:4,fractionClosedLoop2TargetsFound,400,'s','filled','MarkerFaceColor',[0.2 0.5 1.0],'MarkerFaceAlpha',0.6);
    scatter(1:1:4,fractionClosedLoop3TargetsFound,400,'o','filled','MarkerFaceColor',[0.5 0.5 0.5],'MarkerFaceAlpha',0.6);
    scatter(1:1:4,fractionClosedLoop4TargetsFound,400,'^','filled','MarkerFaceColor',[1 0.5 0.1],'MarkerFaceAlpha',0.6);
    scatter(1:1:4,fractionRandomSearchTargetsFound,400,'v','filled','MarkerFaceColor',[0.2 1.0 0.2],'MarkerFaceAlpha',0.6);
    scatter(1:1:4,fractionSpiralSearchTargetsFound,400,'h','filled','MarkerFaceColor',[0.5 0.5 0.5],'MarkerFaceAlpha',0.6);
    scatter(1:1:4,fractionHumanTargetsFound,200,'s','MarkerEdgeColor',[0 0 0],'LineWidth',1.5);
    grid on
    if(lmn == 1)
        legend('AsPkTk','AsPk','AsPkTkSA','AsPkSA','Rs','Ss','Experimental','NumColumns',2)

    end
    
    % legend("Follow Search","Closed Loop","Random Search")
    %ylabel("Fraction of trials target found by swarm")
    if(lmn == 1)
        ylabel("Success rate")

    end
    if(lmn == 1)
        xlabel({" ","(a)"})
    end
    if(lmn == 2)
        xlabel({"Conditions (Person know Y/N, Terrain Know. Y/N)","(b)"})
    end
    if(lmn == 3)
        xlabel({" ","(c)"})
    end
    set(gca,'xtick',1:8,'xticklabel',trialNames)
    ylim([0, 1]);

    %%%%%%%%% Search time
    figure(2)
    subplot(1,3,lmn)
    %clf;
    % % subplot(1,3,lmn)
    % % cats = [ones(size(swarmTimeClosedLoop1,1),1);2*ones(size(swarmTimeClosedLoop1,1),1); ...
    % %     3*ones(size(swarmTimeClosedLoop1,1),1);4*ones(size(swarmTimeClosedLoop1,1),1) ...
    % %     ;5*ones(size(swarmTimeClosedLoop1,1),1);6*ones(size(swarmTimeClosedLoop1,1),1);7*ones(size(swarmTimeClosedLoop1,1),1)];
    % % aggData = [swarmTimeClosedLoop1;swarmTimeClosedLoop2;swarmTimeClosedLoop3;swarmTimeClosedLoop4;swarmTimeRandomSearch; ...
    % %     swarmTimeSpiralSearch;humanTime ];
    % % categories = categorical(cats,[1 2 3 4 5 6 7],{'Closed Loop type 1','Closed Loop type 2','Closed Loop type 3','Closed Loop type 4','Random Search','Spiral Search','Human Search'});
    % % c = 1;
    % % l = [];
    % % for i = 1:4
    % %     l(i) = c;
    % %     h = boxchart(c*ones(size(aggData(:,i))),aggData(:,i),'GroupByColor',categories);
    % %     c = c + 1.5;
    % %     hold on
    % %     h(1).BoxFaceColor='r';
    % %     h(2).BoxFaceColor='b';
    % %     h(3).BoxFaceColor='g';
    % %     h(4).BoxFaceColor='m';
    % %     h(5).BoxFaceColor='c';
    % %     h(6).BoxFaceColor='k';
    % %     h(7).BoxFaceColor='y';
    % %     % if(i == 1)
    % %     %     legend('Follow Search','Closed Loop','Random Search','Spiral');
    % %     % end
    % % 
    % % end
% aggData = [swarmTimeClosedLoop1;swarmTimeClosedLoop2;swarmTimeClosedLoop3;swarmTimeClosedLoop4;swarmTimeRandomSearch;swarmTimeSpiralSearch;humanTime ];
meanAggData = [nanmean(swarmTimeClosedLoop1);nanmean(swarmTimeClosedLoop2);nanmean(swarmTimeClosedLoop3);nanmean(swarmTimeClosedLoop4);
    nanmean(swarmTimeRandomSearch);nanmean(swarmTimeSpiralSearch);nanmean(humanTime)];
stdAggData = [nanstd(swarmTimeClosedLoop1);nanstd(swarmTimeClosedLoop2);nanstd(swarmTimeClosedLoop3);nanstd(swarmTimeClosedLoop4);
    nanstd(swarmTimeRandomSearch);nanstd(swarmTimeSpiralSearch);nanstd(humanTime)];

    scatter([1,4,7,10]-0.9,meanAggData(1,:),300,'d','filled','MarkerFaceColor',[1 .2 .2],'MarkerFaceAlpha',0.6);
    hold on
    bnmy = errorbar([1,4,7,10]-0.9,meanAggData(1,:),stdAggData(1,:),'.','Color',[1 .2 .2]);
    alpha(bnmy,0.4)
    
    scatter([1,4,7,10]-0.6,meanAggData(2,:),300,'s','filled','MarkerFaceColor',[0.2 0.5 1.0],'MarkerFaceAlpha',0.6);
    errorbar([1,4,7,10]-0.6,meanAggData(2,:),stdAggData(2,:),'.','Color',[0.2 0.5 1.0]);

    
    scatter([1,4,7,10]-0.3,meanAggData(3,:),300,'o','filled','MarkerFaceColor',[0.5 0.5 0.5],'MarkerFaceAlpha',0.6);
    errorbar([1,4,7,10]-0.3,meanAggData(3,:),stdAggData(3,:),'.','Color',[0.5 0.5 0.5]);

    
    scatter([1,4,7,10]+0,meanAggData(4,:),300,'^','filled','MarkerFaceColor',[1 0.5 0.1],'MarkerFaceAlpha',0.6);
    errorbar([1,4,7,10]+0,meanAggData(4,:),stdAggData(4,:),'.','Color',[1 0.5 0.1]);

    
    scatter([1,4,7,10]+0.3,meanAggData(5,:),300,'v','filled','MarkerFaceColor',[0.2 1.0 0.2],'MarkerFaceAlpha',0.6);
    errorbar([1,4,7,10]+0.3,meanAggData(5,:),stdAggData(5,:),'.','Color',[0.2 1.0 0.2]);

    
    scatter([1,4,7,10]+0.6,meanAggData(6,:),300,'h','filled','MarkerFaceColor',[0.5 0.5 0.5],'MarkerFaceAlpha',0.6);
    hold on
    errorbar([1,4,7,10]+0.6,meanAggData(6,:),stdAggData(6,:),'.','Color',[0.5 0.5 0.5]);

    
    scatter([1,4,7,10]+0.9,meanAggData(7,:),300,'s','MarkerEdgeColor',[0 0 0],'LineWidth',1.3);
    hold on
    errorbar([1,4,7,10]+0.9,meanAggData(7,:),stdAggData(7,:),'.','Color',[0 0 0]);

    xlim([-1 12])


    % scatter(1:1:4,fractionClosedLoop2TargetsFound,400,'s','filled','MarkerFaceColor',[0.2 0.5 1.0],'MarkerFaceAlpha',0.4);
    % scatter(1:1:4,fractionClosedLoop3TargetsFound,400,'d','filled','MarkerFaceColor',[0.5 0.5 0.5],'MarkerFaceAlpha',0.4);
    % scatter(1:1:4,fractionClosedLoop4TargetsFound,400,'^','filled','MarkerFaceColor',[1 0.5 0.1],'MarkerFaceAlpha',0.4);
    % scatter(1:1:4,fractionRandomSearchTargetsFound,400,'d','filled','MarkerFaceColor',[0.2 1.0 0.2],'MarkerFaceAlpha',0.4);
    % scatter(1:1:4,fractionSpiralSearchTargetsFound,400,'s','filled','MarkerFaceColor',[0.5 0.5 0.5],'MarkerFaceAlpha',0.4);
    % scatter(1:1:4,fractionHumanTargetsFound,200,'s','MarkerEdgeColor',[0 0 0],'LineWidth',1.5);
    grid on
    
    if(lmn == 1)
        ylabel("Time-to-find (s)")
    end
    if(lmn == 1)
        xlabel({" ","(a)"})
    end
    if(lmn == 2)
        xlabel({"Conditions (Person know Y/N, Terrain Know. Y/N)","(b)"})
    end
    if(lmn == 3)
        xlabel({" ","(c)"})
    end
    
    xticks([1,4,7,10]);
    xticklabels(trialNames)
    if(lmn == 1)
        legend('AsPkTk','','AsPk','','AsPkTkSA','','AsPkSA','','Rs','','Ss','','Experimental','');
    end
    
    ylim([-50, 600]);
end
