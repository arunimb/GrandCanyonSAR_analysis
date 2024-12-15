clearvars
close all
clc

trajPath = 'E:\PreliminaryAnalysisGrandCanyon\data\';
subject = cellstr(num2str(readmatrix([trajPath, 'participantID1.csv'])));
exportPath = 'D:\UWmonitoring\MissingPersonSearchSim\Assets\trajData\';
% Trial order
samplingRate = 24; % Average sampling rate for unity
interpolationSampleRate = samplingRate;
trialNum = [111,211,121,221,112,212,122,222];
unwrapOrNot = 1;
interpolating = 1;

for ii = 1:numel(subject)
    s2 = ["============ Subject ", cell2mat(subject(ii)), " ============" ];
    disp(s2);
    for j = 1:numel(trialNum)
        % Import Trajectory
        % Trajectory data columns: time(s), xPos, yPos, zPos, xRot (deg),
        % yRot (deg), zRot (deg), camera pitch (deg)
        % xPos, yPos, zPos are in unity and y is pointing up
        % xRot, yRot, zRot are in fixed frame
        % camera pitch is positive pointing down
        s3 = ["======== Trial ", num2str(trialNum(j)), " ========" ];
        disp(s3);

        fileName = dir([trajPath, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','Trajectory*.csv']);
        fileName = [fileName.folder,'\',fileName.name];
        trajFile = readmatrix(fileName); % Get Trajectory data
        timeStamps = trajFile(:,1); % 1st column of trajectory data is time stamps

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

        disp(pause2)


        % truncate the trajectory data
        trajFile = trajFile(pause1:pause2,:);
        timeStamps = trajFile(:,1)-trajFile(1,1);

        % wrap to pi heading data
        if (unwrapOrNot)
            trajFile(:,6) = unwrap(trajFile(:,6)*2*pi/360); % [in radians]
            trajFile(:,6) = trajFile(:,6)*180/pi; % [deg]
        end

        % Regularize timestamps, trajectory, heading
        regTimeStamps = timeStamps(1):1/interpolationSampleRate:timeStamps(end); % resample timestamps to regularly spaced timestamps

        % Resample trajectory data, heading, to new timestamps
        if interpolating
            tempTraj = zeros(numel(regTimeStamps),7);
            for kk = 2:7
                tempTraj(:,kk) = interp1(timeStamps,trajFile(:,kk),regTimeStamps);
            end
            trajFile = tempTraj;
        else
            regTimeStamps = timeStamps;
        end

        % folder where to save trajectory file
        saveFolder = [exportPath, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\',];

        % If folder exists, do not create a folder
        if ~exist(saveFolder, 'dir')
            mkdir(saveFolder)
        end

        % Because unity y is real world z
        subjectXPos = trajFile(:,2);% + normrnd(mu,sigma,size(trajFile(:,2)));
        subjectYPos = trajFile(:,4);% + normrnd(mu,sigma,size(trajFile(:,4)));
        subjectZPos = trajFile(:,3);% + normrnd(mu,sigma,size(trajFile(:,3)));
        % File save location
        saveTrajFile = [saveFolder,'trajectory.csv'];

        if ~isempty(trajFile)
            temp = [regTimeStamps',subjectXPos,subjectZPos,subjectYPos,trajFile(:,6)];
            %writematrix(temp,saveTrajFile);
        end
        swarmStartPos = temp(1,2:4);
        swarmPosition = readmatrix([trajPath, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','SwarmPosition.csv']);
        
        % Get trajectory 
        %trajFile = readmatrix([fileName.folder,'\',fileName.name]);
        
        % read trajectory as text file to obtain missing person position
        A = fileread(fileName); 
        k1 = strfind(A,'Ethan Pos:');
        k2 = strfind(A,'Color Pair');
        neededString = A(k1+11:k2-2);
        splitString = strsplit(neededString,' ');
        ethanPos = str2double(splitString');
        ethanPos = ethanPos';
        saveEthanPosition = [saveFolder,'ethanPos.csv'];
        saveSwarmPosition = [saveFolder,'swarmPos.csv'];
        saveSwarmStartPosition = [saveFolder,'swarmStartPos.csv'];
        %writematrix(ethanPos,saveEthanPosition);
        %writematrix(swarmPosition,saveSwarmPosition);
        writematrix(swarmStartPos,saveSwarmStartPosition);
    end
end