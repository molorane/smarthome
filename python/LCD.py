# Simple string program. Writes and updates strings.
# Demo program for the I2C 16x2 Display from Ryanteck.uk
# Created by Matthew Timmons-Brown for The Raspberry Pi Guy YouTube channel

# Import necessary libraries for communication and display use
import lcddriver
import time


display = lcddriver.lcd()


class LCD:
    def __init__(self):
        self.lcd = lcddriver.lcd()
    
    def print(self, str):
        self.lcd.lcd_clear()
        self.lcd.lcd_display_string(str,1)
            
    def printB(self, str1, str2):
        self.lcd.lcd_clear()
        self.lcd.lcd_display_string(str1, 1)
        self.lcd.lcd_display_string(str2, 2)