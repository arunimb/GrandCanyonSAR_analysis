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
auvNumber = 5; %[5 10 15]
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

closedLoop = [];
spiralRandom = [];
spriralFollow = [];
random = [];
follow = [];

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

            % if(swarmSearchLength < 0)
            %     swarmTimeFound(j,i) = nan;
            %     if(humanSearchLength >= 599)
            %         netSearchTime(j,i) = 600;
            %         targetFoundOrNot(j,i) = 0;
            %     end
            %     if(humanSearchLength < 599)
            %         netSearchTime(j,i) = humanSearchLength;
            %     end
            % 
            % end
            % 
            % if(swarmSearchLength > 0)
            %     targetFoundBySwarm(j,i) = 1;
            %     swarmTimeFound(j,i) = swarmSearchLength;
            %     if(swarmSearchLength > humanSearchLength)
            %         netSearchTime(j,i) = humanSearchLength;
            %         targetFoundOrNot(j,i) = 0;
            %     end
            %     if(swarmSearchLength < humanSearchLength - humanTimeToLand)
            %         netSearchTime(j,i) = swarmSearchLength;
            %         targetFoundOrNot(j,i) = 1;
            %         swarmTimeGained(j,i) = humanSearchLength - humanTimeToLand - swarmSearchLength;
            %     end
            % end
        end
    end
end

targetFoundBySwarmOrNot = [];
targetFoundOrNotReshaped = [];
swarmTimeGainedReshaped = [];
netSearchTimeReshaped = [];
swarmSearchTimeReshaped = [];
for i = 1:size(swarmTimeGained,2)
    targetFoundOrNotReshaped = [targetFoundOrNotReshaped;targetFoundOrNot(:,i)'];
    swarmTimeGainedReshaped = [swarmTimeGainedReshaped;swarmTimeGained(:,i)'];
    netSearchTimeReshaped = [netSearchTimeReshaped;netSearchTime(:,i)'];
    targetFoundBySwarmOrNot = [targetFoundBySwarmOrNot;targetFoundBySwarm(:,i)'];
    swarmSearchTimeReshaped = [swarmSearchTimeReshaped;swarmTimeFound(:,i)'];
end
%% replace nan value with the value equal to its corresponding trial value
for i = 1:size(swarmSearchTimeReshaped,2)
    for j = 1:size(trialNumIndices,1)
        if(isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,1))) && ~isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,2))))
            swarmSearchTimeReshaped(i,trialNumIndices(j,1)) = swarmSearchTimeReshaped(i,trialNumIndices(j,2));
        end
        if(isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,2))) && ~isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,1))))
            swarmSearchTimeReshaped(i,trialNumIndices(j,2)) = swarmSearchTimeReshaped(i,trialNumIndices(j,1));
        end
    end
    %swarmSearchTimeReshaped = [swarmSearchTimeReshaped;swarmTimeFound(:,i)'];
end

% Do the stats
% Throw away zeros
%% average clustered+unclustered
tempp1 = [];
tempp2 = [];
tempp3 = [];
for i = 1:size(trialNumIndices,1)
    tempp1(:,i) = (swarmTimeGainedReshaped(:,trialNumIndices(i,1))+swarmTimeGainedReshaped(:,trialNumIndices(i,2)))/2;
    tempp2(:,i) = (netSearchTimeReshaped(:,trialNumIndices(i,1))+netSearchTimeReshaped(:,trialNumIndices(i,2)))/2;
    tempp3(:,i) = (swarmSearchTimeReshaped(:,trialNumIndices(i,1))+swarmSearchTimeReshaped(:,trialNumIndices(i,2)))/2;
end

%% sum clustered+unclustered
tempp4  = [];
tempp5  = [];
for i = 1:size(trialNumIndices,1)
    tempp4(:,i)= targetFoundOrNotReshaped(:,trialNumIndices(i,1))+targetFoundOrNotReshaped(:,trialNumIndices(i,2));
    tempp5(:,i)= targetFoundBySwarm(:,trialNumIndices(i,1))+targetFoundBySwarm(:,trialNumIndices(i,2));
end

swarmTimeGainedReshaped = tempp1;
netSearchTimeReshaped = tempp2;
swarmSearchTimeReshaped = tempp3;
targetFoundOrNotReshaped = tempp4;
targetFoundBySwarm = tempp5;



swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
netSearchTimeReshaped(netSearchTimeReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);

meanSwarmTimeReshaped = nanmean(swarmSearchTimeReshaped); %%
stdSwarmTimeReshaped = nanstd(swarmSearchTimeReshaped); %%

meanHsiSearchTime = nanmean(netSearchTimeReshaped);
stdHsiSearchTime = nanstd(netSearchTimeReshaped);


sumTargetFoundOrNotReshaped = sum(targetFoundBySwarm);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped./size(targetFoundBySwarm,1)/2;

meanClosedLoop1Time = meanSwarmTimeReshaped; %%
stdClosedLoop1Time = stdSwarmTimeReshaped; %%
meanClosedLoop1SwarmTime = meanHsiSearchTime;
stdClosedLoop1SwarmTime = stdHsiSearchTime;

fractionClosedLoop1TargetsFound = fractionOfTrialsTargetFound; %%
swarmTimeClosedLoop1 = swarmSearchTimeReshaped; %%

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

            if(swarmSearchLength < 0)
                swarmTimeFound(j,i) = nan;
                if(humanSearchLength >= 599)
                    netSearchTime(j,i) = 600;
                    targetFoundOrNot(j,i) = 0;
                end
                if(humanSearchLength < 599)
                    netSearchTime(j,i) = humanSearchLength;
                end
                
            end

            if(swarmSearchLength > 0)
                targetFoundBySwarm(j,i) = 1;
                swarmTimeFound(j,i) = swarmSearchLength;
                if(swarmSearchLength > humanSearchLength)
                    netSearchTime(j,i) = humanSearchLength;
                    targetFoundOrNot(j,i) = 0;
                end
                if(swarmSearchLength < humanSearchLength - humanTimeToLand)
                    netSearchTime(j,i) = swarmSearchLength;
                    targetFoundOrNot(j,i) = 1;
                    swarmTimeGained(j,i) = humanSearchLength - humanTimeToLand - swarmSearchLength;
                end
            end
        end
    end
end

targetFoundBySwarmOrNot = [];
targetFoundOrNotReshaped = [];
swarmTimeGainedReshaped = [];
netSearchTimeReshaped = [];
swarmSearchTimeReshaped = [];
for i = 1:size(swarmTimeGained,2)
    targetFoundOrNotReshaped = [targetFoundOrNotReshaped;targetFoundOrNot(:,i)'];
    swarmTimeGainedReshaped = [swarmTimeGainedReshaped;swarmTimeGained(:,i)'];
    netSearchTimeReshaped = [netSearchTimeReshaped;netSearchTime(:,i)'];
    targetFoundBySwarmOrNot = [targetFoundBySwarmOrNot;targetFoundBySwarm(:,i)'];
    swarmSearchTimeReshaped = [swarmSearchTimeReshaped;swarmTimeFound(:,i)'];
end
%% replace nan value with the value equal to its corresponding trial value
for i = 1:size(swarmSearchTimeReshaped,2)
    for j = 1:size(trialNumIndices,1)
        if(isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,1))) && ~isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,2))))
            swarmSearchTimeReshaped(i,trialNumIndices(j,1)) = swarmSearchTimeReshaped(i,trialNumIndices(j,2));
        end
        if(isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,2))) && ~isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,1))))
            swarmSearchTimeReshaped(i,trialNumIndices(j,2)) = swarmSearchTimeReshaped(i,trialNumIndices(j,1));
        end
    end
    %swarmSearchTimeReshaped = [swarmSearchTimeReshaped;swarmTimeFound(:,i)'];
end

% Do the stats
% Throw away zeros
%% average clustered+unclustered
tempp1 = [];
tempp2 = [];
tempp3 = [];
for i = 1:size(trialNumIndices,1)
    tempp1(:,i) = (swarmTimeGainedReshaped(:,trialNumIndices(i,1))+swarmTimeGainedReshaped(:,trialNumIndices(i,2)))/2;
    tempp2(:,i) = (netSearchTimeReshaped(:,trialNumIndices(i,1))+netSearchTimeReshaped(:,trialNumIndices(i,2)))/2;
    tempp3(:,i) = (swarmSearchTimeReshaped(:,trialNumIndices(i,1))+swarmSearchTimeReshaped(:,trialNumIndices(i,2)))/2;
end

%% sum clustered+unclustered
tempp4  = [];
tempp5  = [];
for i = 1:size(trialNumIndices,1)
    tempp4(:,i)= targetFoundOrNotReshaped(:,trialNumIndices(i,1))+targetFoundOrNotReshaped(:,trialNumIndices(i,2));
    tempp5(:,i)= targetFoundBySwarm(:,trialNumIndices(i,1))+targetFoundBySwarm(:,trialNumIndices(i,2));
end

swarmTimeGainedReshaped = tempp1;
netSearchTimeReshaped = tempp2;
swarmSearchTimeReshaped = tempp3;
targetFoundOrNotReshaped = tempp4;
targetFoundBySwarm = tempp5;



swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
netSearchTimeReshaped(netSearchTimeReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);

meanSwarmTimeReshaped = nanmean(swarmSearchTimeReshaped); %%
stdSwarmTimeReshaped = nanstd(swarmSearchTimeReshaped); %%

meanHsiSearchTime = nanmean(netSearchTimeReshaped);
stdHsiSearchTime = nanstd(netSearchTimeReshaped);


sumTargetFoundOrNotReshaped = sum(targetFoundBySwarm);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped./size(targetFoundBySwarm,1)/2;

meanClosedLoop2Time = meanSwarmTimeReshaped; %%
stdClosedLoop2Time = stdSwarmTimeReshaped; %%
meanClosedLoop2SwarmTime = meanHsiSearchTime;
stdClosedLoop2SwarmTime = stdHsiSearchTime;

fractionClosedLoop2TargetsFound = fractionOfTrialsTargetFound; %%
swarmTimeClosedLoop2 = swarmSearchTimeReshaped; %%

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

            if(swarmSearchLength < 0)
                swarmTimeFound(j,i) = nan;
                if(humanSearchLength >= 599)
                    netSearchTime(j,i) = 600;
                    targetFoundOrNot(j,i) = 0;
                end
                if(humanSearchLength < 599)
                    netSearchTime(j,i) = humanSearchLength;
                end
                
            end

            if(swarmSearchLength > 0)
                targetFoundBySwarm(j,i) = 1;
                swarmTimeFound(j,i) = swarmSearchLength;
                if(swarmSearchLength > humanSearchLength)
                    netSearchTime(j,i) = humanSearchLength;
                    targetFoundOrNot(j,i) = 0;
                end
                if(swarmSearchLength < humanSearchLength - humanTimeToLand)
                    netSearchTime(j,i) = swarmSearchLength;
                    targetFoundOrNot(j,i) = 1;
                    swarmTimeGained(j,i) = humanSearchLength - humanTimeToLand - swarmSearchLength;
                end
            end
        end
    end
end

targetFoundBySwarmOrNot = [];
targetFoundOrNotReshaped = [];
swarmTimeGainedReshaped = [];
netSearchTimeReshaped = [];
swarmSearchTimeReshaped = [];
for i = 1:size(swarmTimeGained,2)
    targetFoundOrNotReshaped = [targetFoundOrNotReshaped;targetFoundOrNot(:,i)'];
    swarmTimeGainedReshaped = [swarmTimeGainedReshaped;swarmTimeGained(:,i)'];
    netSearchTimeReshaped = [netSearchTimeReshaped;netSearchTime(:,i)'];
    targetFoundBySwarmOrNot = [targetFoundBySwarmOrNot;targetFoundBySwarm(:,i)'];
    swarmSearchTimeReshaped = [swarmSearchTimeReshaped;swarmTimeFound(:,i)'];
end
%% replace nan value with the value equal to its corresponding trial value
for i = 1:size(swarmSearchTimeReshaped,2)
    for j = 1:size(trialNumIndices,1)
        if(isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,1))) && ~isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,2))))
            swarmSearchTimeReshaped(i,trialNumIndices(j,1)) = swarmSearchTimeReshaped(i,trialNumIndices(j,2));
        end
        if(isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,2))) && ~isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,1))))
            swarmSearchTimeReshaped(i,trialNumIndices(j,2)) = swarmSearchTimeReshaped(i,trialNumIndices(j,1));
        end
    end
    %swarmSearchTimeReshaped = [swarmSearchTimeReshaped;swarmTimeFound(:,i)'];
end

% Do the stats
% Throw away zeros
%% average clustered+unclustered
tempp1 = [];
tempp2 = [];
tempp3 = [];
for i = 1:size(trialNumIndices,1)
    tempp1(:,i) = (swarmTimeGainedReshaped(:,trialNumIndices(i,1))+swarmTimeGainedReshaped(:,trialNumIndices(i,2)))/2;
    tempp2(:,i) = (netSearchTimeReshaped(:,trialNumIndices(i,1))+netSearchTimeReshaped(:,trialNumIndices(i,2)))/2;
    tempp3(:,i) = (swarmSearchTimeReshaped(:,trialNumIndices(i,1))+swarmSearchTimeReshaped(:,trialNumIndices(i,2)))/2;
end

%% sum clustered+unclustered
tempp4  = [];
tempp5  = [];
for i = 1:size(trialNumIndices,1)
    tempp4(:,i)= targetFoundOrNotReshaped(:,trialNumIndices(i,1))+targetFoundOrNotReshaped(:,trialNumIndices(i,2));
    tempp5(:,i)= targetFoundBySwarm(:,trialNumIndices(i,1))+targetFoundBySwarm(:,trialNumIndices(i,2));
end

swarmTimeGainedReshaped = tempp1;
netSearchTimeReshaped = tempp2;
swarmSearchTimeReshaped = tempp3;
targetFoundOrNotReshaped = tempp4;
targetFoundBySwarm = tempp5;



swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
netSearchTimeReshaped(netSearchTimeReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);

meanSwarmTimeReshaped = nanmean(swarmSearchTimeReshaped); %%
stdSwarmTimeReshaped = nanstd(swarmSearchTimeReshaped); %%

meanHsiSearchTime = nanmean(netSearchTimeReshaped);
stdHsiSearchTime = nanstd(netSearchTimeReshaped);


sumTargetFoundOrNotReshaped = sum(targetFoundBySwarm);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped./size(targetFoundBySwarm,1)/2;

meanClosedLoop3Time = meanSwarmTimeReshaped; %%
stdClosedLoop3Time = stdSwarmTimeReshaped; %%
meanClosedLoop3SwarmTime = meanHsiSearchTime;
stdClosedLoop3SwarmTime = stdHsiSearchTime;

fractionClosedLoop3TargetsFound = fractionOfTrialsTargetFound; %%
swarmTimeClosedLoop3 = swarmSearchTimeReshaped; %%

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

            if(swarmSearchLength < 0)
                swarmTimeFound(j,i) = nan;
                if(humanSearchLength >= 599)
                    netSearchTime(j,i) = 600;
                    targetFoundOrNot(j,i) = 0;
                end
                if(humanSearchLength < 599)
                    netSearchTime(j,i) = humanSearchLength;
                end
                
            end

            if(swarmSearchLength > 0)
                targetFoundBySwarm(j,i) = 1;
                swarmTimeFound(j,i) = swarmSearchLength;
                if(swarmSearchLength > humanSearchLength)
                    netSearchTime(j,i) = humanSearchLength;
                    targetFoundOrNot(j,i) = 0;
                end
                if(swarmSearchLength < humanSearchLength - humanTimeToLand)
                    netSearchTime(j,i) = swarmSearchLength;
                    targetFoundOrNot(j,i) = 1;
                    swarmTimeGained(j,i) = humanSearchLength - humanTimeToLand - swarmSearchLength;
                end
            end
        end
    end
end

targetFoundBySwarmOrNot = [];
targetFoundOrNotReshaped = [];
swarmTimeGainedReshaped = [];
netSearchTimeReshaped = [];
swarmSearchTimeReshaped = [];
for i = 1:size(swarmTimeGained,2)
    targetFoundOrNotReshaped = [targetFoundOrNotReshaped;targetFoundOrNot(:,i)'];
    swarmTimeGainedReshaped = [swarmTimeGainedReshaped;swarmTimeGained(:,i)'];
    netSearchTimeReshaped = [netSearchTimeReshaped;netSearchTime(:,i)'];
    targetFoundBySwarmOrNot = [targetFoundBySwarmOrNot;targetFoundBySwarm(:,i)'];
    swarmSearchTimeReshaped = [swarmSearchTimeReshaped;swarmTimeFound(:,i)'];
end
%% replace nan value with the value equal to its corresponding trial value
for i = 1:size(swarmSearchTimeReshaped,2)
    for j = 1:size(trialNumIndices,1)
        if(isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,1))) && ~isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,2))))
            swarmSearchTimeReshaped(i,trialNumIndices(j,1)) = swarmSearchTimeReshaped(i,trialNumIndices(j,2));
        end
        if(isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,2))) && ~isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,1))))
            swarmSearchTimeReshaped(i,trialNumIndices(j,2)) = swarmSearchTimeReshaped(i,trialNumIndices(j,1));
        end
    end
    %swarmSearchTimeReshaped = [swarmSearchTimeReshaped;swarmTimeFound(:,i)'];
end

% Do the stats
% Throw away zeros
%% average clustered+unclustered
tempp1 = [];
tempp2 = [];
tempp3 = [];
for i = 1:size(trialNumIndices,1)
    tempp1(:,i) = (swarmTimeGainedReshaped(:,trialNumIndices(i,1))+swarmTimeGainedReshaped(:,trialNumIndices(i,2)))/2;
    tempp2(:,i) = (netSearchTimeReshaped(:,trialNumIndices(i,1))+netSearchTimeReshaped(:,trialNumIndices(i,2)))/2;
    tempp3(:,i) = (swarmSearchTimeReshaped(:,trialNumIndices(i,1))+swarmSearchTimeReshaped(:,trialNumIndices(i,2)))/2;
end

%% sum clustered+unclustered
tempp4  = [];
tempp5  = [];
for i = 1:size(trialNumIndices,1)
    tempp4(:,i)= targetFoundOrNotReshaped(:,trialNumIndices(i,1))+targetFoundOrNotReshaped(:,trialNumIndices(i,2));
    tempp5(:,i)= targetFoundBySwarm(:,trialNumIndices(i,1))+targetFoundBySwarm(:,trialNumIndices(i,2));
end

swarmTimeGainedReshaped = tempp1;
netSearchTimeReshaped = tempp2;
swarmSearchTimeReshaped = tempp3;
targetFoundOrNotReshaped = tempp4;
targetFoundBySwarm = tempp5;



swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
netSearchTimeReshaped(netSearchTimeReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);

meanSwarmTimeReshaped = nanmean(swarmSearchTimeReshaped); %%
stdSwarmTimeReshaped = nanstd(swarmSearchTimeReshaped); %%

meanHsiSearchTime = nanmean(netSearchTimeReshaped);
stdHsiSearchTime = nanstd(netSearchTimeReshaped);


sumTargetFoundOrNotReshaped = sum(targetFoundBySwarm);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped./size(targetFoundBySwarm,1)/2;

meanClosedLoop4Time = meanSwarmTimeReshaped; %%
stdClosedLoop4Time = stdSwarmTimeReshaped; %%
meanClosedLoop4SwarmTime = meanHsiSearchTime;
stdClosedLoop4SwarmTime = stdHsiSearchTime;

fractionClosedLoop4TargetsFound = fractionOfTrialsTargetFound; %%
swarmTimeClosedLoop4 = swarmSearchTimeReshaped; %%

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

            if(swarmSearchLength < 0)
                swarmTimeFound(j,i) = nan;
                if(humanSearchLength >= 599)
                    netSearchTime(j,i) = 600;
                    targetFoundOrNot(j,i) = 0;
                end
                if(humanSearchLength < 599)
                    netSearchTime(j,i) = humanSearchLength;
                end
                
            end

            if(swarmSearchLength > 0)
                targetFoundBySwarm(j,i) = 1;
                swarmTimeFound(j,i) = swarmSearchLength;
                if(swarmSearchLength > humanSearchLength)
                    netSearchTime(j,i) = humanSearchLength;
                    targetFoundOrNot(j,i) = 0;
                end
                if(swarmSearchLength < humanSearchLength - humanTimeToLand)
                    netSearchTime(j,i) = swarmSearchLength;
                    targetFoundOrNot(j,i) = 1;
                    swarmTimeGained(j,i) = humanSearchLength - humanTimeToLand - swarmSearchLength;
                end
            end
        end
    end
end

targetFoundBySwarmOrNot = [];
targetFoundOrNotReshaped = [];
swarmTimeGainedReshaped = [];
netSearchTimeReshaped = [];
swarmSearchTimeReshaped = [];
for i = 1:size(swarmTimeGained,2)
    targetFoundOrNotReshaped = [targetFoundOrNotReshaped;targetFoundOrNot(:,i)'];
    swarmTimeGainedReshaped = [swarmTimeGainedReshaped;swarmTimeGained(:,i)'];
    netSearchTimeReshaped = [netSearchTimeReshaped;netSearchTime(:,i)'];
    targetFoundBySwarmOrNot = [targetFoundBySwarmOrNot;targetFoundBySwarm(:,i)'];
    swarmSearchTimeReshaped = [swarmSearchTimeReshaped;swarmTimeFound(:,i)'];
end
%% replace nan value with the value equal to its corresponding trial value
for i = 1:size(swarmSearchTimeReshaped,2)
    for j = 1:size(trialNumIndices,1)
        if(isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,1))) && ~isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,2))))
            swarmSearchTimeReshaped(i,trialNumIndices(j,1)) = swarmSearchTimeReshaped(i,trialNumIndices(j,2));
        end
        if(isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,2))) && ~isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,1))))
            swarmSearchTimeReshaped(i,trialNumIndices(j,2)) = swarmSearchTimeReshaped(i,trialNumIndices(j,1));
        end
    end
    %swarmSearchTimeReshaped = [swarmSearchTimeReshaped;swarmTimeFound(:,i)'];
end

% Do the stats
% Throw away zeros
%% average clustered+unclustered
tempp1 = [];
tempp2 = [];
tempp3 = [];
for i = 1:size(trialNumIndices,1)
    tempp1(:,i) = (swarmTimeGainedReshaped(:,trialNumIndices(i,1))+swarmTimeGainedReshaped(:,trialNumIndices(i,2)))/2;
    tempp2(:,i) = (netSearchTimeReshaped(:,trialNumIndices(i,1))+netSearchTimeReshaped(:,trialNumIndices(i,2)))/2;
    tempp3(:,i) = (swarmSearchTimeReshaped(:,trialNumIndices(i,1))+swarmSearchTimeReshaped(:,trialNumIndices(i,2)))/2;
end

%% sum clustered+unclustered
tempp4  = [];
tempp5  = [];
for i = 1:size(trialNumIndices,1)
    tempp4(:,i)= targetFoundOrNotReshaped(:,trialNumIndices(i,1))+targetFoundOrNotReshaped(:,trialNumIndices(i,2));
    tempp5(:,i)= targetFoundBySwarm(:,trialNumIndices(i,1))+targetFoundBySwarm(:,trialNumIndices(i,2));
end

swarmTimeGainedReshaped = tempp1;
netSearchTimeReshaped = tempp2;
swarmSearchTimeReshaped = tempp3;
targetFoundOrNotReshaped = tempp4;
targetFoundBySwarm = tempp5;



swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
netSearchTimeReshaped(netSearchTimeReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);

meanSwarmTimeReshaped = nanmean(swarmSearchTimeReshaped); %%
stdSwarmTimeReshaped = nanstd(swarmSearchTimeReshaped); %%

meanHsiSearchTime = nanmean(netSearchTimeReshaped);
stdHsiSearchTime = nanstd(netSearchTimeReshaped);


sumTargetFoundOrNotReshaped = sum(targetFoundBySwarm);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped./size(targetFoundBySwarm,1)/2;

meanRandomSearchTime = meanSwarmTimeReshaped; %%
stdRandomSearchTime = stdSwarmTimeReshaped; %%
meanRandomSearchSwarmTime = meanHsiSearchTime;
stdRandomSearchSwarmTime = stdHsiSearchTime;

fractionRandomSearchTargetsFound = fractionOfTrialsTargetFound; %%
swarmTimeRandomSearch = swarmSearchTimeReshaped; %%

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

            if(swarmSearchLength < 0)
                swarmTimeFound(j,i) = nan;
                if(humanSearchLength >= 599)
                    netSearchTime(j,i) = 600;
                    targetFoundOrNot(j,i) = 0;
                end
                if(humanSearchLength < 599)
                    netSearchTime(j,i) = humanSearchLength;
                end
                
            end

            if(swarmSearchLength > 0)
                targetFoundBySwarm(j,i) = 1;
                swarmTimeFound(j,i) = swarmSearchLength;
                if(swarmSearchLength > humanSearchLength)
                    netSearchTime(j,i) = humanSearchLength;
                    targetFoundOrNot(j,i) = 0;
                end
                if(swarmSearchLength < humanSearchLength - humanTimeToLand)
                    netSearchTime(j,i) = swarmSearchLength;
                    targetFoundOrNot(j,i) = 1;
                    swarmTimeGained(j,i) = humanSearchLength - humanTimeToLand - swarmSearchLength;
                end
            end
        end
    end
end

targetFoundBySwarmOrNot = [];
targetFoundOrNotReshaped = [];
swarmTimeGainedReshaped = [];
netSearchTimeReshaped = [];
swarmSearchTimeReshaped = [];
for i = 1:size(swarmTimeGained,2)
    targetFoundOrNotReshaped = [targetFoundOrNotReshaped;targetFoundOrNot(:,i)'];
    swarmTimeGainedReshaped = [swarmTimeGainedReshaped;swarmTimeGained(:,i)'];
    netSearchTimeReshaped = [netSearchTimeReshaped;netSearchTime(:,i)'];
    targetFoundBySwarmOrNot = [targetFoundBySwarmOrNot;targetFoundBySwarm(:,i)'];
    swarmSearchTimeReshaped = [swarmSearchTimeReshaped;swarmTimeFound(:,i)'];
end
%% replace nan value with the value equal to its corresponding trial value
for i = 1:size(swarmSearchTimeReshaped,2)
    for j = 1:size(trialNumIndices,1)
        if(isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,1))) && ~isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,2))))
            swarmSearchTimeReshaped(i,trialNumIndices(j,1)) = swarmSearchTimeReshaped(i,trialNumIndices(j,2));
        end
        if(isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,2))) && ~isnan(swarmSearchTimeReshaped(i,trialNumIndices(j,1))))
            swarmSearchTimeReshaped(i,trialNumIndices(j,2)) = swarmSearchTimeReshaped(i,trialNumIndices(j,1));
        end
    end
    %swarmSearchTimeReshaped = [swarmSearchTimeReshaped;swarmTimeFound(:,i)'];
end

% Do the stats
% Throw away zeros
%% average clustered+unclustered
tempp1 = [];
tempp2 = [];
tempp3 = [];
for i = 1:size(trialNumIndices,1)
    tempp1(:,i) = (swarmTimeGainedReshaped(:,trialNumIndices(i,1))+swarmTimeGainedReshaped(:,trialNumIndices(i,2)))/2;
    tempp2(:,i) = (netSearchTimeReshaped(:,trialNumIndices(i,1))+netSearchTimeReshaped(:,trialNumIndices(i,2)))/2;
    tempp3(:,i) = (swarmSearchTimeReshaped(:,trialNumIndices(i,1))+swarmSearchTimeReshaped(:,trialNumIndices(i,2)))/2;
end

%% sum clustered+unclustered
tempp4  = [];
tempp5  = [];
for i = 1:size(trialNumIndices,1)
    tempp4(:,i)= targetFoundOrNotReshaped(:,trialNumIndices(i,1))+targetFoundOrNotReshaped(:,trialNumIndices(i,2));
    tempp5(:,i)= targetFoundBySwarm(:,trialNumIndices(i,1))+targetFoundBySwarm(:,trialNumIndices(i,2));
end

swarmTimeGainedReshaped = tempp1;
netSearchTimeReshaped = tempp2;
swarmSearchTimeReshaped = tempp3;
targetFoundOrNotReshaped = tempp4;
targetFoundBySwarm = tempp5;



swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
netSearchTimeReshaped(netSearchTimeReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);

meanSwarmTimeReshaped = nanmean(swarmSearchTimeReshaped); %%
stdSwarmTimeReshaped = nanstd(swarmSearchTimeReshaped); %%

meanHsiSearchTime = nanmean(netSearchTimeReshaped);
stdHsiSearchTime = nanstd(netSearchTimeReshaped);


sumTargetFoundOrNotReshaped = sum(targetFoundBySwarm);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped./size(targetFoundBySwarm,1)/2;

meanSpiralSearchTime = meanSwarmTimeReshaped; %%
stdSpiralSearchTime = stdSwarmTimeReshaped; %%
meanSpiralSearchSwarmTime = meanHsiSearchTime;
stdSpiralSearchSwarmTime = stdHsiSearchTime;

fractionSpiralSearchTargetsFound = fractionOfTrialsTargetFound; %%
swarmTimeSpiralSearch = swarmSearchTimeReshaped; %%

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
grid on
legend("Closed Loop type 1","Closed Loop type 2","Closed Loop type 3","Closed Loop type 4","Random Search","Spiral Search",'NumColumns',2)
% legend("Follow Search","Closed Loop","Random Search")
%ylabel("Fraction of trials target found by swarm")
ylabel("Fraction of trials target found by Swarm")
xlabel("Conditions")
set(gca,'xtick',1:8,'xticklabel',trialNames)
ylim([0, 1]);

%%%%%%%%% Search time
figure(2)
clf;
cats = [ones(size(swarmSearchTimeReshaped,1),1);2*ones(size(swarmSearchTimeReshaped,1),1); ...
    3*ones(size(swarmSearchTimeReshaped,1),1);4*ones(size(swarmSearchTimeReshaped,1),1) ...
    ;5*ones(size(swarmSearchTimeReshaped,1),1);6*ones(size(swarmSearchTimeReshaped,1),1)];
aggData = [swarmTimeClosedLoop1;swarmTimeClosedLoop2;swarmTimeClosedLoop3;swarmTimeClosedLoop4;swarmTimeRandomSearch; ...
   swarmTimeSpiralSearch ];
categories = categorical(cats,[1 2 3 4 5 6],{'Closed Loop type 1','Closed Loop type 2','Closed Loop type 3','Closed Loop type 4','Random Search','Spiral Search'});
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
    % if(i == 1)
    %     legend('Follow Search','Closed Loop','Random Search','Spiral');
    % end

end
ylabel("Average time taken to find \newline missing person by H-S team")
xlabel("Conditions")
xticks(l);
xticklabels(trialNames)
legend('Closed Loop type 1','Closed Loop type 2','Closed Loop type 3','Closed Loop type 4','Random Search','Spiral Search', ...
    '','','','','','','','','','','','','','','','','','','','','');