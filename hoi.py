from pymodbus.client import ModbusSerialClient as ModbusClient
from pymodbus.constants import Endian
from pymodbus.payload import BinaryPayloadBuilder
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

# Configure the Modbus client
client = ModbusClient(
    method='rtu',
    # port='/dev/ttyUSB0',  # Replace with your serial port
    port=getPort(),
    baudrate=115200,
    timeout=1,
    parity='N',
    stopbits=1,
    bytesize=8
)

# Connect to the Modbus server
connection = client.connect()
if not connection:
    print("Failed to connect to Modbus server.")
    exit(1)
else:
    print("Connect ok")
    


builder = BinaryPayloadBuilder(byteorder=Endian.Big, wordorder=Endian.Little)
builder.add_16bit_uint(2233)  # Example data, replace with actual data

payload = builder.build()

# Write to a holding register (e.g., starting at register address 1)
address = 1
result = client.write_registers(address, payload, skip_encode=True)

if result.isError():
    print("Error writing data to the Modbus server.")
else:
    print("Data successfully written to the Modbus server.")

# Close the connection
client.close()

















# /dev/tty1
# /dev/tty2
# /dev/tty3



# # print("Sensors and Actuators")

# # import time
# # import serial.tools.list_ports

# # def getPort():
# #     ports = serial.tools.list_ports.comports()
# #     N = len(ports)
# #     commPort = "None"
# #     for i in range(0, N):
# #         port = ports[i]
# #         strPort = str(port)
# #         if "USB" in strPort:
# #             splitPort = strPort.split(" ")
# #             commPort = (splitPort[0])
# #     return commPort
# #     # return "/dev/ttyUSB1"

# # portName = "/dev/ttyUSB1"
# # print(portName)



# # try:
# #     ser = serial.Serial(port=portName, baudrate=115200)
# #     print("Open successfully")
# # except:
# #     print("Can not open the port")

# # relay1_ON  = [0, 6, 0, 0, 0, 255, 200, 91]
# # relay1_OFF = [0, 6, 0, 0, 0, 0, 136, 27]

# # def setDevice1(state):
# #     if state == True:
# #         ser.write(relay1_ON)
# #     else:
# #         ser.write(relay1_OFF)
# #     time.sleep(1)
# #     print(serial_read_data(ser))

# # while True:
# #     setDevice1(True)
# #     time.sleep(2)
# #     setDevice1(False)
# #     time.sleep(2)


# # def serial_read_data(ser):
# #     bytesToRead = ser.inWaiting()
# #     if bytesToRead > 0:
# #         out = ser.read(bytesToRead)
# #         data_array = [b for b in out]
# #         print(data_array)
# #         if len(data_array) >= 7:
# #             array_size = len(data_array)
# #             value = data_array[array_size - 4] * 256 + data_array[array_size - 3]
# #             return value
# #         else:
# #             return -1
# #     return 0

# # soil_temperature =[1, 3, 0, 6, 0, 1, 100, 11]
# # def readTemperature():
# #     serial_read_data(ser)
# #     ser.write(soil_temperature)
# #     time.sleep(1)
# #     return serial_read_data(ser)

# # soil_moisture = [1, 3, 0, 7, 0, 1, 53, 203]
# # def readMoisture():
# #     serial_read_data(ser)
# #     ser.write(soil_moisture)
# #     time.sleep(1)
# #     return serial_read_data(ser)

# # while True:
# #     print("TEST SENSOR")
# #     print(readMoisture())
# #     time.sleep(1)
# #     print(readTemperature())
# #     time.sleep(1)