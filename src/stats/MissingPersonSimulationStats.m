clearvars
close all
clc

addpath("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\")
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\';
trialName = {'dontUse','NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'};  % Person, Terrain, Swarm cohesion
auvNumber= 5; %[5 10 20]
numRuns = [1];
humanTimeToLand = 15;
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [0,111,211,121,221,112,212,122,222];

c = 1;
time2FinishBySubject = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 2:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','time_to_finish.csv'];
        if isfile(fileName)
            time2FinishBySubject(ii,j-1) = readmatrix(fileName);
            c = c + 1;
        end
        if ~isfile(fileName)
            time2FinishBySubject(ii,j-1) = nan;
            c = c + 1;
        end
    end
end

%% Random Search
%preFolder = D:\UWmonitoring\RunMissingPersonSim\simulationRecord\RandomSearch\66194\112\10
searchType = "RandomSearch";
targetFoundOrNot = zeros(1,numel(trialNum)-1,20);
swarmTimeGained = zeros(1,numel(trialNum)-1,20);
preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",searchType);
counter = 1;
for i = 1:numel(subject)
    for j = 2:numel(trialNum)
        counter = 1;
        for k = 1:numel(numRuns)
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
            if(swarmSearchLength<0 || abs(swarmSearchLength) >= humanSearchLength - 15)
                targetFoundOrNot(counter,j-1,i) = 0;
                swarmTimeGained(counter,j-1,i) = 0;
                counter = counter+1;
            end

            if(abs(swarmSearchLength) < humanSearchLength - 15)
                targetFoundOrNot(counter,j-1,i) = 1;
                swarmTimeGained(counter,j-1,i) = humanSearchLength - 15-abs(swarmSearchLength);
                counter = counter+1;
            end

            %[preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','swarmFoundTime.csv'];
        end

    end
end

targetFoundOrNotReshaped = [];
swarmTimeGainedReshaped = [];
for i = 1:size(swarmTimeGained,3)
targetFoundOrNotReshaped = [targetFoundOrNotReshaped;targetFoundOrNot(:,:,i)];
swarmTimeGainedReshaped = [swarmTimeGainedReshaped;swarmTimeGained(:,:,i)];
end

%Do the stats

swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);
sumTargetFoundOrNotReshaped = sum(targetFoundOrNotReshaped);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped/size(targetFoundOrNotReshaped,1);

meanRandomSwarmTimeGained = meanSwarmTimeGainedReshaped;
stdRandomSwarmTimeGained = stdSwarmTimeGainedReshaped; 
fractionRandomSwarmTargetsFound = fractionOfTrialsTargetFound;

%% Follow Search
%preFolder = D:\UWmonitoring\RunMissingPersonSim\simulationRecord\RandomSearch\66194\112\10
searchType = "FollowSearch";
targetFoundOrNot = zeros(1,numel(trialNum)-1,20);
swarmTimeGained = zeros(1,numel(trialNum)-1,20);
preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",searchType);
counter = 1;
for i = 1:numel(subject)
    for j = 2:numel(trialNum)
        counter = 1;
        for k = 1:numel(numRuns)
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
            if(swarmSearchLength<0 || abs(swarmSearchLength) >= humanSearchLength - humanTimeToLand)
                targetFoundOrNot(counter,j-1,i) = 0;
                swarmTimeGained(counter,j-1,i) = 0;
                counter = counter+1;
            end

            if(abs(swarmSearchLength) < humanSearchLength - humanTimeToLand)
                targetFoundOrNot(counter,j-1,i) = 1;
                swarmTimeGained(counter,j-1,i) = humanSearchLength - humanTimeToLand-abs(swarmSearchLength);
                counter = counter+1;
            end

            %[preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','swarmFoundTime.csv'];
        end

    end
end

targetFoundOrNotReshaped = [];
swarmTimeGainedReshaped = [];
for i = 1:size(swarmTimeGained,3)
targetFoundOrNotReshaped = [targetFoundOrNotReshaped;targetFoundOrNot(:,:,i)];
swarmTimeGainedReshaped = [swarmTimeGainedReshaped;swarmTimeGained(:,:,i)];
end

%Do the stats
% Throw away zeros
swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);
sumTargetFoundOrNotReshaped = sum(targetFoundOrNotReshaped);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped/size(targetFoundOrNotReshaped,1);

meanFollowSwarmTimeGained = meanSwarmTimeGainedReshaped;
stdFollowSwarmTimeGained = stdSwarmTimeGainedReshaped; 
fractionFollowSwarmTargetsFound = fractionOfTrialsTargetFound;


%% LSTM Search
%preFolder = D:\UWmonitoring\RunMissingPersonSim\simulationRecord\RandomSearch\66194\112\10
searchType = "LSTMSearch";
targetFoundOrNot = zeros(1,numel(trialNum)-1,20);
swarmTimeGained = zeros(1,numel(trialNum)-1,20);
preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",searchType);
counter = 1;
for i = 1:numel(subject)
    for j = 2:numel(trialNum)
        counter = 1;
        for k = 1:numel(numRuns(1))
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
            if(swarmSearchLength<0 || abs(swarmSearchLength) >= humanSearchLength - humanTimeToLand)
                targetFoundOrNot(counter,j-1,i) = 0;
                swarmTimeGained(counter,j-1,i) = 0;
                counter = counter+1;
            end

            if(abs(swarmSearchLength) < humanSearchLength - humanTimeToLand)
                targetFoundOrNot(counter,j-1,i) = 1;
                swarmTimeGained(counter,j-1,i) = humanSearchLength - humanTimeToLand-abs(swarmSearchLength);
                counter = counter+1;
            end

            %[preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','swarmFoundTime.csv'];
        end

    end
end

targetFoundOrNotReshaped = [];
swarmTimeGainedReshaped = [];
for i = 1:size(swarmTimeGained,3)
targetFoundOrNotReshaped = [targetFoundOrNotReshaped;targetFoundOrNot(:,:,i)];
swarmTimeGainedReshaped = [swarmTimeGainedReshaped;swarmTimeGained(:,:,i)];
end

%Do the stats
% Throw away zeros
swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);
sumTargetFoundOrNotReshaped = sum(targetFoundOrNotReshaped);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped/size(targetFoundOrNotReshaped,1);

meanLSTMSwarmTimeGained = meanSwarmTimeGainedReshaped;
stdLSTMSwarmTimeGained = stdSwarmTimeGainedReshaped; 
fractionLSTMSwarmTargetsFound = fractionOfTrialsTargetFound;

%% Plotssssss
trialNames = {'NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'};
figure(1)
subplot(1,2,1)
scatter(1:1:8,fractionFollowSwarmTargetsFound,100,'d','filled','MarkerFaceColor',[1 .2 .2]);
hold on
scatter(1:1:8,fractionRandomSwarmTargetsFound,60,'s','filled','MarkerFaceColor',[0.2 .2 1.0]);
scatter(1:1:8,fractionLSTMSwarmTargetsFound,60,'^','filled','MarkerFaceColor',[0.2 1.0 0.2]);
grid on
legend("Follow Human","Random Search","Closed Loop")
ylabel("Fraction of trials target found by swarm")
xlabel("Conditions")
set(gca,'xtick',1:8,'xticklabel',trialNames)
ylim([0, 1]);

subplot(1,2,2)
scatter(1:1:8,meanFollowSwarmTimeGained,100,'d','filled','MarkerFaceColor',[1 .2 .2]);
errorbar(1:1:8,meanFollowSwarmTimeGained,stdFollowSwarmTimeGained, 'vertical', 'color',[1 .2 .2]);
hold on
scatter(1:1:8,meanRandomSwarmTimeGained,60,'s','filled','MarkerFaceColor',[0.2 .2 1.0]);
errorbar(1:1:8,meanRandomSwarmTimeGained,stdRandomSwarmTimeGained, 'vertical', 'color',[0.2 .2 1]);

scatter(1:1:8,meanLSTMSwarmTimeGained,60,'^','filled','MarkerFaceColor',[0.2 1.0 0.2]);
errorbar(1:1:8,meanLSTMSwarmTimeGained,stdLSTMSwarmTimeGained, 'vertical', 'color',[0.2 1.0 0.2]);
ylim([-100, 600]);

grid on
legend("Follow Human","","Random Search","","Closed Loop","")
ylabel("Average time gain")
xlabel("Conditions")
set(gca,'xtick',1:8,'xticklabel',trialNames)

titleString = strcat("Swarm Size: ",num2str(auvNumber));
sgtitle(titleString)
