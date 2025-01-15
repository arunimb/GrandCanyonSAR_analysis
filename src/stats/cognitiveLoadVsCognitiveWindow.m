clearvars
close all
clc

addpath(['boundedline', filesep, 'boundedline'])
addpath(['boundedline', filesep, 'Inpaint_nans'])
fileName = "outputTables\outputForGLMM_GrandCanyon_test.csv";

table = readtable(fileName);

tarKnowledge = [1,2,1,2,1,2,1,2];
terKnowledge = [1,1,2,2,1,1,2,2];
cKnowledge = [1,1,1,1,2,2,2,2]; % cohesion knowledge

figure(1)
clf;
for i = 1:numel(tarKnowledge)
    subplot(3,3,i)
    requiredTable = table(table.TargetKnowledge == tarKnowledge(i) & ...
        table.TerrainKnowledge == terKnowledge(i) & table.SwarmCohesion == cKnowledge(i),:);
    %requiredTable = table(table.SwarmCohesion == 2,:);
    cogload = requiredTable.CognitiveLoad;
    cogWindow = requiredTable.CogWindow;
    d = dataset(cogWindow, cogload);
    % mdl=fitlm(d, 'cognitiveLoad~reactionTime+ageYrs') 
    mdl = fitlm(d, 'cogload~cogWindow');
    plot(mdl);
    str = sprintf("R^2 %0.4f and p-value %0.4f, condition %d%d%d",mdl.Rsquared.Ordinary,mdl.Coefficients.pValue(2), ...
        tarKnowledge(i),terKnowledge(i),cKnowledge(i));
    xlabel('Cog Window (s)');
    ylabel('Cognitive Load (v)');
    title(str);
end
figure
cogload = requiredTable.CognitiveLoad;
cogWindow = requiredTable.CogWindow;

scatter(cogWindow,cogload,20,'k','*');

xlabel('Window Size (s)');
ylabel('Cognitive Load (uV^2/Hz)');

meanCogLoad = [];
stdCogLoad = [];
windowSize = [];

for i = 1:25
    CogLoadAccu = [];
    c = 1;
    for j = 1:numel(cogWindow)
        if(cogWindow(j) == i)
            CogLoadAccu(c) = cogload(j);
            c = c + 1;
        end
    end
    meanCogLoad(i) = mean(CogLoadAccu);
    stdCogLoad(i) = std(CogLoadAccu);
    windowSize(i) = i;
end
figure
boundedline(windowSize,meanCogLoad,stdCogLoad, '-r','alpha','linewidth',1.2);
grid on
xlabel("Observation window length (s)");
ylabel('Cognitive Load (uV^2/Hz)');