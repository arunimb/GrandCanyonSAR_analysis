clear all
close all
clc


% Writes fraction of dwell time to file
addpath("subtightplot\")
% Read subject id list
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));  % Get subject id list
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [111,211,121,221,112,212,122,222];
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
minimap = [[1919,2560],[809,1080]];
for ii = 1:numel(subject)

    for j = 1:numel(trialNum)
        fileName1 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','fixations.csv'];
        fileName2 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','time_to_finish.csv'];

        if isfile(fileName1)
            fixations = readmatrix(fileName1);
            time2finish = readmatrix(fileName2);
            dwellTime = 0;
            for k = 1:size(fixations,1)
                if(fixations(k,3) >= 1919 && fixations(k,3) <= 2560 && fixations(k,4) >= 809 && fixations(k,4) <= 2560)
                    dwellTime = dwellTime + fixations(k,2);
                end
            end

            percentDwell = dwellTime/time2finish;

            fileName = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','percentDwellMiniMap.csv'];
            writematrix("dwell Time / time2finish",fileName);
            writematrix(percentDwell,fileName,'WriteMode','append');
        end
    end
end