import socket
import numpy as np
import tensorflow as tf
from keras import Sequential
from keras.layers import Dense
from keras.layers import LSTM, GRU
from keras.layers import Activation
from keras.layers import Dropout
import random
import threading
import tensorflow.python.util.deprecation as deprecation
import logging, os
import keras.backend as K
import time
logging.getLogger('tensorflow').disabled = True
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "3"
#tf.compat.v1.disable_eager_execution()

def sendAndReceiveTrajInfo():
    
    global run
    global mlModel
    if run:
        
        HOST = "127.0.0.1"  # Standard loopback interface address (localhost)
        PORT = 65432  # Port to listen on
        #paramSet = returnParamSet()
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            #label = Label(mainWin, text="Waiting for connection")
            #label.pack()
            print("Waiting for connection\n") 
            s.bind((HOST, PORT))
            s.listen()
            conn, addr = s.accept()

            with conn:
                #print(f"Connected by {addr}")
                print(f"Connected by {addr}\n")
                #this creates a new label to the GUI
                #label.pack() 
                while run:
                    try:
                        data = conn.recv(14000)
                        #print(data)
                        decodedData = data.decode('utf-8')
                        try:
                            if decodedData != "qw":
                                x = np.str_.split(decodedData, ",")
                                xx = np.reshape(x,(1,360,2))
                                inputData = xx.astype(float)
                                #speedArray = x[0:360]
                                #turnRateArray = x[360:720]
                                #inputData = np.reshape(xx,(360,2))
                                try:
                                    pred = mlModel.predict(inputData,verbose=None)
                                    print(pred)
                                    pred=np.reshape(pred,(2,1))
                                    strPred = ",".join(str(xxxx[0]) for xxxx in pred)
                                    conn.sendall(strPred.encode())
                                except:
                                    pred = np.array([0,0])
                                    print(pred)
                                    pred=np.reshape(pred,(2,1))
                                    strPred = ",".join(str(xxxx[0]) for xxxx in pred)
                                    conn.sendall(strPred.encode())
                                #x2 = np.array(x2)
                            if decodedData == "qw":
                                #label = Label(mainWin, text="Server Stopped")
                                print("Server Stop command received\n")
                            
                                #label.pack()
                                #print("Server Stopped")
                                return 3 # server disconnect command
                                #break
                        except:
                            #label = Label(mainWin, text="Error in received Data")
                            if decodedData == '':
                                print("Empty String\n")
                                return 4
                            print("Error in received Data\n")
                            
                            #label.pack()
                    except:
                        #label = Label(mainWin, text="Client Connection Lost")
                        #label.pack()
                        print("Client connection lost\n")
                        print("Exiting Loop\n")
                        s.close()
                        return 2 #client dsconnected
                        #break
                        #label.pack()
                    if run == False:
                        s.close()
                        print("Exiting Loop\n")
                        break

run = True

print("Loading model\n")
#"/mnt/e/UnderwaterMonitoring/lstm/pilotData/55555/"
mlModel = tf.keras.models.load_model('E:\\GrandCanyonSAR_analysis\\src\\inferenceLSTM\\newML\\metisRun\\test1\\CNN_LSTM_trainedModel\\', compile=False)
#mlModel = tf.keras.models.load_model('/mnt/e/UnderwaterMonitoring/lstm/pilotData/55555/savedModel/', compile=False)
#label = Label(mainWin, text="Model Loaded")
print( "Model Loaded\n")
#tf.compat.v1.disable_eager_execution()
while(True):
    val = sendAndReceiveTrajInfo()
    if val == 2:
        print("Client connection lost\n")
        time.sleep(2)
    if val == 3:
        print("server disconnection command received\n")
        time.sleep(2)
    if val == 4:
        print("Empty string\n")
        time.sleep(2)
        #break