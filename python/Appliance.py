import datetime , time
import threading
import RPi.GPIO as GPIO
from nanpy import (ArduinoApi, SerialManager)

from ConnectionDB import ConnectionDB
from Alert import *
from ICommand import *

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

# Appliance Generic Class
class Appliance:
    def __init__(self,conn_d_id, _user = 'system'):
        self.conn_d_id = conn_d_id
        self.user = _user
        self.alert = Alert()

        """
            Read database to get full details of device with conn_d_id = self.conn_d_id
            Then assign the values appropriately below
        """
        self.getAppData()
        
        if self.boardID == 2:
            if self.appliance == "Motion Detector":
                GPIO.setup(int(self.pin),GPIO.IN)
            else:
                GPIO.setup(int(self.pin), GPIO.OUT)

    def on(self):
        threading.Thread(target=self.alert.ledOn).start()
        if self.boardID == 2:  # Board is Raspberry Pi
            try:
                GPIO.output(int(self.pin), False)
                notify = "{}-{} On".format(self.appliance, self.device_name)
                notifyLCD = "{}".format(self.device_name)
                print(notify)
                self.updateState(1)
                self.alert.display2(notifyLCD,"On")
                return True
            except Exception as e:
                print("Process Raspberry Pi failed {}".format(str(e)))
                return False
        elif self.boardID == 1:  # Board is Arduino
            try:
                conn = SerialManager()
                a = ArduinoApi(conn)
                a.pinMode(int(self.pin), a.OUTPUT)
                a.digitalWrite(int(self.pin), a.LOW)
                notify = "{}-{} On".format(self.appliance, self.device_name)
                notifyLCD = "{}".format(self.device_name)
                print(notify)
                self.updateState(1)
                self.alert.display2(notifyLCD,"On")
                return True
            except Exception as e:
                print("Failed to connect to Arduino {}".format(str(e)))
                return False

    def off(self):
        threading.Thread(target=self.alert.ledOff).start()
        if self.boardID == 2:  # Board is Raspberry Pi
            try:
                GPIO.output(int(self.pin), True)
                notify = "{}-{} Off".format(self.appliance, self.device_name)
                notifyLCD = "{}".format(self.device_name)
                print(notify)
                self.updateState(0)
                self.alert.display2(notifyLCD,"Off")
                return True
            except Exception as e:
                print("Process Raspberry Pi failed {}".format(str(e)))
                return False
        elif self.boardID == 1:  # Board is Arduino
            try:
                conn = SerialManager()
                a = ArduinoApi(conn)
                a.pinMode(int(self.pin), a.OUTPUT)
                a.digitalWrite(int(self.pin), a.HIGH)
                notify = "{}-{} Off".format(self.appliance, self.device_name)
                notifyLCD = "{}".format(self.device_name)
                print(notify)
                self.updateState(0)
                self.alert.display2(notifyLCD,"Off")
                return True;
            except Exception as e:
                print("Failed to connect to Arduino {}".format(str(e)))
                return False;
        
    def getstatus(self):
        return self.dstatus

    def updateState(self, state):
        conn = ConnectionDB()
        conn.updateState(self.conn_d_id, state, self.user)
    
    def logOnDevice(self):
        conn = ConnectionDB()
        conn.logOnDevice(self.conn_d_id, self.user)
    
    def logOffDevice(self):
        conn = ConnectionDB()
        conn.logOffDevice(self.conn_d_id, self.user)
    
    def getAppData(self):
        conn = ConnectionDB()
        data = conn.getAppData(self.conn_d_id)
        
        self.device_id = data['appID']
        self.boardID = data['boardID']
        self.mode = data['modeID']
        self.appliance = data['appliance']
        self.location = data['location']
        self.device_name = data['device_name']
        self.watts = data['watts']
        self.board = data['board']
        self.pin = data['PIN']
        self.date_added = data['date_added']
        self.status = data['state']
        self.auto_time_on = data['auto_time_on']
        self.auto_time_off = data['auto_time_off']
    
    def buzzerState(self, conn_d_id, state):
        conn = ConnectionDB()
        conn.buzzerState(conn_d_id, state)
            
# Air conditioner or Fan
class AirConditioner(Appliance):

    def __init__(self, conn_d_id, user = 'system'):
        Appliance.__init__(self, conn_d_id, user)

# Fridge
class Fridge(Appliance):

    def __init__(self, conn_d_id, user = 'system'):
        Appliance.__init__(self, conn_d_id, user)


# Garage Door
class GarageDoor(Appliance):

    def __init__(self, conn_d_id, user = 'system'):
        Appliance.__init__(self, conn_d_id, user)


# GatenotifyLCD = "{} Off".format(self.device_name)
class Gate(Appliance):

    def __init__(self, conn_d_id, user = 'system'):
        Appliance.__init__(self, conn_d_id, user)


# Geyser
class Geyser(Appliance):

    def __init__(self, conn_d_id, user = 'system'):
        Appliance.__init__(self, conn_d_id, user)


# Heater
class Heater(Appliance):

    def __init__(self, conn_d_id, user = 'system'):
        Appliance.__init__(self, conn_d_id, user)


# Light bulb
class LightBulb(Appliance):

    def __init__(self, conn_d_id, user = 'system'):
        Appliance.__init__(self, conn_d_id, user)


# Sprinkler
class Sprinkler(Appliance):

    def __init__(self, conn_d_id, user = 'system'):
        Appliance.__init__(self, conn_d_id, user)


# Stove
class Stove(Appliance):

    def __init__(self, conn_d_id, user = 'system'):
        Appliance.__init__(self, conn_d_id, user)


# Washing Machine
class WashingMachine(Appliance):

    def __init__(self, conn_d_id, user = 'system'):
        Appliance.__init__(self, conn_d_id, user)


# Motion Detector or PIR
class PIR(Appliance,threading.Thread):
    
    def __init__(self, conn_d_id, user = 'system'):
        Appliance.__init__(self, conn_d_id, user)
        threading.Thread.__init__(self)
        self.pirOn = True
        
    def run(self):
        while self.pirOn:
            if GPIO.input(int(self.pin)):
                #threading.Thread(target=self.sirenOn).start()
                print("{} detected motion".format(self.device_name))
                self.DBalarmOn(self.conn_d_id, 1)
                #self.sendEmail()
                pirbulbs = PIRBulbs(self.conn_d_id)
                pirbulbs.execute()
                time.sleep(3)

    def on(self):
        self.updateState(1)
        self.start()
        print("{} {} on".format(self.device_name,self.appliance))
        notifyLCD = "{} On".format(self.device_name)
        self.alert.display1(notifyLCD)
        return True

    def off(self):
        self.pirOn = False
        self.updateState(0)
        print("{} {} off".format(self.device_name,self.appliance))
        notifyLCD = "{} Off".format(self.device_name)
        self.alert.display1(notifyLCD)
        return True
    
    def sirenOn(self):
        self.alert.sirenOn()

    def sirenOff(self):
        self.alert.sirenOff()
        
    def sendEmail(self):
        sendMail = SendEmail()
        time_now = time.ctime()
        msg = """<html>
                    <body>
                        <h3 style="color:#FF0000">Motion Detected</h3>
                        <p>Oops! Mr Molorane, suspicious movement has been detected at your house. Crime rate has escalated,
                        smarthome strives to keep you and your place safe at all time! <br/>
                        Check the details below about the PIR's Motion detection</p>
                        <table border="2">
                            <tr>
                                <td><b>Appliance</b></td>
                                <td>{}</td>
                            </tr>
                            <tr>
                                <td><b>PIR-Name </b></td>
                                <td>{}</td>
                            </tr>
                            <tr>
                                <td><b>Location </b></td>
                                <td>{}</td>
                            </tr>
                            <tr>
                                <td><b>Time </b></td>
                                <td>{}</td>
                            </tr>
                        </table>
                        <p style="color:#FF0000">BE SAFE!</p>
                    </body>
                </html>""".format(self.appliance, self.device_name,self.location, time_now)
        sendMail.send(msg)
        
    def DBalarmOn(self, dID, state):
        conn = ConnectionDB()
        conn.DBalarmOn(dID, state)


# Door Sensor
class DoorSensor(Appliance,threading.Thread):
    
    def __init__(self, conn_d_id, user = 'system'):
        Appliance.__init__(self, conn_d_id, user)
        threading.Thread.__init__(self)
        GPIO.setup(int(self.pin), GPIO.IN, pull_up_down = GPIO.PUD_UP)
        self.sensorOn = True
        self.counter = 0
        
    def run(self):
        while self.sensorOn:
            if GPIO.input(int(self.pin)):
                self.counter += 1
                #threading.Thread(target=self.sirenOn).start()
                self.alert.display2("{} SENSOR".format(self.device_name.upper()),"TRIGGERED ({})".format(self.counter))
                print("{} detected motion".format(self.device_name))
                pirbulbs = PIRBulbs(self.conn_d_id)
                pirbulbs.execute()
                time.sleep(3)
                            
    def on(self):
        self.updateState(1)
        self.start()
        print("{} {} on".format(self.device_name,self.appliance))
        notifyLCD = "{} On".format(self.device_name)
        threading.Thread(target=self.alert.display2, args=(notifyLCD,self.appliance,)).start()

    def off(self):
        self.sensorOn = False
        self.updateState(0)
        print("{} {} off".format(self.device_name,self.appliance))
        notifyLCD = "{} Off".format(self.device_name)
        threading.Thread(target=self.alert.display2, args=(notifyLCD,self.appliance,)).start()
    
    def ringSiren(self):
        self.alert.sirenOn()
        
    def notifyOnMotionDetection(self):
        conn = ConnectionDB()
        query = ("""SELECT value FROM tbl_settings WHERE stID = 4""")
        data = conn.execQuery(query)
        return (data['value'] == 'Yes')
    
    def sendEmail(self):
        sendMail = SendEmail()
        time_now = time.ctime()
        msg = """<html>
                    <body>
                        <h3 style="color:#FF0000">Door Opened</h3>
                        <p>Oops! Mr Molorane, a door has been opened. Crime, robbery & bugglary rate has escalated,
                        nanoWare strives to keep you and your place safe at all time.
                        Check the details of the opened door below</p>
                        <table border="2">
                            <tr>
                                <td><b>Appliance</b></td>
                                <td>{}</td>
                            </tr>
                            <tr>
                                <td><b>Door-Name </b></td>
                                <td>{}</td>
                            </tr>
                            <tr>
                                <td><b>Level </b></td>
                                <td>{}</td>
                            </tr>
                            <tr>
                                <td><b>Location </b></td>
                                <td>{}</td>
                            </tr>
                            <tr>
                                <td><b>Time </b></td>
                                <td>{}</td>
                            </tr>
                            <tr>
                                <td><b>Place </b></td>
                                <td>Thaba-Bosiu Ha Sofonia</td>
                            </tr>
                        </table>
                        <p style="color:#FF0000">BE SAFE!</p>
                    </body>
                </html>""".format(self.appliance, self.device_name,  self.level,  self.location, time_now)
        sendMail.send(msg)

# PIRBulbs if Motion Detector or PIR
class PIRBulbs(Appliance,threading.Thread):
    def __init__(self, _pirID):
        Appliance.__init__(self, _pirID)
        threading.Thread.__init__(self)
        conn = ConnectionDB()
        apps = conn.getPIRBulbs(self.conn_d_id)
        self.devices = []
        for app in apps:
            self.devices.append(app['conn_d_id'])

    def run(self):
        macros = MacroCommand(self.devices, 'on', 'system')
        macros.execute()
        time.sleep(8)
        macros = MacroCommand(self.devices, 'off', 'system')
        macros.execute()
                
    def execute(self):
        self.start()


# Automation classes
class autoOn(Appliance,threading.Thread):

    def __init__(self, conn_d_id):
        Appliance.__init__(self, conn_d_id)
        threading.Thread.__init__(self)
        self.makeOn = True
        self.auOn = str(self.auto_time_on)
        self.dTime = self.auOn.split(':')
        #print(self.dTime)

    def run(self):
        while self.makeOn:
            now = datetime.datetime.now()
            if int(now.hour) == int(self.dTime[0]) and int(now.minute) == int(self.dTime[1]):
                self.on()
            time.sleep(59);

    def startAuto(self):
        self.start()
        print("{} {} automation started".format(self.device_name,self.appliance))
        return True

    def endAuto(self):
        self.makeOn = False
        print("{} {} automation ended".format(self.device_name,self.appliance))
        return True
    
    def update(self):
        self.getAppData()
        self.auOn = str(self.auto_time_on)
        self.dTime = self.auOn.split(':')

# Automation classes
class autoOff(Appliance,threading.Thread):

    def __init__(self, conn_d_id):
        Appliance.__init__(self, conn_d_id)
        threading.Thread.__init__(self)
        self.makeOff = True
        self.auOff = str(self.auto_time_off)
        self.dTime = self.auOff.split(':')
        #print(self.dTime)

    def run(self):
        while self.makeOff:
            now = datetime.datetime.now()
            if int(now.hour) == int(self.dTime[0]) and int(now.minute) == int(self.dTime[1]):
                self.off()
            time.sleep(59);

    def startAuto(self):
        self.start()
        print("{} {} automation started".format(self.device_name,self.appliance))
        return True

    def endAuto(self):
        self.makeOff = False
        print("{} {} automation ended".format(self.device_name,self.appliance))
        return True
    
    def update(self):
        self.getAppData()
        self.auOff = str(self.auto_time_off)
        self.dTime = self.auOff.split(':')


# macros
class MacroCommand(ICommand):

    def __init__(self, _devices, _action, _user = 'system'):
        self.devices = _devices
        self.action = _action
        self.user = _user

    def execute(self):
        for device in self.devices:
            app = Appliance(device, self.user)
            app = receiver[app.appliance](device, self.user)
            if self.action == 'on':
                appOn = concreteOn[app.appliance](app)
                appOn.execute()
            else:
                appOff = concreteOff[app.appliance](app)
                appOff.execute()

    def undo(self):
        for device in self.devices:
            app = Appliance(device, self.user)
            app = receiver[app.appliance](device, self.user)
            if self.action == 'on':
                appOn = concreteOn[app.appliance](app)
                appOn.execute()
            else:
                appOff = concreteOff[app.appliance](app)
                appOff.execute()

# This is to enable dynamic instantiation of classes using string names
receiver = {'Light Bulb': LightBulb, 'Motion Detector': PIR, 'Air Conditioner': AirConditioner,
            'Gate': Gate, 'Geyser': Geyser, 'Heater': Heater, 'Sprinkler': Sprinkler,
            'Stove': Stove, 'Garage Door': GarageDoor, 'Fridge': Fridge,
            'Washing Machine': WashingMachine}
