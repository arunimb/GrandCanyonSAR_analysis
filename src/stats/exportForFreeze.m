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
trials = strings;
fracCompleteStops = [];
fracPartialStops = [];


for ii = 1:numel(subject)
    csvfileName = 'freeze.csv';
    for jj = 1:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(jj)),'\',csvfileName];
        if isfile(fileName)
            temp  = readmatrix(fileName);
            fracCompleteStops(c) = temp(1);
            fracPartialStops(c) = temp(2);
            swarmCohesion(c)  = cKnowledge(jj);
            targetKnowledge(c)  = tarKnowledge(jj);
            terrainKnowledge(c)  = terKnowledge(jj);

            c = c + 1;
        end
        if ~isfile(fileName)
            fracCompleteStops(c) = nan;
            fracPartialStops(c) = nan;
            swarmCohesion(c)  = cKnowledge(jj);
            targetKnowledge(c)  = tarKnowledge(jj);
            terrainKnowledge(c)  = terKnowledge(jj);
            c = c + 1;
        end
    end
end
preTable1 = [fracCompleteStops',swarmCohesion',targetKnowledge',terrainKnowledge'];
preTable1(any(isnan(preTable1),2),:) = [];
preTable2 = [fracPartialStops',swarmCohesion',targetKnowledge',terrainKnowledge'];
preTable2(any(isnan(preTable2),2),:) = [];

% meanOfCog = mean(preTable(:,1));
% stdOfCog = std(preTable(:,1));
% for i = 1:size(preTable(:,1),1)
%     if( preTable(i,1)>=meanOfCog+3*stdOfCog || preTable(i,1)<=meanOfCog-3*stdOfCog)
%         preTable(i,1) = nan;
%     end
% 
% end
% preTable(any(isnan(preTable),2),:) = [];
outputTable1 = array2table(preTable1,...
    'VariableNames',{'fracCompleteStops','SwarmCohesion','TargetKnowledge','TerrainKnowledge'});
writetable(outputTable1,['outputTables/outputForFracCompleteStops.csv'],'Delimiter',',');
outputTable2 = array2table(preTable2,...
    'VariableNames',{'fracPartialStops','SwarmCohesion','TargetKnowledge','TerrainKnowledge'});
writetable(outputTable2,['outputTables/outputForFracPartialStops.csv'],'Delimiter',',');
