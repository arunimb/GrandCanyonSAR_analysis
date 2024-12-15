%%%%% Plots figure 6


clearvars
close all
clc

% Read subject id list
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\'; % location of subject data folders
addpath('..\..\');
trialNum = [111,211,121,221,112,212,122,222];
%trialUnclustered = [111,211,121,221];
%trialClustered = [112,212,122,222];
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
trialCombination = [111,112;211,212;121,122;221,222];
dFromCentreClustered = [];
titles={'NN','YN','NY','YY'};
figure(1);
c = 1;
for j = 1:size(trialCombination,1)
    aggX = [];
    aggY = [];
    for ii = 1:numel(subject)

        % Get Trajectory file name
        for k=1:2
            fileName = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialCombination(j,k)),'\','Trajectory*.csv']);
            % Get swarm position
            fileName = [fileName.folder,'\',fileName.name];
            trajFile = readmatrix(fileName); % Get Trajectory data
            swarmCentreX = trajFile(2,2);
            swarmCentreY = trajFile(2,4);
            swarmCentreZ = trajFile(2,3);
            timeStamps = trajFile(:,1); % 1st column of trajectory data is time stamps

            % Routine to identify paused simulation, f2 key marks the beginning
            % of the trial, also unpauses the simulation for the subject. F11
            % key marks the end of the trial, pauses the trial for the subject.
            % When the simulation is paused, the recorded timestamps do not
            % change, so the diff function lets us identify beginning and
            % ending of a trial.
            diffTimeStamps = diff(timeStamps(2:end));

            pause1 = 0; % start of trial index (guess)
            for k = 1:numel(diffTimeStamps)
                if (diffTimeStamps(k) ~= 0)
                    pause1 = k+1;
                    break; % Break when encountering a non zero diff value
                end
            end

            pause2 = 0; % end of trial index (guess)
            for k = pause1+1:numel(diffTimeStamps)
                if (diffTimeStamps(k) == 0)
                    pause2 = k; % Break when encountering a zero diff value
                    break;
                end
            end

            % Trim time to 600 seconds. subjects who do not search within 600
            % seconds are truncated.
            time2finish = timeStamps(pause2)-timeStamps(pause1); % guess time to finish


            % truncate the trajectory data
            trajFile = trajFile(pause1:pause2,:);
            trajFile2 = trajFile;
            timeStamps = trajFile(:,1)-trajFile(1,1);


            subjectXPos = trajFile(:,2)-trajFile(2,2);
            subjectYPos = trajFile(:,4)-trajFile(2,4);

            aggX= [aggX,subjectXPos'];
            aggY= [aggY,subjectYPos'];

        end
    end
subplot(2,2,j)
viscircles([0,0],0.36*1000,'Color',"black")
hold on
viscircles([0,0],0.72*1000,'Color',"black")
viscircles([0,0],1.08*1000,'Color',"black")
axis equal
h = histogram2(aggX,aggY,[300 300],'DisplayStyle','tile','FaceColor','flat');
xlim([-1500 1500])
ylim([-1500 1500])
xlabel("X position (m)");
ylabel("Y position (m)");
title(titles(j))
grid on
colorbar
colormap sky
clim([10 30])
end
