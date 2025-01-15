clearvars
close all
clc

% This script finds the overlapping trials, trims them  end to end.


subject = cellstr(num2str(readmatrix('..\data\participantID1.csv')));
preFolder = '..\data\';
postFolder = '..\data\';
preFile2 = 'trialOrder.txt';
for ii = 1:numel(subject)
    
    userNo = ii;
    lookFolder = [preFolder, cell2mat(subject(userNo)),'\'];
    lookfile = [lookFolder,'subject_',cell2mat(subject(userNo)),'_v2','.mat'];
    load(lookfile);
    lookFile2 = [preFolder, cell2mat(subject(ii)),'\',preFile2];
    %fprintf('%s\n',lookFile);
    trialOrder = readmatrix(lookFile2);
    tempStamps = data{1, 6}.resampledKeyboardTimeStamps;
    tempSeries = data{1, 6}.resampledModdedKeyboardTimeseries;
    data{1, 6}.correctedKeyboardTimeSeries = data{1, 6}.resampledModdedKeyboardTimeseries;
    tempCorrectedTimeseries = data{1, 6}.correctedKeyboardTimeSeries;
    tempCorrectedTimeseries(tempCorrectedTimeseries == 11) = 0;
    experimentTimes = [find(tempSeries==10)',find(tempSeries==11)'];
    overlapIndex  = [];
    overlapIndex(1) = 0;
    for k = 2:numel(trialOrder)
        if(experimentTimes(k,1)-experimentTimes(k-1,2)>0)
            overlapIndex(k) = 0;
            tempCorrectedTimeseries(experimentTimes(k-1,2)) = 11;
        end
        if(experimentTimes(k,1)-experimentTimes(k-1,2)<0)
            overlapIndex(k) = 1;
            tempCorrectedTimeseries(experimentTimes(k,1)-1) = 11;
        end
    end
    tempCorrectedTimeseries(experimentTimes(k,2)) = 11;
    data{1, 6}.correctedKeyboardTimeSeries = tempCorrectedTimeseries;
    experimentTimes2 = [find(tempCorrectedTimeseries==10)',find(tempCorrectedTimeseries==11)'];

    subplot(4,5,ii)
    hold on
    for j = 1:size(experimentTimes2,1)
        plot ([tempStamps(experimentTimes2(j,1)), tempStamps(experimentTimes2(j,2)) ],[2+j, 2+j], "Color",'k','LineWidth',2)
    end
    grid on
    xlabel("Time")
    ylabel("Trial #")
    s = sprintf("participant %s",cell2mat(subject(ii)));
    title(s);


    save([postFolder, cell2mat(subject(ii)),'\','subject_',cell2mat(subject(ii)),'_v2','.mat'],'data');
end