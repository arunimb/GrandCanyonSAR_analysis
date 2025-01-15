close all
clearvars
clc

t1 = load_xdf("gaze1.xdf");
l1Gaze = t1{1}.time_series';
l1Gaze = [t1{1}.time_stamps',l1Gaze(:,2:end)];
l1Gaze(:,1) = l1Gaze(:,1)-l1Gaze(1,1);
l1Gaze = l1Gaze(:,1:3);
halfPoint = ceil(size(l1Gaze,1)/2);
l1Gaze = l1Gaze(halfPoint:end,:);
% fileName = 'uncalibratedGaze1.csv';
% writematrix(["Time (s)","x (pixels)", "y (pixels)"],fileName);
% writematrix(l1Gaze,fileName,'WriteMode','append');

figure(1)
scatter(l1Gaze(:,2),l1Gaze(:,3),2,'+')
hold on
rectangle('Position',[0,0,1,1])
% plot([0,2560,2560,0,0],[0,0,1080,1080,0],LineWidth=2,Color=[1.0,0.7,0])
% axis image
xlim([-0.1,1.1])
ylim([-0.1,1.1])
pbaspect([2.37 1 1])
xlabel("x position (normalized)")
ylabel("y position (normalized)")

load("XCalib.mat");
load("YCalib.mat");

% map normalized gaze to pixel gaze
for k = 1:size(l1Gaze,1)
    calibGaze(k,1) = calcCalibratedX(XCalib,l1Gaze(k,2),l1Gaze(k,3));
    calibGaze(k,2) = calcCalibratedY(YCalib,l1Gaze(k,2),l1Gaze(k,3));
end

figure(2)
scatter(calibGaze(:,1),calibGaze(:,2),2,'+')
hold on
rectangle('Position',[0,0,2560,1080])
% plot([0,2560,2560,0,0],[0,0,1080,1080,0],LineWidth=2,Color=[1.0,0.7,0])
% axis image
xlim([-300,2860])
ylim([-300,1380])
pbaspect([2.37 1 1])
xlabel("x position (pixel)")
ylabel("y position (pixel)")
% fileName = 'calibratedGaze.csv';
% writematrix(["Time (s)","x (pixels)", "y (pixels)"],fileName);
% writematrix([l1Gaze(:,1), calibGaze],fileName,'WriteMode','append');




t1 = load_xdf("gaze2.xdf");
l1Gaze = t1{1}.time_series';
l1Gaze = [t1{1}.time_stamps',l1Gaze(:,2:end)];
l1Gaze(:,1) = l1Gaze(:,1)-l1Gaze(1,1);
l1Gaze = l1Gaze(:,1:3);
halfPoint = ceil(size(l1Gaze,1)/2);
l1Gaze = l1Gaze(halfPoint:end,:);
% fileName = 'uncalibratedGaze1.csv';
% writematrix(["Time (s)","x (pixels)", "y (pixels)"],fileName);
% writematrix(l1Gaze,fileName,'WriteMode','append');

figure(3)
scatter(l1Gaze(:,2),l1Gaze(:,3),2,'+')
hold on
rectangle('Position',[0,0,1,1])
% plot([0,2560,2560,0,0],[0,0,1080,1080,0],LineWidth=2,Color=[1.0,0.7,0])
% axis image
xlim([-0.1,1.1])
ylim([-0.1,1.1])
pbaspect([2.37 1 1])
xlabel("x position (normalized)")
ylabel("y position (normalized)")

load("XCalib.mat");
load("YCalib.mat");

% map normalized gaze to pixel gaze
for k = 1:size(l1Gaze,1)
    calibGaze(k,1) = calcCalibratedX(XCalib,l1Gaze(k,2),l1Gaze(k,3));
    calibGaze(k,2) = calcCalibratedY(YCalib,l1Gaze(k,2),l1Gaze(k,3));
end

figure(4)
scatter(calibGaze(:,1),calibGaze(:,2),2,'+')
hold on
rectangle('Position',[0,0,2560,1080])
% plot([0,2560,2560,0,0],[0,0,1080,1080,0],LineWidth=2,Color=[1.0,0.7,0])
% axis image
xlim([-300,2860])
ylim([-300,1380])
pbaspect([2.37 1 1])
xlabel("x position (pixel)")
ylabel("y position (pixel)")
% fileName = 'calibratedGaze.csv';
% writematrix(["Time (s)","x (pixels)", "y (pixels)"],fileName);
% writematrix([l1Gaze(:,1), calibGaze],fileName,'WriteMode','append');


t1 = load_xdf("gaze3.xdf");
l1Gaze = t1{1}.time_series';
l1Gaze = [t1{1}.time_stamps',l1Gaze(:,2:end)];
l1Gaze(:,1) = l1Gaze(:,1)-l1Gaze(1,1);
l1Gaze = l1Gaze(:,1:3);
halfPoint = ceil(size(l1Gaze,1)/2);
l1Gaze = l1Gaze(halfPoint:end,:);
% fileName = 'uncalibratedGaze1.csv';
% writematrix(["Time (s)","x (pixels)", "y (pixels)"],fileName);
% writematrix(l1Gaze,fileName,'WriteMode','append');

figure(5)
scatter(l1Gaze(:,2),l1Gaze(:,3),2,'+')
hold on
rectangle('Position',[0,0,1,1])
% plot([0,2560,2560,0,0],[0,0,1080,1080,0],LineWidth=2,Color=[1.0,0.7,0])
% axis image
xlim([-0.1,1.1])
ylim([-0.1,1.1])
pbaspect([2.37 1 1])
xlabel("x position (normalized)")
ylabel("y position (normalized)")

load("XCalib.mat");
load("YCalib.mat");

% map normalized gaze to pixel gaze
for k = 1:size(l1Gaze,1)
    calibGaze(k,1) = calcCalibratedX(XCalib,l1Gaze(k,2),l1Gaze(k,3));
    calibGaze(k,2) = calcCalibratedY(YCalib,l1Gaze(k,2),l1Gaze(k,3));
end

figure(6)
scatter(calibGaze(:,1),calibGaze(:,2),2,'+')
hold on
rectangle('Position',[0,0,2560,1080])
% plot([0,2560,2560,0,0],[0,0,1080,1080,0],LineWidth=2,Color=[1.0,0.7,0])
% axis image
xlim([-300,2860])
ylim([-300,1380])
pbaspect([2.37 1 1])
xlabel("x position (pixel)")
ylabel("y position (pixel)")
% fileName = 'calibratedGaze.csv';
% writematrix(["Time (s)","x (pixels)", "y (pixels)"],fileName);
% writematrix([l1Gaze(:,1), calibGaze],fileName,'WriteMode','append');

function pos = calcCalibratedX(Calib,Xpos,Ypos)
% Function maps normalized x coordinates to x pixel location on screen
% For validation see powerpoint file in /doc/overlaidGazeImages.pptx
pos = Calib(1) + Calib(2)*Xpos + Calib(3)*Xpos^2 + Calib(4)*Xpos*Ypos;
pos = int16(pos);
end
function pos = calcCalibratedY(Calib,Xpos,Ypos)
% Function maps normalized y coordinates to y pixel location on screen
% For validation see powerpoint file in /doc/overlaidGazeImages.pptx
pos = Calib(1) + Calib(2)*Ypos + Calib(3)*Ypos^2 + Calib(4)*Ypos*Xpos;
pos = int16(pos);
end