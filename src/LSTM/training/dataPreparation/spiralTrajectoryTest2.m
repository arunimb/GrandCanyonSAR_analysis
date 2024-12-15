clearvars
clc

figure(1); gcf; clf;
viscircles([0,0],1080,'Color','yellow');
axis square
grid on
hold on


theta = 0;
separationFactor = 1;
speed = 50;
xPos = 0;
yPos = 0;
dt = 1;
timeElapsed = 0;
radius = separationFactor*0.01;
for i = 1:1000
    xPos = radius*cos(theta);
    yPos = radius*sin(theta);
    scatter(xPos,yPos,'blue','.');
    timeElapsed = timeElapsed * dt;
    dTheta = speed*dt/(radius);
    theta = theta + dTheta;
    radius = separationFactor * theta;
    timeElapsed = timeElapsed + dt;
    drawnow
end