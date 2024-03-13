%% housekeeping
clearvars
%close all
clc

% This file plots filtered EEG and cognitive load

subject = cellstr(num2str(readmatrix('..\data\participantID1.csv')));
preFolder = '..\data\';
trialName = {'Fam','NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'};  % Person, Terrain, Swarm cohesion
preFolder = '..\data\'; % location of subject data folders
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [0,111,211,121,221,112,212,122,222];

for ii = 1:numel(subject)
    for j = 1:numel(trialNum)
        % Get filtered EEG filename for the trial section
        fileName1 = dir([preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','TLX_*.txt']);
        if(~isempty(fileName1))
            tlxValues = readmatrix([fileName1.folder,'\',fileName1.name]);
            saveFolder = [fileName1.folder,'\','TLX.csv'];
            tlxValues = tlxValues(3:end);
            writematrix(tlxValues,saveFolder);
        end

    end
end