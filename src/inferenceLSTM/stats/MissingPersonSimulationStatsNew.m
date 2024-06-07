clearvars
close all
clc


addpath("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\")
subject = cellstr(num2str(readmatrix('..\..\..\data\participantID1.csv')));
preFolder = '..\..\..\data\';
trialNames = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
trialNum = [111,211,121,221,112,212,122,222];
auvNumber=20; %[5 10 20]
numRuns = [1];
humanTimeToLand = 15;
simulationMode = {'followSearch','LSTMSearch','randomSearch','spiralFollowSearch','spiralRandomSearch'};

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

closedLoop = [];
spiralRandom = [];
spriralFollow = [];
random = [];
follow = [];

%% Follow Search
targetFoundOrNot = zeros(1,numel(trialNum),20);
swarmTimeGained = zeros(1,numel(trialNum),20);
preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(1)),"\");
counter = 1;
for i = 1:numel(subject)
    for j = 1:numel(trialNum)
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
                targetFoundOrNot(counter,j,i) = 0;
                swarmTimeGained(counter,j,i) = 0;
                counter = counter+1;
            end

            if(abs(swarmSearchLength) < humanSearchLength - 15)
                targetFoundOrNot(counter,j,i) = 1;
                swarmTimeGained(counter,j,i) = humanSearchLength - 15-abs(swarmSearchLength);
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

% Do the stats
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
targetFoundOrNot = zeros(1,numel(trialNum),20);
swarmTimeGained = zeros(1,numel(trialNum),20);
preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(2)),"\");
counter = 1;
for i = 1:numel(subject)
    for j = 1:numel(trialNum)
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
                targetFoundOrNot(counter,j,i) = 0;
                swarmTimeGained(counter,j,i) = 0;
                counter = counter+1;
            end

            if(abs(swarmSearchLength) < humanSearchLength - 15)
                targetFoundOrNot(counter,j,i) = 1;
                swarmTimeGained(counter,j,i) = humanSearchLength - 15-abs(swarmSearchLength);
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

% Do the stats
% Throw away zeros
swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);
sumTargetFoundOrNotReshaped = sum(targetFoundOrNotReshaped);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped/size(targetFoundOrNotReshaped,1);

meanClosedLoopTimeGained = meanSwarmTimeGainedReshaped;
stdClosedLoopTimeGained = stdSwarmTimeGainedReshaped; 
fractionClosedLoopTimeGained = fractionOfTrialsTargetFound;


%% Random Search
targetFoundOrNot = zeros(1,numel(trialNum),20);
swarmTimeGained = zeros(1,numel(trialNum),20);
preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(3)),"\");
counter = 1;
for i = 1:numel(subject)
    for j = 1:numel(trialNum)
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
                targetFoundOrNot(counter,j,i) = 0;
                swarmTimeGained(counter,j,i) = 0;
                counter = counter+1;
            end

            if(abs(swarmSearchLength) < humanSearchLength - 15)
                targetFoundOrNot(counter,j,i) = 1;
                swarmTimeGained(counter,j,i) = humanSearchLength - 15-abs(swarmSearchLength);
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

% Do the stats
% Throw away zeros
swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);
sumTargetFoundOrNotReshaped = sum(targetFoundOrNotReshaped);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped/size(targetFoundOrNotReshaped,1);

meanRandomSearchTimeGained = meanSwarmTimeGainedReshaped;
stdRandomSearchTimeGained = stdSwarmTimeGainedReshaped; 
fractionRandomSearchTimeGained = fractionOfTrialsTargetFound;

%% Spiral Follow
targetFoundOrNot = zeros(1,numel(trialNum),20);
swarmTimeGained = zeros(1,numel(trialNum),20);
preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(4)),"\");
counter = 1;
for i = 1:numel(subject)
    for j = 1:numel(trialNum)
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
                targetFoundOrNot(counter,j,i) = 0;
                swarmTimeGained(counter,j,i) = 0;
                counter = counter+1;
            end

            if(abs(swarmSearchLength) < humanSearchLength - 15)
                targetFoundOrNot(counter,j,i) = 1;
                swarmTimeGained(counter,j,i) = humanSearchLength - 15-abs(swarmSearchLength);
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

% Do the stats
% Throw away zeros
swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);
sumTargetFoundOrNotReshaped = sum(targetFoundOrNotReshaped);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped/size(targetFoundOrNotReshaped,1);

meanSpiralFollowTimeGained = meanSwarmTimeGainedReshaped;
stdSpiralFollowTimeGained = stdSwarmTimeGainedReshaped; 
fractionSpiralFollowTimeGained = fractionOfTrialsTargetFound;

%% Spiral Random
targetFoundOrNot = zeros(1,numel(trialNum),20);
swarmTimeGained = zeros(1,numel(trialNum),20);
preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(5)),"\");
counter = 1;
for i = 1:numel(subject)
    for j = 1:numel(trialNum)
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
                targetFoundOrNot(counter,j,i) = 0;
                swarmTimeGained(counter,j,i) = 0;
                counter = counter+1;
            end

            if(abs(swarmSearchLength) < humanSearchLength - 15)
                targetFoundOrNot(counter,j,i) = 1;
                swarmTimeGained(counter,j,i) = humanSearchLength - 15-abs(swarmSearchLength);
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

% Do the stats
% Throw away zeros
swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);
sumTargetFoundOrNotReshaped = sum(targetFoundOrNotReshaped);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped/size(targetFoundOrNotReshaped,1);

meanSpiralRandomTimeGained = meanSwarmTimeGainedReshaped;
stdSpiralRandomTimeGained = stdSwarmTimeGainedReshaped; 
fractionSpiralRandomTimeGained = fractionOfTrialsTargetFound;

%% Plotssssss
%trialNames = {'NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'};
figure(1)
clf;
subplot(1,2,1)
scatter(1:1:8,fractionFollowSwarmTargetsFound,100,'d','filled','MarkerFaceColor',[1 .2 .2]);
hold on
scatter(1:1:8,fractionClosedLoopTimeGained,50,'s','filled','MarkerFaceColor',[0.2 .2 1.0]);
scatter(1:1:8,fractionRandomSearchTimeGained,40,'d','filled','MarkerFaceColor',[0.2 1.0 0.2]);
scatter(1:1:8,fractionSpiralFollowTimeGained,70,'s','filled','MarkerFaceColor',[0.5 0.5 0.5]);
scatter(1:1:8,fractionSpiralRandomTimeGained,80,'d','filled','MarkerFaceColor',[0.1 0.5 0.5]);
grid on
legend("Follow Search","Closed Loop","Random Search","Spiral Follow", "Spiral Random")
% legend("Follow Search","Closed Loop","Random Search")
%ylabel("Fraction of trials target found by swarm")
ylabel("Fraction of trials target found by human swarm team compared to single human")
xlabel("Conditions")
set(gca,'xtick',1:8,'xticklabel',trialNames)
ylim([0, 1]);

subplot(1,2,2)
scatter(1:1:8,meanFollowSwarmTimeGained,100,'d','filled','MarkerFaceColor',[1 .2 .2]);
errorbar(1:1:8,meanFollowSwarmTimeGained,stdFollowSwarmTimeGained, 'vertical', 'color',[1 .2 .2]);
hold on
scatter(1:1:8,meanClosedLoopTimeGained,60,'p','filled','MarkerFaceColor',[0.2 .2 1.0]);
errorbar(1:1:8,meanClosedLoopTimeGained,stdClosedLoopTimeGained, 'vertical', 'color',[0.2 .2 1]);

scatter(1:1:8,meanRandomSearchTimeGained,60,'h','filled','MarkerFaceColor',[0.2 1.0 0.2]);
errorbar(1:1:8,meanRandomSearchTimeGained,stdRandomSearchTimeGained, 'vertical', 'color',[0.2 1.0 0.2]);

% scatter(1:1:8,meanSpiralFollowTimeGained,60,'s','filled','MarkerFaceColor',[0.5 0.5 0.5]);
% errorbar(1:1:8,meanSpiralFollowTimeGained,stdSpiralFollowTimeGained, 'vertical', 'color',[0.5 0.5 0.5]);
% 
% scatter(1:1:8,meanSpiralRandomTimeGained,60,'+','filled','MarkerFaceColor',[0.1 0.5 0.5]);
% errorbar(1:1:8,meanSpiralRandomTimeGained,stdSpiralRandomTimeGained, 'vertical', 'color',[0.1 0.5 0.5]);


ylim([-100, 600]);

grid on
%legend("Follow Search","","Closed Loop","","Random Search","","Spiral Follow","", "Spiral Random","")
legend("Follow Search","","Closed Loop","","Random Search","")
ylabel("Average time gain")
xlabel("Conditions")
set(gca,'xtick',1:8,'xticklabel',trialNames)

titleString = strcat("Swarm Size: ",num2str(auvNumber));
sgtitle(titleString)
