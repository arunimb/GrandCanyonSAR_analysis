clearvars
close all
clc

maxSpeed = 26;
b = 48.6;
a = 0.05;

x=-150:1:150;

speed = maxSpeed./(1+exp(-a.*(x - b)));
speed = speed + maxSpeed./(1+exp(a.*(x + b)));

plot(x,speed);
grid on