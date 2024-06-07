from tkinter import *
import tkinter.scrolledtext as st 
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
logging.getLogger('tensorflow').disabled = True
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "3"

def sendAndReceiveTrajInfo():
    global run
    if run:
        text_area.insert(INSERT, "Loading model\n")
        #"/mnt/e/UnderwaterMonitoring/lstm/pilotData/55555/"
        
        mlModel = tf.keras.models.load_model('E:\\GrandCanyonSAR_analysis\\src\\inferenceLSTM\\newML\\metisRun\\test1\\CNN_LSTM_trainedModel\\', compile=False)
        #mlModel = tf.keras.models.load_model('/mnt/e/UnderwaterMonitoring/lstm/pilotData/55555/savedModel/', compile=False)
        #label = Label(mainWin, text="Model Loaded")
        text_area.insert(INSERT, "Model Loaded\n")
        HOST = "127.0.0.1"  # Standard loopback interface address (localhost)
        PORT = 65432  # Port to listen on
        #paramSet = returnParamSet()
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            #label = Label(mainWin, text="Waiting for connection")
            #label.pack()
            text_area.insert(INSERT, "Waiting for connection\n") 
            s.bind((HOST, PORT))
            s.listen()
            conn, addr = s.accept()

            with conn:
                #print(f"Connected by {addr}")
                text_area.insert(INSERT, f"Connected by {addr}\n")
                #this creates a new label to the GUI
                #label.pack() 
                while run:
                    try:
                        data = conn.recv(14000)
                        #print(data)
                        decodedData = data.decode('utf-8')
                        try:
                            x = np.str_.split(decodedData, ",")
                            xx = np.reshape(x,(1,360,2))
                            inputData = xx.astype(float)
                            #speedArray = x[0:360]
                            #turnRateArray = x[360:720]
                            #inputData = np.reshape(xx,(360,2))
                            pred = mlModel.predict(inputData,verbose=None)
                            print(pred)
                            pred=np.reshape(pred,(2,1))
                            strPred = ",".join(str(xxxx[0]) for xxxx in pred)
                            conn.sendall(strPred.encode())
                            #x2 = np.array(x2)
                            if decodedData == "qw":
                                #label = Label(mainWin, text="Server Stopped")
                                text_area.insert(INSERT, "Server Stop command received\n")
                            
                                #label.pack()
                                #print("Server Stopped")
                                break
                        except:
                            #label = Label(mainWin, text="Error in received Data")
                            text_area.insert(INSERT,"Error in received Data\n")
                            #label.pack()
                    except:
                        #label = Label(mainWin, text="Client Connection Lost")
                        #label.pack()
                        text_area.insert(INSERT,"Client connection lost\n")
                        text_area.insert(INSERT,"Exiting Loop\n")
                        s.close()
                        break
                        #label.pack()
                    if run == False:
                        s.close()
                        text_area.insert(INSERT,"Exiting Loop\n")
                        break

def mid():
    global run
    run = True
    th = threading.Thread(target=sendAndReceiveTrajInfo)
    th.start()


def stopServer():
    global run, safeCount
    safeCount = safeCount + 1
    text_area.insert(INSERT, f"Stop Button Pressed {safeCount} times\n")
    if safeCount >= 3:
        run = False

mainWin = Tk()
mainWin.title("Python Server")
mainWin.geometry("550x280")
mainWin.resizable(False, False)
button1 = Button(mainWin,text="Start Server",command=mid).grid(row = 0, column = 10) #args=(mlModel,)
#button1.pack()
text_area = st.ScrolledText(mainWin, 
                            width = 30,  
                            height = 8,  
                            font = ("Times New Roman", 
                                    15)) 
  
text_area.grid(column = 0, pady = 10, padx = 10) 
run = False
safeCount = 0
button2 = Button(mainWin,text="Stop Server",command=stopServer).grid(row = 5, column = 10)
#text_area.configure(state ='disabled') 
mainWin.mainloop()
    #greeting = Label(text="Hello, Tkinter")