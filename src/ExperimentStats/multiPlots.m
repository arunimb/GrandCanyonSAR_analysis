%%%% This script plots Figure 4

clearvars
close all
clc
%%
addpath("subtightplot\")
trajPath = "..\simulation\trajData\";
speedFilePath = '..\simulation\trajData\';
% Read subject id list
subject = cellstr(num2str(readmatrix(strcat(trajPath,'participantID1.csv'))));
% Standard order of trials, which is different from subjectwise trial
% order
% trialNum = [111,211,121,221,112,212,122,222];
% trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'}; % Person, Terrain, Swarm cohesion
trialNum = [111,121,212,222];
trialName = {'NNU','NYU','YNC','YYC'}; % Person, Terrain, Swarm cohesion
ii = 14;
plotWindow = 60;
figure(1)
clf;
%% trajectory
for j = 1:numel(trialNum)
    fileName = strcat(trajPath,[cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','trajectory.csv']);
    ethanFile = strcat(trajPath,[cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','ethanPos.csv']);
    trajFile = readmatrix(fileName); % Get Trajectory data
    ethanPos = readmatrix(ethanFile);
    swarmPosition = readmatrix(strcat(trajPath,[cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\', 'swarmPos.csv']));

    xPos = trajFile(:,2);
    zPos = trajFile(:,3);
    yPos = trajFile(:,4);
    heading = trajFile(:,5);

    opt = [0.06 0.06];
    subtightplot(5,4,j,opt,opt,opt)
    plot3(xPos,yPos,zPos,LineWidth=2) % Plot trajectory of human controlled drone
    hold on
    scatter3 (xPos(1),yPos(1),zPos(1),"green","filled","o") % Plot Drone start position
    hold on
    scatter3 (xPos(end),yPos(end),zPos(end),"red","filled","o")% Plot Drone end position
    hold on
    scatter3 (swarmPosition(:,1),swarmPosition(:,3),swarmPosition(:,2),5,"k","filled","o")% Plot swarm drone locations
    hold on
    h = scatter3 (ethanPos(1),ethanPos(3),ethanPos(2),12,"r","+"); % Plot missing person position
    hold on

    title(trialName{j});
    grid on
    hold off

    % Only Plot legend for the first plot
    if j==1
        %legend("Trajectory","Start","End","Swarm","Missing Person");
        xlabel("X location (m)");
        ylabel("Y location (m)");
        zlabel("Z location (m)");
    end
    ax = ancestor(h, 'axes');
    ax.XAxis.Exponent = 0;
    ax.YAxis.Exponent = 0;
    ytickformat('%1.0e');
    xtickformat('%1.0e');
    %view(2)
end
% Gaze
for j = 1:numel(trialNum)
    fileName1 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','calibratedGaze.csv'];
    if isfile(fileName1)
        disp(cell2mat(subject(ii)));
        gaze = readmatrix(fileName1);
        gazeTime = gaze(:,1);
        gazeCalibrated = gaze(:,2:3);
        [~,ind] = min(abs(gazeTime-30));
        opt = [0.04 0.04];
        subtightplot(5,4,j+12,opt,opt,opt)
        scatter(gazeCalibrated(1:ind,1),gazeCalibrated(1:ind,2),0.1,'+')

        %         hold on
        %         plot([0,2560,2560,0,0],[0,0,1080,1080,0],LineWidth=2,Color=[1.0,0.7,0])
        axis image
        xlim([0 2560]);
        ylim([0 1080]);
        pbaspect([2.37 1 1])
        xlabel("x position (pixel)");
        if j==1
            %legend("Trajectory","Start","End","Swarm","Missing Person");

            ylabel("y position (pixel)");
        end
    end
end

% speed
for j = 1:numel(trialNum)
    fileName1 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','speed.csv'];
    fileName2 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','regTime.csv'];
    if isfile(fileName1)
        speed = readmatrix(fileName1);
        time = readmatrix(fileName2);
        opt = [0.06 0.06];
        subtightplot(5,4,j+4,opt,opt,opt)
        plot(time(2:end),speed,LineWidth=2);
        xlim([0 plotWindow]);
        ylim([0 60]);
        grid on;
        if j==1
            %legend("Trajectory","Start","End","Swarm","Missing Person");
            %xlabel("Time (s)")
            ylabel("Speed (m/s)");
        end
    end
end

% turnRate
for j = 1:numel(trialNum)
    fileName1 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','turnRate.csv'];
    fileName2 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','regTime.csv'];
    if isfile(fileName1)
        turnRate = readmatrix(fileName1);
        time = readmatrix(fileName2);
        opt = [0.06 0.06];
        subtightplot(5,4,j+8,opt,opt,opt)
        plot(time(2:end),turnRate,LineWidth=2);
        xlim([0 plotWindow]);
        ylim([0 25]);
        grid on;
        if j==1
            %legend("Trajectory","Start","End","Swarm","Missing Person");
            %xlabel("Time (s)")
            ylabel("Turn rate (deg./s)");
        end
    end
end


%% Cognitive Load
samplerate = 256; % Hz
baselineWindow = 5; % in second
EEGThreshold = 1000; % Max allowable EEG muV
threshold2 = 0.001; % fraction of data allowed to be over EEGThreshold value
windowStartTime = 0;
eegChannelWeighting = [ 0.0398,    0.370,    0.1741 ,   0.6393 ,  ...
    0   ,      0   ,      0   ,      0 ,        0  ,       0  , ...
    0.6393  ,  0.1741 ,0.3706,    0.0398];
for j = 1:numel(trialNum)
    % Get filtered EEG filename for the trial section
    fileName1 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','eegFiltered.csv'];
    % Get baseline filtered EEG filename for the trial section
    fileName2 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','eegBaselineFiltered.csv'];
    if isfile(fileName1)
        disp(cell2mat(subject(ii)));
        eeg = readmatrix(fileName1);
        time = eeg(:,1);
        time = time-time(1); % set start time to 0
        % Frontal EEG cannels
        eegChannels = ["AF3","F7","F3","FC5","FC6","F4","F8","AF4"];
        % Extract frontal EEG samples
        frontalEEG = [eeg(:,2:5),eeg(:,12:15)];

        %Calculate cognitive load
        cogLoad = [];
        cogLoadTime = [];
        cogLoadIndexer = 1;
        baselineEEG = readmatrix(fileName2);
        c = 1;
        for k = 1:1*samplerate:plotWindow*samplerate
            [~,~,~,~,~,cogLoad(1,c)] = cogload(baselineEEG(end-baselineWindow*samplerate:end,2:end)',eeg(k:k+1*samplerate,2:end)', ...
                1/samplerate,eegChannelWeighting/sum(eegChannelWeighting),'alphaDiff','fft');
            c = c + 1;
        end

        opt = [0.06 0.06];
        eegChannels = ["AF3","F7","F3","FC5","FC6","F4","F8","AF4"];
        % Extract frontal EEG samples
        frontalEEG = [eeg(:,2:5),eeg(:,12:15)];
        frontalEEG = frontalEEG';
        subtightplot(5,4,j+16,opt,opt,opt)
        plot(linspace(0,59,numel(cogLoad)),cogLoad,LineWidth=2);
        if j==1
            %legend("Trajectory","Start","End","Swarm","Missing Person");
            %xlabel("Time (s)")
            ylabel(textwrap(uicontrol('Style','text'),"Cognitive Load(uV^2/Hz)"));
        end
        yticks(-10:2:0)
        xlabel("Time (s)")
        xlim([0,plotWindow]);
        ylim([-10 0])
        grid on
        %         if(windowStartTime*samplerate + 1*samplerate <= size(eeg,1))
        %             [~,~,~,~,~,cogLoad] = cogload(baselineEEG(end-baselineWindow*samplerate:end,2:end)', eeg((windowStartTime*samplerate)+1:(windowStartTime*samplerate)+1*samplerate,2:end)', ...
        %                 1/samplerate,eegChannelWeighting/sum(eegChannelWeighting),'alphaDiff','fft');
        %             %saveFolder = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','cogload_First',num2str(cogWindow(mm)),'s','_from',num2str(windowStartTime),'s.csv'];
        %             %writematrix("uV^2/Hz",saveFolder);
        %             %writematrix(cogLoad,saveFolder,'WriteMode','append');
        %         end
    end
end


