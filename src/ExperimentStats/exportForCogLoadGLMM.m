% Produces stats for time to finish, turn rate, speed and gaze.
clearvars
close all
clc

%% Run this section
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\';
trialNum = [111,211,121,221,112,212,122,222];
tarKnowledge = [1,2,1,2,1,2,1,2];
terKnowledge = [1,1,2,2,1,1,2,2];
cKnowledge = [1,1,1,1,2,2,2,2]; % cohesion knowledge
trialAlias = [1,2,3,4,5,6,7,8];
fileNamesToRead = 1:25;
subjectAliases = [];
swarmCohesion = [];
targetKnowledge = [];
terrainKnowledge = [];
cogWindow = [];
c = 1;
cogLoadBySubject = [];
trials = strings;


%csvfileName = 'cogload_First6s_from0s.csv';
for mm = 1:numel(fileNamesToRead)
    csvfileName = ['cogload_First',num2str(fileNamesToRead(mm)),'s_from0s.csv'];
    csvfileName2 = ['time_to_finish.csv'];
    for ii = 1:numel(subject)
        for jj = 1:numel(trialNum)
            fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(jj)),'\',csvfileName];
            fileName2 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(jj)),'\',csvfileName2];
            if isfile(fileName)
                time2finish = readmatrix(fileName2);
                if (time2finish>=599)
                    cogLoadBySubject(c) = nan;
                end
                if (time2finish<599)
                    cogLoadBySubject(c) = readmatrix(fileName);
                end
                
                swarmCohesion(c)  = cKnowledge(jj);
                targetKnowledge(c)  = tarKnowledge(jj);
                terrainKnowledge(c)  = terKnowledge(jj);
                cogWindow(c)  = fileNamesToRead(mm);
                c = c + 1;
            end
            if ~isfile(fileName)
                cogLoadBySubject(c) = nan;
                swarmCohesion(c)  = cKnowledge(jj);
                targetKnowledge(c)  = tarKnowledge(jj);
                terrainKnowledge(c)  = terKnowledge(jj);
                cogWindow(c)  = fileNamesToRead(mm);
                c = c + 1;
            end
        end
    end
end
preTable = [cogLoadBySubject',swarmCohesion',targetKnowledge',terrainKnowledge',cogWindow'];
copyTable = preTable;
preTable(any(isnan(preTable),2),:) = [];

meanOfCog = mean(preTable(:,1));
stdOfCog = std(preTable(:,1));
for i = 1:size(preTable(:,1),1)
    if( preTable(i,1)>=meanOfCog+3*stdOfCog || preTable(i,1)<=meanOfCog-3*stdOfCog)
        preTable(i,1) = nan;
    end
end
preTable(any(isnan(preTable),2),:) = [];

% meanOfCog = mean(preTable(:,1));
% stdOfCog = std(preTable(:,1));
% for i = 1:size(preTable(:,1),1)
%     if( preTable(i,1)>=meanOfCog+3*stdOfCog || preTable(i,1)<=meanOfCog-3*stdOfCog)
%         preTable(i,1) = nan;
%     end
% end
% preTable(any(isnan(preTable),2),:) = [];

outputTable = array2table(preTable,...
    'VariableNames',{'CognitiveLoad','SwarmCohesion','TargetKnowledge','TerrainKnowledge','CogWindow'});
writetable(outputTable,['outputTables/outputForGLMM_GrandCanyon_test_trialsUnder600.csv'],'Delimiter',',');

copyTable(all(~isnan(copyTable),2),:) = []; % extract all the nan values

tarKnowledge = [1,2,1,2,1,2,1,2];
terKnowledge = [1,1,2,2,1,1,2,2];
cKnowledge = [1,1,1,1,2,2,2,2]; % cohesion knowledge

%%
distribution = zeros(1,numel(terKnowledge));
c = 1;
for i = 1:numel(tarKnowledge)
    for j = 1:size(copyTable,1)
        if cKnowledge(i) == copyTable(j,2) && tarKnowledge(i) == copyTable(j,3) && terKnowledge(i) == copyTable(j,4)
            distribution(i) = distribution(i) + 1;
        end
    end
end
bar(distribution)
