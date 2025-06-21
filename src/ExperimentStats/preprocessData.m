clearvars
close all
clc

%Read the list of participants
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
%subject = {'57621'}; %change subject id here
preFolder = '..\..\data\'; % location of subject data folders
postFolder = '..\..\data\';% location of save subject data folders


%% Chop Data

preFolder = '..\..\data\';
preFile1 = 'subject_';
preFile2 = 'trialOrder.txt';
exceptionFile = 'eeg_notRecorded.txt';
cutoffTime = 600;
baselineWindow = 5;
for ii = 1:numel(subject)
    % load mat files generated from stitchData.m
    lookFile = [preFolder, cell2mat(subject(ii)),'\',preFile1,char(subject(ii)),'.mat'];
    load(lookFile)
    userFileLength = numel(data);
    lookFile2 = [preFolder, cell2mat(subject(ii)),'\',preFile2];
    % Import trial order
    trialOrder = readmatrix(lookFile2);
    % Import exception
    exceptionTrials = [preFolder, cell2mat(subject(ii)),'\',exceptionFile];
    eegGazeExceptionTrials = [];
    if isfile(exceptionTrials)
        eegGazeExceptionTrials = readmatrix(exceptionTrials);
    end

    % create dummy structure, assigned to the 6th element because the first
    % 5 are concatenated data from xdf files.
    data{6}.info.name = 'Time stamps using system time record of generated files';
    data{6}.trial = [];
    data{6}.trialLength = [];
    data{6}.UnitytrialLength = [];
    data{6}.trialTimeStamps = strings;
    % RUN ONLY ON BACKUP DRIVE WITH ORIGINAL TIMESTAMPS, OTHERWISE
     % IGNORE THIS SCRIPT
    if 1
        counter = 1;
        for j = 1:numel(trialOrder)
            if ~ismember(trialOrder(j),eegGazeExceptionTrials)
                data{6}.trial(counter) = trialOrder(j);
                % pickup timestamps from start and endscreen images
                data{6}.trialTimeStamps(counter,1) = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialOrder(j)),'\','startScreen*.png']).date; % get startscreen.png file creation time
                data{6}.trialTimeStamps(counter,2) = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialOrder(j)),'\','endScreen*.png']).date; % get endscreen.png file creation time
                trajFileName = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialOrder(j)),'\','Traj*.csv']);
                unityTraj = readmatrix([preFolder, cell2mat(subject(ii)),'\',num2str(trialOrder(j)),'\',trajFileName.name]); % read trajectory file
                data{6}.trialLength(counter) = seconds(datetime(data{6}.trialTimeStamps(counter,2))-datetime(data{6}.trialTimeStamps(counter,1))); %Trial length using timestamps from screenshots creation time
                data{6}.UnitytrialLength(counter) = max(unityTraj(:,1));%Trial length using timestamps from trajectory file
                counter = counter + 1;
            end


        end
    end


    % Look for EEG stream in the data structure
    for eegIndex = 1:numel(data)
        if (strcmp(data{eegIndex}.info.name,'EmotivDataStream-EEG'))
            break;
        end
    end
    % Look for keyboard stream in the data structure
    for keyboardIndex = 1:numel(data)
        try
            if (strcmp(data{keyboardIndex}.info.name,'KeyBoard'))
                break;
            end
        catch
            disp("Some Silly Error");
        end
    end
    % Look for gaze stream in the data structure
    for gazeIndex = 1:numel(data)
        if (strcmp(data{gazeIndex}.info.name,'pupil_capture'))
            break;
        end
    end
    keystrokes = data{keyboardIndex}.time_series;
    keystrokeTime = data{keyboardIndex}.time_stamps;
    keystrokes(keystrokes~=10) = 0;
    %     g = numel(keystrokes(keystrokes ==10));
    %     disp(cell2mat(subject(ii)));
    %     disp(g);

    % identify trial begin time in seconds
    eegTrialIndices = [];
    gazeTrialIndices = [];
    trialStartEndTime = [];
    c = 0;
    if (~strcmp(cell2mat(subject(ii)), '70928') && ~strcmp(cell2mat(subject(ii)), '57621') && ~strcmp(cell2mat(subject(ii)), '19175'))
        for keys = 1:numel(keystrokes)
            if(keystrokes(keys) == 10)
                c=c+1;
                trialStartTime = keystrokeTime(keys);
                if(data{6}.UnitytrialLength(c) > cutoffTime)
                    trialEndTime = trialStartTime+cutoffTime;
                else
                    trialEndTime = trialStartTime+data{6}.UnitytrialLength(c);
                end

                trialStartEndTime(c,1)=trialStartTime;
                trialStartEndTime(c,2)=trialEndTime;
            end
        end

        % get EEG indices
        for kk = 1:c
            temp1 = abs(data{eegIndex}.time_stamps-trialStartEndTime(kk,1));
            [~, eegTrialIndices(kk,1)] = min(temp1);
            temp2 = abs(data{eegIndex}.time_stamps-trialStartEndTime(kk,2));
            [~, eegTrialIndices(kk,2)] = min(temp2);
        end

        % get gaze indices
        for kk = 1:c
            temp1 = abs(data{gazeIndex}.time_stamps-trialStartEndTime(kk,1));
            [~, gazeTrialIndices(kk,1)] = min(temp1);
            temp2 = abs(data{gazeIndex}.time_stamps-trialStartEndTime(kk,2));
            [~, gazeTrialIndices(kk,2)] = min(temp2);
        end
    end

    % Exception for 19175 (2nd half of gaze is not recorded)
    if (strcmp(cell2mat(subject(ii)), '19175'))
        for keys = 1:numel(keystrokes)
            if(keystrokes(keys) == 10)
                c=c+1;
                trialStartTime = keystrokeTime(keys);
                if(data{6}.UnitytrialLength(c) > cutoffTime)
                    trialEndTime = trialStartTime+cutoffTime;
                else
                    trialEndTime = trialStartTime+data{6}.UnitytrialLength(c);
                end
                trialStartEndTime(c,1)=trialStartTime;
                trialStartEndTime(c,2)=trialEndTime;
            end
        end

        % get EEG indices
        for kk = 1:c
            temp1 = abs(data{eegIndex}.time_stamps-trialStartEndTime(kk,1));
            [~, eegTrialIndices(kk,1)] = min(temp1);
            temp2 = abs(data{eegIndex}.time_stamps-trialStartEndTime(kk,2));
            [~, eegTrialIndices(kk,2)] = min(temp2);
        end

        % get gaze indices
        for kk = 6:9
            gazeTrialIndices(kk,1) = nan;
            gazeTrialIndices(kk,2) = nan;
        end

        for kk = 1:5
            temp1 = abs(data{gazeIndex}.time_stamps-trialStartEndTime(kk,1));
            [~, gazeTrialIndices(kk,1)] = min(temp1);
            temp2 = abs(data{gazeIndex}.time_stamps-trialStartEndTime(kk,2));
            [~, gazeTrialIndices(kk,2)] = min(temp2);
        end
    end
    % Exception for 70928 (5th trial LSL is not recorded)
    c = 0;
    if (strcmp(cell2mat(subject(ii)), '70928'))
        for keys = 1:numel(keystrokes)
            if(keystrokes(keys) == 10)
                c=c+1;
                trialStartTime = keystrokeTime(keys);
                if(data{6}.UnitytrialLength(c) > cutoffTime)
                    trialEndTime = trialStartTime+cutoffTime;
                else
                    trialEndTime = trialStartTime+data{6}.UnitytrialLength(c);
                end
                trialStartEndTime(c,1)=trialStartTime;
                trialStartEndTime(c,2)=trialEndTime;
            end
        end
        % get EEG indices
        for kk = 1:4
            temp1 = abs(data{eegIndex}.time_stamps-trialStartEndTime(kk,1));
            [~, eegTrialIndices(kk,1)] = min(temp1);
            temp2 = abs(data{eegIndex}.time_stamps-trialStartEndTime(kk,2));
            [~, eegTrialIndices(kk,2)] = min(temp2);
        end
        for kk = 6:9
            temp1 = abs(data{eegIndex}.time_stamps-trialStartEndTime(kk-1,1));
            [~, eegTrialIndices(kk,1)] = min(temp1);
            temp2 = abs(data{eegIndex}.time_stamps-trialStartEndTime(kk-1,2));
            [~, eegTrialIndices(kk,2)] = min(temp2);
        end
        eegTrialIndices(5,1) = nan;
        eegTrialIndices(5,2) = nan;
        % get gaze indices

        for kk = 1:4
            temp1 = abs(data{gazeIndex}.time_stamps-trialStartEndTime(kk,1));
            [~, gazeTrialIndices(kk,1)] = min(temp1);
            temp2 = abs(data{gazeIndex}.time_stamps-trialStartEndTime(kk,2));
            [~, gazeTrialIndices(kk,2)] = min(temp2);
        end
        for kk = 6:9
            temp1 = abs(data{gazeIndex}.time_stamps-trialStartEndTime(kk-1,1));
            [~, gazeTrialIndices(kk,1)] = min(temp1);
            temp2 = abs(data{gazeIndex}.time_stamps-trialStartEndTime(kk-1,2));
            [~, gazeTrialIndices(kk,2)] = min(temp2);
        end
        gazeTrialIndices(5,1) = nan;
        gazeTrialIndices(5,2) = nan;
    end

    % Exception for 57621 (1st trial LSL is not recorded)
    c = 0;
    if (strcmp(cell2mat(subject(ii)), '57621'))
        for keys = 1:numel(keystrokes)
            if(keystrokes(keys) == 10)
                c=c+1;
                trialStartTime = keystrokeTime(keys);
                if(data{6}.UnitytrialLength(c) > cutoffTime)
                    trialEndTime = trialStartTime+cutoffTime;
                else
                    trialEndTime = trialStartTime+data{6}.UnitytrialLength(c);
                end
                trialStartEndTime(c,1)=trialStartTime;
                trialStartEndTime(c,2)=trialEndTime;
            end
        end
        % get EEG indices

        for kk = 2:9
            temp1 = abs(data{eegIndex}.time_stamps-trialStartEndTime(kk-1,1));
            [~, eegTrialIndices(kk,1)] = min(temp1);
            temp2 = abs(data{eegIndex}.time_stamps-trialStartEndTime(kk-1,2));
            [~, eegTrialIndices(kk,2)] = min(temp2);
        end
        eegTrialIndices(1,1) = nan;
        eegTrialIndices(1,2) = nan;
        % get gaze indices

        for kk = 2:9
            temp1 = abs(data{gazeIndex}.time_stamps-trialStartEndTime(kk-1,1));
            [~, gazeTrialIndices(kk,1)] = min(temp1);
            temp2 = abs(data{gazeIndex}.time_stamps-trialStartEndTime(kk-1,2));
            [~, gazeTrialIndices(kk,2)] = min(temp2);
        end
        gazeTrialIndices(1,1) = nan;
        gazeTrialIndices(1,2) = nan;
    end


    % Trim overlaps
    % Trim EEG overlap
    nonNanEegTrialIndices = eegTrialIndices(~isnan(eegTrialIndices));
    nonNanEegTrialIndices = reshape(nonNanEegTrialIndices,[numel(nonNanEegTrialIndices)/2,2]);
    for trial = 1:size(nonNanEegTrialIndices,1)-1
        if(nonNanEegTrialIndices(trial,2) > nonNanEegTrialIndices(trial+1,1))
            nonNanEegTrialIndices(trial,2) = nonNanEegTrialIndices(trial+1,1)-1;
        end
    end

    % Trim Gaze overlap
    nonNanGazeTrialIndices = gazeTrialIndices(~isnan(gazeTrialIndices));
    nonNanGazeTrialIndices = reshape(nonNanGazeTrialIndices,[numel(nonNanGazeTrialIndices)/2,2]);
    for trial = 1:size(nonNanGazeTrialIndices,1)-1
        if(nonNanGazeTrialIndices(trial,2) > nonNanGazeTrialIndices(trial+1,1))
            nonNanGazeTrialIndices(trial,2) = nonNanGazeTrialIndices(trial+1,1)-1;
        end
    end


    % %     % plot trial overlaps using EEG
    % %     height = 1;
    % %     figure(1)
    % %     subplot(4,5,ii)
    % %
    % %     for trial = 1:size(nonNanEegTrialIndices,1)
    % %         if(~isnan(nonNanEegTrialIndices(trial,1)))
    % %             slots =  [data{eegIndex}.time_stamps(nonNanEegTrialIndices(trial,1)),data{eegIndex}.time_stamps(nonNanEegTrialIndices(trial,2))];
    % %             plot(slots,[height, height],'k',LineWidth=2);
    % %             hold on
    % %             height = height + 1;
    % %         end
    % %     end
    % %     grid on
    % %     xlabel(subject(ii))
    % %
    % %     % plot trial overlaps using Gaze
    % %     height = 1;
    % %     figure(2)
    % %     subplot(4,5,ii)
    % %
    % %     for trial = 1:size(nonNanGazeTrialIndices,1)
    % %         if(~isnan(nonNanGazeTrialIndices(trial,1)))
    % %             slots =  [data{eegIndex}.time_stamps(nonNanGazeTrialIndices(trial,1)),data{eegIndex}.time_stamps(nonNanGazeTrialIndices(trial,2))];
    % %             plot(slots,[height, height],'k',LineWidth=2);
    % %             hold on
    % %             height = height +1;
    % %         end
    % %     end
    % %     grid on
    % %     xlabel(subject(ii))

    % write file timestamps for each subject
    file = [preFolder, cell2mat(subject(ii)),'\','fileTimeStamps.csv'];
    % writematrix(["Start time","End time"],file);
    % writematrix(data{6}.trialTimeStamps,file,'WriteMode','append');

    % write file EEG trial indices for each subject
    file = [preFolder, cell2mat(subject(ii)),'\','eegTrialIndices.csv'];
    % writematrix(["Start Index","End Index"],file);
    % writematrix(nonNanEegTrialIndices,file,'WriteMode','append');

    % write file EEG trial indices for each subject
    file = [preFolder, cell2mat(subject(ii)),'\','gazeTrialIndices.csv'];
    % writematrix(["Start Index","End Index"],file);
    % writematrix(nonNanGazeTrialIndices,file,'WriteMode','append');

    % write EEG values
    %     counter = 1;
    for eeg = 1:size(eegTrialIndices,1)
        if (~isnan(eegTrialIndices(eeg,1)))

            % write unfiltered eeg
            file = [preFolder, cell2mat(subject(ii)),'\',num2str(trialOrder(eeg)),'\','eegUnfiltered.csv'];
            eegData = [data{eegIndex}.time_stamps(eegTrialIndices(eeg,1):eegTrialIndices(eeg,2))', ...
                data{eegIndex}.time_series(4:17,eegTrialIndices(eeg,1):eegTrialIndices(eeg,2))']; % [timestamp, AF3...Af4]
            % writematrix(["Time (s)","AF3(uV)", "F7(uV)", "F3(uV)", "FC5(uV)", "T7(uV)", "P7(uV)", ...
            %     "O1(uV)", "O2(uV)", "P8(uV)", "T8(uV)", "FC6(uV)", "F4(uV)", "F8(uV)", "AF4(uV)"],file);
            % writematrix(eegData,file,'WriteMode','append');

            % write filtered eeg
            file = [preFolder, cell2mat(subject(ii)),'\',num2str(trialOrder(eeg)),'\','eegFiltered.csv'];
            filteredEEG = bandpass_filter_1ch_test(data{eegIndex}.time_series(4:17,eegTrialIndices(eeg,1):eegTrialIndices(eeg,2))');
            filteredEEGData = [data{eegIndex}.time_stamps(eegTrialIndices(eeg,1):eegTrialIndices(eeg,2))', ...
                filteredEEG]; % [timestamp, AF3...Af4]
            % writematrix(["Time (s)","AF3(uV)", "F7(uV)", "F3(uV)", "FC5(uV)", "T7(uV)", "P7(uV)", ...
            %     "O1(uV)", "O2(uV)", "P8(uV)", "T8(uV)", "FC6(uV)", "F4(uV)", "F8(uV)", "AF4(uV)"],file);
            % writematrix(filteredEEGData,file,'WriteMode','append');

            % write unfiltered baseline eeg
            file = [preFolder, cell2mat(subject(ii)),'\',num2str(trialOrder(eeg)),'\','eegBaselineUnfiltered.csv'];
            baselineEegData = [data{eegIndex}.time_stamps(eegTrialIndices(eeg,1)-baselineWindow*256:eegTrialIndices(eeg,1))', ...
                data{eegIndex}.time_series(4:17,eegTrialIndices(eeg,1)-baselineWindow*256:eegTrialIndices(eeg,1))']; % [timestamp, AF3...Af4]
            % writematrix(["Time (s)","AF3(uV)", "F7(uV)", "F3(uV)", "FC5(uV)", "T7(uV)", "P7(uV)", ...
            %     "O1(uV)", "O2(uV)", "P8(uV)", "T8(uV)", "FC6(uV)", "F4(uV)", "F8(uV)", "AF4(uV)"],file);
            % writematrix(baselineEegData,file,'WriteMode','append');

            % write filtered baseline eeg
            file = [preFolder, cell2mat(subject(ii)),'\',num2str(trialOrder(eeg)),'\','eegBaselineFiltered.csv'];
            filteredBaselineEEG = bandpass_filter_1ch_test(data{eegIndex}.time_series(4:17,eegTrialIndices(eeg,1)-baselineWindow*256:eegTrialIndices(eeg,1))');
            filteredBaselineEEGData = [data{eegIndex}.time_stamps(eegTrialIndices(eeg,1)-baselineWindow*256:eegTrialIndices(eeg,1))', ...
                filteredBaselineEEG]; % [timestamp, AF3...Af4]
            %writematrix(["Time (s)","AF3(uV)", "F7(uV)", "F3(uV)", "FC5(uV)", "T7(uV)", "P7(uV)", ...
                %"O1(uV)", "O2(uV)", "P8(uV)", "T8(uV)", "FC6(uV)", "F4(uV)", "F8(uV)", "AF4(uV)"],file);
            %writematrix(filteredBaselineEEGData,file,'WriteMode','append');
            %             counter = counter + 1;
        end

    end

    % write Gaze values
    counter = 1;
    for gaze = 1:size(gazeTrialIndices,1)
        if (~isnan(gazeTrialIndices(gaze,1)))
            % write raw gaze
            file = [preFolder, cell2mat(subject(ii)),'\',num2str(trialOrder(counter)),'\','rawGaze.csv'];
            gazeData = [data{gazeIndex}.time_stamps(gazeTrialIndices(gaze,1):gazeTrialIndices(gaze,2))', ...
                data{gazeIndex}.time_series(2:end,gazeTrialIndices(gaze,1):gazeTrialIndices(gaze,2))'];
            % writematrix(["Time (s)","norm_x (normalised)", "norm_y (normalised)","gaze_point_3d_x (mm)" ...
            %     ,"gaze_point_3d_y (mm)","gaze_point_3d_z (mm)","eye_center0_3d_x (mm) (right)" ,"eye_center0_3d_y (mm) (right)","eye_center0_3d_z (mm) (right)" ...
            %     ,"eye_center1_3d_x (mm) (left)" ,"eye_center1_3d_y (mm) (left)","eye_center1_3d_z (mm) (left)" ...
            %     ,"gaze_normal0_x (mm) (right)","gaze_normal0_y (mm) (right)","gaze_normal0_z (mm) (right)" ...
            %     ,"gaze_normal1_x (mm) (left)","gaze_normal1_y (mm) (left)","gaze_normal1_z (mm) (left)" ...
            %     ,"diameter0_2d (pixels) (right)","diameter1_2d (pixels) (left)" ...
            %     ,"diameter0_3d (mm) (right)","diameter1_2d (mm) (left)"] ,file);
            % writematrix(gazeData,file,'WriteMode','append');

            % write baseline raw gaze
            timeStammps = data{gazeIndex}.time_stamps;
            dd = diff(timeStammps);
            dd = dd(dd>0);
            avgSamplingRate = int32(1/mean(dd));
            file = [preFolder, cell2mat(subject(ii)),'\',num2str(trialOrder(counter)),'\','baselineRawGaze.csv'];
            gazeData = [data{gazeIndex}.time_stamps(gazeTrialIndices(gaze,1)-avgSamplingRate*baselineWindow+1:gazeTrialIndices(gaze,1))', ...
                data{gazeIndex}.time_series(2:end,gazeTrialIndices(gaze,1)-avgSamplingRate*baselineWindow+1:gazeTrialIndices(gaze,1))'];
            writematrix(["Time (s)","norm_x (normalised)", "norm_y (normalised)","gaze_point_3d_x (mm)" ...
                ,"gaze_point_3d_y (mm)","gaze_point_3d_z (mm)","eye_center0_3d_x (mm) (right)" ,"eye_center0_3d_y (mm) (right)","eye_center0_3d_z (mm) (right)" ...
                ,"eye_center1_3d_x (mm) (left)" ,"eye_center1_3d_y (mm) (left)","eye_center1_3d_z (mm) (left)" ...
                ,"gaze_normal0_x (mm) (right)","gaze_normal0_y (mm) (right)","gaze_normal0_z (mm) (right)" ...
                ,"gaze_normal1_x (mm) (left)","gaze_normal1_y (mm) (left)","gaze_normal1_z (mm) (left)" ...
                ,"diameter0_2d (pixels) (right)","diameter1_2d (pixels) (left)" ...
                ,"diameter0_3d (mm) (right)","diameter1_2d (mm) (left)"] ,file);
            writematrix(gazeData,file,'WriteMode','append');
            counter = counter + 1;
        end
    end
end