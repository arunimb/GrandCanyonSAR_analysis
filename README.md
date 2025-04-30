This paper has 3 main parts: Experiments, LSTM and simulation

# Experiments
- The data for the experiments can be downloaded from 
[SARVR data](https://niuits-my.sharepoint.com/:f:/r/personal/z1776960_students_niu_edu/Documents/SARVR_Data?csf=1&web=1&e=VjOEob) (Raw data availabile upon request can be downloaded from [Raw data](https://niuits-my.sharepoint.com/:f:/r/personal/z1776960_students_niu_edu/Documents/SAR_VR_experimentData?csf=1&web=1&e=536rSK)
- The data folder contains subfolders for each subject, and the subfolders are organized as follows (example files and folders are represented): 
- **data** -> *parent data folder*
    - **11940** -> *participant id*
        - **0**,  **111**-**222** -> *trial names, 0 stands for familiarization trial, 111 stands for NNU trial, 222 stand for YYC trial, etc.*
        - **cluster1**, **cluster2** -> *folders containing gaze calibration information, cluster1 is calibration before break and cluster2 is after break*
            - cluster1.csv ... cluster9.csv -> *gaze data recorded at 9 different locations on the computer screen*
            - XCalib.mat -> *x-axis calibration values for gaze*
            - YCalib.mat -> *y-axis calibration values for gaze*
        - subject_11940.xdf -> *raw LSL data recorded after break*
        - subject_11940_old1.xdf -> *raw LSL data recorded before break*
        - subject_11940.mat -> *processed data*
    

# Processing the raw data

1. First run the *src/ExperimentStats/stitchData.m* script, this combines the recorded LSL data containing keystrokes, EEG, gaze to individual subject *.mat files; Aligns EEG timestamps with keystrokes for later segmentation of data.
2. Then run *src/ExperimentStats/preprocessData.m*, this  script chops up the recorded data into inidividual trials taking into account possible overlaps and exceptions for anomalous recordings.


# Stats and plots

## Plots
1. *src/ExperimentStats/trajHeatmapPriorKnowledgeComparison.m* script plots figure 6
2. *src/ExperimentStats/TwoDTrajPlotting.m* script plots figure 7
3. *src/ExperimentStats/aggregateStats.m* script plots figure 5 and figure 8
4. *src/LSTM/stats/plotTrajectories.m* script plots figure 12
5. *src/LSTM/stats/priorKnowledgeAndSAEstimates.m* script plots figure 11
6. *src/LSTM/stats/MissingPersonSimulationStats.m* script plot figure 13 and 14
7. *src/LSTM/training/metisRun/LSTM_observationTimeVsAccuracy.m* script plot figure 10
8. *src/ExperimentStats/multiPlots.m* script plots figure 4

## Stats
1. *src/ExperimentStats/tlxGLMM.R* script exports GLMM results in Table 2 ***need to change line 26 and 39 to the correct metric*** (effortTLX, frustrationTLX, mentalTLX, performanceTLX, physicalTLX, temporalTLX)
2. *src/ExperimentStats/performanceGLMM.R* script exports GLMM results for Table 3
3. *src/ExperimentStats/speedGLMM.R* script exports GLMM results for portion of table 4
4. *src/ExperimentStats/turnRateGLMM.R* script exports GLMM results for portion of table 4
5. *src/ExperimentStats/FracFreezeTimeGLMM.R* script exports GLMM results for portion of table 4
6. *src/ExperimentStats/FracTurningWhileStillGLMM.R* script exports GLMM results for portion of table 4
7. *src/ExperimentStats/presenceQuestionnaire_analysis.m* script generates values for table 1
8. *src/ExperimentStats/dwellTimeBehaviorCorrelation.m* calculates dwell time (SA) correlations with teleoperator behavior in table 5
9. *src/ExperimentStats/pupilDilationBehaviourCorrelation.m* calculates correlation b/w pupil dilation and teleoperator behavior in table 5
10. *src/ExperimentStats/saccadeFrequencyBehaviourCorrelation.m* calculates correlation b/w saccadic frequency and teleoperator behavior in table 5
11. *src/ExperimentStats/NasaTLX_analysis.m* produces values of table 1 in supplementary material
12. *src/ExperimentStats/situationAwarenessBehaviorFit.m* calculates fit between alpha power (SA) and moving while still behavior


## Support scripts
1. *src/ExperimentStats/funcIdt.m* function to identify fixations using IDT method
2. *src/ExperimentStats/cogload.m* function to calculate cognitive load
2. *src/ExperimentStats/eegAlphaPower.m* function to calculate eeg based SA
3. *src/ExperimentStats/exportForPerformanceGLMM.m* exports data in csv file for *performanceGLMM.R* script
4. *src/ExperimentStats/exportForSpeedandTurnRate.m* exports data in csv file for *speedGLMM.R* and *turnRateGLMM.R*
5. *src/ExperimentStats/exportForFreeze.m* exports data in csv file for *FracFreezeTimeGLMM.R* and *FracTurningWhileStillGLMM.R*
7. *src/ExperimentStats/TLXbySubject.m* exports TLX values to a csv file for use in *NasaTLX_analysis.m*
8. *src/ExperimentStats/freezeTime.m* exports data in csv file for *exportForFreeze.m* and *aggregateStats.m*

# LSTM prior knowledge inference

1. *src/LSTM/training/dataPreparation/exportTrajectoryForTeleopModel.m* exports trajectories of participants resampled at 1/24s
2. *src/LSTM/training/dataPreparation/spiralTrajectory.m* creates trajectory for spiral search trajectory
3. *src/LSTM/training/dataFormattingWin.ipynb* script to export data for python pandas readability
4. *src/LSTM/training/metisRun/* Folder contains K-fold training of the inference model
5. *src/LSTM/training/metisRun/LSTM_inputData/* folder containing training data for the inference model
6. *src/LSTM/training/metisRun/saveData/* Folder containing output data obtained by running kFoldMultilabel_Inference.py
7. *src/LSTM/training/metisRun/kFoldMultilabel_Inference.py* python script to check for optimal hyper-parameters for the inference model using k-fold method 
8. *src/LSTM/training/metisRun/grandCanyonPythonServer.py* script to create a python server which returns inference values when requested in real-time based on trajectory data
9. *src/LSTM/training/metisRun/multilabelProductionmodel.ipynb* script to train inference model from using the optimal hyper-parameters and save it to CNN_LSTM_trainedModel/ folder
10. *src/LSTM/training/metisRun/progress.txt* Accuracy Logs for k-fold optimisation
11. *src/LSTM/training/metisRun/kClusteringResult.xlsx* tabulated data for the accuracy values of every k-fold run

# Simulation
There are 6 binaries (for windows) exported for 6 types of search algorithms as described in the paper

## Binaries

1. *src/Simulation/closedLoop1/MissingPersonSearchSim.exe* binary for strategy ***AsPkTk***
2. *src/Simulation/closedLoop2/MissingPersonSearchSim.exe* binary for strategy ***AsPk***
3. *src/Simulation/closedLoop3/MissingPersonSearchSim.exe* binary for strategy ***AsPkTkSA***
4. *src/Simulation/closedLoop4/MissingPersonSearchSim.exe* binary for strategy ***AsPkSA***
5. *src/Simulation/randomSearch/MissingPersonSearchSim.exe* binary for strategy ***Rs***
6. *src/Simulation/spiralSearch/MissingPersonSearchSim.exe* binary for strategy ***Ss***

## Batch scripts for batch running of the simulation
1. *src/Simulation/simBatchScriptLSTMType1.bat* batch script for strategy ***AsPkTk***
2. *src/Simulation/simBatchScriptLSTMType2.bat* batch script for strategy ***AsPk***
3. *src/Simulation/simBatchScriptLSTMType3.bat* batch script for strategy ***AsPkTkSA***
4. *src/Simulation/simBatchScriptLSTMType4.bat* batch script for strategy ***AsPkSA***
5. *src/Simulation/simBatchScriptRandomSearch.bat* batch script for strategy ***Rs***
6. *src/Simulation/ssimBatchScriptSpiralSearch.bat* batch script for strategy ***Ss***

To run the simulation 

1. Run script *grandCanyonPythonServer.py*, it will load the trained model in *Simulation/CNN_LSTM_trainedModel/** and start a window. On clicking Start it will wait for data from the binaries.
2. Run the batch script corresponding to the search strategy
3. Depending on the strategy type, the output will be stored in one of the following folders:
    - src/Simulation/trajData/simulationRecord/closedLoopType1/
    - src/Simulation/trajData/simulationRecord/closedLoopType2/
    - src/Simulation/trajData/simulationRecord/closedLoopType3/
    - src/Simulation/trajData/simulationRecord/closedLoopType4/
    - src/Simulation/trajData/simulationRecord/randomSearch/
    - src/Simulation/trajData/simulationRecord/spiralSearch/
