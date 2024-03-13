clearvars
close all
clc

addpath("subtightplot\")
% Read subject id list
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));  % Get subject id list
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [111,211,121,221,112,212,122,222];
trialName = {'NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'}; % Person, Terrain, Swarm cohesion
ii = 14;
figure(1)

for ii = 1:numel(subject)
    clf;
    for j = 1:numel(trialNum)
        fileName1 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','fixations.csv'];

        if isfile(fileName1)
            disp(cell2mat(subject(ii)));
            gaze = readmatrix(fileName1);
            gaze = gaze(:,2:3);
            opt = [0.001 0.001];
            subtightplot(2,4,j,opt,opt,opt)
            %scatter(gaze(:,1),gaze(:,2),2,'+')
            histogram2(gaze(:,1),gaze(:,2),25,'DisplayStyle','tile','ShowEmptyBins','on','EdgeColor','none','Normalization','probability','FaceColor','flat');
            %hh = hist3(gaze,[50,50]);
            %hh = hh/sum(sum(hh));
            %imagesc(hh,'Interpolation','bilinear');
            %caxis([0,0.04])
            xlim([0 2540]);
            ylim([0 1080]);
            %         hold on
            %         plot([0,2560,2560,0,0],[0,0,1080,1080,0],LineWidth=2,Color=[1.0,0.7,0])
            %axis image

            %pbaspect([2.35 1 1])
            if j==4
                %legend("Trajectory","Start","End","Swarm","Missing Person");
                xlabel("x position (pixel)")
                ylabel("y position (pixel)");
                zlabel("Z location (m)");
            end
        end
    end
end
