import serial
import struct

# Function to calculate CRC
def calculate_crc(data):
    crc = 0xFFFF
    for pos in data:
        crc ^= pos
        for _ in range(8):
            if (crc & 0x0001) != 0:
                crc >>= 1
                crc ^= 0xA001
            else:
                crc >>= 1
    return crc

# Function to construct a Modbus write request
def construct_write_request(slave_address, start_address, values):
    request = struct.pack('>B', slave_address)  # Slave address
    request += struct.pack('>B', 0x10)  # Function code (Write Multiple Registers)
    request += struct.pack('>H', start_address)  # Start address
    request += struct.pack('>H', len(values))  # Quantity of registers
    request += struct.pack('>B', len(values) * 2)  # Byte count

    for value in values:
        request += struct.pack('>H', value)  # Register values

    crc = calculate_crc(request)
    request += struct.pack('<H', crc)  # CRC
    return request

# Configure the serial connection
ser = serial.Serial(
    port='/dev/ttyUSB0',  # Replace with your serial port
    baudrate=9600,
    bytesize=serial.EIGHTBITS,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_ONE,
    timeout=1
)

# Construct the Modbus write request
slave_address = 1
start_address = 0  # Starting address (0-based)
values = [12345, 54321]  # Array of values to write
request = construct_write_request(slave_address, start_address, values)

# Send the request
ser.write(request)

# Read the response (fixed size for write multiple registers)
response = ser.read(8)

# Close the serial connection
ser.close()