clearvars
close
clc

%% Run this section
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\';
trialNum = [111,211,121,221,112,212,122,222];
tarKnowledge = [1,2,1,2,1,2,1,2]; % Target knowledge
terKnowledge = [1,1,2,2,1,1,2,2]; %terrain knowledge
cKnowledge = [1,1,1,1,2,2,2,2];  %cohesion knowledge
trialAlias = [1,2,3,4,5,6,7,8];

subjectAliases = [];
swarmCohesion = [];
targetKnowledge = [];
terrainKnowledge = [];
cogWindow = [];
c = 1;
dwellTimeRatio = [];
trials = strings;



for ii = 1:numel(subject)
    csvfileName = 'percentDwellMiniMap.csv';
    for jj = 1:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(jj)),'\',csvfileName];
        if isfile(fileName)
            dwellTimeRatio(c) = readmatrix(fileName);
            swarmCohesion(c)  = cKnowledge(jj);
            targetKnowledge(c)  = tarKnowledge(jj);
            terrainKnowledge(c)  = terKnowledge(jj);

            c = c + 1;
        end
        if ~isfile(fileName)
            dwellTimeRatio(c) = nan;
            swarmCohesion(c)  = cKnowledge(jj);
            targetKnowledge(c)  = tarKnowledge(jj);
            terrainKnowledge(c)  = terKnowledge(jj);
            c = c + 1;
        end
    end
end
preTable = [dwellTimeRatio',swarmCohesion',targetKnowledge',terrainKnowledge'];
preTable(any(isnan(preTable),2),:) = [];

% meanOfCog = mean(preTable(:,1));
% stdOfCog = std(preTable(:,1));
% for i = 1:size(preTable(:,1),1)
%     if( preTable(i,1)>=meanOfCog+3*stdOfCog || preTable(i,1)<=meanOfCog-3*stdOfCog)
%         preTable(i,1) = nan;
%     end
% 
% end
% preTable(any(isnan(preTable),2),:) = [];
outputTable = array2table(preTable,...
    'VariableNames',{'dwellTimeRatio','SwarmCohesion','TargetKnowledge','TerrainKnowledge'});
writetable(outputTable,['outputTables/outputForGazeGLMM_GrandCanyon.csv'],'Delimiter',',');
