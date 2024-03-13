import pandas as pd
import numpy as np
import os
import tensorflow as tf
from keras import Sequential
from keras.layers import Dense
from keras.layers import LSTM, GRU, Permute,Conv1D, BatchNormalization, GlobalAveragePooling1D, concatenate, Input
from keras.layers import Activation
from keras.layers import Dropout
from keras.models import Model
import pickle
import warnings
warnings.filterwarnings("ignore")
import logging
logging.getLogger('tensorflow').setLevel(logging.ERROR)
from pathlib import Path

subjectList = pd.read_csv('participantID1.csv', header=None) # import the number participant IDs without the header
numSubjects = subjectList.count()[0]

subjectAlias = np.linspace(1,numSubjects,numSubjects).tolist()
outerSubjectAlias = subjectAlias
trialNames = ['NN','YN','NY','YY'] # NN = NNL + NNH, YN = YNL + YNH, NY = NYL + NHH, YY = YYL + YYH

epochLength = 350
parameterSpace = []
miniBatch = [64, 128]
featureAliases = [0]
#winSize = [5, 10, 15, 20]
# featureCombo = [['xDot','yDot','zDot','thetaDot'], ['speed', 'thetaDot'], ['speed','thetaDot','theta']]
# thetaDot, theta, speed, accel
# speed , thetaDot, height
# how long
featureCombo = [['speed','thetaDot']]
for m in miniBatch:
    for o in featureAliases:
        tempParamSpace = [m,o]
        parameterSpace.append(tempParamSpace)

def assignUserOutput(dataFrameData, requiredSubjects):
    requiredData = dataFrameData.loc[requiredSubjects].to_numpy()
    return requiredData

def assignUserTraj(dataFrameData, requiredSubjects, featureCombo, requiredFeatureCombo):
    requiredData = np.array([])
    for i in range(len(trajectoryDataFrame)):
        temp = dataFrameData[i].loc[requiredSubjects,featureCombo[requiredFeatureCombo]].to_numpy()
        temp = temp.reshape(temp.shape[0],1,temp.shape[1])
        if i == 0:
            requiredData = temp
        if i != 0 :
            requiredData = np.append(requiredData,temp, axis=1)
    return requiredData

def CNNlstmModel(numFeatures, seqLength, numCLasses, NUM_CELLS=8):

    #ip = Input(shape=(numFeatures, seqLength))
    ip = Input(shape=(seqLength, numFeatures))
    x = Permute((2, 1))(ip)
    x = LSTM(NUM_CELLS)(x)
    x = Dropout(0.8)(x)

    #y = Permute((2, 1))(ip)
    #y = Conv1D(128, 8, padding='same', kernel_initializer='he_uniform')(y)
    y = Conv1D(128, 8, padding='same', kernel_initializer='he_uniform')(ip)
    y = BatchNormalization()(y)
    y = Activation('relu')(y)

    y = Conv1D(256, 5, padding='same', kernel_initializer='he_uniform')(y)
    y = BatchNormalization()(y)
    y = Activation('relu')(y)

    y = Conv1D(128, 3, padding='same', kernel_initializer='he_uniform')(y)
    y = BatchNormalization()(y)
    y = Activation('relu')(y)

    y = GlobalAveragePooling1D()(y)

    x = concatenate([x, y])
    #out = Dense(numCLasses, activation='softmax')(x)
    out = Dense(numCLasses, activation='sigmoid')(x)
    model = Model(ip, out)
    optimizer = tf.keras.optimizers.Adam(learning_rate = 0.1)
    #model.compile(loss='categorical_crossentropy',optimizer =optimizer,metrics=['accuracy']) 
    model.compile(loss='BinaryCrossentropy',optimizer =optimizer,metrics=['accuracy']) 
    # model.summary()
    #model.summary()
    # add load model code here to fine-tune
    return model

def resetSaveFile(win):
    writeToFolder = 'saveData/saveData_'+str(win)+'/'
    Path(writeToFolder).mkdir(parents=True, exist_ok=True)
    # if not os.path.exists(writeToFolder):
    # os.path.makedirs(writeToFolder)    
    global i, j, k, outerParameterAccuracy
    global innerParameterUsed, innerParameterAccuracy, innerAggregatedData, outerAggregatedData
    i = 0
    j = 0
    k = 0
    outerParameterAccuracy = np.array([])
    outerParameterUsed = np.array([])
    innerParameterUsed = np.array([])
    innerParameterAccuracy = np.array([])
    innerAggregatedData = np.array([])
    outerAggregatedData = np.array([])
    with open(writeToFolder+'i.pkl', 'wb') as file:
        pickle.dump(i, file)
    with open(writeToFolder+'j.pkl', 'wb') as file:
        pickle.dump(j, file)
    with open(writeToFolder+'k.pkl', 'wb') as file:
        pickle.dump(k, file)
    with open(writeToFolder+'outerParameterAccuracy.pkl', 'wb') as file:
        pickle.dump(outerParameterAccuracy, file)
    with open(writeToFolder+'outerParameterUsed.pkl', 'wb') as file:
        pickle.dump(outerParameterUsed, file)
    with open(writeToFolder+'innerParameterUsed.pkl', 'wb') as file:
        pickle.dump(innerParameterUsed, file)
    with open(writeToFolder+'innerParameterAccuracy.pkl', 'wb') as file:
        pickle.dump(innerParameterAccuracy, file)
    with open(writeToFolder+'innerAggregatedData.pkl', 'wb') as file:
        pickle.dump(innerAggregatedData, file)
    with open(writeToFolder+'outerAggregatedData.pkl', 'wb') as file:
        pickle.dump(outerAggregatedData, file)


def readSavedData(win):
    readFromFolder = 'saveData/saveData_'+str(win)+'/'
    with open(readFromFolder+'i.pkl', 'rb') as file:
        i = pickle.load(file)
    with open(readFromFolder+'j.pkl', 'rb') as file:
        j= pickle.load(file)
    with open(readFromFolder+'k.pkl', 'rb') as file:
        k = pickle.load(file)
    with open(readFromFolder+'outerParameterAccuracy.pkl', 'rb') as file:
        outerParameterAccuracy = pickle.load(file)
    with open(readFromFolder+'outerParameterUsed.pkl', 'rb') as file:
        outerParameterUsed = pickle.load(file)
    with open(readFromFolder+'innerParameterUsed.pkl', 'rb') as file:
        innerParameterUsed = pickle.load(file)
    with open(readFromFolder+'innerParameterAccuracy.pkl', 'rb') as file:
        innerParameterAccuracy = pickle.load(file)
    with open(readFromFolder+'innerAggregatedData.pkl', 'rb') as file:
        innerAggregatedData = pickle.load(file)
    with open(readFromFolder+'outerAggregatedData.pkl', 'rb') as file:
        outerAggregatedData = pickle.load(file)

K1 = 2
K2 = 2
trainFraction = 0.8 # defines fraction of training data
testFraction = 1 - trainFraction
shouldResetSaveFiles = True

i = 0
j = 0
k = 0
outerParameterAccuracy = np.array([])
outerParameterUsed = np.array([])
innerParameterUsed = np.array([])
innerParameterAccuracy = np.array([])

innerAggregatedData = np.array([])
outerAggregatedData = np.array([])

for win in [5, 10, 15, 20]:
    if shouldResetSaveFiles:
        resetSaveFile(win)
    with open('LSTM_inputData/trajectoryDataFrame_'+str(win)+'_multilabel.pkl', 'rb') as file:
    # Call load method to deserialze
        trajectoryDataFrame = pickle.load(file)
    with open('LSTM_inputData/outputDataFrame_'+str(win)+'_multilabel.pkl', 'rb') as file:
    # Call load method to deserialze
        outputDataFrame = pickle.load(file)
    readSavedData(win)
    print('Window Size = {}, Outer Loop no. = {}, Inner Loop no. = {}, Parameter Space no. = {} \n'.format(win,i,j,k))
    writeToFolder = 'saveData/saveData_'+str(win)+'/'
    while i < K1:
        np.random.shuffle(outerSubjectAlias)
        numTrainDataOuter = int(trainFraction*len(outerSubjectAlias))
        numTestDataOuter = len(outerSubjectAlias) - numTrainDataOuter
        trainSubjectsOuterLoop = outerSubjectAlias[0:numTrainDataOuter]
        testSubjectsOuterLoop = outerSubjectAlias[len(trainSubjectsOuterLoop):len(outerSubjectAlias)]
        innerSubjectAlias = trainSubjectsOuterLoop


        while j < K2:
            print()
            print('Window Size = {}, Outer Loop no. = {}, Inner Loop no. = {}, Parameter Space no. = {} \n'.format(win,i,j,k))
            np.random.shuffle(innerSubjectAlias)
            numTrainDataInner = int(trainFraction*len(innerSubjectAlias))
            numTestDataInner = len(innerSubjectAlias) - numTrainDataInner
            trainSubjectsInnerLoop = outerSubjectAlias[0:numTrainDataInner]
            testSubjectsInnerLoop = outerSubjectAlias[len(trainSubjectsInnerLoop): len(trainSubjectsInnerLoop) + numTestDataInner]
            #for k, kk in zip(parameterSpace, range(len(parameterSpace))):
            while k < len(parameterSpace):
                requiredFeatureCombo = parameterSpace[k][1]
                trainTrajData = assignUserTraj(trajectoryDataFrame,trainSubjectsInnerLoop, featureCombo, requiredFeatureCombo)
                trainOutputData = assignUserOutput(outputDataFrame,trainSubjectsInnerLoop)

                testTrajData = assignUserTraj(trajectoryDataFrame,testSubjectsInnerLoop, featureCombo, requiredFeatureCombo)
                testOutputData = assignUserOutput(outputDataFrame,testSubjectsInnerLoop)

                # dropoutRate, LSTM1, LSTM2, numDenseLayers, features, seq_length, numClasses
                features = trainTrajData.shape[2]
                seq_length = trainTrajData.shape[1]
                numClasses = trainOutputData.shape[1]
                mlModel = CNNlstmModel(features, seq_length, numClasses, NUM_CELLS=8)
                #mlModel = lstmModel(parameterSpace[k][0], parameterSpace[k][1], parameterSpace[k][2], parameterSpace[k][3], features, seq_length, numClasses)
                # print("Parameter Tested: " + str((kk+1)/len(parameterSpace)))
                print("\r Inner Loop Progress: {:03.2f} %".format((k+1)/len(parameterSpace)), end='')
                #tf.keras.backend.clear_session()
                innerHistory = mlModel.fit(trainTrajData,trainOutputData,epochs=2,batch_size=parameterSpace[k][0],validation_data=(testTrajData, testOutputData),verbose=0)
                innerParameterAccuracy = np.append(innerParameterAccuracy, innerHistory.history['val_accuracy'][-1])
                #print("\n Parameter Set: {:02.1f},  Test Accuracy: {:03.3f} %".format((k+1)/len(parameterSpace),innerParameterAccuracy[-1]), end='')
                if  innerParameterUsed.shape[0]==0:
                    innerParameterUsed = np.array(parameterSpace[k]).reshape(1,len(parameterSpace[k]))
                else:
                    innerParameterUsed = np.append(innerParameterUsed, np.array(parameterSpace[k]).reshape(1,len(parameterSpace[k])), axis=0)

                if  innerAggregatedData.shape[0]==0:
                    temp = [i, j,k,parameterSpace[k][0],parameterSpace[k][1],
                                                    innerHistory.history['val_accuracy'][-1],innerHistory.history['accuracy'][-1]]
                    innerAggregatedData = np.array(temp).reshape(1,len(temp))
                else:
                    temp = [i, j,k,parameterSpace[k][0],parameterSpace[k][1],
                                                    innerHistory.history['val_accuracy'][-1],innerHistory.history['accuracy'][-1]]
                    innerAggregatedData = np.append(innerAggregatedData, np.array(temp).reshape(1,len(temp)), axis=0)

                k = k + 1
                with open(writeToFolder+'innerParameterUsed.pkl', 'wb') as file:
                    pickle.dump(innerParameterUsed, file)
                with open(writeToFolder+'innerParameterAccuracy.pkl', 'wb') as file:
                    pickle.dump(innerParameterAccuracy, file)
                with open(writeToFolder+'k.pkl', 'wb') as file:
                    pickle.dump(k, file)
                with open(writeToFolder+'innerAggregatedData.pkl', 'wb') as file:
                    pickle.dump(innerAggregatedData, file)
                with open("progress.txt", "a+") as file:
                    file.write(' Window Size = {}, Outer Loop no. = {}, Inner Loop no. = {}, Parameter Space no. = {}, Accuracy = {} \n'.format(win,i,j,k, innerHistory.history['val_accuracy'][-1]))
            j = j + 1
            k = 0
            with open(writeToFolder+'j.pkl', 'wb') as file:
                pickle.dump(j, file)

        max_val = innerParameterAccuracy.max()
        maxAccuracyIndex = innerParameterAccuracy.argmax()
        optimalHyperparams = innerParameterUsed[maxAccuracyIndex] # Optimal Hyperparameters in the inner loop
        requiredFeatureCombo = int(optimalHyperparams[1])
        # Extract data for outer loop training
        trainTrajData = assignUserTraj(trajectoryDataFrame,trainSubjectsOuterLoop, featureCombo, requiredFeatureCombo)
        trainOutputData = assignUserOutput(outputDataFrame,trainSubjectsOuterLoop)

        testTrajData = assignUserTraj(trajectoryDataFrame,testSubjectsOuterLoop, featureCombo, requiredFeatureCombo)
        testOutputData = assignUserOutput(outputDataFrame,testSubjectsOuterLoop)

        # dropoutRate, LSTM1, LSTM2, numDenseLayers, features, seq_length, numClasses
        miniBatchSize = int(optimalHyperparams[0])
        requiredFeatureCombo = int(optimalHyperparams[1])
        features = trainTrajData.shape[2]
        seq_length = trainTrajData.shape[1]
        numClasses = trainOutputData.shape[1]

        # Train the data
        mlModel = CNNlstmModel(features, seq_length, numClasses, NUM_CELLS=8)
        #mlModel = lstmModel(dropoutRate, LSTM1_nodes, LSTM2_nodes, numDenseLayers, features, seq_length, numClasses)
        #tf.keras.backend.clear_session()
        outerHistory = mlModel.fit(trainTrajData,trainOutputData,epochs=2,batch_size=miniBatchSize,validation_data=(testTrajData, testOutputData),verbose=0)
        outerParameterAccuracy = np.append(outerParameterAccuracy, outerHistory.history['val_accuracy'][-1])

        if  outerParameterUsed.shape[0]==0:
            outerParameterUsed = np.array(optimalHyperparams).reshape(1,len(optimalHyperparams))
        else:
            outerParameterUsed = np.append(outerParameterUsed, optimalHyperparams.reshape(1,len(optimalHyperparams)), axis=0)
        if  outerAggregatedData.shape[0]==0:
                    temp = [i,optimalHyperparams[0],optimalHyperparams[1],
                                                    outerHistory.history['val_accuracy'][-1],outerHistory.history['accuracy'][-1]]
                    outerAggregatedData = np.array(temp).reshape(1,len(temp))
        else:
            temp = [i,optimalHyperparams[0],optimalHyperparams[1],
                                                    outerHistory.history['val_accuracy'][-1],outerHistory.history['accuracy'][-1]]
            outerAggregatedData = np.append(outerAggregatedData, np.array(temp).reshape(1,len(temp)), axis=0)

        # save state
        i = i + 1
        j = 0
        innerParameterAccuracy = np.array([])
        innerParameterUsed = np.array([])
        print(" ")
        print("==================Saving Data========================")
        with open(writeToFolder+'i.pkl', 'wb') as file:
            pickle.dump(i, file)
        with open(writeToFolder+'outerParameterAccuracy.pkl', 'wb') as file:
            pickle.dump(outerParameterAccuracy, file)
        with open(writeToFolder+'outerParameterUsed.pkl', 'wb') as file:
            pickle.dump(outerParameterUsed, file)
        with open(writeToFolder+'j.pkl', 'wb') as file:
            pickle.dump(j, file)
        with open(writeToFolder+'k.pkl', 'wb') as file:
            pickle.dump(k, file)
        with open(writeToFolder+'outerAggregatedData.pkl', 'wb') as file:
            pickle.dump(outerAggregatedData, file)