import datetime , time
import socket
import threading
import RPi.GPIO as GPIO

from ConnectionDB import ConnectionDB
from Appliance import *
from ICommand import *
from Alert import *

import hashlib

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)


class MatrixKeypad(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        
        self.MATRIX = [ [1,2,3,'A'],
                        [4,5,6,'B'],
                        [7,8,9,'C'],
                        ['*',0,'#','D'] ]
        self.ROW = [6,5,11,9]
        self.COL = [10,22,27,17]
        self.password = ""  # this will store current entered password
        self.authenticated = False
        self.GPIOPin = ""
        self.alert = Alert()
        self.command = "Enter password:"

        for j in range(4):
            GPIO.setup(self.COL[j], GPIO.OUT)
            GPIO.output(self.COL[j],1)

        for i in range(4):
            GPIO.setup(self.ROW[i], GPIO.IN, pull_up_down = GPIO.PUD_UP)

    def run(self):
        try:
            self.alert.display1(self.command)
            while True:
                for j in range(4):
                    GPIO.output(self.COL[j], 0)
                    for i in range(4):
                        if GPIO.input(self.ROW[i]) == 0:
                            self.beep()
                            if self.MATRIX[i][j] == "C":  # press C for resetting a password
                                self.clear()
                            elif self.authenticated:
                                key = str(self.MATRIX[i][j])
                                if key not in("D","A","B","*","#"):
                                    self.GPIOPin = self.GPIOPin + key
                                    self.alert.display2(self.command, self.GPIOPin)
                                    self.portValid(self.GPIOPin)
                                elif key == "A":
                                    self.onAll()
                                elif key == "B":
                                    self.offAll()
                            else:
                                self.password = self.password + str(self.MATRIX[i][j])
                                passLen = "*"*len(self.password)
                                print(passLen)
                                self.alert.display2(self.command, passLen)
                                if len(self.password) == 4:
                                    self.authenticate()
                            time.sleep(0.1)
                            while GPIO.input(self.ROW[i]) == 0:
                                  pass
                    GPIO.output(self.COL[j], 1)
        except KeyboardInterrupt:
            GPIO.cleanup()

    def clear(self):
        self.password = ""
        self.GPIOPin = ""
        self.alert.display2(self.command, "")

    def requireAuth(self):
        self.authenticated = False
        self.command = "Enter password:"
        self.password = ""
        self.GPIOPin = ""
        self.alert.display1(self.command)
    
    def notFound(self):
        self.clear()
        self.alert.display2("Device", "Not found!")

    def onAll(self):
        conn = ConnectionDB()
        apps = conn.getAllLights()
        devices = []
        for app in apps:
            devices.append(app['conn_d_id'])
        macros = MacroCommand(devices, 'on')
        macros.execute()
        self.requireAuth()

    def offAll(self):
        conn = ConnectionDB()
        apps = conn.getAllLights()
        devices = []
        for app in apps:
            devices.append(app['conn_d_id'])
        macros = MacroCommand(devices, 'off')
        macros.execute()
        self.requireAuth()

    def beep(self):
        self.alert.beep()
    
    def portValid(self, conn_d_id):
        conn = ConnectionDB()
        data = conn.portValid(conn_d_id)
        if data:
            state = data['state']
            ap = Appliance(data['conn_d_id'])
            if state == 1:
                ap.off()
            else:
                ap.on()
            self.requireAuth()
        else:
            if len(conn_d_id) == 2:
                self.notFound()
    
    def authenticate(self):
        conn = ConnectionDB()
        response = conn.pinValid(self.password)
        if response == 1:
            print("PIN CORRECT")
            self.command = "Command:"
            self.alert.display1(self.command)
            self.authenticated = True
        else:
            print("PIN wrong.")
            self.alert.display1("PIN WRONG")
            self.command = "Enter password:"
            time.sleep(3)
            self.alert.display2(self.command,"")
            self.clear()
