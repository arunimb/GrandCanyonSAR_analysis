clearvars
close all
clc

% This file plots speed and turn rate by trial for every subject and saves them in
% data folder
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\';
% Trial names are in the order Missing Person Prior knowledge Y or N,
% Terrain knowledge Y or N, Swarm Cohesion L or H.
trialName = {'NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'};
preFolder = '..\..\data\'; % location of subject data folders
trialNum = [111,211,121,221,112,212,122,222];
accTLX = [];
meanScoresAcc=[];
stdScoresAcc=[];

for j = 1:numel(trialNum)
    for ii = 1:numel(subject)
        disp(ii);
        disp(j);      
        fileNameTLX = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','TLX.csv']);
        if (~isempty(fileNameTLX))
            TLXval = readmatrix([fileNameTLX.folder,'\',fileNameTLX.name])';
            accTLX = [accTLX;TLXval];
        end
        if (isempty(fileNameTLX))
            disp("culprit")
        end
        disp("===")
    end

end

figure(1)
meanScores = mean(accTLX);
stdScores = std(accTLX);
meanScoresAcc=cat(1,meanScoresAcc,meanScores);
stdScoresAcc=cat(1,stdScoresAcc,stdScores);
%plot(meanScoresAcc)
errorbar(1:1:6,meanScoresAcc,stdScoresAcc)
% for i = 1:1:8
%     errorbar(1:1:6,meanScoresAcc(i,:),stdScoresAcc(i,:))
%     hold on
% end
grid on

%% question of interest
questionOfInterest = 1;

accTLX = [];
meanScoresAcc=[];
stdScoresAcc=[];
accTLX = [];
meanScorePerTrial = zeros(1,6);
stdScorePerTrial = zeros(1,6);
for j = 1:numel(trialNum)
    accTLX = [];
    for ii = 1:numel(subject)
        disp(ii);
        disp(j);
        disp("===")

        fileNameTLX = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','TLX.csv']);
        if (~isempty(fileNameTLX))
            TLXval = readmatrix([fileNameTLX.folder,'\',fileNameTLX.name])';
            accTLX = [accTLX;TLXval];
        end
    end

    meanScorePerTrial(j,:) = mean(accTLX);
    stdScorePerTrial(j,:) = std(accTLX);

end

figure(2)
clf;
meanScorePerTrial = meanScorePerTrial';
stdScorePerTrial = stdScorePerTrial';

%plot(meanScoresAcc)
for i = [4]
    errorbar(1:1:8,meanScorePerTrial(i,:),stdScorePerTrial(i,:))
    hold on
end
%legend("Mental","Physical","Pace","Performance","Strenuous","Insecurity")
xlabel("Condition")
ylabel("TLX Score")
legend("Performance")
set(gca,'xtick',1:8,'xticklabel',trialName)
grid on
