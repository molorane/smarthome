import datetime , time
import threading
import RPi.GPIO as GPIO
from nanpy import (ArduinoApi, SerialManager)

from ConnectionDB import ConnectionDB
from Alert import *
from LCD import LCD

class CurrentSensor(threading.Thread):
    def __init__(self, _lcd):
        threading.Thread.__init__(self)
        try:
            self.conn = SerialManager()
            self.a = ArduinoApi(self.conn)
        except:
            print("Failed to connect to Arduino.")

        self.analogIn = 'A0'
        self.mVperAmp = 66  # use 100 for 20A Module and 66 for 30A Module
        self.voltage = 0
        self.amps = 0
        self.rawValue = 0
        self.default = 510
        # Current = Voltage You Applied / The Resistance of your Load
        
        self.lcd = _lcd

    def getAmps(self):
        self.readSensor()
        self.amps = round(((self.rawValue - self.default )* 27.03) / 1023,3)
        #self.amps = (self.default - self.a.analogRead(self.analogIn)) / 102.4
        self.lcd.print("AMPS: {}".format(self.amps))
        return self.amps
    
    def readSensor(self):
        count = 10
        while count > 0:
            self.rawValue = self.a.analogRead(self.analogIn)
            if(self.rawValue < self.default):
                self.rawValue = self.default + (self.default - self.rawValue)
            count = count - 1
            
    def run(self):
        try:
            while True:
                self.getAmps()
                self.saveReadings()
                #self.checkForLimit()
                time.sleep(1)
        except Exception as e:
                print("Reading error {}".format(str(e)))
    
    def getRawValue(self):
        self.readSensor()
        return self.rawValue
    
    def saveReadings(self):
        conn = ConnectionDB()
        
        query = ("""INSERT INTO tbl_liveamps(liveTime, liveValue, liveRaw)
                         VALUES(CURRENT_TIME, %(lvValue)s, %(lvRaw)s)""")
        data = {
                'lvValue': self.amps,
                'lvRaw':self.rawValue,}
        conn.insertQueryArgs(query,data)
    
    def checkForLimit(self):
        conn = ConnectionDB()
        query = ("""SELECT value FROM tbl_settings
                     WHERE stID = %s""")
        values = (1,)
        data = conn.execQueryArgs(query,values)
        
        if float(self.amps) > float(data['value']):
            #self.sendEmail(data['value'])
            print("more energy alert")
    
    def sendEmail(self, expected):
        sendMail = sendEmail()
        time_now = time.ctime()
        msg = """<html>
                    <body>
                        <h3 style="color:#FF0000">Motion Detected</h3>
                        <p>Oops! Mr Molorane, your energy consumption has increased.Smart home strives always to help you
                        save energy, save cost! <br/>
                        Check the details below about the Energy consumption</p>
                        <table border="2">
                            <tr>
                                <td><b>Actual Energy Consumption</b></td>
                                <td>{}amps</td>
                            </tr>
                            <tr>
                                <td><b>Expected Energy Consumption</b></td>
                                <td>{}amps</td>
                            </tr>
                            <tr>
                                <td><b>Time </b></td>
                                <td>{}</td>
                            </tr>
                        </table>
                        <p style="color:#FF0000">Saving energy is important!</p>
                    </body>
                </html>""".format(self.amps, expected, time_now)
        sendMail.send(msg)