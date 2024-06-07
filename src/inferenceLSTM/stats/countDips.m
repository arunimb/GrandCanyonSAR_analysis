clearvars
close all
clc
preFolder = 'D:\UWmonitoring\MissingPersonSearchSim\Assets\trajData\';
subject = cellstr(num2str(readmatrix('..\..\..\data\participantID1.csv')));
%preFolder = '..\..\data\';
trialNum = [111,211,121,221,112,212,122,222];

numDips = zeros(20,8);

for ii = 1:numel(subject)
    figure(ii)
    for j = 1:numel(trialNum)
        fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','trajectory.csv'];
        traj = readmatrix(fileName);
        heightData = traj(:,3);
        subplot(2,4,j)
        plot(0:1/24:numel(heightData)/24 - (1/24),heightData);
        title(cell2mat(subject(ii)))
        meanHeight = mean(heightData);
        stdHeight = std(heightData);
        dips = heightData(heightData<meanHeight-2*stdHeight);
    
        if(numel(dips)>0)
            numDips(ii,j)= numel(dips)-1;
        else
            numDips(ii,j) = 0;
        end
    end
end

avgSlowdown = mean(numDips(:));
stdSlowdown = std(numDips(:));


%histogram2(xDist,yDist,[12 12],'DisplayStyle','tile')
%[X,Y] = meshgrid(0:1:1080,0:1:1080);
xLoc = [];
yLoc = [];
c = 1;
for j = 1:ceil(12)
    dist = 2000;
    while dist > 1080
        xDist = unifrnd(-1080,1080,[1,1]);
        yDist = unifrnd(-1080,1080,[1,1]);
        dist = sqrt(xDist^2+yDist^2);
    end
    xLoc(c) = xDist;
    yLoc(c) = yDist;
    c = c + 1;
end
scatter(xLoc,yLoc);
grid on
axis square