%clearvars
close all



% load("segmented.mat");
% sampleSpeedSegmented = uint16(sampleSpeed);
% sampleThetaDotSegmented = uint16(sampleThetaDot);
% 
% 
% load("sliding.mat")
% sampleSpeed = uint16(sampleSpeed);
% sampleThetaDot = uint16(sampleThetaDot);

%h1 = histogram(sampleSpeedSegmented, 200,'Normalization','probability');
edges = 0:1:60;
[h1,edges1] = histcounts(sampleSpeedSegmented,edges, 'Normalization', 'probability');
%h1 = histogram(sampleSpeedSegmented, 200,'Normalization','probability');
plot(edges1(1:end-1),h1,'LineWidth',1.5)
% ylabel("Normalized frequency")
% xlabel("Value")
hold on

[h2,edges2] = histcounts(sampleSpeed,edges,'Normalization','probability');
plot(edges2(1:end-1),h2,'LineWidth',1.5)
ylabel("Normalized frequency")
xlabel("Value")
legend("Segmented","Sliding")
title("Speed")


figure
%sampleThetaDotSegmentedModded = sort(sampleThetaDotSegmented,'ascend'); 
%sampleThetaDotSegmentedModded = sampleThetaDotSegmented(sampleThetaDotSegmented<=100000);
edges = 0:1:30;
[h3,edges3] = histcounts(sampleThetaDotSegmented,edges, 'Normalization', 'probability');
plot(edges3(1:end-1),h3,'LineWidth',1.5)
%histogram(sampleThetaDotSegmentedModded, 50,'Normalization','probability');
ylabel("Normalized frequency")
xlabel("Value")
hold on
%sampleThetaDotModded = sort(sampleThetaDot,'ascend');
%sampleThetaDotModded = sampleThetaDot(sampleThetaDot<= 100000);
[h4,edges4] = histcounts(sampleThetaDot,edges, 'Normalization', 'probability');
plot(edges4(1:end-1),h4,'LineWidth',1.5)
%histogram(sampleThetaDotModded, 50,'Normalization','probability');
ylabel("Normalized frequency")
xlabel("Value")
legend("Segmented","Sliding")
title("Turn rate")
% figure
% h2 = histogram(sampleThetaDot, 50,'Normalization','probability');
% ylabel("Normalized frequency")
% xlabel("Value")
% title("Segmented Window Turn rate")
% 
% 
% 
% histogram(sampleSpeed, 50,'Normalization','probability')
% ylabel("Normalized frequency")
% xlabel("Value")
% title("Sliding window Speed")
% figure
% histogram(sampleThetaDot, 50,'Normalization','probability')
% ylabel("Normalized frequency")
% xlabel("Value")
% title("Sliding window Turn rate")