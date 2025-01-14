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


-tlxGLMM.R -> GLMM results in Table 2  %need to change line 26 and 39 to the correct metric (effortTLX, frustrationTLX, mentalTLX, performanceTLX, physicalTLX, temporalTLX)
-performanceGLMM.R -> GLMM results for Table 3
-speedGLMM.R -> GLMM results for table 4
-turnRateGLMM.R -> GLMM results for table 4
-FracFreezeTimeGLMM.R -> GLMM results for table 4
-FracTurningWhileStillGLMM.R -> GLMM results for table 4

7) src/Unity/ -> Unity source code to export the binaries.

8) src/LSTM/training/dataPreparation/ -> Folder containing scripts to prepare training dataPreparation
- exportTrajectoryForTeleopModel.m -> Exports trajectories of participants resampled at 1/24s
- spiralTrajectory.m -> Creates trajectory for spiral search trajectory

9) src/LSTM/training/ -> Folder contains prepared data and output data for ML training
- dataFormattingWin.ipynb -> Script to export data for python pandas readability

10) src/LSTM/training/metisRun/ -> Folder contains K-fold training of the inference model
- LSTM_inputData/ -> folder containing training data for the inference model
- saveData/ -> Folder containing output data obtained by running kFoldMultilabel_Inference.py
- kFoldMultilabel_Inference.py -> python script to check for optimal hyper-parameters for the inference model using k-fold method
- grandCanyonPythonServer.py -> script to create a python server which returns inference values when requested in real-time based on trajectory data
- multilabelProductionmodel.ipynb -> script to train inference model from using the optimal hyper-parameters and save it to CNN_LSTM_trainedModel/ folder
- progress.txt -> Accuracy Logs for k-fold optimisation
- kClusteringResult.xlsx -> tabulated data for the accuracy values of every k-fold run
- LSTM_observationTimeVsAccuracy.m -> script to plot accuracy data over window size fig8 in the paper

11) src/LSTM/stats/ -> Stats for the prior knowledge based simulation
- MissingPersonSimulationStats.m -> plots figures 13 and 14 in the paper
- plotTrajectories.m -> plots figure 12 in the paper
- priorKnowledgeAndSAEstimates.m -> Plots figure 11 in the paper

12) src/Unity/ -> folder containing source code for simulation

13) src/Simulation/ -> folder containing the trained ML model, binaries for various search strategies, batch scripts to run different scenarios
