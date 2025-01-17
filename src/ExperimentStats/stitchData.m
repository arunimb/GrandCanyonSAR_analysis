clearvars
close all
clc

%Read the list of participants
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\'; % location of subject data folders
postFolder = '..\..\data\';% location of save subject data folders

for ii = 1:numel(subject)
    userNo = ii;
    % Read from specially created *.mat files for subject 19175 
    % because for the second half of the experiment the gaze was not
    % recorded
    if (~strcmp(cell2mat(subject(userNo)), '19175'))
        lookFolder = [preFolder, cell2mat(subject(userNo)),'\'];
        lookFile1 = [lookFolder, 'subject_',cell2mat(subject(userNo)),'_old1.xdf'];
        lookFile2 = [lookFolder, 'subject_',cell2mat(subject(userNo)),'.xdf'];
        data1 = load_xdf(lookFile1);
        data2 = load_xdf(lookFile2);
        data = data1;
    end
    
    if (strcmp(cell2mat(subject(userNo)), '19175'))
        lookFolder = [preFolder, cell2mat(subject(userNo)),'\'];
        lookFile1 = [lookFolder, 'subject_',cell2mat(subject(userNo)),'c_old1.mat'];
        lookFile2 = [lookFolder, 'subject_',cell2mat(subject(userNo)),'c.mat'];
        load(lookFile1);
        load(lookFile2);
        data = data1;
    end


    % Find EEG stream index in *.xdf part 1
    strToCmp = 'EmotivDataStream-EEG';
    for eeg_i = 1:numel(data1)
        if (strcmp(data1{eeg_i}.info.name,strToCmp))
            break;
        end
    end
    % Find EEG stream index in *.xdf part 2
    strToCmp = 'EmotivDataStream-EEG';
    for eeg_j = 1:numel(data2)
        if (strcmp(data2{eeg_j}.info.name,strToCmp))
            break;
        end
    end
    % Find keyboard stream index in *.xdf part 1
    strToCmp = 'KeyBoard';
    for key_i = 1:numel(data1)
        if (strcmp(data1{key_i}.info.name,strToCmp))
            break;
        end
    end
    % Find keyboard stream index in *.xdf part 2
    strToCmp = 'KeyBoard';
    for key_j = 1:numel(data2)
        if (strcmp(data2{key_j}.info.name,strToCmp))
            break;
        end
    end
    % eliminate trial number 5 for subject 70928 because eeg stopped
    % recording in the first half
    %
    if (~strcmp(cell2mat(subject(userNo)),'70928'))
        temp1_eeg = double(data1{eeg_i}.time_stamps);% get
        temp2_eeg = double(data2{eeg_j}.time_stamps);

        temp1_key = double(data1{key_i}.time_stamps);
        temp2_key = double(data2{key_j}.time_stamps);

        % getting the difference between the start of EEG sample and
        % Keyboard sample, keyboard sample always start later than EEG sample
        keyShift1 = temp1_key(1) - temp1_eeg(1);
        keyShift2 = temp2_key(1) - temp2_eeg(1);

        temp1_eeg = temp1_eeg - temp1_eeg(1);
        temp1_key = temp1_key - temp1_key(1) + keyShift1;

        % Aligning the keystroke timeseries to EEG timeseries
        % the F2 keystroke entries are then used along with OS timestamps
        % to partitition the data.
        temp2_eeg = temp2_eeg - temp2_eeg(1) + temp1_eeg(end);
        temp2_key = temp2_key - temp2_key(1) + keyShift2 + temp1_eeg(end);
    end
    % eliminate trial number 5 for subject 70928 because eeg stopped
    % recording after the fifth trial
    if (strcmp(cell2mat(subject(userNo)),'70928'))
        temp1_eeg = double(data1{eeg_i}.time_stamps);
        temp2_eeg = double(data2{eeg_j}.time_stamps);

        temp1_key = double(data1{key_i}.time_stamps);
        temp2_key = double(data2{key_j}.time_stamps);
        
        % var a is the keystroke, var b marks beginning of a trial and
        % there are 5 trials in the first half including familiarisation
        % we ignore the time series of the 5th trial in data1
        stemp1_key = double(data1{key_i}.time_series); % correction needed for only the first xdf recording
        a = stemp1_key;
        b = find(a== 10);
        temp1_key = temp1_key(1:b(4));
        data1{key_i}.time_series = data1{key_i}.time_series(1:b(4));

        keyShift1 = temp1_key(1) - temp1_eeg(1);
        keyShift2 = temp2_key(1) - temp2_eeg(1);

        temp1_eeg = temp1_eeg - temp1_eeg(1);
        temp1_key = temp1_key - temp1_key(1) + keyShift1;

        temp2_eeg = temp2_eeg - temp2_eeg(1) + temp1_eeg(end);
        temp2_key = temp2_key - temp2_key(1) + keyShift2 + temp1_eeg(end);
    end



    data{key_i}.time_series = [double(data1{key_i}.time_series),double(data2{key_j}.time_series)]; % concatenate keyboard time series

    data{key_i}.time_stamps = [temp1_key, temp2_key];  % concatenate keyboard time stamps

    data{eeg_i}.time_series = [double(data1{eeg_i}.time_series),double(data2{eeg_j}.time_series)]; % concatenate EEG time series
    data{eeg_i}.time_stamps = [temp1_eeg, temp2_eeg]; % concatenate EEG time stamps

    % Find eye tracker stream index in *.xdf part 1
    strToCmp = 'pupil_capture';
    for i = 1:numel(data1)
        if (strcmp(data1{i}.info.name,strToCmp))
            break;
        end
    end
    % Find eye tracker stream index in *.xdf part 2
    strToCmp = 'pupil_capture';
    for j = 1:numel(data2)
        if (strcmp(data2{j}.info.name,strToCmp))
            break;
        end
    end
    % concatenate eye Tracker time series
    if (~isempty(data2{j}.time_series))
        data{i}.time_series = [data1{i}.time_series, data2{j}.time_series];
        temp = data1{i}.time_stamps-data1{i}.time_stamps(1); % set the first timestamp to 0 in the first dataset
        data{i}.time_stamps = [temp, max(temp) + (data2{j}.time_stamps-data2{j}.time_stamps(1))]; % concatenate the first dataset and the second dataset
    end
    if (isempty(data2{j}.time_series)) % exception for subject 19175 whose pupil was not captured in the second half
        data{i}.time_series = data1{i}.time_series;
        temp = data1{i}.time_stamps-data1{i}.time_stamps(1); %only using the first dataset
        data{i}.time_stamps = temp;
    end
    mkdir([postFolder, cell2mat(subject(userNo)),'\'])
    save([postFolder, cell2mat(subject(userNo)),'\','subject_',cell2mat(subject(userNo)),'.mat'],'data')
end