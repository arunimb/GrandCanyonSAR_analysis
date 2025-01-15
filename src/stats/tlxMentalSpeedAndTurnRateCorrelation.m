% Produces stats for time to finish, turn rate, speed and gaze.
clearvars
close all
clc


%% Run this section
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\';
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion

% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [111,211,121,221,112,212,122,222];
%% Speed
c = 1;
avgSpeedBySubject = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','avgSpeed.csv'];
        if isfile(fileName)
            avgSpeedBySubject(ii,j) = readmatrix(fileName);
            c = c + 1;
        end
        if ~isfile(fileName)
            avgSpeedBySubject(ii,j) = nan;
            c = c + 1;
        end
    end
end

%%Turnrate
c = 1;
avgTurnRateBySubject = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','avgTurnRate.csv'];
        if isfile(fileName)
            avgTurnRateBySubject(ii,j) = readmatrix(fileName);
            c = c + 1;
        end
        if ~isfile(fileName)
            avgTurnRateBySubject(ii,j) = nan;
            c = c + 1;
        end
    end
end

%% TLX
c = 1;
time2FinishBySubject = [];
questions = ["Mental Demand", "Physical Demand", "Temporal Demand", "Performance", "Effort", "Frustration"];
q = [];
for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','TLX.csv'];
        if isfile(fileName)
            temp = readmatrix(fileName);
            q(ii,j,1) = temp(1);
            % q(ii,j,2) = temp(2);
            % q(ii,j,3) = temp(3);
            % q(ii,j,4) = temp(4);
            % q(ii,j,5) = temp(5);
            % q(ii,j,6) = temp(6);
            c = c + 1;
        end
        if ~isfile(fileName)
            q(ii,j,1) = nan;
            % q(ii,j,2) = nan;
            % q(ii,j,3) = nan;
            % q(ii,j,4) = nan;
            % q(ii,j,5) = nan;
            % q(ii,j,6) = nan;
            c = c + 1;
        end
    end
end

aggregatedVals = [];
c = 1;
for i = 1:20
    for j = 1:8
        if(~isnan(avgSpeedBySubject(i,j)) && ~isnan(avgTurnRateBySubject(i,j)) && ~isnan(q(i,j)))
            aggregatedVals(1,c) = avgSpeedBySubject(i,j);
            aggregatedVals(2,c) = avgTurnRateBySubject(i,j);
            aggregatedVals(3,c) = q(i,j);
            c = c + 1;
        end
        if(isnan(q(i,j)))
            lll = 1;
        end
    end
end
[RSpeed,pSpeed ] = corrcoef(aggregatedVals(3,:),aggregatedVals(1,:));
[RTurnRate,pTurnRate ] = corrcoef(aggregatedVals(3,:),aggregatedVals(2,:));