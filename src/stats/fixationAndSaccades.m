clear all
close all
clc
% Plots gaze fixation and saccades and also exports them to csv files. Also
% calculates percent of gaze saccades and fixation
% Fixation and saccades are calculated using Velocity thresholding method
% as described in:
% Salvucci, Dario D., and Joseph H. Goldberg. "Identifying fixations and saccades 
% in eye-tracking protocols." Proceedings of the 2000 symposium on Eye tracking 
% research & applications. 2000.

%distanceFromScreen = 24.5*2.54; %mm probably wrong
distanceFromScreen = 488.95; %mm
screenWidth = 795; %mm
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));  % Get subject id list
preFolder = '..\..\data\';
trialName = {'Fam','NNL','YNL','NYL','YYL','NNH','YNH','NYH','YYH'}; % Person, Terrain, Swarm cohesion
preFolder = '..\..\data\'; % location of subject data folders

% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [0,111,211,121,221,112,212,122,222];

%% gaze LSL data format
% confidence, norm_pos_x, norm_pos_y, gaze_point_3d_x, gaze_point_3d_y, gaze_point_3d_z,
% eye_center0_3d_x, eye_center0_3d_y, eye_center0_3d_z, eye_center1_3d_x, eye_center1_3d_y,
% eye_center1_3d_z, gaze_normal0_x, gaze_normal0_y, gaze_normal0_z, gaze_normal1_x,
% gaze_normal1_y, gaze_normal1_z, diameter0_2d, diameter1_2d, diameter0_3d, diameter1_3d

% hold Gaze
sigma1 = 100;
sigma2 = 100;
mu1 = 2560/2;
mu2 = 1080/2;
for i = 1:numel(subject)
    trialOrder = readmatrix([preFolder, cell2mat(subject(i)),'\','trialOrder.txt']);
    h = figure(2);
    clf;
    figure(1);
    clf;
    tiledlayout(3,3,'TileSpacing','Compact','Padding','Compact')
    for j = 1:numel(trialOrder)
        fileName1 = [preFolder, cell2mat(subject(i)),'\',num2str(trialOrder(j)),'\','rawGaze.csv'];
        fileName2 = [preFolder, cell2mat(subject(i)),'\',num2str(trialOrder(j)),'\','calibratedGaze.csv'];
        if (isfile(fileName1))
            rawGaze = readmatrix(fileName1);
            calibratedGaze = readmatrix(fileName2);
            calibratedGaze = calibratedGaze(:,2:3);
            time = rawGaze(:,1)-rawGaze(1,1);
            
            % mark Gaze point either saccade or fixation or neither.
            [gazeEventIdentifier, ~] = saccadesOrFixation3D(double(calibratedGaze)*screenWidth,time, distanceFromScreen);

            % Extract fixation points
            fixationPoints = evaluateFixationsPoints(calibratedGaze, gazeEventIdentifier);

            % Extract saccade points
            saccadePoints = extractSaccades(calibratedGaze, gazeEventIdentifier);

            figure(1)

            subplot(3,3,j)
            plot(calibratedGaze(:,1),calibratedGaze(:,2),'-.');
            hold on;
            scatter(fixationPoints(:,1),fixationPoints(:,2));
            xlabel("X location (px)");
            ylabel("Y location (px)");
            %xlim([0-200 2560+200]);
            %ylim([0-200 1080+200]);
            title(trialName(j));
            grid on
            sgtitle(subject(i))

%             nexttile(j)
%             weightsSacc = twoDGauss(saccadePoints(:,1),saccadePoints(:,2),mu1,mu2,sigma1,sigma2);
%             plot(saccadePoints(:,1).*weightsSacc',saccadePoints(:,2).*weightsSacc',Marker=".");
%             hold on;
%             weightsFix = twoDGauss(fixationPoints(:,1),fixationPoints(:,2),mu1,mu2,sigma1,sigma2);
%             scatter(fixationPoints(:,1).*weightsFix',fixationPoints(:,2).*weightsFix',Marker=".");
%             scatter(mu1,mu2,50,Marker="+",LineWidth=5);
%             xlabel("X location (px)");
%             ylabel("Y location (px)");
%             xlim([0-200 2560+200]);
%             ylim([0-200 1080+200]);
%             title(trialName(j));
%             grid on
%             sgtitle(subject(i))
%             hold off
            % Write fixation, saccades to csv file
            fileName = [preFolder, cell2mat(subject(i)),'\',num2str(trialOrder(j)),'\','fixations.csv'];
%             writematrix(["xPos (pixels)","yPos (pixels)"],fileName);
%             writematrix(fixationPoints,fileName,'WriteMode','append');

            fileName = [preFolder, cell2mat(subject(i)),'\',num2str(trialOrder(j)),'\','saccades.csv'];
%             writematrix(["xPos (pixels)","yPos (pixels)"],fileName);
%             writematrix(saccadePoints,fileName,'WriteMode','append');

%             fileName = [preFolder, cell2mat(subject(i)),'\',num2str(trialOrder(j)),'\','fixationsGauss.csv'];
%             writematrix(["xPos (pixels)","yPos (pixels)"],fileName);
%             writematrix(fixationPointsGauss,fileName,'WriteMode','append');
% 
%             fileName = [preFolder, cell2mat(subject(i)),'\',num2str(trialOrder(j)),'\','saccadesGauss.csv'];
%             writematrix(["xPos (pixels)","yPos (pixels)"],fileName);
%             writematrix(saccadePointsGauss,fileName,'WriteMode','append');

            percentFixations = numel(find(gazeEventIdentifier == 0))/numel(gazeEventIdentifier);
            percentSaccades = numel(find(gazeEventIdentifier == 1))/numel(gazeEventIdentifier);

            fileName = [preFolder, cell2mat(subject(i)),'\',num2str(trialOrder(j)),'\','percentFixations.csv'];
%             writematrix("Percent of time spent in fixating",fileName);
%             writematrix(percentFixations,fileName,'WriteMode','append');

            fileName = [preFolder, cell2mat(subject(i)),'\',num2str(trialOrder(j)),'\','percentSaccades.csv'];
%             writematrix("Percent of time spent in saccades",fileName);
%             writematrix(percentSaccades,fileName,'WriteMode','append');
        end
    end
    % Save Plots
    %saveas(h,[preFolder, cell2mat(subject(i)),'\','saccadesAndFixations.fig']);
    %saveas(h,[preFolder, cell2mat(subject(i)),'\','saccadesAndFixationsGaussWeighted.png']);
end

function fixWeight = twoDGauss(x,y,mu1,mu2,sigma1,sigma2)
fixWeight = [];
for i = 1:size(x,1)
    temp1 = ( (x(i)-mu1) / sigma1 )^2 ;
    temp2 = ( (y(i)-mu2) / sigma2 )^2;
    fixWeight(i) = 1-(1/(2*pi*sigma1*sigma2))*exp( -0.5 * ( temp1 + temp2 ) ) ;
end

end

function fixationPoints = evaluateFixationsPoints(gazeLocation, gazeEventArray)
% Function extracts fixation points


length = numel(gazeEventArray);
fixationPoints = [];
i = 1;
c = 1;
while i < length - 2
    if gazeEventArray(i) == 0
        startFixation = i;
        for j = i:length
            if gazeEventArray(j) ~= 0
                break;
            end
        end
        endFixation = j;
        tempGazeArray = double(gazeLocation(i:j,:));

        fixationPoints(c,:) = mean(tempGazeArray);
        c = c+1;
        i =j-1;
    end
    i = i +1;
end
end

function saccadePoints = extractSaccades(gazeLocation, gazeEventArray)
% Function extracts saccades


length = numel(gazeEventArray);
saccadePoints = [];

c = 1;
for i = 1:length
    if(gazeEventArray(i) == 1)
        saccadePoints(c,:) = double(gazeLocation(i,:));
        c = c+1;
    end
end

end






