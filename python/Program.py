import time
import RPi.GPIO as GPIO
import socket
import threading

from ConnectionDB import ConnectionDB

# import all appliances
from Appliance import *

# import all concrete commands
from ICommand import *

# import class alert for alerts
from Alert import *

from MatrixKeypad import *


sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.bind(('localhost', 5000))
sock.listen(1)

# List of all active motion sensors
motionSensors = []
doorSensors = []

# Initialize two arrays for automation
automatedOn = []
automatedOff = []


def loadOnStateDevices():
    cnx = ConnectionDB()
    data = cnx.getAllOnStateDevices()
    for app in data:
        device = receiver[app['appliance']](app['conn_d_id'], 'system')
        deviceOn = concreteOn[app['appliance']](device)
        deviceOn.execute()
        if(app['appID'] == 6):
            motionSensors.append(device)


def loadOnModeDevices():
    cnx = ConnectionDB()
    data = cnx.getAllOnModeDevices()
    for app in data:
        if(app['auto_time_on'] != None):
            device = autoOn(app['conn_d_id'])
            device.startAuto()
            automatedOn.append(device)
        
        if(app['auto_time_off'] != None):
            device = autoOff(app['conn_d_id'])
            device.startAuto()
            automatedOff.append(device)


def handler(c, a):
    data = c.recv(1024)
    if data:
        print(data)
    tokens = data.decode().split(':')
    action = tokens[0]
    success = False

    if action == 'state':
        appliance = tokens[1]
        conn_d_id = tokens[2]
        status = tokens[3]
        user = tokens[4]
        if appliance == 'Motion Sensor':
            pir = receiver[appliance](conn_d_id, user)
            if status == '1':
                pirOn = concreteOn[appliance](pir)
                success = pirOn.execute()
                motionSensors.append(pir)
            else:
                for sensor in motionSensors:
                    if int(sensor.conn_d_id) == int(conn_d_id):
                        pirOff = concreteOff[appliance](sensor)
                        success = pirOff.execute()
                        motionSensors.remove(sensor)
        elif appliance == 'Door Sensor':
            door = receiver[appliance](conn_d_id, user)
            if status == '1':
                doorOn = concreteOn[appliance](door)
                success = doorOn.execute()
                doorSensors.append(door)
            else:
                for sensor in doorSensors:
                    if int(sensor.conn_d_id) == int(conn_d_id):
                        doorOff = concreteOff[appliance](sensor)
                        success = doorOff.execute()
                        doorSensors.remove(sensor)
        else:
            app = receiver[appliance](conn_d_id, user)
            if status == '1':
                appOn = concreteOn[appliance](app)
                success = appOn.execute()
            else:
                appOff = concreteOff[appliance](app)
                success = appOff.execute()
        if success:
            c.send(b"success")
        else:
            c.send(b"failure")
    elif action == 'mode':
        appliance = tokens[1]
        conn_d_id = tokens[2]
        status = tokens[3]

        if appliance != 'Motion Sensor':
            if status == 'remove':
                for device in automatedOn:
                    if int(device.conn_d_id) == int(conn_d_id):
                        device.endAuto()
                        automatedOn.remove(device)
                        success = True
                for device in automatedOff:
                    if device.conn_d_id == conn_d_id:
                        device.endAuto()
                        automatedOff.remove(device)
                        success = True
            else:
                exist = False
                if status == 'on':
                    for device in automatedOn:
                        if int(device.conn_d_id) == int(conn_d_id):
                            exist = True
                            device.update()
                            success = True
                    if not exist:
                        device = autoOn(conn_d_id)
                        device.startAuto()
                        automatedOn.append(device)
                        success = True
                else:
                    for device in automatedOff:
                        if int(device.conn_d_id) == int(conn_d_id):
                            exist = True
                            device.update()
                            success = True
                    if not exist:
                        device = autoOff(conn_d_id)
                        device.startAuto()
                        automatedOff.append(device)
                        success = True
        else:
            success = False
        if success:
            c.send(b"success")
        else:
            c.send(b"failure")
    elif action == 'macros':
        status = tokens[1]
        data = tokens[2]
        user = tokens[3]
        devices = data.split('-')
        macros = MacroCommand(devices, status, user)
        macros.execute()
        c.send(b"success")
    elif action == 'macrosCategory':
        location = tokens[1]
        status = tokens[2]
        user = tokens[3]
        if location == 'OutSide':
            cnx = ConnectionDB()
            data = cnx.getAllOutSideLights()
            devices = []
            for app in data:
                devices.append(app['conn_d_id'])
            macros = MacroCommand(devices, status, user)
            macros.execute()
            c.send(b"success")
        elif location == 'InHouse':
            cnx = ConnectionDB()
            data = cnx.getAllInHouseLights()
            devices = []
            for app in data:
                devices.append(app['conn_d_id'])
            macros = MacroCommand(devices, status, user)
            macros.execute()
            c.send(b"success")
    elif action == 'macrosCustom':
        macID = tokens[1]
        state = tokens[2]
        user = tokens[3]
        cnx = ConnectionDB()
        data = cnx.getMacrosDevices(macID)
        devices = []
        for app in data:
            devices.append(app['conn_d_id'])
        macros = MacroCommand(devices, state, user)
        macros.execute()
        c.send(b"success")
    if not data:
        c.close()

if __name__ == "__main__":
    
    try:
        print("####################################")
        print("##     SmartHome Automation       ##")
        print("##     Version 1.1.1              ##")
        print("####################################")
        
        matrix = MatrixKeypad()
        matrix.start()

        # load all devices with on state
        # Set their state 1 to ON
        cThread = threading.Thread(target=loadOnStateDevices)
        cThread.start()
                
        # Load all devices with Automatic mode on at start
        # and set them to corresponding automatic mode
        cThread = threading.Thread(target=loadOnModeDevices)
        cThread.start()

        while True:
            c, a = sock.accept()
            cThread = threading.Thread(target=handler, args=(c,a))
            cThread.daemon = True
            cThread.start()
            
    # End program cleanly with keyboard
    except KeyboardInterrupt:
        # Reset GPIO settings
        GPIO.cleanup()

