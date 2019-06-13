import mysql.connector as MySQLdb

import hashlib

class ConnectionDB:

    def __init__(self):
        self.cnx = MySQLdb.connect(host="localhost", user="admin", passwd="blessing", db="home_automation")
        self.curs = self.cnx.cursor(dictionary=True)

    def execQuery(self, query):
        try:
            self.curs.execute(query)
            data = self.curs.fetchone()
            self.cnx.close()
            return data
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0
    
    def getAll(self, query):
        try:
            self.curs.execute(query)
            data = self.curs.fetchall()
            self.cnx.close()
            return data
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0

    def execQueryArgs(self, query, values):
        try:
            self.curs.execute(query, values)
            data = self.curs.fetchone()
            self.curs.close()
            self.cnx.close()
            return data
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0

    def readAll(self, query, values):
        try:
            self.curs.execute(query, values)
            data = self.curs.fetchall()
            self.curs.close()
            self.cnx.close()
            return data
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0

    def appliance(self, query, values):
        try:
            self.curs.execute(query, values)
            data = self.curs.fetchone()
            self.closeDB()
            return data[0]['Appliance']
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0

    def updateQuery(self, query):
        try:
            self.curs.execute(query)
            rows = self.curs.rowcount
            self.cnx.commit()
            self.closeDB()
            return rows
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0
    
    def updateQueryArgs(self, query, args):
        try:
            self.curs.execute(query, args)
            self.cnx.commit()
            self.closeDB()
            return 1
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0
    
    def insertQuery(self, query):
        try:
            self.curs.execute(query)
            rows = self.curs.rowcount
            self.cnx.commit()
            self.closeDB()
            return rows
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0
    
    def insertQueryArgs(self, query, args):
        try:
            self.curs.execute(query, args)
            self.cnx.commit()
            self.closeDB()
            return 1
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0
        
    def getCharge(self):
        try:
            query = ("""SELECT raID,charge FROM tbl_rates ORDER BY raID DESC LIMIT 1""")
            self.curs.execute(query)
            data = self.curs.fetchone()
            return data['raID']
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0
    
    def getLastLoggID(self, conn_d_id):
        try:
            query = """
                        SELECT loggID
                            FROM tbl_activity_log
                            WHERE conn_d_id = %s AND turnoff IS NULL
                            ORDER BY loggID DESC
                            LIMIT 1
                    """
            values = (conn_d_id,)
            self.curs.execute(query, values)
            data = self.curs.fetchone()
            
            if(data):
                return data['loggID']
            else:
                return 0;
        except Exception as e:
            print(e)
            return 0
        
    def getAppData(self, conn_d_id):
        try:
            query = """
                    SELECT cd.conn_d_id,cd.appID,cd.boardID,cd.modeID,a.appliance,l.location,cd.device_name,
                        cd.watts,b.board,cd.PIN, cd.date_added,cd.state,cd.auto_time_on,cd.auto_time_off
                         FROM tbl_connected_devices cd
                         JOIN tbl_appliances a
                         ON cd.appID = a.appID
                         JOIN tbl_board b
                         ON cd.boardID = b.boardID
                         JOIN tbl_mode m
                         ON cd.modeID = m.modeID
                         JOIN tbl_location l
                         ON cd.locationID = l.locationID
                         WHERE cd.conn_d_id = %s
                     """
            values = (conn_d_id,)
            self.curs.execute(query, values)
            return self.curs.fetchone()
        except Exception as e:
            print(e)
            return 0;
    
    def portValid(self, conn_d_id):
        try:
            query = """
                    SELECT conn_d_id, state
                           FROM tbl_connected_devices
                           WHERE appID NOT IN(3,6) AND conn_d_id = %s
                     """
            values = (conn_d_id,)
            self.curs.execute(query, values)
            return self.curs.fetchone()
        except Exception as e:
            print(e)
            return 0;
    
    def pinValid(self, pin):
        try:
            query = """
                        SELECT * FROM tbl_userpins
                         WHERE pin = %s
                    """
            pass_hash = hashlib.md5(pin.encode('utf-8')).hexdigest()
            values = (pass_hash,)
            self.curs.execute(query, values)
            data = self.curs.fetchone()
            if(data):
                return 1
            else:
                return 0
            
        except Exception as e:
            print(e)
            return 0
    
    def updateState(self, conn_d_id, state, user):
        try:
            query = """
                        UPDATE tbl_connected_devices
                            SET state = %(state)s
                            WHERE conn_d_id = %(conn_d_id)s
                    """
            values = { 'conn_d_id': conn_d_id,'state':state }
            self.curs.execute(query, values)
            self.cnx.commit()
            if state == 1:
                self.logOnDevice(conn_d_id, user)
            else:
                self.logOffDevice(conn_d_id, user) 
             
        except Exception as e:
            print(e)
            return 0
    
    def buzzerState(self, conn_d_id, state):
        try:
            query = ("""UPDATE tbl_connected_devices
                                SET state = %(state)s
                                WHERE conn_d_id = %(conn_d_id)s""")
            values = { 'conn_d_id': conn_d_id,'state':state }
            self.curs.execute(query, values)
            self.cnx.commit()
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0
        
    def DBalarmOn(self, conn_d_id, state):
        try:
            conn = ConnectionDB()
            query = ("""UPDATE tbl_connected_devices
                                SET state = %(state)s
                                WHERE conn_d_id = %(conn_d_id)s""")
            values = { 'conn_d_id': conn_d_id,'state':state }
            self.curs.execute(query, values)
            self.cnx.commit()
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0
        
    def getPIRBulbs(self, pirID):
        try:
            query = (""" SELECT ml.conn_d_id
                        FROM tbl_motionlights ml
                        JOIN tbl_connected_devices cd
                        ON ml.conn_d_id = cd.conn_d_id
                        WHERE ml.pirID = %s""")
            values = (pirID,)
            self.curs.execute(query, values)
            data = self.curs.fetchall()
            self.curs.close()
            self.cnx.close()
            return data
        except Exception as e:
            print(e)
            return 0
        
    def logOnDevice(self, conn_d_id, user = 'system', mode=1):
        try:
            latestCharge = self.getCharge()
            query = "INSERT INTO tbl_activity_log(turnonby,conn_d_id, modeID, raID) VALUES(%s, %s, %s, %s)"
            loggData = (user, conn_d_id, mode, latestCharge)
            self.curs.execute(query, loggData)
            self.cnx.commit()
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0
        
    def logOffDevice(self,conn_d_id, user = 'system'):
        try:
            lastLoggID = self.getLastLoggID(conn_d_id)
            query = """
                        UPDATE tbl_activity_log SET turnoff = NOW(),
                            turnoffby = %s
                            WHERE loggID = %s
                    """
            values = (user, lastLoggID)
            self.curs.execute(query, values)
            self.cnx.commit()
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0

    def getAllLights(self):
        try:
            query = ("""SELECT conn_d_id
                                FROM tbl_connected_devices
                                WHERE appID = 1""")
            return self.getAll(query)
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0

    def getAllInHouseLights(self):
        try:
            query = ("""SELECT conn_d_id
                                FROM tbl_connected_devices
                                WHERE appID = 1 AND locationID = 1 """)
            return self.getAll(query)
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0
        
    def getAllOutSideLights(self):
        try:
            query = ("""SELECT conn_d_id
                                FROM tbl_connected_devices
                                WHERE appID = 1 AND locationID = 2 """)
            return self.getAll(query)
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0
        
    def getAllOnStateDevices(self):
        try:
            query = ("""SELECT cd.conn_d_id, cd.appID,a.appliance
                         FROM tbl_connected_devices cd
                         JOIN tbl_appliances a
                         ON cd.appID = a.appID
                         WHERE cd.state = 1""")
            return self.getAll(query)
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0
    
    def getAllOnModeDevices(self):
        try:
            query = ("""SELECT cd.conn_d_id,cd.appID,a.appliance,cd.auto_time_on,cd.auto_time_off
                         FROM tbl_connected_devices cd
                         JOIN tbl_appliances a
                         ON cd.appID = a.appID
                         WHERE cd.modeID = 2""")
            return self.getAll(query)
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0
    
    def getMacrosDevices(self, macID):
        try:
            query = ("""SELECT conn_d_id
                            FROM tbl_macros_list
                            WHERE macID = %s""")
            values = (macID,)
            return self.readAll(query,values)
        except Exception as e:
            print("Database failure {}".format(str(e)))
            return 0
    
    def closeDB(self):
        self.curs.close()
        self.cnx.close()
