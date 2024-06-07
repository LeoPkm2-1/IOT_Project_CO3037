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

print("Sensors and Actuators")

import time
import serial.tools.list_ports

def getPort():
    ports = serial.tools.list_ports.comports()
    N = len(ports)
    print('===N_____',N)    # insert
    commPort = "None"
    for i in range(0, N):
        port = ports[i]
        strPort = str(port)
        print('===strPort___',strPort)
        if "USB" in strPort:
            splitPort = strPort.split(" ")
            commPort = (splitPort[0])
    return commPort
    # return "/dev/ttyUSB1"

portName = getPort()
print('portName___',portName)


try:
    ser = serial.Serial(port=portName, baudrate=115200)
    print("Open successfully")
except:
    print("Can not open the port")

# relay1_ON  = [0, 6, 0, 0, 0, 255, 200, 91]
# relay1_OFF = [0, 6, 0, 0, 0, 0, 136, 27]

# relay1_ON  = [1, 6, 0, 0, 0, 255, 201, 138]
# relay1_OFF = [1, 6, 0, 0, 0, 0, 137, 202]

# relay5_ON  = [5, 6, 0, 0, 0, 255, 200, 14]
# relay5_OFF = [5, 6, 0, 0, 0, 0, 136, 78]

def setDevice1(state):
    if state == True:
        print('\t\t relay8_ON')
        ser.write(relay8_ON)
    else:
        print('\t\t relay8_OFF')
        ser.write(relay8_OFF)
    time.sleep(1)
    print(serial_read_data(ser))


def serial_read_data(ser):
    bytesToRead = ser.inWaiting()
    print('\t\tbytesToRead',bytesToRead)
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
    time.sleep(2)
    setDevice1(False)
    time.sleep(2)

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