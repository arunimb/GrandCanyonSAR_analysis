% Fixation and saccades are calculated using Velocity thresholding method
% as described in:
% Salvucci, Dario D., and Joseph H. Goldberg. "Identifying fixations and saccades
% in eye-tracking protocols." Proceedings of the 2000 symposium on Eye tracking
% research & applications. 2000.

function [fixations,dwellTime] = funcIdt(calibratedGaze,aoi)

    distanceFromScreen = 488.95; %mm
    screenWidth = 798; %mm
    screenHeight = 338;
    
    %Thresholds
    timeThreshold = 100/1000; % sec 100 - 300
    dispersionThreshold = 1; % degree 0.5 -1
    
    %distance per pixel
    xDpixel = screenWidth/2560;
    yDpixel = screenHeight/1080;
    
    %calibratedGaze = readmatrix(fileName1);
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
            fixations(c,3) = mean(calibratedGaze(k:k+windowsSize-2,1));
            fixations(c,4) = mean(calibratedGaze(k:k+windowsSize-2,2));
            fixations(c,1) = gazeTime(k); % start of fixation time
            fixations(c,2) = sum(diff(gazeTime(k:k+windowsSize-2))); % total time fixating
            c = c + 1;
            k = k+windowsSize-2;
        end
        if fixFlag == 0
    
            k = k + 1;
        end
    
        windowsSize = windowsSizeInit;
    end
    dwellTime = 0;
    for k = 1:size(fixations,1)
        if(fixations(k,3) >= aoi(1) && fixations(k,3) <= aoi(3) && fixations(k,4) >= aoi(2) && fixations(k,4) <= aoi(4))
            dwellTime = dwellTime + fixations(k,2);
        end   
    end




end