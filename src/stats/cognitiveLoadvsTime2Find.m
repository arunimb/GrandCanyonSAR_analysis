%% housekeeping
clearvars
close all
clc

% This file plots filtered EEG and cognitive load

subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
preFolder = '..\..\data\'; % location of subject data folders
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [111,211,121,221,112,212,122,222];
% Bhattacharya, Arunim, and Sachit Butail. "Measurement and Analysis of Cognitive Load
% Associated with Moving Object Classification in Underwater Environments."
% International Journal of Human–Computer Interaction (2023): 1-11.
eegChannelWeighting = [ 0.0398,    0.370,    0.1741 ,   0.6393 ,  ...
    0   ,      0   ,      0   ,      0 ,        0  ,       0  , ...
    0.6393  ,  0.1741 ,0.3706,    0.0398];
cogWindow = 5; % Cognitive load calculation window
samplingRate = 256; % EEG sampling rate (Hz)
regularizationDt = 1/24;
aggCogLoad = [];
aggTime2Finish = [];
for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        % Get filtered EEG filename for the trial section
        fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','eegFiltered.csv'];
        % Get baseline filtered EEG filename for the trial section
        fileName2 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','eegBaselineFiltered.csv'];

        fileName3 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','time_to_finish.csv'];
        if isfile(fileName1)
            %disp(cell2mat(subject(ii)));
            eeg = readmatrix(fileName1);
            time2Finish = readmatrix(fileName3);



            eegTime = eeg(:,1);
            eegTime = eegTime-eegTime(1); % set start time to 0
            eegTimeEnd = time2Finish;
            % Frontal EEG cannels
            eegChannels = ["AF3","F7","F3","FC5","FC6","F4","F8","AF4"];
            % Extract frontal EEG samples
            frontalEEG = [eeg(:,2:5),eeg(:,12:15)];

            cogLoad = [];
            cogLoadTime = [];
            cogLoadIndexer = 1;
            baselineEEG = readmatrix(fileName2);

            cogLoadIndex = 1;
            cogLoad=[];
            for k = 1:cogWindow*samplingRate:eegTimeEnd*samplingRate-(cogWindow*samplingRate)+1
                [~,~,~,~,~,cogLoad(cogLoadIndex)] = cogload(baselineEEG(:,2:end)', eeg(k:k+cogWindow*samplingRate,2:end)', ...
                    1/samplingRate,eegChannelWeighting/sum(eegChannelWeighting),'alphaDiff','fft');
                cogLoadIndex = cogLoadIndex + 1;
            end
        end
        aggCogLoad = [aggCogLoad,mean(cogLoad)];
        aggTime2Finish = [aggTime2Finish,time2Finish];
    end
end

outlierCogLoad = mean(aggCogLoad) + 3*std(aggCogLoad);

indRej = abs(aggCogLoad) <= outlierCogLoad ;
aggCogLoad = aggCogLoad(indRej);
aggTime2Finish = aggTime2Finish(indRej);

[RR,pp ] = corrcoef(aggCogLoad,aggTime2Finish);
RTime2Finish = RR(1,2);
pTime2Finish = pp(1,2);
% d1=dataset(aggCogLoad, aggTime2Finish);
% % mdl=fitlm(d, 'cognitiveLoad~reactionTime+ageYrs') % use this only if the alpha range is set by age
% mdl=fitlm(d1, 'aggCogLoad~aggTime2Finish')
% figure(1); gcf; clf;
% subplot(121)
% plot(mdl);
% xlabel('Time to finish (s)');
% ylabel('Average Cognitive load (v)');