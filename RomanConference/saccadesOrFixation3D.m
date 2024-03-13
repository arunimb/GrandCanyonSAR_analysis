% function identifies whether a gaze location is a fixation or a saccade
function [sof,gazeSpeedDegs]  = saccadesOrFixation3D(calibratedGazeArray,timeArray, distanceFromScreen)

length = size(calibratedGazeArray,1);
sof = [];
gazeSpeedDegs = [];
for i = 2:length
    % Angle between two gaze points
    traverseAngle = angleCalc3D([calibratedGazeArray(i-1,:); calibratedGazeArray(i,:) ],distanceFromScreen);
    angleRate = abs(traverseAngle)/abs(timeArray(i)-timeArray(i-1));
    gazeSpeedDegs(i-1) = angleRate;
    % Classify Gaze b/w fixations and saccades
    if (angleRate <=100 )
        sof(i-1)= 0; %fixation
    end
    if (angleRate >= 300 )
        sof(i-1)= 1; %saccade
    end

    if (angleRate >100 && angleRate < 300)
        sof(i-1)= 2; % Not fixation or saccade
    end
end

end
