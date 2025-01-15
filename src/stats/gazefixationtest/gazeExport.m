clearvars
close all
clc

addpath("..\");
data = load_xdf('block2.xdf');
rawGaze = data{1,1}.time_series(2:3,:)';
time = data{1,1}.time_stamps';
time = time - time(1);
rawGaze = [time,rawGaze];
scatter(rawGaze(:,2),rawGaze(:,3));

load("XCalib.mat");
load("YCalib.mat");
calibGaze = [];
for k = 1:size(rawGaze,1)
    calibGaze(k,1) = calcCalibratedX(XCalib,rawGaze(k,2),rawGaze(k,3));
    calibGaze(k,2) = calcCalibratedY(YCalib,rawGaze(k,2),rawGaze(k,3));
end
calibGaze = [time,calibGaze];
imshow( imread("testImage.png") ) ;
hold on ;
scatter(calibGaze(:,2),1080-calibGaze(:,3),0.5,'.');
hold on ;
% Check if break trial has been reached or not


%% Fixation

distanceFromScreen = 488.95; %mm
screenWidth = 798; %mm
screenHeight = 338;


% thresholds
timeThreshold = 100/1000; % sec
dispersionThreshold = 2; % degree

%distance per pixel
xDpixel = screenWidth/2560;
yDpixel = screenHeight/1080;



calibratedGaze = calibGaze;
gazeTime = calibratedGaze(:,1);
calibratedGaze = calibratedGaze(:,2:3);
euclideanDispersionThreshold = distanceFromScreen * dispersionThreshold * pi/180;
diffTime = diff(gazeTime);
meanSampleRate = mean(diffTime);
windowsSizeInit = ceil(timeThreshold/meanSampleRate);
fixations = [];
point2pointDistance = []; %mm
for k = 1:size(calibratedGaze,1)
    %             xDistance = (calibratedGaze(k,1)-calibratedGaze(k-1,1))*xDpixel;
    %             yDistance = (calibratedGaze(k,2)-calibratedGaze(k-1,2))*yDpixel;
    %             point2pointDistance(k) =  (xDistance^2+yDistance^2)^0.5;
    point2pointDistance(k,:) =  [calibratedGaze(k,1)*xDpixel, calibratedGaze(k,2)*yDpixel];
end
c = 1;
fixFlag = 0;
k = 1;
windowsSize = windowsSizeInit;
while k+windowsSize-1 <= size(calibratedGaze,1)
    window = point2pointDistance(k:k+windowsSize-1,:);
    D = max(window(:,1))-min(window(:,1)) + max(window(:,2))-min(window(:,2));
    fixFlag = 0;
    while D <= euclideanDispersionThreshold && k+windowsSize <= size(calibratedGaze,1)
        fixFlag = 1;
        windowsSize = windowsSize + 1;
        window = point2pointDistance(k:k+windowsSize-1,:);
        D = max(window(:,1))-min(window(:,1)) + max(window(:,2))-min(window(:,2));
    end
    if (fixFlag == 1)
        fixations(c,1) = mean(calibratedGaze(k:k+windowsSize-2,1));
        fixations(c,2) = mean(calibratedGaze(k:k+windowsSize-2,2));
        c = c + 1;
        k = k+windowsSize-2;
    end
    if fixFlag == 0
        k = k + 1;
    end

    windowsSize = windowsSizeInit;
end
%subplot(3,3,j)

%plot(calibratedGaze(:,1),calibratedGaze(:,2),'-.');
scatter(fixations(:,1),1080-fixations(:,2));
% plot([0, 2560, 2560, 0, 0],[0, 0, 1080, 1080, 0],LineWidth=2);
% plot([2278, 2467, 2467, 2278, 2278],[291, 291, 435, 435, 291],LineWidth=2);
% plot([1919, 2560, 2560, 1919, 1919],[809, 809, 1080, 1080, 809],LineWidth=2);
% xlim([-50 2610]);
% ylim([-50 1130]);



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