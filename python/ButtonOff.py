import datetime , time
import socket
import threading
import RPi.GPIO as GPIO

from LCD import LCD
from ConnectionDB import ConnectionDB
from Appliance import *

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)


class ButtonOff(threading.Thread):
    def __init__(self, btnID):
        threading.Thread.__init__(self)
        self.lcd = LCD()
        self.dName = 'Button-Press'
        self.btnID = btnID
        GPIO.setup(self.btnID, GPIO.IN, pull_up_down=GPIO.PUD_UP)

    def run(self):
        while True:
            if not GPIO.input(self.btnID):
                threading.Thread(target=self.beep).start()
                str = "Btn On Pressed!"
                self.lcd.print(str)
                print(str)
                threading.Thread(target=self.offOutSideLights).start()
                time.sleep(0.2)

    def buzzerOff(self):
        pin = 16
        GPIO.setup(pin, GPIO.OUT)
        GPIO.output(pin, False)
        self.updateStatus(0,60)

    def offOutSideLights(self):
        conn = ConnectionDB()
        data = conn.getAllOutSideLights()
        devices = []
        for app in data:
            devices.append(app['conn_d_id'])

        macros = MacroCommand(devices, 'off', self.lcd, 'system')
        macros.execute()
