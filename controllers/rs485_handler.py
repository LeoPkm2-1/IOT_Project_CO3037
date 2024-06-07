relay1_ON  = [1, 6, 0, 0, 0, 255, 201, 138]
relay1_OFF = [1, 6, 0, 0, 0, 0, 137, 202]

relay2_ON  = [2, 6, 0, 0, 0, 255, 201, 185]
relay2_OFF = [2, 6, 0, 0, 0, 0, 137, 249]

relay3_ON  = [3, 6, 0, 0, 0, 255, 200, 104]
relay3_OFF = [3, 6, 0, 0, 0, 0, 136, 40]

relay4_ON  = [4, 6, 0, 0, 0, 255, 201, 223]
relay4_OFF = [4, 6, 0, 0, 0, 0, 137, 159]

relay5_ON  = [5, 6, 0, 0, 0, 255, 200, 14]
relay5_OFF = [5, 6, 0, 0, 0, 0, 136, 78]

relay6_ON  = [6, 6, 0, 0, 0, 255, 200, 61]
relay6_OFF = [6, 6, 0, 0, 0, 0, 136, 125]

relay7_ON  = [7, 6, 0, 0, 0, 255, 201, 236]
relay7_OFF = [7, 6, 0, 0, 0, 0, 137, 172]

relay8_ON  = [8, 6, 0, 0, 0, 255, 201, 19]
relay8_OFF = [8, 6, 0, 0, 0, 0, 137, 83]


import time
import serial.tools.list_ports


def getPort():
    ports = serial.tools.list_ports.comports()
    N = len(ports)
    commPort = "None"
    for i in range(0, N):
        port = ports[i]
        strPort = str(port)
        if "USB" in strPort:
            splitPort = strPort.split(" ")
            commPort = (splitPort[0])
    return commPort



portName = getPort()
print(f"portName: {portName}")



try:
    ser = serial.Serial(port=portName, baudrate=115200)
    print("Open successfully")
except:
    print("Can not open the port")
    
    
# def serial_read_data(ser):
#     bytesToRead = ser.inWaiting()
#     if bytesToRead > 0:
#         out = ser.read(bytesToRead)
#         data_array = [b for b in out]
#         print(data_array)
#         if len(data_array) >= 7:
#             array_size = len(data_array)
#             value = data_array[array_size - 4] * 256 + data_array[array_size - 3]
#             return value
#         else:
#             return -1
#     return 0
    
def set_device_1(state):
    if state == True:
        ser.write(relay1_ON)
    else:
        ser.write(relay1_OFF)
    time.sleep(1)
    print(serial_read_data(ser))
    
def serial_read_data(ser):
    bytesToRead = ser.inWaiting()
    if bytesToRead > 0:
        out = ser.read(bytesToRead)
        data_array = [b for b in out]
        print(data_array)
        if len(data_array) >= 7:
            array_size = len(data_array)
            value = data_array[array_size - 4] * 256 + data_array[array_size - 3]
            return value
        else:
            return -1
    return 0


while True:
    set_device_1(True)
    time.sleep(2)
    set_device_1(False)
    time.sleep(2)