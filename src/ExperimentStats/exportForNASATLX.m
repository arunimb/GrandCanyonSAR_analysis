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
tlxScore = [];
avgTurnRate = [];
trials = strings;



for ii = 1:numel(subject)
    csvfileName1 = 'TLX.csv';
    %csvfileName2 = 'avgTurnRate.csv';
    %csvfileName3 = ['time_to_finish.csv'];
    for jj = 1:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(jj)),'\',csvfileName1];
        %fileName3 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(jj)),'\',csvfileName3];
        %time2finish = readmatrix(fileName3);
        if isfile(fileName)
            temp = readmatrix(fileName);
            tlxScore(c,1) = temp(1) ;          
            tlxScore(c,2) = temp(2) ;          
            tlxScore(c,3) = temp(3) ;          
            tlxScore(c,4) = temp(4) ;          
            tlxScore(c,5) = temp(5) ;          
            tlxScore(c,6) = temp(6) ;          
            swarmCohesion(c)  = cKnowledge(jj);
            targetKnowledge(c)  = tarKnowledge(jj);
            terrainKnowledge(c)  = terKnowledge(jj);
            c = c + 1;
        end
        if ~isfile(fileName)
            tlxScore(c,1) = nan ;          
            tlxScore(c,2) = nan ;          
            tlxScore(c,3) = nan ;          
            tlxScore(c,4) = nan ;          
            tlxScore(c,5) = nan ;          
            tlxScore(c,6) = nan ; 
            swarmCohesion(c)  = cKnowledge(jj);
            targetKnowledge(c)  = tarKnowledge(jj);
            terrainKnowledge(c)  = terKnowledge(jj);
            c = c + 1;
        end
    end
end
preTable1 = [tlxScore(:,1),swarmCohesion',targetKnowledge',terrainKnowledge'];
preTable1(any(isnan(tlxScore),2),:) = [];

preTable2 = [tlxScore(:,2),swarmCohesion',targetKnowledge',terrainKnowledge'];
preTable2(any(isnan(tlxScore),2),:) = [];

preTable3 = [tlxScore(:,3),swarmCohesion',targetKnowledge',terrainKnowledge'];
preTable3(any(isnan(tlxScore),2),:) = [];

preTable4 = [tlxScore(:,4),swarmCohesion',targetKnowledge',terrainKnowledge'];
preTable4(any(isnan(tlxScore),2),:) = [];

preTable5 = [tlxScore(:,5),swarmCohesion',targetKnowledge',terrainKnowledge'];
preTable5(any(isnan(tlxScore),2),:) = [];

preTable6 = [tlxScore(:,6),swarmCohesion',targetKnowledge',terrainKnowledge'];
preTable6(any(isnan(tlxScore),2),:) = [];

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
    'VariableNames',{'MentalTLX','SwarmCohesion','TargetKnowledge','TerrainKnowledge'});
writetable(outputTable1,['outputTables/mentalTLX.csv'],'Delimiter',',');

outputTable2 = array2table(preTable2,...
    'VariableNames',{'PhysicalTLX','SwarmCohesion','TargetKnowledge','TerrainKnowledge'});
writetable(outputTable2,['outputTables/physicalTLX.csv'],'Delimiter',',');

outputTable3 = array2table(preTable3,...
    'VariableNames',{'TemporalTLX','SwarmCohesion','TargetKnowledge','TerrainKnowledge'});
writetable(outputTable3,['outputTables/temporalTLX.csv'],'Delimiter',',');

outputTable4 = array2table(preTable4,...
    'VariableNames',{'PerformanceTLX','SwarmCohesion','TargetKnowledge','TerrainKnowledge'});
writetable(outputTable4,['outputTables/performanceTLX.csv'],'Delimiter',',');

outputTable5 = array2table(preTable5,...
    'VariableNames',{'EffortTLX','SwarmCohesion','TargetKnowledge','TerrainKnowledge'});
writetable(outputTable5,['outputTables/effortTLX.csv'],'Delimiter',',');

outputTable6 = array2table(preTable6,...
    'VariableNames',{'FrustrationTLX','SwarmCohesion','TargetKnowledge','TerrainKnowledge'});
writetable(outputTable6,['outputTables/frustrationTLX.csv'],'Delimiter',',');
