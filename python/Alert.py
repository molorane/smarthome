import datetime , time
import threading
import RPi.GPIO as GPIO

from ConnectionDB import ConnectionDB
from LCD import LCD
from Appliance import *
from ICommand import *

import hashlib
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)


class Alert:
    def beep(self):
        GPIO.setup(23, GPIO.OUT)
        GPIO.output(23, True)
        time.sleep(0.2)
        GPIO.output(23, False)

    def sirenOn(self):
        GPIO.setup(23, GPIO.OUT)
        GPIO.output(23, True)

    def sirenOff(self):
        GPIO.setup(23, GPIO.OUT)
        GPIO.output(23, False)

    def ledOn(self):
        pin = 4
        GPIO.setup(pin, GPIO.OUT)
        GPIO.output(pin, True)
        time.sleep(0.2)
        GPIO.output(pin, False)
        time.sleep(0.2)
        GPIO.output(pin, True)
        time.sleep(0.2)
        GPIO.output(pin, False)

    def ledOff(self):
        pin = 24
        GPIO.setup(pin, GPIO.OUT)
        GPIO.output(pin, True)
        time.sleep(0.2)
        GPIO.output(pin, False)
        time.sleep(0.2)
        GPIO.output(pin, True)
        time.sleep(0.2)
        GPIO.output(pin, False)

    def display1(self, str):
        lcd = LCD()
        lcd.print(str)
        del lcd

    def display2(self, str1, str2):
        lcd = LCD()
        lcd.printB(str1, str2)
        del lcd


class LED(Alert ,threading.Thread):
    def __init__(self, pin, lcd):
        Alert.__init__(self, pin, lcd)
        threading.Thread.__init__(self)
        self.dName = 'LED'
    
    def run(self):
        counter = 0
        while counter < 10:
            GPIO.setup(self.PIN, GPIO.OUT)
            GPIO.output(self.PIN, True)
            time.sleep(0.2)
            GPIO.output(self.PIN, False)
            time.sleep(0.2)
            GPIO.output(self.PIN, True)
            time.sleep(0.2)
            GPIO.output(self.PIN, False)
            counter = counter + 1
            
    def on(self):
        GPIO.setup(self.PIN, GPIO.OUT)
        GPIO.output(self.PIN, True)
        time.sleep(0.2)
        GPIO.output(self.PIN, False)
        time.sleep(0.2)
        GPIO.output(self.PIN, True)
        time.sleep(0.2)
        GPIO.output(self.PIN, False)
        
    def off(self):
        GPIO.setup(self.PIN, GPIO.OUT)
        GPIO.output(self.PIN, True)
        time.sleep(0.2)
        GPIO.output(self.PIN, False)
        time.sleep(0.2)
        GPIO.output(self.PIN, True)
        time.sleep(0.2)
        GPIO.output(self.PIN, False)

"""
    Email class
    Sends email to user
"""


class SendEmail(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        self.fromEmail = "ta04051991@gmail.com"
        self.my_password = "Itumeleng*4"
        self.toEmail = "molorane.mothusi@gmail.com"
        self.msg = MIMEMultipart('alternative')
        self.msg['Subject'] = "Smart Home Automation"
        self.msg['From'] = self.fromEmail
        self.msg['To'] = self.toEmail
        self.msgBody = ""
        # Send the message via gmail's regular server, over SSL - passwords are being sent, afterall
        self.s = smtplib.SMTP_SSL('smtp.gmail.com')
        # uncomment if interested in the actual smtp conversation
        # s.set_debuglevel(1)
        # do the smtp auth; sends ehlo if it hasn't been sent already
        self.s.login(self.fromEmail, self.my_password)

    def run(self):
        try:
            html = self.msgBody  # '<html><body><p>Hi, I have the following python message for you! Later you will get notifications on electricity <span style="color:#FF0000">usage</span></p></body></html>'
            part2 = MIMEText(html, 'html')
            self.msg.attach(part2)
            self.s.sendmail(self.fromEmail, self.toEmail, self.msg.as_string())
            self.s.quit()
        except Exception as e:
            print(e)
    
    def send(self, msg):
        self.msgBody = msg
        self.start()
