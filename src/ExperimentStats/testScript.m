clearvars
close all
clc

subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));  % Get subject id list
%subject = subject(randperm( numel(subject))); %Testing, comment later
trialName = {'NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'}; % Person, Terrain, Swarm cohesion
preFolder = '..\..\data\'; % location of subject data folders

% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [111,211,121,221,112,212,122,222];

%% gaze LSL data format
% confidence, norm_pos_x, norm_pos_y, gaze_point_3d_x, gaze_point_3d_y, gaze_point_3d_z,
% eye_center0_3d_x, eye_center0_3d_y, eye_center0_3d_z, eye_center1_3d_x, eye_center1_3d_y,
% eye_center1_3d_z, gaze_normal0_x, gaze_normal0_y, gaze_normal0_z, gaze_normal1_x,
% gaze_normal1_y, gaze_normal1_z, diameter0_2d, diameter1_2d, diameter0_3d, diameter1_3d


AOI1coord = [[2560-635,1080-260],[2560, 1080]]; %top right, coordinates for bottom left and top right corners
AOI2coord = [[1,1080-260],[635,1080]]; %top left
AOI3coord = [[1,1],[635,260]];%bottom left
AOI4coord = [[2560-635,1],[2560,260]]; %bottom right
AOI5coord = [[1,1],[2560, 1080]]; %whole screen
for ii = 1:numel(subject)

    %     tiledlayout(3,3,'TileSpacing','Compact','Padding','Compact')
    %figure(1);
    %clf;
    for j = 1:numel(trialNum)

        fileName1 = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','calibratedGaze.csv'];
        if (isfile(fileName1))
            calibratedGaze = readmatrix(fileName1);
            [fixations, dwellTimeAOI5] = funcIdt(calibratedGaze,AOI5coord);
            % [fixations, dwellTimeAOI2] = funcIdt(calibratedGaze,AOI2coord);
            % [fixations, dwellTimeAOI3] = funcIdt(calibratedGaze,AOI3coord);
            % [fixations, dwellTimeAOI4] = funcIdt(calibratedGaze,AOI4coord);
            fileName = [preFolder, cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','fixations_new.csv'];
            writematrix(["Start Time (sec)","Fixation Time (sec)","xPos (pixels)","yPos (pixels)"],fileName);
            writematrix(fixations,fileName,'WriteMode','append');
        end

    end
end