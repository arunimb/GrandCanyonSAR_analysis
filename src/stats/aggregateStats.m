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

%% Average Speed and Turn rate
figure
trajAggregate = [];
trials = {};
c = 1;

% Plot Violin plots, keep as an example do not delete

% c = 1;
% avgSpeed = [];
% trials = strings;
% for j = 2:numel(trialNum)
%     for ii = 1:numel(subject)
%         fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','avgSpeed.csv'];
%         if isfile(fileName)
%             avgSpeed(c,1) = readmatrix(fileName);
%             trials(c,1) = trialName(j);
%             c = c + 1;
%         end
%     end
% end
% subplot(2,2,1)
% vs = violinplot(avgSpeed, trials,'GroupOrder',trialName');
% ylabel("Average Speed (m/s)");
% xlabel("Person, Terrain, Swarm");
% set(gca,"FontSize",16,"LineWidth",1.5);

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
subplot(1,2,1)
[p_data, tbl_data, stats_data]=friedman(avgSpeedBySubject, 1, 'off');
plot(avgSpeedBySubject', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
hold on;
plot(median(avgSpeedBySubject), 'k+', 'markersize', 16, 'linewidth', 2);
%title(p_data)
% if p_data < 0.05
%     res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
%     %         if disp1
% 
%     sigstar([],res_data,1);
%     %         end
% end
set(gca, 'xtick', 1:8)
xlabel("Condition")
ylabel("Speed (m/s)")
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
subplot(1,2,2)
[p_data, tbl_data, stats_data]=friedman(avgTurnRateBySubject, 1, 'off');
plot(avgTurnRateBySubject', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
hold on;
plot(median(avgTurnRateBySubject), 'k+', 'markersize', 16, 'linewidth', 2);
%title(p_data)
% if p_data < 0.05
%     res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
%     %         if disp1
% 
%     sigstar([],res_data,1);
%     %         end
% end
set(gca, 'xtick', 1:8)
xlabel("Condition")
ylabel("Turn rate (deg/s)")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName;
%% Average Height
figure
c = 1;
avgHeightBySubject = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 2:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','avgHeight.csv'];
        if isfile(fileName)
            avgHeightBySubject(ii,j-1) = readmatrix(fileName);
            c = c + 1;
        end
        if ~isfile(fileName)
            avgHeightBySubject(ii,j-1) = nan;
            c = c + 1;
        end
    end
end
avgHeightBySubject(any(isnan(avgHeightBySubject),2),:) = [];

subplot(1,1,1)
[p_data, tbl_data, stats_data]=friedman(avgHeightBySubject, 1, 'off');
plot(avgHeightBySubject', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
hold on;
plot(median(avgHeightBySubject), 'k+', 'markersize', 16, 'linewidth', 2);
if p_data < 0.05
    res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
    %         if disp1

    sigstar([],res_data,1);
    %         end
end
set(gca, 'xtick', 1:8)
xlabel("Condition")
ylabel("Average height (m)")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName(2:9);

%% Total Distance
figure
c = 1;
totalDistance = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 2:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','totalDistance.csv'];
        if isfile(fileName)
            totalDistance(ii,j-1) = readmatrix(fileName);
            c = c + 1;
        end
        if ~isfile(fileName)
            totalDistance(ii,j-1) = nan;
            c = c + 1;
        end
    end
end
totalDistance(any(isnan(totalDistance),2),:) = [];

subplot(1,1,1)
[p_data, tbl_data, stats_data]=friedman(totalDistance, 1, 'off');
plot(totalDistance', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
hold on;
plot(median(totalDistance), 'k+', 'markersize', 16, 'linewidth', 2);
if p_data < 0.05
    res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
    %         if disp1

    sigstar([],res_data,1);
    %         end
end
set(gca, 'xtick', 1:8)
xlabel("Condition")
ylabel("Total Distance (m)")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName(2:9);

%% Total turn Angle
figure
c = 1;
totalTurn = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 2:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','totalTurn.csv'];
        if isfile(fileName)
            totalTurn(ii,j-1) = readmatrix(fileName);
            c = c + 1;
        end
        if ~isfile(fileName)
            totalTurn(ii,j-1) = nan;
            c = c + 1;
        end
    end
end
totalTurn(any(isnan(totalTurn),2),:) = [];

subplot(1,1,1)
[p_data, tbl_data, stats_data]=friedman(totalTurn, 1, 'off');
plot(totalTurn', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
hold on;
plot(median(totalTurn), 'k+', 'markersize', 16, 'linewidth', 2);
if p_data < 0.05
    res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
    %         if disp1

    sigstar([],res_data,1);
    %         end
end
set(gca, 'xtick', 1:8)
xlabel("Condition")
ylabel("Total Angle Turned (degree)")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName(2:9);

%% Average HeightRate
figure
c = 1;
avgHeightDotBySubject = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 2:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','avgSubjectHeightDot.csv'];
        if isfile(fileName)
            avgHeightDotBySubject(ii,j-1) = readmatrix(fileName);
            c = c + 1;
        end
        if ~isfile(fileName)
            avgHeightDotBySubject(ii,j-1) = nan;
            c = c + 1;
        end
    end
end
avgHeightDotBySubject(any(isnan(avgHeightDotBySubject),2),:) = [];

subplot(1,1,1)
[p_data, tbl_data, stats_data]=friedman(avgHeightDotBySubject, 1, 'off');
plot(avgHeightDotBySubject', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
hold on;
plot(median(avgHeightDotBySubject), 'k+', 'markersize', 16, 'linewidth', 2);
title(p_data)
if p_data < 0.05
    res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
    %         if disp1

    sigstar([],res_data,1);
    %         end
end
set(gca, 'xtick', 1:8)
xlabel("Condition")
ylabel("Average Height Dot (m/s)")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName(2:9);

%% Average Gaze Speed
figure
c = 1;
avgGazeSpeed = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 2:numel(trialNum)
        % use avgGazeSpeed.csv for pixels/second, avgGazeSpeedDegrees.csv for degrees/second
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','avgGazeSpeedDegrees.csv']; 
        if isfile(fileName)
            avgGazeSpeed(ii,j-1) = readmatrix(fileName);
            c = c + 1;
        end
        if ~isfile(fileName)
            avgGazeSpeed(ii,j-1) = nan;
            c = c + 1;
        end
    end
end
avgGazeSpeed(any(isnan(avgGazeSpeed),2),:) = [];

meanOfGazeSpeed = mean(avgGazeSpeed(:));
stdOfGazeSpeed = std(avgGazeSpeed(:));
for i = 1:size(avgGazeSpeed,1)
    for j = 1:size(avgGazeSpeed,2)
        if(avgGazeSpeed(i,j) >= meanOfGazeSpeed+3*stdOfGazeSpeed || avgGazeSpeed(i,j) <= meanOfGazeSpeed - 3*stdOfGazeSpeed)
            avgGazeSpeed(i,j) = nan;
        end
    end
end
avgGazeSpeed(any(isnan(avgGazeSpeed),2),:) = [];
subplot(1,1,1)
[p_data, tbl_data, stats_data]=friedman(avgGazeSpeed, 1, 'off');
plot(avgGazeSpeed', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
hold on;
plot(median(avgGazeSpeed), 'k+', 'markersize', 16, 'linewidth', 2);
title(p_data)
if p_data < 0.05
    res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
    %         if disp1

    sigstar([],res_data,1);
    %         end
end
set(gca, 'xtick', 1:8)
xlabel("Condition")
ylabel("Average Gaze Speed ( deg/s)")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName;

%% Average Ground Speed
figure
c = 1;
avgSubjectGroundSpeed = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 2:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','avgSubjectGroundSpeed.csv'];
        if isfile(fileName)
            avgSubjectGroundSpeed(ii,j-1) = readmatrix(fileName);
            c = c + 1;
        end
        if ~isfile(fileName)
            avgSubjectGroundSpeed(ii,j-1) = nan;
            c = c + 1;
        end
    end
end
avgSubjectGroundSpeed(any(isnan(avgSubjectGroundSpeed),2),:) = [];

subplot(1,1,1)
[p_data, tbl_data, stats_data]=friedman(avgSubjectGroundSpeed, 1, 'off');
plot(avgSubjectGroundSpeed', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
hold on;
plot(median(avgSubjectGroundSpeed), 'k+', 'markersize', 16, 'linewidth', 2);
title(p_data)
if p_data < 0.05
    res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
    %         if disp1

    sigstar([],res_data,1);
    %         end
end
set(gca, 'xtick', 1:8)
xlabel("Condition")
ylabel("Average Ground Speed(m/s)")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName(2:9);

%% time to finish
figure
c = 1;
time2FinishBySubject = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 2:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','time_to_finish.csv'];
        if isfile(fileName)
            time2FinishBySubject(ii,j-1) = readmatrix(fileName);
            c = c + 1;
        end
        if ~isfile(fileName)
            time2FinishBySubject(ii,j-1) = nan;
            c = c + 1;
        end
    end
end
time2FinishBySubject(any(isnan(time2FinishBySubject),2),:) = [];

subplot(1,1,1)
[p_data, tbl_data, stats_data]=friedman(time2FinishBySubject, 1, 'off');
plot(time2FinishBySubject', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
hold on;
plot(median(time2FinishBySubject), 'k+', 'markersize', 16, 'linewidth', 2);
% title(p_data)
% if p_data < 0.05
%     res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
%     %         if disp1
% 
%     sigstar([],res_data,1);
%     %         end
% end
set(gca, 'xtick', 1:8)
xlabel("Condition")
ylabel("Time to find (s)")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName;

%% NASA TLX
figure
c = 1;
time2FinishBySubject = [];
questions = ["Mental Demand", "Physical Demand", "Temporal Demand", "Performance", "Effort", "Frustration"];
q = [];
for ii = 1:numel(subject)
    for j = 2:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','TLX.csv'];
        if isfile(fileName)
            temp = readmatrix(fileName);
            q(ii,j-1,1) = temp(1);
            q(ii,j-1,2) = temp(2);
            q(ii,j-1,3) = temp(3);
            q(ii,j-1,4) = temp(4);
            q(ii,j-1,5) = temp(5);
            q(ii,j-1,6) = temp(6);
            c = c + 1;
        end
        if ~isfile(fileName)
            q(ii,j-1,1) = nan;
            q(ii,j-1,2) = nan;
            q(ii,j-1,3) = nan;
            q(ii,j-1,4) = nan;
            q(ii,j-1,5) = nan;
            q(ii,j-1,6) = nan;
            c = c + 1;
        end
    end
end
q(any(any(isnan(q),3),2),:,:) = [];

for i = 1:size(q,3)
    subplot(2,3,i)
    [p_data, tbl_data, stats_data]=friedman(q(:,:,i), 1, 'off');
    plot(q(:,:,i)', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
    hold on;
    plot(median(q(:,:,i)), 'k+', 'markersize', 16, 'linewidth', 2);
    title(p_data)
    if p_data < 0.05
        res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
        %         if disp1

        sigstar([],res_data,1);
        %         end
    end
    set(gca, 'xtick', 1:8)
    xlabel("Condition")
    ylabel("TLX Score")
    str = [questions(i),' ',num2str(p_data) ];
    title(str)
    ax = gca;
    ax.FontSize = 18;
    ax.TickLabelInterpreter = 'latex';
    ax.XTickLabel = trialName;
end



%% Distance from inset corner
figure(3)
c = 1;
distanceFromInsetBySubject = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 2:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','distance_from_corner.csv'];
        if isfile(fileName)
            distanceFromInsetBySubject(ii,j-1) = mean(readmatrix(fileName));
            c = c + 1;
        end
        if ~isfile(fileName)
            distanceFromInsetBySubject(ii,j-1) = nan;
            c = c + 1;
        end
    end
end
distanceFromInsetBySubject(any(isnan(distanceFromInsetBySubject),2),:) = [];

subplot(1,1,1)
[p_data, tbl_data, stats_data]=friedman(distanceFromInsetBySubject, 1, 'off');
plot(distanceFromInsetBySubject', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
hold on;
plot(median(distanceFromInsetBySubject), 'k+', 'markersize', 16, 'linewidth', 2);
title(p_data)
if p_data < 0.05
    res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
    %         if disp1

    sigstar([],res_data,1);
    %         end
end
set(gca, 'xtick', 1:8)
xlabel("Condition")
ylabel("Fixation Distance from top right corner")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName(2:9);

%% Cognitive load
figure(4)
c = 1;
cogLoadBySubject = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 2:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','cogLoad_win=5s.csv'];
        if isfile(fileName)
            cogLoadBySubject(ii,j-1) = readmatrix(fileName);
            c = c + 1;
        end
        if ~isfile(fileName)
            cogLoadBySubject(ii,j-1) = nan;
            c = c + 1;
        end
    end
end
percentOfDataRejected = numel(find(isnan(cogLoadBySubject)))/numel(cogLoadBySubject)
cogLoadBySubject
cogLoadBySubject(any(isnan(cogLoadBySubject),2),:) = [];

subplot(1,1,1)
[p_data, tbl_data, stats_data]=friedman(cogLoadBySubject, 1, 'off');
plot(cogLoadBySubject', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
hold on;
plot(median(cogLoadBySubject), 'k+', 'markersize', 16, 'linewidth', 2);
title(p_data)
if p_data < 0.05
    res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
    %         if disp1

    sigstar([],res_data,1);
    %         end
end
set(gca, 'xtick', 1:8)
xlabel("Condition")
ylabel("Cognitive load (uV^2/Hz)")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName(2:9);
%% Cognitive load first X seconds
c = 1;
figure(8)
clf;
cogLoadBySubject = [];
trials = strings;
csvfileName = 'cogload_First6s_from0s.csv';
negThreshold = -5*100;
posThreshold = 5*100;
for ii = 1:numel(subject)
    for j = 2:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\',csvfileName];
        if isfile(fileName)
            cogLoadBySubject(ii,j-1) = readmatrix(fileName);
            c = c + 1;
        end
        if ~isfile(fileName)
            cogLoadBySubject(ii,j-1) = nan;
            c = c + 1;
        end
    end

    %     for j = 1:numel(cogLoadBySubject(ii,:))
    %         if cogLoadBySubject(ii,j)<negThreshold || cogLoadBySubject(ii,j)>posThreshold
    %             cogLoadBySubject(ii,j) = nan;
    %         end
    %     end



end
cogLoadBySubject(any(isnan(cogLoadBySubject),2),:) = [];
rejectionRate1 = 1 - size(cogLoadBySubject,1)/20;
%rejectionRate
meanOfCog = mean(cogLoadBySubject(:));
stdOfCog = std(cogLoadBySubject(:));
for i = 1:size(cogLoadBySubject,1)
    for j = 1:size(cogLoadBySubject,2)
        if(cogLoadBySubject(i,j) >= meanOfCog+3*stdOfCog || cogLoadBySubject(i,j) <= meanOfCog - 3*stdOfCog)
            cogLoadBySubject(i,j) = nan;
        end
    end
end
cogLoadBySubject(any(isnan(cogLoadBySubject),2),:) = [];
rejectionRate2 = 1 - size(cogLoadBySubject,1)/20;

rejectionRateDueToOutlier = (rejectionRate2 - rejectionRate1)*20
rejectionRate1*20

[p_data, tbl_data, stats_data]=friedman(cogLoadBySubject, 1, 'off');
plot(cogLoadBySubject', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
hold on;
plot(median(cogLoadBySubject), 'k+', 'markersize', 16, 'linewidth', 2);
title(p_data)
if p_data < 0.05
    res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
    %         if disp1

    sigstar([],res_data,1);
    %         end
end
set(gca, 'xtick', 1:8)
xlabel("Condition")
ylabel("Cognitive load (uV^2/Hz)")
title(csvfileName,'Interpreter','none')
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName(2:9);
hold off
%% Gaze, % fixation, % saccades
figure
%  fixation
c = 1;
fixationsBySubject = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 2:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','percentFixations.csv'];
        if isfile(fileName)
            fixationsBySubject(ii,j-1) = mean(readmatrix(fileName));
            c = c + 1;
        end
        if ~isfile(fileName)
            fixationsBySubject(ii,j-1) = nan;
            c = c + 1;
        end
    end
end
fixationsBySubject(any(isnan(fixationsBySubject),2),:) = [];

subplot(1,2,1)
[p_data, tbl_data, stats_data]=friedman(fixationsBySubject, 1, 'off');
plot(fixationsBySubject', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
hold on;
plot(median(fixationsBySubject), 'k+', 'markersize', 16, 'linewidth', 2);
title(p_data)
if p_data < 0.05
    res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
    %         if disp1

    sigstar([],res_data,1);
    %         end
end
set(gca, 'xtick', 1:8)
xlabel("Condition")
ylabel("Percent of time spent on fixating")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName(2:9);

% Saccades
c = 1;
saccadeBySubject = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 2:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','percentSaccades.csv'];
        if isfile(fileName)
            saccadeBySubject(ii,j-1) = mean(readmatrix(fileName));
            c = c + 1;
        end
        if ~isfile(fileName)
            saccadeBySubject(ii,j-1) = nan;
            c = c + 1;
        end
    end
end
saccadeBySubject(any(isnan(saccadeBySubject),2),:) = [];

subplot(1,2,2)
[p_data, tbl_data, stats_data]=friedman(saccadeBySubject, 1, 'off');
plot(saccadeBySubject', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
hold on;
plot(median(saccadeBySubject), 'k+', 'markersize', 16, 'linewidth', 2);
title(p_data)
if p_data < 0.05
    res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
    %         if disp1

    sigstar([],res_data,1);
    %         end
end
set(gca, 'xtick', 1:8)
xlabel("Condition")
ylabel("Percent of time spent on saccades")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName(2:9);

%% fixationRatio
figure
%  fixation
c = 1;
totalFixationBySubject = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 2:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','fixationTimeRatio.csv'];
        if isfile(fileName)
            totalFixationBySubject(ii,j-1) = mean(readmatrix(fileName));
            c = c + 1;
        end
        if ~isfile(fileName)
            totalFixationBySubject(ii,j-1) = nan;
            c = c + 1;
        end
    end
end
totalFixationBySubject(any(isnan(totalFixationBySubject),2),:) = [];

[p_data, tbl_data, stats_data]=friedman(totalFixationBySubject, 1, 'off');
plot(totalFixationBySubject', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
hold on;
plot(median(totalFixationBySubject), 'k+', 'markersize', 16, 'linewidth', 2);
title(p_data)
if p_data < 0.05
    res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
    %         if disp1

    sigstar([],res_data,1);
    %         end
end
set(gca, 'xtick', 1:8)
xlabel("Condition")
ylabel("Percentage of time fixation")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName;

%% Dwell time percent inside mini-map
figure(3)
c = 1;
percentDwellTime = [];
trials = strings;
for ii = 1:numel(subject)
    for j = 2:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','percentDwellMiniMap.csv'];
        if isfile(fileName)
            percentDwellTime(ii,j-1) = mean(readmatrix(fileName));
            c = c + 1;
        end
        if ~isfile(fileName)
            percentDwellTime(ii,j-1) = nan;
            c = c + 1;
        end
    end
end
percentDwellTime(any(isnan(percentDwellTime),2),:) = [];

subplot(1,1,1)
[p_data, tbl_data, stats_data]=friedman(percentDwellTime, 1, 'off');
plot(percentDwellTime', '-o', 'markersize', 12, 'color', ones(1,3)*.5, 'markerface', ones(1,3)*.75);
hold on;
plot(median(percentDwellTime), 'k+', 'markersize', 16, 'linewidth', 2);
title(p_data)
if p_data < 0.05
    res_data=multcompare(stats_data, 'Ctype','bonferroni', 'Display', 'off');
    %         if disp1

    sigstar([],res_data,1);
    %         end
end
set(gca, 'xtick', 1:8)
xlabel("Condition")
ylabel("Percent dwell time")
ax = gca;
ax.FontSize = 18;
ax.TickLabelInterpreter = 'latex';
ax.XTickLabel = trialName;