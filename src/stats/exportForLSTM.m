%% housekeeping
clearvars
close all
clc

%% Run this section
subject = cellstr(num2str(readmatrix('..\data\participantID1.csv')));
preFolder = '..\data\';
postFolder = 'plots\subjectWisePlots\';
trialName = {'NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'};
%% Load dataset
addpath("E:\PreliminaryAnalysisGrandCanyon\data\aggregatedMatlabFiles");
load subjectTrajDataModified.mat

