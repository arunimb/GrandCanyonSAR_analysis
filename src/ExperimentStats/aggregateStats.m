% Plots figure 5 and figure 8
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

%% Average Speed and Turn rate

trajAggregate = [];
trials = {};
c = 1;

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
avgSpeedBySubject(any(isnan(avgSpeedBySubject),2),:) = [];
figure(1)
subplot(222)
[p_data, tbl_data, stats_data]=friedman(avgSpeedBySubject, 1, 'off');

boxchart(avgSpeedBySubject);
xlabel("Condition")
ylabel("Average speed (m/s)")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName;


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
avgTurnRateBySubject(any(isnan(avgTurnRateBySubject),2),:) = [];
subplot(221)
[p_data, tbl_data, stats_data]=friedman(avgTurnRateBySubject, 1, 'off');
boxchart(avgTurnRateBySubject);

xlabel("Condition (Person know. Y/N, Terrain know. Y/N, Swarm distr. U/C)")
ylabel("Average turn rate (deg/s)")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName;

%% Freeze time
c = 1;
completeStop = [];
partialStop = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','freeze.csv'];
        if isfile(fileName)
            temp = readmatrix(fileName);
            completeStop(ii,j) =temp(1);
            partialStop(ii,j) = temp(2);
            c = c + 1;
        end
        if ~isfile(fileName)
            completeStop(ii,j) = nan;
            partialStop(ii,j) = nan;
            c = c + 1;
        end
    end
end
figure(1)
subplot(223)
[p_data, tbl_data, stats_data]=friedman(completeStop, 1, 'off');
boxchart(completeStop);
xlabel("Condition")
ylabel("Freeze time (fraction)")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName;

subplot(224)
[p_data, tbl_data, stats_data]=friedman(partialStop, 1, 'off');
boxchart(partialStop);
xlabel("Condition (Person know. Y/N, Terrain know. Y/N, Swarm distr. U/C)")
ylabel("Turning while still (fraction)")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName;


%% time to finish
figure (2)
c = 1;
time2FinishBySubject = [];
successOrNot = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','time_to_finish.csv'];
        if isfile(fileName)
            if(readmatrix(fileName)<599)
                time2FinishBySubject(ii,j) = readmatrix(fileName);
                successOrNot(ii,j) = 1;
            end
            if(readmatrix(fileName)>=599)
                time2FinishBySubject(ii,j) = nan;
                successOrNot(ii,j) = 0;
            end
            c = c + 1;
        end
        if ~isfile(fileName)
            time2FinishBySubject(ii,j) = nan;
            successOrNot(ii,j) = 0;
            c = c + 1;
        end
    end
end
meanSuccessRate = mean(successOrNot);
stdSuccessRate = std(successOrNot);
subplot(1,2,1)
scatter([1:1:8],meanSuccessRate,100,'black','square');
grid on
ylabel("Success rate")
xlim([1,8])
ylim([0,1])
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName;

subplot(1,2,2)
boxchart(time2FinishBySubject)

xlabel("Condition (Person know. Y/N, Terrain know. Y/N, Swarm distr. U/C)")
ylabel("Time to find (s)")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName;