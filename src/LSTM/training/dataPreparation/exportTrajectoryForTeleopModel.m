% This script exports trajectory data for the first X seconds.

% Read subject id list
subject = cellstr(num2str(readmatrix('..\..\..\..\data\participantID1.csv')));
preFolder = '..\..\..\..\data\'; % location of subject data folders
addpath('..\..\');
saveFolder = 'exportedTrajectoryTeleoperatorModelling\';
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [111,211,121,221,112,212,122,222];
personKnowledge = [1,2,1,2,1,2,1,2];
terrainKnowledge = [1,1,2,2,1,1,2,2];
interpolationSampleRate = 24;
unwrapOrNot = 1; % Unwrap heading data or not, 1 = yes
samplingRate = 24; % Average sampling rate for unity
%windowSize = 15;


for windowSize = 5:5:20
    trajectoryExportWindow = windowSize * interpolationSampleRate;
    s1 = ["================== Window ", num2str(windowSize), "s ==================" ];
    disp(s1);
    tempSample = [];
    for ii = 1:numel(subject)
        s2 = ["============ Subject ", cell2mat(subject(ii)), " ============" ];
        disp(s2);
        accumulateXtrajSegments = [];
        accumulateYtrajSegments = [];
        accumulateZtrajSegments = [];
        accumulateXswarmCentroid = [];
        accumulateZswarmCentroid= [];
        accumulateXswarmStd = [];
        accumulateZswarmStd = [];
        accumulatePersonKnowledge = [];
        accumulateTerrainKnowledge = [];

        accumulateOutputXvel = [];
        accumulateOutputYvel = [];
        accumulateOutputZvel = [];
        accumulateOutputXacc = [];
        accumulateOutputYacc = [];
        accumulateOutputZacc = [];
        for j = 1:numel(trialNum)

            fileName = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','Trajectory*.csv']);
            fileName = [fileName.folder,'\',fileName.name];
            trajFile = readmatrix(fileName); % Get Trajectory data
            timeStamps = trajFile(:,1); % 1st column of trajectory data is time stamps

            fileName2 = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','SwarmPosition.csv']);
            fileName2 = [fileName2.folder,'\',fileName2.name];
            swarmPos = readmatrix(fileName2);
            xStd = std(swarmPos(:,1));
            zStd = std(swarmPos(:,3));

            xCentroid = mean(swarmPos(:,1));
            zCentroid = mean(swarmPos(:,3));


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

            % wrap to pi heading data
            if (unwrapOrNot)
                trajFile(:,6) = unwrap(trajFile(:,6)*2*pi/360); % [in radians]
                trajFile(:,6) = trajFile(:,6)*180/pi; % [deg]
            end

            % Regularize timestamps, trajectory, heading
            regTimeStamps = timeStamps(1):1/interpolationSampleRate:timeStamps(end); % resample timestamps to regularly spaced timestamps

            % Resample trajectory data, heading, to new timestamps
            if 1
                tempTraj = zeros(numel(regTimeStamps),7);
                for kk = 2:7
                    tempTraj(:,kk) = interp1(timeStamps,trajFile(:,kk),regTimeStamps);
                end
                trajFile = tempTraj;
            else
                regTimeStamps = timeStamps;
            end
            sectionX = [];
            sectionY = [];
            sectionZ = [];
            swarmStdX = [];
            swarmStdZ = [];
            swarmCentX = [];
            swarmCentZ = [];
            personKnowledgeSection = [];
            terrainKnowledgeSection = [];
            outputXvel = [];
            outputYvel = [];
            outputZvel = [];
            outputXacc = [];
            outputYacc = [];
            outputZacc = [];

            c = 0;
            for ll = 1:trajectoryExportWindow:size(trajFile,1)-trajectoryExportWindow-3
                sectionX = [sectionX;trajFile(ll:ll+trajectoryExportWindow-1,2)']; % keeping unity format for coordinates
                sectionY = [sectionY;trajFile(ll:ll+trajectoryExportWindow-1,3)']; % keeping unity format for coordinates
                sectionZ = [sectionZ;trajFile(ll:ll+trajectoryExportWindow-1,4)']; % keeping unity format for coordinates
                swarmStdX = [swarmStdX;xStd];
                swarmStdZ = [swarmStdZ;zStd];
                swarmCentX = [swarmCentX;xCentroid];
                swarmCentZ = [swarmCentZ;zCentroid];
                personKnowledgeSection = [personKnowledgeSection;personKnowledge(j)];
                terrainKnowledgeSection = [terrainKnowledgeSection;terrainKnowledge(j)];
                XVel = (trajFile(ll+trajectoryExportWindow,2)-trajFile(ll+trajectoryExportWindow-1,2))/(1/interpolationSampleRate);
                YVel = (trajFile(ll+trajectoryExportWindow,3)-trajFile(ll+trajectoryExportWindow-1,3))/(1/interpolationSampleRate);
                ZVel = (trajFile(ll+trajectoryExportWindow,4)-trajFile(ll+trajectoryExportWindow-1,4))/(1/interpolationSampleRate);
                outputXvel = [outputXvel;XVel];
                outputYvel = [outputYvel;YVel];
                outputZvel = [outputZvel;ZVel];
                xAcc = ((trajFile(ll+trajectoryExportWindow+1,2)-trajFile(ll+trajectoryExportWindow,2))/(1/interpolationSampleRate) ...
                    - (trajFile(ll+trajectoryExportWindow,2)-trajFile(ll+trajectoryExportWindow-1,2))/(1/interpolationSampleRate))/(1/interpolationSampleRate);
                yAcc = ((trajFile(ll+trajectoryExportWindow+1,3)-trajFile(ll+trajectoryExportWindow,3))/(1/interpolationSampleRate) ...
                    - (trajFile(ll+trajectoryExportWindow,3)-trajFile(ll+trajectoryExportWindow-1,3))/(1/interpolationSampleRate))/(1/interpolationSampleRate);
                zAcc = ((trajFile(ll+trajectoryExportWindow+1,4)-trajFile(ll+trajectoryExportWindow,4))/(1/interpolationSampleRate) ...
                    - (trajFile(ll+trajectoryExportWindow,4)-trajFile(ll+trajectoryExportWindow-1,4))/(1/interpolationSampleRate))/(1/interpolationSampleRate);
                outputXacc = [outputXacc;xAcc];
                outputYacc = [outputYacc;yAcc];
                outputZacc = [outputZacc;zAcc];
                c = c + 1;
            end

            accumulateXtrajSegments = [accumulateXtrajSegments;sectionX];
            accumulateYtrajSegments = [accumulateYtrajSegments;sectionY];
            accumulateZtrajSegments = [accumulateZtrajSegments;sectionZ];
            accumulateXswarmStd = [accumulateXswarmStd;swarmStdX];
            accumulateZswarmStd = [accumulateZswarmStd;swarmStdZ];
            accumulateXswarmCentroid = [accumulateXswarmCentroid;swarmCentX];
            accumulateZswarmCentroid = [accumulateZswarmCentroid;swarmCentZ];
            accumulatePersonKnowledge = [accumulatePersonKnowledge;personKnowledgeSection];
            accumulateTerrainKnowledge = [accumulateTerrainKnowledge;terrainKnowledgeSection];
            accumulateOutputXvel = [accumulateOutputXvel;outputXvel];
            accumulateOutputYvel = [accumulateOutputYvel;outputYvel];
            accumulateOutputZvel = [accumulateOutputZvel;outputZvel];
            accumulateOutputXacc = [accumulateOutputXacc;outputXacc];
            accumulateOutputYacc = [accumulateOutputYacc;outputYacc];
            accumulateOutputZacc = [accumulateOutputZacc;outputZacc];
        end
        %temp = [subjectSpeed', subjectTurnRate'];
        writeFolder = [saveFolder,'windowSize_',num2str(windowSize),'\',cell2mat(subject(ii)),'\'];
        mkdir(writeFolder) 
        writematrix(accumulateXtrajSegments/1000,[writeFolder,'accumulateXtrajSegments.csv']);
        writematrix(accumulateYtrajSegments/1000,[writeFolder,'accumulateYtrajSegments.csv']);
        writematrix(accumulateZtrajSegments/1000,[writeFolder,'accumulateZtrajSegments.csv']);
        writematrix(accumulateXswarmStd/1000,[writeFolder,'accumulateXswarmStd.csv']);
        writematrix(accumulateZswarmStd/1000,[writeFolder,'accumulateZswarmStd.csv']);
        writematrix(accumulateXswarmCentroid/1000,[writeFolder,'accumulateXswarmCentroid.csv']);
        writematrix(accumulateZswarmCentroid/1000,[writeFolder,'accumulateZswarmCentroid.csv']);
        writematrix(accumulatePersonKnowledge/1000,[writeFolder,'accumulatePersonKnowledge.csv']);
        writematrix(accumulateTerrainKnowledge/1000,[writeFolder,'accumulateTerrainKnowledge.csv']);
        writematrix(accumulateOutputXvel/1000,[writeFolder,'accumulateOutputXvel.csv']);
        writematrix(accumulateOutputYvel/1000,[writeFolder,'accumulateOutputYvel.csv']);
        writematrix(accumulateOutputZvel/1000,[writeFolder,'accumulateOutputZvel.csv']);
        writematrix(accumulateOutputXacc/1000,[writeFolder,'accumulateOutputXacc.csv']);
        writematrix(accumulateOutputYacc/1000,[writeFolder,'accumulateOutputYacc.csv']);
        writematrix(accumulateOutputZacc/1000,[writeFolder,'accumulateOutputZacc.csv']);
        %writematrix(temp,saveTrajFile);
        %writematrix(trajectoryExportWindow,saveWindowFile);

    end

end
