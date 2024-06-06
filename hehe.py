print("Sensors and Actuators")

import time
import serial.tools.list_ports

def getPort():
    ports = serial.tools.list_ports.comports()
    N = len(ports)
    print('N_____',N)    # insert
    commPort = "None"
    for i in range(0, N):
        port = ports[i]
        strPort = str(port)
        print('strPort',strPort)
        if "USB" in strPort:
            splitPort = strPort.split(" ")
            commPort = (splitPort[0])
    return commPort
    # return "/dev/ttyUSB1"

portName = getPort()
# print(portName)


try:
    ser = serial.Serial(port=portName, baudrate=115200)
    print("Open successfully")
except:
    print("Can not open the port")

# relay1_ON  = [0, 6, 0, 0, 0, 255, 200, 91]
# relay1_OFF = [0, 6, 0, 0, 0, 0, 136, 27]

relay1_ON  = [1, 6, 0, 0, 0, 255, 201, 138]
relay1_OFF = [1, 6, 0, 0, 0, 0, 137, 202]

def setDevice1(state):
    if state == True:
        ser.write(relay1_ON)
    else:
        ser.write(relay1_OFF)
    time.sleep(1)
    print(serial_read_data(ser))




def serial_read_data(ser):
    bytesToRead = ser.inWaiting()
    print('bytesToRead',bytesToRead)
    if bytesToRead > 0:
        out = ser.read(bytesToRead)
        data_array = [b for b in out]
        print('data_array',data_array)
        if len(data_array) >= 7:
            array_size = len(data_array)
            print('array_size',array_size)
            value = data_array[array_size - 4] * 256 + data_array[array_size - 3]
            return value
        else:
            return -1
    return 0


while True:
    setDevice1(True)
    time.sleep(1)
    setDevice1(False)
    time.sleep(1)

# soil_temperature =[1, 3, 0, 6, 0, 1, 100, 11]
# def readTemperature():
#     serial_read_data(ser)
#     ser.write(soil_temperature)
#     time.sleep(1)
#     return serial_read_data(ser)

# soil_moisture = [1, 3, 0, 7, 0, 1, 53, 203]
# def readMoisture():
#     serial_read_data(ser)
#     ser.write(soil_moisture)
#     time.sleep(1)
#     return serial_read_data(ser)

# while True:
#     print("TEST SENSOR")
#     print(readMoisture())
#     time.sleep(1)
#     print(readTemperature())
#     time.sleep(1)