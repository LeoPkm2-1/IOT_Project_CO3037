import time
import struct
import serial.tools.list_ports

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


ser=None
try:
    ser = serial.Serial(port=portName, baudrate=9600)
    print("__Open successfully")
except:
    print("__Can not open the port")

class Modbus485:
    def __init__(self, _rs485):
        self.rs485 = _rs485
    
    def modbus485_send(self, data):
        ser = self.rs485
        self.modbus485_clear_buffer()
        try:
            ser.write(serial.to_bytes(data))
        except Exception as e:
            print("Modbus485**","Failed to write data:",e)
            return 0
        return 1
    
    def modbus485_read(self):
        ser = self.rs485
        bytesToRead = ser.inWaiting()
        if bytesToRead > 0:
            out = ser.read(bytesToRead)
            data_array = [b for b in out]
            print('Received Data:', data_array)
            return data_array
        return []
    
    def modbus485_clear_buffer(self):
        ser = self.rs485
        bytesToRead = ser.inWaiting()
        print('_bytesToRead: ',bytesToRead)
        if bytesToRead > 0:
            out = ser.read(bytesToRead)
            print("__Buffer: ",out)
            
    def modbus485_read_adc(self):
        ser = self.rs485
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
                return 400
        return 404
    
    def modbus485_read_big_endian(self):
        ser = self.rs485
        bytesToRead = ser.inWaiting()
        return_array = [0, 0, 0, 0]
        if bytesToRead > 0:
            out = ser.read(bytesToRead)
            data_array = [b for b in out]
            print(data_array)
            
            if len(data_array) >= 7:
                return_array[0] = return_array[5]
                return_array[1] = return_array[6]
                return_array[2] = return_array[3]
                return_array[3] = return_array[4]
                print("Modbus485**", "Raw Data: ",return_array)
                
                [value] = struct.unpack('>f', bytearray(return_array))
                return value
            else:
                return 400
        return 404
    
    def set_device_1(self,state):
        ser = self.rs485
        try:
            if state == True:
                ser.write(serial.to_bytes(relay1_ON))
            else:
                ser.write(serial.to_bytes(relay1_OFF))
        except Exception as e:
            print("Modbus485**","Failed to write data:",e)
        time.sleep(0.07)
        print(f'data__: {self.serial_read_data()}')


    def set_device_2(self,state):
        ser = self.rs485
        try:
            if state == True:
                ser.write(serial.to_bytes(relay2_ON))
            else:
                ser.write(serial.to_bytes(relay2_OFF))
        except Exception as e:
            print("Modbus485**","Failed to write data:",e)
        time.sleep(0.07)
        print(f'data__: {self.serial_read_data()}')

    def set_device_3(self,state):
        ser = self.rs485
        try:
            if state == True:
                ser.write(serial.to_bytes(relay3_ON))
            else:
                ser.write(serial.to_bytes(relay3_OFF))
        except Exception as e:
            print("Modbus485**","Failed to write data:",e)
        time.sleep(0.07)
        print(f'data__: {self.serial_read_data()}')
        
        
    def set_device_4(self,state):
        ser = self.rs485
        try:
            if state == True:
                ser.write(serial.to_bytes(relay4_ON))
            else:
                ser.write(serial.to_bytes(relay4_OFF))
        except Exception as e:
            print("Modbus485**","Failed to write data:",e)
        time.sleep(0.07)
        print(f'data__: {self.serial_read_data()}')
        
        
    def set_device_5(self,state):
        ser = self.rs485
        try:
            if state == True:
                ser.write(serial.to_bytes(relay5_ON))
            else:
                ser.write(serial.to_bytes(relay5_OFF))
        except Exception as e:
            print("Modbus485**","Failed to write data:",e)
        time.sleep(0.07)
        print(f'data__: {self.serial_read_data()}')
                
        
    def set_device_6(self,state):
        ser = self.rs485
        try:
            if state == True:
                ser.write(serial.to_bytes(relay6_ON))
            else:
                ser.write(serial.to_bytes(relay6_OFF))
        except Exception as e:
            print("Modbus485**","Failed to write data:",e)
        time.sleep(0.07)
        print(f'data__: {self.serial_read_data()}')
        
    def set_device_7(self,state):
        ser = self.rs485
        try:
            if state == True:
                ser.write(serial.to_bytes(relay7_ON))
            else:
                ser.write(serial.to_bytes(relay7_OFF))
        except Exception as e:
            print("Modbus485**","Failed to write data:",e)
        time.sleep(0.07)
        print(f'data__: {self.serial_read_data()}')


    def set_device_8(self,state):
        ser = self.rs485
        try:
            if state == True:
                ser.write(serial.to_bytes(relay8_ON))
            else:
                ser.write(serial.to_bytes(relay8_OFF))
        except Exception as e:
            print("Modbus485**","Failed to write data:",e)
        time.sleep(0.07)
        print(f'data__: {self.serial_read_data()}')


    def set_device_state(self,deviceId=1,state=True):
        if deviceId == 1:
            self.set_device_1(state)
        elif deviceId == 2:
            self.set_device_2(state)
        elif deviceId == 3:
            self.set_device_3(state)
        elif deviceId == 4:
            self.set_device_4(state)
        elif deviceId == 5:
            self.set_device_5(state)        
        elif deviceId == 6:
            self.set_device_6(state)  
        elif deviceId == 7:
            self.set_device_7(state)
        elif deviceId == 8:
            self.set_device_8(state)


    def serial_read_data(self):
        ser = self.rs485
        bytesToRead = ser.inWaiting()
        print(f'_bytesToRead: {bytesToRead}')
        if bytesToRead > 0:
            out = ser.read(bytesToRead)
            data_array = [b for b in out]
            print(f'__data_array: {data_array}')
            if len(data_array) >= 7:
                array_size = len(data_array)
                value = data_array[array_size - 4] * 256 + data_array[array_size - 3]
                return value
            else:
                return -1
        return 0
    
SerialController = Modbus485(ser)

if __name__ =='__main__':
    # SerialController.set_device_state(2,True)
    temp_data =[10, 3,2,0,11,92,66]
    SerialController.modbus485_send(temp_data)
    time.sleep(0.1)
    temp_data =[10, 3,2,20,187,82,246]
    SerialController.modbus485_send(temp_data)
    time.sleep(0.1)
    print('data:__',SerialController.serial_read_data())