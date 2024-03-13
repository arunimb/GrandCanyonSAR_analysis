To recreate all the plots the scripts have to be run in the following order:


1) concantenateLSLdata.m --> combines *.xdf LSL files (keystrokes, EEG, gaze) to individual subject *.mat files; Aligns EEG timestamps with keystrokes for later; 

2) preprocessData.m --> Chopping into conditions.


3) findOverlaps.m --> Finds overlapping trials and trims them from end to end


4a) plotEEGbyTrial.m --> Exports cognitive load for all subjects in one matlab files
4b) plotSpeedTurnRate.m --> Exports speed, turn rate for all subjects
4c) timeViolinPlots.m --> Exports time to finish for all subjects
4d) plotGazeFromInsetCorner.m --> Exports gaze distance for all subjects
5) reexportMatFiles.m --> Truncates time series over 600s to 600s
6) aggregateStats.m --> Plots the stats

To run the stats, run step 6.
Also, running one can run 4a through 6, if the *_v2.mat files are available on the github