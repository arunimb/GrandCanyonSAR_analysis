clear all
close all
clc


% Writes fraction of dwell time to file
addpath("subtightplot\")
% Read subject id list
subject = cellstr(num2str(readmatrix('..\..\data\participantID1.csv')));  % Get subject id list
% Standard order of trials, which is different from subjectwise trial
% order
trialNum = [111,211,121,221,112,212,122,222];
trialName = {'NNU','YNU','NYU','YYU','NNC','YNC','NYC','YYC'};  % Person, Terrain, Swarm cohesion
AOI1coord = [[2560-635,1080-260],[2560, 1080]]; %top right, coordinates for bottom left and top right corners
AOI2coord = [[1,1080-260],[635,1080]]; %top left
AOI3coord = [[1,1],[635,260]];%bottom left
AOI4coord = [[2560-635,1],[2560,260]]; %bottom right
for ii = 1:numel(subject)

    for j = 1:numel(trialNum)
        fileName1 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','fixations.csv'];
        fileName2 = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','time_to_finish.csv'];

        if isfile(fileName1)
            fixations = readmatrix(fileName1);
            time2finish = readmatrix(fileName2);
            dwellTime1 = 0;
            dwellTime2 = 0;
            dwellTime3 = 0;
            dwellTime4 = 0;
            dwellTime5 = 0;
            for k = 1:size(fixations,1)
                if(fixations(k,3) >= AOI1coord(1) && fixations(k,3) <= AOI1coord(3) && fixations(k,4) >= AOI1coord(2) && fixations(k,4) <= AOI1coord(4))
                    dwellTime1 = dwellTime1 + fixations(k,2);

                elseif(fixations(k,3) >= AOI2coord(1) && fixations(k,3) <= AOI2coord(3) && fixations(k,4) >= AOI2coord(2) && fixations(k,4) <= AOI2coord(4))
                    dwellTime2 = dwellTime2 + fixations(k,2);

                elseif(fixations(k,3) >= AOI3coord(1) && fixations(k,3) <= AOI3coord(3) && fixations(k,4) >= AOI3coord(2) && fixations(k,4) <= AOI3coord(4))
                    dwellTime3 = dwellTime3 + fixations(k,2);

                elseif(fixations(k,3) >= AOI4coord(1) && fixations(k,3) <= AOI4coord(3) && fixations(k,4) >= AOI4coord(2) && fixations(k,4) <= AOI4coord(4))
                    dwellTime4 = dwellTime4 + fixations(k,2);
                else
                    dwellTime5 = dwellTime5 + fixations(k,2);
                end

            end

            percentDwell = dwellTime5/time2finish + dwellTime1/time2finish;

            fileName = ['..\..\data\', cell2mat(subject(ii)),'\',num2str(trialNum(j)),'\','percentDwellScreen.csv'];
            writematrix("Screen dwell Time (SA)/ time2finish",fileName);
            writematrix(percentDwell,fileName,'WriteMode','append');
        end
    end
end