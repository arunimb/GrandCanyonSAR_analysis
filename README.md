To recreate all the plots the scripts have to be run in the following order:


1) preprocessingLSLData/stitchData.m --> combines *.xdf LSL files (keystrokes, EEG, gaze) to individual subject *.mat files; Aligns EEG timestamps with keystrokes for later; 
2) preprocessingLSLData/preprocessData.m --> Chopping into conditions.
3) preprocessingLSLData/findOverlaps.m --> Finds overlapping trials and trims them from end to end
4) preprocessingLSLData/reexportMatFiles.m --> Truncates time series over 600s to 600s


5a) stats/plotEEGbyTrial.m --> Exports cognitive load for all subjects in one matlab files
5b) stats/plotSpeedTurnRate.m --> Exports speed, turn rate for all subjects
5c) stats/timeViolinPlots.m --> Exports time to finish for all subjects
5d) stats/plotGazeFromInsetCorner.m --> Exports gaze distance for all subjects

6) stats/aggregateStats.m --> Plots the friedman stats

To run the stats, run step 6.
Also, running one can run 4a through 6, if the *_v2.mat files are available on the github