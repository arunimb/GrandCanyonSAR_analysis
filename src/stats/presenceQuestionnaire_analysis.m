clearvars
close all
clc

% This file plots speed and turn rate by trial for every subject and saves them in
% data folder
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));
preFolder = '..\..\data\';
% Trial names are in the order Missing Person Prior knowledge Y or N,
% Terrain knowledge Y or N, Swarm Cohesion L or H.
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
preFolder = '..\..\data\'; % location of subject data folders
trialNum = [111,211,121,221,112,212,122,222];
accPres = [];
for ii = 1:numel(subject)
    fileNameTLX = dir([preFolder, cell2mat(subject(ii)),'\','Presence*.txt']);
    if (~isempty(fileNameTLX))
        opts = delimitedTextImportOptions('Delimiter','\n\r');
        temp = readmatrix([fileNameTLX.folder,'\',fileNameTLX.name],opts)';
        if(numel(temp)>=12)
            presVal=str2double(temp(4:10));
            presVal=[presVal, str2double(temp(12))];
            accPres = [accPres;presVal];
        end
        if(numel(temp)<12)
            presVal=str2double(temp(4:10));
            presVal=[presVal, -1];
            accPres = [accPres;presVal];
        end
        %presVal=str2double(presVal(4:10));
        %accPres = [accPres;presVal];
    end
end

meanScores1 = mean(accPres(:,1:end-1))';
stdScores1 = std(accPres(:,1:end-1))';
tempAcc = accPres(:,end);
tempAcc(tempAcc == -1)=nan;
meanScore = mean(tempAcc,'omitnan');
stdScore = std(tempAcc,'omitnan');