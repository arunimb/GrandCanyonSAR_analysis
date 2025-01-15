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
c = 1;
d = 1;
avgSpeed = [];
avgTurnRate = [];
trials = strings;



for ii = 1:numel(subject)
    csvfileName1 = 'avgSpeed.csv';
    csvfileName2 = 'avgTurnRate.csv';
    csvfileName3 = ['time_to_finish.csv'];
    for jj = 1:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(jj)),'\',csvfileName1];
        fileName3 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(jj)),'\',csvfileName3];
        time2finish = readmatrix(fileName3);
        if isfile(fileName)
            
            if(time2finish>=599)
                avgSpeed(c) = nan;
            end
            if(time2finish<599)
                avgSpeed(c) = readmatrix(fileName);
            end            
            swarmCohesion(c)  = cKnowledge(jj);
            targetKnowledge(c)  = tarKnowledge(jj);
            terrainKnowledge(c)  = terKnowledge(jj);

            c = c + 1;
        end
        if ~isfile(fileName)
            avgSpeed(c) = nan;
            swarmCohesion(c)  = cKnowledge(jj);
            targetKnowledge(c)  = tarKnowledge(jj);
            terrainKnowledge(c)  = terKnowledge(jj);
            c = c + 1;
        end
    end
    for jj = 1:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(jj)),'\',csvfileName2];
        fileName3 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(jj)),'\',csvfileName3];
        time2finish = readmatrix(fileName3);
        if isfile(fileName)
            if(time2finish>=599)
                avgTurnRate(d) = nan;
            end
            if(time2finish<599)
                avgTurnRate(d) = readmatrix(fileName);
            end
            
            swarmCohesion(d)  = cKnowledge(jj);
            targetKnowledge(d)  = tarKnowledge(jj);
            terrainKnowledge(d)  = terKnowledge(jj);

            d = d + 1;
        end
        if ~isfile(fileName)
            avgTurnRate(d) = nan;
            swarmCohesion(d)  = cKnowledge(jj);
            targetKnowledge(d)  = tarKnowledge(jj);
            terrainKnowledge(d)  = terKnowledge(jj);
            d = d + 1;
        end
    end
end
preTable1 = [avgSpeed',swarmCohesion',targetKnowledge',terrainKnowledge'];
preTable1(any(isnan(preTable1),2),:) = [];
preTable2 = [avgTurnRate',swarmCohesion',targetKnowledge',terrainKnowledge'];
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
    'VariableNames',{'avgSpeed','SwarmCohesion','TargetKnowledge','TerrainKnowledge'});
outputTable2 = array2table(preTable2,...
    'VariableNames',{'avgTurnRate','SwarmCohesion','TargetKnowledge','TerrainKnowledge'});
writetable(outputTable1,['outputTables/outputForSpeedGLMM_GrandCanyon_trialsUnder600.csv'],'Delimiter',',');
writetable(outputTable2,['outputTables/outputForTurnRateGLMM_GrandCanyon_trialsUnder600.csv'],'Delimiter',',');
