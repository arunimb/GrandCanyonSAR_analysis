import socket
import numpy as np
import time
HOST = "127.0.0.1"  # Standard loopback interface address (localhost)
PORT = 65432  # Port to listen on
clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
clientsocket.setsockopt(socket.SOL_SOCKET, socket.SO_SNDBUF, 14000)
clientsocket.connect((HOST, PORT))


while True:
    dataToSend = np.random.rand(720,1)
    #print(dataToSend)
    strToSend = ",".join(str(xxxx[0]) for xxxx in dataToSend)
    clientsocket.send(strToSend.encode())
    dataRecv = clientsocket.recv(1000)
    print(dataRecv)