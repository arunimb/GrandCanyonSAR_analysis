% Returns angle in 3D space

function angle = angleCalc3D(gazePointXY,distanceFromScreen)
% Vector pointing from chin rest to gaze point on screen
vector1 = [gazePointXY(1,1), gazePointXY(1,2), -distanceFromScreen]; 

% Vector pointing from chin rest to next gaze point on screen
vector2 = [gazePointXY(2,1), gazePointXY(2,2), -distanceFromScreen]; 

% Vector Magnitudes
vector1mag = norm(vector1); 
vector2mag = norm(vector2);

% Calculate angle between the two vectors
angle = acosd(dot(vector1,vector2)/(vector1mag*vector2mag));
end