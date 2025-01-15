clearvars
close all

file1 = readmatrix("cluster1.csv");
file2 = readmatrix("cluster2.csv");
file3 = readmatrix("cluster3.csv");
file4 = readmatrix("cluster4.csv");
file5 = readmatrix("cluster5.csv");
file6 = readmatrix("cluster6.csv");
file7 = readmatrix("cluster7.csv");
file8 = readmatrix("cluster8.csv");
file9 = readmatrix("cluster9.csv");
figure(1)
scatter(file1(:,1),file1(:,2));
hold on
scatter(file2(:,1),file2(:,2));
scatter(file3(:,1),file3(:,2));
scatter(file4(:,1),file4(:,2));
scatter(file5(:,1),file5(:,2));
scatter(file6(:,1),file6(:,2));
scatter(file7(:,1),file7(:,2));
scatter(file8(:,1),file8(:,2));
scatter(file9(:,1),file9(:,2));

filtered1 = rmoutliers(file1,"median");
filtered2 = rmoutliers(file2,"median");
filtered3 = rmoutliers(file3,"median");
filtered4 = rmoutliers(file4,"median");
filtered5 = rmoutliers(file5,"median");
filtered6 = rmoutliers(file6,"median");
filtered7 = rmoutliers(file7,"median");
filtered8 = rmoutliers(file8,"median");
filtered9 = rmoutliers(file9,"median");

filtered1 = rmoutliers(filtered1,"median");
filtered2 = rmoutliers(filtered2,"median");
filtered3 = rmoutliers(filtered3,"median");
filtered4 = rmoutliers(filtered4,"median");
filtered5 = rmoutliers(filtered5,"median");
filtered6 = rmoutliers(filtered6,"median");
filtered7 = rmoutliers(filtered7,"median");
filtered8 = rmoutliers(filtered8,"median");
filtered9 = rmoutliers(filtered9,"median");

% filtered1 = rmoutliers(filtered1,"median");
% filtered2 = rmoutliers(filtered2,"median");
% filtered3 = rmoutliers(filtered3,"median");
% filtered4 = rmoutliers(filtered4,"median");
% filtered5 = rmoutliers(filtered5,"median");
% filtered6 = rmoutliers(filtered6,"median");
% filtered7 = rmoutliers(filtered7,"median");
% filtered8 = rmoutliers(filtered8,"median");
% filtered9 = rmoutliers(filtered9,"median");
% 
% filtered1 = rmoutliers(filtered1,"median");
% filtered2 = rmoutliers(filtered2,"median");
% filtered3 = rmoutliers(filtered3,"median");
% filtered4 = rmoutliers(filtered4,"median");
% filtered5 = rmoutliers(filtered5,"median");
% filtered6 = rmoutliers(filtered6,"median");
% filtered7 = rmoutliers(filtered7,"median");
% filtered8 = rmoutliers(filtered8,"median");
% filtered9 = rmoutliers(filtered9,"median");
% 
% filtered1 = rmoutliers(filtered1,"median");
% filtered2 = rmoutliers(filtered2,"median");
% filtered3 = rmoutliers(filtered3,"median");
% filtered4 = rmoutliers(filtered4,"median");
% filtered5 = rmoutliers(filtered5,"median");
% filtered6 = rmoutliers(filtered6,"median");
% filtered7 = rmoutliers(filtered7,"median");
% filtered8 = rmoutliers(filtered8,"median");
% filtered9 = rmoutliers(filtered9,"median");

figure(2)
scatter(filtered1(:,1),filtered1(:,2));
hold on
scatter(filtered2(:,1),filtered2(:,2));
scatter(filtered3(:,1),filtered3(:,2));
scatter(filtered4(:,1),filtered4(:,2));
scatter(filtered5(:,1),filtered5(:,2));
scatter(filtered6(:,1),filtered6(:,2));
scatter(filtered7(:,1),filtered7(:,2));
scatter(filtered8(:,1),filtered8(:,2));
scatter(filtered9(:,1),filtered9(:,2));

meanPos1 = mean(filtered1);
meanPos2 = mean(filtered2);
meanPos3 = mean(filtered3);
meanPos4 = mean(filtered4);
meanPos5 = mean(filtered5);
meanPos6 = mean(filtered6);
meanPos7 = mean(filtered7);
meanPos8 = mean(filtered8);
meanPos9 = mean(filtered9);
scatter(meanPos1(1),meanPos1(2),40,'filled','d');
scatter(meanPos2(1),meanPos2(2),40,'filled','d');
scatter(meanPos3(1),meanPos3(2),40,'filled','d');
scatter(meanPos4(1),meanPos4(2),40,'filled','d');
scatter(meanPos5(1),meanPos5(2),40,'filled','d');
scatter(meanPos6(1),meanPos6(2),40,'filled','d');
scatter(meanPos7(1),meanPos7(2),40,'filled','d');
scatter(meanPos8(1),meanPos8(2),40,'filled','d');
scatter(meanPos9(1),meanPos9(2),40,'filled','d');


%  X = [100 100 960 1820 1820 1820 960 100 960]';
%  Y = [540 980 980 980 540 100 100 100 540]';
 X = [100 100 1280 2460 2460 2460 1280 100 1280]';
 Y = [540 980 980 980 540 100 100 100 540]';


Ax = [1 meanPos1(1) meanPos1(1)^2 meanPos1(1)*meanPos1(2) ; ...
    1 meanPos2(1) meanPos2(1)^2 meanPos2(1)*meanPos2(2);  ...
    1 meanPos3(1) meanPos3(1)^2 meanPos3(1)*meanPos3(2); ...
    1 meanPos4(1) meanPos4(1)^2 meanPos4(1)*meanPos4(2);
    1 meanPos5(1) meanPos5(1)^2 meanPos5(1)*meanPos5(2);
    1 meanPos6(1) meanPos6(1)^2 meanPos6(1)*meanPos6(2);
    1 meanPos7(1) meanPos7(1)^2 meanPos7(1)*meanPos7(2);
    1 meanPos8(1) meanPos8(1)^2 meanPos8(1)*meanPos8(2);
    1 meanPos9(1) meanPos9(1)^2 meanPos9(1)*meanPos9(2);
    ];

Ay = [1 meanPos1(2) meanPos1(2)^2 meanPos1(2)*meanPos1(1); ...
    1 meanPos2(2) meanPos2(2)^2 meanPos2(2)*meanPos2(1); ...
    1 meanPos3(2) meanPos3(2)^2 meanPos3(2)*meanPos3(1); ...
    1 meanPos4(2) meanPos4(2)^2 meanPos4(2)*meanPos4(1);
    1 meanPos5(2) meanPos5(2)^2 meanPos5(2)*meanPos5(1);
    1 meanPos6(2) meanPos6(2)^2 meanPos6(2)*meanPos6(1);
    1 meanPos7(2) meanPos7(2)^2 meanPos7(2)*meanPos7(1);
    1 meanPos8(2) meanPos8(2)^2 meanPos8(2)*meanPos8(1);
    1 meanPos9(2) meanPos9(2)^2 meanPos9(2)*meanPos9(1);
    ];

XCalib = Ax\X;
YCalib = Ay\Y;

%% Calibrated
c = 1;
XposCalibrated = [];
YposCalibrated = [];
for i = 1:numel(filtered1(:,1))
    Xpos = filtered1(i,1);
    Ypos = filtered1(i,2);
    XposCalibrated(c) = calcCalibratedX(XCalib,Xpos,Ypos);
    YposCalibrated(c) = calcCalibratedY(YCalib,Xpos,Ypos);
    c = c+1;
end
c = c-1;
for i = 1:numel(filtered2(:,1))
    Xpos = filtered2(i,1);
    Ypos = filtered2(i,2);
    XposCalibrated(c) = calcCalibratedX(XCalib,Xpos,Ypos);
    YposCalibrated(c) = calcCalibratedY(YCalib,Xpos,Ypos);
    c = c+1;
end
c = c-1;
for i = 1:numel(filtered3(:,1))
    Xpos = filtered3(i,1);
    Ypos = filtered3(i,2);
    XposCalibrated(c) = calcCalibratedX(XCalib,Xpos,Ypos);
    YposCalibrated(c) = calcCalibratedY(YCalib,Xpos,Ypos);
    c = c+1;
end

c = c-1;
for i = 1:numel(filtered4(:,1))
    Xpos = filtered4(i,1);
    Ypos = filtered4(i,2);
    XposCalibrated(c) = calcCalibratedX(XCalib,Xpos,Ypos);
    YposCalibrated(c) = calcCalibratedY(YCalib,Xpos,Ypos);
    c = c+1;
end

c = c-1;
for i = 1:numel(filtered5(:,1))
    Xpos = filtered5(i,1);
    Ypos = filtered5(i,2);
    XposCalibrated(c) = calcCalibratedX(XCalib,Xpos,Ypos);
    YposCalibrated(c) = calcCalibratedY(YCalib,Xpos,Ypos);
    c = c+1;
end

c = c-1;
for i = 1:numel(filtered6(:,1))
    Xpos = filtered6(i,1);
    Ypos = filtered6(i,2);
    XposCalibrated(c) = calcCalibratedX(XCalib,Xpos,Ypos);
    YposCalibrated(c) = calcCalibratedY(YCalib,Xpos,Ypos);
    c = c+1;
end

c = c-1;
for i = 1:numel(filtered7(:,1))
    Xpos = filtered7(i,1);
    Ypos = filtered7(i,2);
    XposCalibrated(c) = calcCalibratedX(XCalib,Xpos,Ypos);
    YposCalibrated(c) = calcCalibratedY(YCalib,Xpos,Ypos);
    c = c+1;
end
c = c-1;
for i = 1:numel(filtered8(:,1))
    Xpos = filtered8(i,1);
    Ypos = filtered8(i,2);
    XposCalibrated(c) = calcCalibratedX(XCalib,Xpos,Ypos);
    YposCalibrated(c) = calcCalibratedY(YCalib,Xpos,Ypos);
    c = c+1;
end

c = c-1;
for i = 1:numel(filtered9(:,1))
    Xpos = filtered9(i,1);
    Ypos = filtered9(i,2);
    XposCalibrated(c) = calcCalibratedX(XCalib,Xpos,Ypos);
    YposCalibrated(c) = calcCalibratedY(YCalib,Xpos,Ypos);
    c = c+1;
end

figure(3)
scatter(XposCalibrated,YposCalibrated)
save("XCalib.mat","XCalib");
save("YCalib.mat","YCalib");

calcCalibratedX(XCalib,meanPos4(1),meanPos4(2))
calcCalibratedY(YCalib,meanPos4(1),meanPos4(2))
function pos = calcCalibratedX(Calib,Xpos,Ypos)
pos = Calib(1) + Calib(2)*Xpos + Calib(3)*Xpos^2 + Calib(4)*Xpos*Ypos;
pos = int16(pos);
end
function pos = calcCalibratedY(Calib,Xpos,Ypos)
pos = Calib(1) + Calib(2)*Ypos + Calib(3)*Ypos^2 + Calib(4)*Ypos*Xpos;
pos = int16(pos);
end








