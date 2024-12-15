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
auvNumber = 10; %[5 10 15 20]
numRuns = [1];
humanTimeToLand = 15;
simulationMode = {'closedLoopType1','closedLoopType2','randomSearch','spiralSearch'};

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

%% ClosedLoop1 Search
targetFoundBySwarm = zeros(numel(trialNum),20);
targetFoundOrNot = zeros(numel(trialNum),20);
swarmTimeGained = zeros(numel(trialNum),20);
netSearchTime = zeros(numel(trialNum),20);
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

            if(swarmSearchLength < 0)
                if(humanSearchLength >= 599)
                    netSearchTime(j,i) = 700;
                    targetFoundOrNot(j,i) = 0;
                end
                if(humanSearchLength < 599)
                    netSearchTime(j,i) = humanSearchLength;
                end
                
            end

            if(swarmSearchLength > 0)
                targetFoundBySwarm(j,i) = 1;
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

            % if(swarmSearchLength<0 || abs(swarmSearchLength) >= humanSearchLength - 15)
            %     targetFoundOrNot(counter,j,i) = 0;
            %     swarmTimeGained(counter,j,i) = 0;
            %     counter = counter+1;
            % end
            % 
            % if(swarmSearchLength > 0 && swarmSearchLength < humanSearchLength - 15)
            %     targetFoundOrNot(counter,j,i) = 1;
            %     swarmTimeGained(counter,j,i) = humanSearchLength - 15-abs(swarmSearchLength);
            %     counter = counter+1;
            % end
            % 
            % netSearchTime
            % if(swarmSearchLength < 0 && humanSearchLength >= 599)
            %     netSearchTime = 700;
            %     counter = counter+1;
            %     if(humanSearchLength < 100)
            %     end
            % end

            %[preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','swarmFoundTime.csv'];
        end

    end
end

targetFoundOrNotReshaped = [];
targetFoundBySwarmOrNot = [];
swarmTimeGainedReshaped = [];
netSearchTimeReshaped = [];
for i = 1:size(swarmTimeGained,2)
    targetFoundOrNotReshaped = [targetFoundOrNotReshaped;targetFoundOrNot(:,i)'];
    swarmTimeGainedReshaped = [swarmTimeGainedReshaped;swarmTimeGained(:,i)'];
    netSearchTimeReshaped = [netSearchTimeReshaped;netSearchTime(:,i)'];
    targetFoundBySwarmOrNot = [targetFoundBySwarmOrNot;targetFoundBySwarm];
end

% Do the stats
% Throw away zeros
%% average clustered+unclustered
tempp1 = [];
tempp2 = [];
for i = 1:size(trialNumIndices,1)
    tempp1(:,i)= (swarmTimeGainedReshaped(:,trialNumIndices(i,1))+swarmTimeGainedReshaped(:,trialNumIndices(i,2)))/2;
    tempp2(:,i)= (netSearchTimeReshaped(:,trialNumIndices(i,1))+netSearchTimeReshaped(:,trialNumIndices(i,2)))/2;
end

%% sum clustered+unclustered
tempp3    = [];
tempp4    = [];
for i = 1:size(trialNumIndices,1)
    tempp3(:,i)= targetFoundOrNotReshaped(:,trialNumIndices(i,1))+targetFoundOrNotReshaped(:,trialNumIndices(i,2));
    tempp4(:,i)= targetFoundBySwarm(:,trialNumIndices(i,1))+targetFoundBySwarm(:,trialNumIndices(i,2));
end

swarmTimeGainedReshaped = tempp1;
netSearchTimeReshaped = tempp2;

targetFoundOrNotReshaped = tempp3;
targetFoundBySwarm = tempp4;



swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
netSearchTimeReshaped(netSearchTimeReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);
meanHsiSearchTime = nanmean(netSearchTimeReshaped);
stdHsiSearchTime = nanstd(netSearchTimeReshaped);


sumTargetFoundOrNotReshaped = sum(targetFoundBySwarm);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped./size(targetFoundBySwarm,1)/2;

meanClosedLoop1TimeGained = meanSwarmTimeGainedReshaped;
stdClosedLoop1TimeGained = stdSwarmTimeGainedReshaped;
meanClosedLoop1SwarmTime = meanHsiSearchTime;
stdClosedLoop1SwarmTime = stdHsiSearchTime;

fractionClosedLoop1TargetsFound = fractionOfTrialsTargetFound;
swarmTimeGainedClosedLoop1 = swarmTimeGainedReshaped;
%% ClosedLoop2 Search
targetFoundBySwarm = zeros(numel(trialNum),20);
targetFoundOrNot = zeros(numel(trialNum),20);
swarmTimeGained = zeros(numel(trialNum),20);
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
            if(swarmSearchLength < 0)
                if(humanSearchLength >= 599)
                    netSearchTime(j,i) = 700;
                    targetFoundOrNot(j,i) = 0;
                end
                if(humanSearchLength < 599)
                    netSearchTime(j,i) = humanSearchLength;
                end
                
            end

            if(swarmSearchLength > 0)
                targetFoundBySwarm(j,i) = 1;
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

            % if(swarmSearchLength<0 || abs(swarmSearchLength) >= humanSearchLength - 15)
            %     targetFoundOrNot(counter,j,i) = 0;
            %     swarmTimeGained(counter,j,i) = 0;
            %     counter = counter+1;
            % end
            % 
            % if(abs(swarmSearchLength) < humanSearchLength - 15)
            %     targetFoundOrNot(counter,j,i) = 1;
            %     swarmTimeGained(counter,j,i) = humanSearchLength - 15-abs(swarmSearchLength);
            %     counter = counter+1;
            % end

            %[preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','swarmFoundTime.csv'];
        end

    end
end

targetFoundBySwarmOrNot = [];
targetFoundOrNotReshaped = [];
swarmTimeGainedReshaped = [];
netSearchTimeReshaped = [];
for i = 1:size(swarmTimeGained,2)
    targetFoundOrNotReshaped = [targetFoundOrNotReshaped;targetFoundOrNot(:,i)'];
    swarmTimeGainedReshaped = [swarmTimeGainedReshaped;swarmTimeGained(:,i)'];
    netSearchTimeReshaped = [netSearchTimeReshaped;netSearchTime(:,i)'];
    targetFoundBySwarmOrNot = [targetFoundBySwarmOrNot;targetFoundBySwarm];
end

% Do the stats
% Throw away zeros
%% average clustered+unclustered
%% average clustered+unclustered
tempp1 = [];
tempp2 = [];
for i = 1:size(trialNumIndices,1)
    tempp1(:,i)= (swarmTimeGainedReshaped(:,trialNumIndices(i,1))+swarmTimeGainedReshaped(:,trialNumIndices(i,2)))/2;
    tempp2(:,i)= (netSearchTimeReshaped(:,trialNumIndices(i,1))+netSearchTimeReshaped(:,trialNumIndices(i,2)))/2;
end

%% sum clustered+unclustered
tempp3    = [];
tempp4    = [];
for i = 1:size(trialNumIndices,1)
    tempp3(:,i)= targetFoundOrNotReshaped(:,trialNumIndices(i,1))+targetFoundOrNotReshaped(:,trialNumIndices(i,2));
    tempp4(:,i)= targetFoundBySwarm(:,trialNumIndices(i,1))+targetFoundBySwarm(:,trialNumIndices(i,2));
end

swarmTimeGainedReshaped = tempp1;
netSearchTimeReshaped = tempp2;

targetFoundOrNotReshaped = tempp3;
targetFoundBySwarm = tempp4;

swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
netSearchTimeReshaped(netSearchTimeReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);
meanHsiSearchTime = nanmean(netSearchTimeReshaped);
stdHsiSearchTime = nanstd(netSearchTimeReshaped);

sumTargetFoundOrNotReshaped = sum(targetFoundOrNotReshaped);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped./size(targetFoundOrNotReshaped,1)/2;


meanClosedLoop2TimeGained = meanSwarmTimeGainedReshaped;
stdClosedLoop2TimeGained = stdSwarmTimeGainedReshaped;
meanClosedLoop2SwarmTime = meanHsiSearchTime;
stdClosedLoop2SwarmTime = stdHsiSearchTime;
fractionClosedLoop2TargetsFound = fractionOfTrialsTargetFound;
swarmTimeGainedClosedLoop2 = swarmTimeGainedReshaped;
%% Random Search
targetFoundBySwarm = zeros(numel(trialNum),20);
targetFoundOrNot = zeros(numel(trialNum),20);
swarmTimeGained = zeros(numel(trialNum),20);
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

            if(swarmSearchLength < 0)
                if(humanSearchLength >= 599)
                    netSearchTime(j,i) = 700;
                    targetFoundOrNot(j,i) = 0;
                end
                if(humanSearchLength < 599)
                    netSearchTime(j,i) = humanSearchLength;
                end
                
            end

            if(swarmSearchLength > 0)
                targetFoundBySwarm(j,i) = 1;
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

            % if(swarmSearchLength<0 || abs(swarmSearchLength) >= humanSearchLength - 15)
            %     targetFoundOrNot(counter,j,i) = 0;
            %     swarmTimeGained(counter,j,i) = 0;
            %     counter = counter+1;
            % end
            % 
            % if(abs(swarmSearchLength) < humanSearchLength - 15)
            %     targetFoundOrNot(counter,j,i) = 1;
            %     swarmTimeGained(counter,j,i) = humanSearchLength - 15-abs(swarmSearchLength);
            %     counter = counter+1;
            % end

            %[preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','swarmFoundTime.csv'];
        end

    end
end

targetFoundBySwarmOrNot = [];
targetFoundOrNotReshaped = [];
swarmTimeGainedReshaped = [];
netSearchTimeReshaped = [];
for i = 1:size(swarmTimeGained,2)
    targetFoundOrNotReshaped = [targetFoundOrNotReshaped;targetFoundOrNot(:,i)'];
    swarmTimeGainedReshaped = [swarmTimeGainedReshaped;swarmTimeGained(:,i)'];
    netSearchTimeReshaped = [netSearchTimeReshaped;netSearchTime(:,i)'];
    targetFoundBySwarmOrNot = [targetFoundBySwarmOrNot;targetFoundBySwarm];
end
% Do the stats
% Throw away zeros

%% average clustered+unclustered
tempp1 = [];
tempp2 = [];
for i = 1:size(trialNumIndices,1)
    tempp1(:,i)= (swarmTimeGainedReshaped(:,trialNumIndices(i,1))+swarmTimeGainedReshaped(:,trialNumIndices(i,2)))/2;
    tempp2(:,i)= (netSearchTimeReshaped(:,trialNumIndices(i,1))+netSearchTimeReshaped(:,trialNumIndices(i,2)))/2;
end

%% sum clustered+unclustered
tempp3    = [];
tempp4    = [];
for i = 1:size(trialNumIndices,1)
    tempp3(:,i)= targetFoundOrNotReshaped(:,trialNumIndices(i,1))+targetFoundOrNotReshaped(:,trialNumIndices(i,2));
    tempp4(:,i)= targetFoundBySwarm(:,trialNumIndices(i,1))+targetFoundBySwarm(:,trialNumIndices(i,2));
end

swarmTimeGainedReshaped = tempp1;
netSearchTimeReshaped = tempp2;

targetFoundOrNotReshaped = tempp3;
targetFoundBySwarm = tempp4;

swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
netSearchTimeReshaped(netSearchTimeReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);
meanHsiSearchTime = nanmean(netSearchTimeReshaped);
stdHsiSearchTime = nanstd(netSearchTimeReshaped);

sumTargetFoundOrNotReshaped = sum(targetFoundBySwarm);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped./size(targetFoundBySwarm,1)/2;


meanRandomSearchTimeGained = meanSwarmTimeGainedReshaped;
stdRandomSearchTimeGained = stdSwarmTimeGainedReshaped;
meanRandomSearchHumanSwarmTime = meanHsiSearchTime;
stdRandomSearchHumanSwarmTime = stdHsiSearchTime;
fractionRandomSearchTargetsFound= fractionOfTrialsTargetFound;

swarmTimeGainedRandomSearch = swarmTimeGainedReshaped;
%% Spiral
targetFoundBySwarm = zeros(numel(trialNum),20);
targetFoundOrNot = zeros(numel(trialNum),20);
swarmTimeGained = zeros(numel(trialNum),20);
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
            
            if(swarmSearchLength < 0)
                if(humanSearchLength >= 599)
                    netSearchTime(j,i) = 700;
                    targetFoundOrNot(j,i) = 0;
                end
                if(humanSearchLength < 599)
                    netSearchTime(j,i) = humanSearchLength;
                end
                
            end

            if(swarmSearchLength > 0)
                targetFoundBySwarm(j,i) = 1;
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

            
            
            % if(swarmSearchLength<0 || abs(swarmSearchLength) >= humanSearchLength - 15)
            %     targetFoundOrNot(counter,j,i) = 0;
            %     swarmTimeGained(counter,j,i) = 0;
            %     counter = counter+1;
            % end
            % 
            % if(abs(swarmSearchLength) < humanSearchLength - 15)
            %     targetFoundOrNot(counter,j,i) = 1;
            %     swarmTimeGained(counter,j,i) = humanSearchLength - 15-abs(swarmSearchLength);
            %     counter = counter+1;
            % end

            %[preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','swarmFoundTime.csv'];
        end

    end
end

targetFoundBySwarmOrNot = [];
targetFoundOrNotReshaped = [];
swarmTimeGainedReshaped = [];
netSearchTimeReshaped = [];
for i = 1:size(swarmTimeGained,2)
    targetFoundOrNotReshaped = [targetFoundOrNotReshaped;targetFoundOrNot(:,i)'];
    swarmTimeGainedReshaped = [swarmTimeGainedReshaped;swarmTimeGained(:,i)'];
    netSearchTimeReshaped = [netSearchTimeReshaped;netSearchTime(:,i)'];
    targetFoundBySwarmOrNot = [targetFoundBySwarmOrNot;targetFoundBySwarm];
end

% Do the stats
% Throw away zeros
%% average clustered+unclustered
tempp1 = [];
tempp2 = [];
for i = 1:size(trialNumIndices,1)
    tempp1(:,i)= (swarmTimeGainedReshaped(:,trialNumIndices(i,1))+swarmTimeGainedReshaped(:,trialNumIndices(i,2)))/2;
    tempp2(:,i)= (netSearchTimeReshaped(:,trialNumIndices(i,1))+netSearchTimeReshaped(:,trialNumIndices(i,2)))/2;
end

%% sum clustered+unclustered
tempp3    = [];
tempp4    = [];
for i = 1:size(trialNumIndices,1)
    tempp3(:,i)= targetFoundOrNotReshaped(:,trialNumIndices(i,1))+targetFoundOrNotReshaped(:,trialNumIndices(i,2));
    tempp4(:,i)= targetFoundBySwarm(:,trialNumIndices(i,1))+targetFoundBySwarm(:,trialNumIndices(i,2));
end

swarmTimeGainedReshaped = tempp1;
netSearchTimeReshaped = tempp2;

targetFoundOrNotReshaped = tempp3;
targetFoundBySwarm = tempp4;

swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
netSearchTimeReshaped(netSearchTimeReshaped == 0) = nan;
meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);
meanHsiSearchTime = nanmean(netSearchTimeReshaped);
stdHsiSearchTime = nanstd(netSearchTimeReshaped);

sumTargetFoundOrNotReshaped = sum(targetFoundBySwarm);
fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped./size(targetFoundBySwarm,1)/2;


meanSpiralTimeGained = meanSwarmTimeGainedReshaped;
stdSpiralTimeGained = stdSwarmTimeGainedReshaped;
meanSpiralHumanSwarmTime = meanHsiSearchTime;
stdSpiralHumanSwarmTime = stdHsiSearchTime;
fractionSpiralTargetsFound = fractionOfTrialsTargetFound;

swarmTimeGainedSpiralSearch = swarmTimeGainedReshaped;
% %% Spiral Random
% targetFoundOrNot = zeros(1,numel(trialNum),20);
% swarmTimeGained = zeros(1,numel(trialNum),20);
% preFolderSim = strcat("D:\UWmonitoring\RunMissingPersonSim\simulationRecord\",cell2mat(simulationMode(5)),"\");
% counter = 1;
% for i = 1:numel(subject)
%     for j = 1:numel(trialNum)
%         counter = 1;
%         for k = 1:numel(numRuns)         
%             folder = strcat(preFolderSim,"\");
%             folder = strcat(folder,cell2mat(subject(i)));
%             folder = strcat(folder,"\");
%             folder = strcat(folder,num2str(trialNum(j)));
%             folder = strcat(folder,"\");
%             folder = strcat(folder,num2str(auvNumber));
%             folder = strcat(folder,"\");
%             folder = strcat(folder,"run");
%             folder = strcat(folder,num2str(numRuns(k)));
%             folder = strcat(folder,"\");
%             fileNameForTrial = strcat(folder,"swarmFoundTime.csv");
%             swarmSearchLength = readmatrix(fileNameForTrial);
%             humanSearchLength = readmatrix([preFolder, cell2mat(subject(i)),'\',num2str(trialNum(j)),'\','time_to_finish.csv']);
%             if(swarmSearchLength<0 || abs(swarmSearchLength) >= humanSearchLength - 15)
%                 targetFoundOrNot(counter,j,i) = 0;
%                 swarmTimeGained(counter,j,i) = 0;
%                 counter = counter+1;
%             end
% 
%             if(abs(swarmSearchLength) < humanSearchLength - 15)
%                 targetFoundOrNot(counter,j,i) = 1;
%                 swarmTimeGained(counter,j,i) = humanSearchLength - 15-abs(swarmSearchLength);
%                 counter = counter+1;
%             end
% 
%             %[preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','swarmFoundTime.csv'];
%         end
% 
%     end
% end
% 
% targetFoundOrNotReshaped = [];
% swarmTimeGainedReshaped = [];
% for i = 1:size(swarmTimeGained,3)
%     targetFoundOrNotReshaped = [targetFoundOrNotReshaped;targetFoundOrNot(:,:,i)];
%     swarmTimeGainedReshaped = [swarmTimeGainedReshaped;swarmTimeGained(:,:,i)];
% end
% 
% % Do the stats
% % Throw away zeros
% swarmTimeGainedReshaped(swarmTimeGainedReshaped == 0) = nan;
% meanSwarmTimeGainedReshaped = nanmean(swarmTimeGainedReshaped);
% stdSwarmTimeGainedReshaped = nanstd(swarmTimeGainedReshaped);
% sumTargetFoundOrNotReshaped = sum(targetFoundOrNotReshaped);
% fractionOfTrialsTargetFound = sumTargetFoundOrNotReshaped/size(targetFoundOrNotReshaped,1);
% 
% meanSpiralRandomTimeGained = meanSwarmTimeGainedReshaped;
% stdSpiralRandomTimeGained = stdSwarmTimeGainedReshaped; 
% fractionSpiralRandomTimeGained = fractionOfTrialsTargetFound;

%% Plotssssss
%trialNames = {'NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'};
figure(1)
clf;
%subplot(1,2,1)
scatter(1:1:4,fractionClosedLoop1TargetsFound,200,'d','filled','MarkerFaceColor',[1 .2 .2]);
hold on
scatter(1:1:4,fractionClosedLoop2TargetsFound,200,'s','filled','MarkerFaceColor',[0.2 .2 1.0]);
scatter(1:1:4,fractionRandomSearchTargetsFound,200,'d','filled','MarkerFaceColor',[0.2 1.0 0.2]);
scatter(1:1:4,fractionSpiralTargetsFound,200,'^','filled','MarkerFaceColor',[0.5 0.5 0.5]);
grid on
legend("Closed Loop type 1","Closed Loop type 2","Random Search","Spiral Search",'NumColumns',2)
% legend("Follow Search","Closed Loop","Random Search")
%ylabel("Fraction of trials target found by swarm")
ylabel("Fraction of trials target found by H-S team \newline  compared to single human")
xlabel("Conditions")
set(gca,'xtick',1:8,'xticklabel',trialNames)
ylim([0, 1]);

figure(2)
clf;
scatter(1:1:4,meanClosedLoop1SwarmTime,200,'d','filled','MarkerFaceColor',[1 .2 .2]);
hold on
errorbar(1:1:4,meanClosedLoop1SwarmTime,stdClosedLoop1SwarmTime,'.', 'vertical', 'color',[1 .2 .2]);

scatter(1:1:4,meanClosedLoop2SwarmTime,200,'s','filled','MarkerFaceColor',[0.2 .2 1.0]);
errorbar(1:1:4,meanClosedLoop2SwarmTime,stdClosedLoop2SwarmTime,'.', 'vertical', 'color',[0.2 .2 1]);

scatter(1:1:4,meanRandomSearchHumanSwarmTime,200,'d','filled','MarkerFaceColor',[0.2 1.0 0.2]);
errorbar(1:1:4,meanRandomSearchHumanSwarmTime,stdRandomSearchHumanSwarmTime,'.', 'vertical', 'color',[0.2 1.0 0.2]);

scatter(1:1:4,meanSpiralHumanSwarmTime,200,'^','filled','MarkerFaceColor',[0.5 0.5 0.5]);
errorbar(1:1:4,meanSpiralHumanSwarmTime,stdSpiralHumanSwarmTime,'.', 'vertical', 'color',[0.5 0.5 0.5]);

ylim([-100, 600]);

grid on
legend("Closed Loop type 1","Closed Loop type 2","Random Search","Spiral Search",'NumColumns',2)
%legend("Follow Search","","Closed Loop","","Random Search","")
ylabel("Average time taken to find \newline missing person by H-S team")
xlabel("Conditions")
set(gca,'xtick',1:4,'xticklabel',trialNames)

% titleString = strcat("Swarm Size: ",num2str(auvNumber));
% sgtitle(titleString)

figure(3)
clf;
cats = [ones(size(swarmTimeGainedSpiralSearch,1),1);2*ones(size(swarmTimeGainedSpiralSearch,1),1); ...
    3*ones(size(swarmTimeGainedSpiralSearch,1),1);4*ones(size(swarmTimeGainedSpiralSearch,1),1)];
aggData = [swarmTimeGainedClosedLoop1;swarmTimeGainedClosedLoop2;swarmTimeGainedRandomSearch; ...
   swarmTimeGainedSpiralSearch ];
categories = categorical(cats,[1 2 3 4],{'Closed Loop type 1','Closed Loop type 2','Random Search','Spiral Search'});
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
    % if(i == 1)
    %     legend('Follow Search','Closed Loop','Random Search','Spiral');
    % end

end
ylabel("Average time taken to find \newline missing person by H-S team")
xlabel("Conditions")
xticks(l);
xticklabels(trialNames)
legend('Closed Loop type 1','Closed Loop type 2','Random Search','Spiral Search','','','','','','','','','','','','','','','','');
% boxchart(swarmTimeGainedFollowSearch);
% hold on
% boxchart(swarmTimeGainedClosedLoop);
% boxchart(swarmTimeGainedRandomSearch);
% boxchart(swarmTimeGainedSpiralSearch);