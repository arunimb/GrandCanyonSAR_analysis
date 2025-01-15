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
windowSize = [];
c = 1;
pupilDiaBySubject = [];
trials = strings;


%csvfileName = 'cogload_First6s_from0s.csv';
for mm = 1:numel(fileNamesToRead)
    csvfileName = ['pupilDia_First',num2str(fileNamesToRead(mm)),'s_from0s.csv'];
    for ii = 1:numel(subject)
        for jj = 1:numel(trialNum)
            fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(jj)),'\',csvfileName];
            if isfile(fileName)
                pupilDiaBySubject(c) = readmatrix(fileName);
                swarmCohesion(c)  = cKnowledge(jj);
                targetKnowledge(c)  = tarKnowledge(jj);
                terrainKnowledge(c)  = terKnowledge(jj);
                windowSize(c)  = fileNamesToRead(mm);
                c = c + 1;
            end
            if ~isfile(fileName)
                pupilDiaBySubject(c) = nan;
                swarmCohesion(c)  = cKnowledge(jj);
                targetKnowledge(c)  = tarKnowledge(jj);
                terrainKnowledge(c)  = terKnowledge(jj);
                windowSize(c)  = fileNamesToRead(mm);
                c = c + 1;
            end
        end
    end
end
preTable = [pupilDiaBySubject',swarmCohesion',targetKnowledge',terrainKnowledge',windowSize'];
preTable(any(isnan(preTable),2),:) = [];
% 
% meanOfCog = mean(preTable(:,1));
% stdOfCog = std(preTable(:,1));
% for i = 1:size(preTable(:,1),1)
%     if( preTable(i,1)>=meanOfCog+3*stdOfCog || preTable(i,1)<=meanOfCog-3*stdOfCog)
%         preTable(i,1) = nan;
%     end
% end
% preTable(any(isnan(preTable),2),:) = [];


outputTable = array2table(preTable,...
    'VariableNames',{'PupilDiam','SwarmCohesion','TargetKnowledge','TerrainKnowledge','WindowSize'});
writetable(outputTable,['outputTables/outputForPupilDiaGLMM_GrandCanyon_test.csv'],'Delimiter',',');

