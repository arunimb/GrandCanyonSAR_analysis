clearvars
%close all
clc
)
fileName = "outputTables\outputForPupilDiaGLMM_GrandCanyon_test.csv";
table = readtable(fileName);

tarKnowledge = [1,2,1,2,1,2,1,2];
terKnowledge = [1,1,2,2,1,1,2,2];
cKnowledge = [1,1,1,1,2,2,2,2]; % cohesion knowledge

figure(1)
clf;

%requiredTable = table(table.TargetKnowledge == tarKnowledge(i) & ...
        %table.TerrainKnowledge == terKnowledge(i) & table.SwarmCohesion == cKnowledge(i),:);

pupilDia = table.PupilDiam;
windowSize = table.WindowSize;
%PupilDiam	SwarmCohesion	TargetKnowledge	TerrainKnowledge	WindowSize

scatter(windowSize,pupilDia,20,'k','*');
%ylim([0 10])
%d = dataset(cogWindow, cogload);
% mdl=fitlm(d, 'cognitiveLoad~reactionTime+ageYrs') 
%mdl = fitlm(d, 'cogload~cogWindow');

%plot(mdl);

%boundedline(TErange,meanNetTE_param_Itotdot,stdNetTE_param_Itotdot, '-b','alpha','linewidth',1.2);
xlabel('Window Size (s)');
ylabel('Pupil Dilation (mm)');
