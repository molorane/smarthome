This smarthome project consists of two board
1. Raspberry Pi 
2. Arduino

The two boards communicate to each other via a serial connection using a nanpy library.
The arduino is connected as a slave to the raspberry pi.

Backend Software on the raspberry Pi
1. PHP
2. Python
3. MySQL

FrontEnd Software on the raspberry pi
1. Angular 1
2. jQuery & jQuery-UI
3. HTML
4. Bootstrap, FontAwesome

The program depends on sockets to communicate between PHP and Python.
Python is the server backend  that receives commands from MatrixKeypad as well as PHP to perform commands.

Angular sends ajax requests to PHP and PHP in turn sends instructions to python via a socket. 
