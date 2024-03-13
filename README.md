# PreliminaryAnalysisGrandCanyon


# To recreate all the plots the scripts have to be run in the following order:

1) stitchData.m --> combines *.xdf LSL files to individual subject *.mat files
2) preprocessGrandCanyonData.m--> preprocesses and chopping all time series into individual trials
3) calibratedGaze.m --> Maps normalized gaze coordinates to pixel on screen
4) cognitiveLoadByTrial.m --> calculates cognitive load after thresholding over filtered EEG
5) timeToFinishSpeedTurnRateByTrial.m --> Exports speed, turn rate, average height and mission time
6) aggregateStats.m --> Plots the stats

# To run the stats, run step 6
 
