-- phpMyAdmin SQL Dump
-- version 4.6.6deb4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 09, 2019 at 03:08 PM
-- Server version: 10.1.38-MariaDB-0+deb9u1
-- PHP Version: 7.0.33-0+deb9u3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `home_automation`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `allAccounts` ()  BEGIN
 		SELECT u.userName,u.Email,u.IsApproved,u.IsLocked,u.CreateDate,r.roleName
									FROM tbl_users u
									JOIN tbl_roles r
									ON u.roleID = r.roleID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `allAppliances` ()  BEGIN
 		SELECT appID,appliance
									FROM tbl_appliances
									ORDER BY appliance;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `allConnectedBulbs` ()  BEGIN
 SELECT cd.conn_d_id, cd.device_name
	FROM tbl_connected_devices cd
    WHERE cd.appID = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `allConnectedDevices` ()  BEGIN
 		SELECT cd.conn_d_id,a.appliance,l.location,cd.device_name,cd.watts,b.board,CONCAT('GPIO',cd.PIN) as PIN,
							cd.date_added,cd.state,m.mode,cd.auto_time_on,cd.auto_time_off,p.port,v.level
							FROM tbl_connected_devices cd
							JOIN tbl_appliances a
							ON cd.appID = a.appID
							JOIN tbl_board b
							ON cd.boardID = b.boardID
							JOIN tbl_mode m
							ON cd.modeID = m.modeID
                            JOIN tbl_location l
                            ON cd.locationID = l.locationID
                            JOIN tbl_ports p
                            ON cd.portID = p.portID
                            JOIN tbl_level v
                            ON cd.levelID = v.levelID
							ORDER BY cd.conn_d_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `allCustomMacros` ()  BEGIN
 		SELECT macID,macName,macDescription
		FROM tbl_macros
        WHERE macID IN(SELECT DISTINCT macID FROM tbl_macros_list);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `allDevices` ()  BEGIN
 		SELECT cd.conn_d_id, ap.appliance,l.level,lt.location,cd.device_name
            FROM tbl_connected_devices cd
            JOIN tbl_appliances ap
            ON cd.appID = ap.appID
            JOIN tbl_level l
            ON cd.levelID = l.levelID
            JOIN tbl_location lt
            ON cd.locationID = lt.locationID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `allDevicesWithDeviceID` (IN `_device_d` INT)  BEGIN
  
  SELECT cd.conn_d_id,a.appliance,l.location,cd.device_name,cd.watts,b.board,cd.PIN,cd.date_added,
							cd.state,m.mode,cd.auto_time_on,cd.auto_time_off,p.port,v.levelID,v.level
							FROM tbl_connected_devices cd
							JOIN tbl_appliances a
							ON cd.appID = a.appID
							JOIN tbl_board b
							ON cd.boardID = b.boardID
							JOIN tbl_mode m
							ON cd.modeID = m.modeID
                            JOIN tbl_location l
                            ON cd.locationID = l.locationID
                            JOIN tbl_ports p
                            ON cd.portID = p.portID
                            JOIN tbl_level v
                            ON cd.levelID = v.levelID
							WHERE cd.appID = _device_d
							ORDER BY cd.conn_d_id;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `allLevels` ()  BEGIN
 		SELECT levelID,level
									FROM tbl_level;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `allLocations` ()  BEGIN
 		SELECT locationID,location
									FROM tbl_location;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `allMacros` ()  BEGIN
 		SELECT macID,macName,macDescription
									FROM tbl_macros;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `allMacrosList` (IN `macID` INT)  BEGIN
	SELECT ml.conn_d_id,ap.appliance, lv.level,l.location,cd.device_name
        FROM tbl_macros_list ml
        JOIN tbl_connected_devices cd
        ON ml.conn_d_id = cd.conn_d_id
        JOIN  tbl_level lv
        ON lv.levelID = cd.levelID
        JOIN tbl_location l
        ON l.locationID = cd.locationID
        JOIN tbl_appliances ap
        ON cd.appID = ap.appID
        WHERE ml.macID = macID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `allPIRBulbs` (IN `pir_id` INT)  BEGIN
SELECT ml.conn_d_id, l.location ,cd.device_name, CONCAT('GPIO', cd.PIN) as gpio,b.board as board
	FROM tbl_motionlights ml
    JOIN tbl_connected_devices cd
    ON ml.conn_d_id = cd.conn_d_id
    JOIN tbl_board b
    ON b.boardID = cd.boardID
    JOIN tbl_location l
    ON cd.locationID = l.locationID
    WHERE ml.pirID = pir_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `allPorts` ()  BEGIN
 		SELECT portID,port
									FROM tbl_ports;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `allRates` ()  BEGIN
 		SELECT *
									FROM tbl_rates;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `allRoles` ()  BEGIN
 		SELECT roleID,roleName
									FROM tbl_roles;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `countAlerts` ()  BEGIN
 		SELECT COUNT(*) as notSeen
        	FROM tbl_alerts
            WHERE isSeen = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAccount` (IN `_userName` VARCHAR(20))  BEGIN
  
  SELECT u.userName,u.Email,u.IsApproved,u.IsLocked,u.CreateDate,r.roleName,r.roleID
									FROM tbl_users u
									JOIN tbl_roles r
									ON u.roleID = r.roleID
					        WHERE u.userName = _userName;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getApp` ()  BEGIN
 		SELECT *
									FROM tbl_application;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getAppliance` (IN `_appID` INT)  BEGIN
  
  SELECT appID,appliance
									FROM tbl_appliances
					        WHERE appID = _appID;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getConnectedDevice` (IN `conn_d_id` INT)  BEGIN
  
 	SELECT cd.conn_d_id,cd.appID,cd.boardID,m.mode,a.appliance,l.location,cd.locationID,cd.device_name,cd.watts,b.board,CONCAT('GPIO',cd.PIN) as PIN,
							cd.date_added,cd.state,cd.modeID,cd.auto_time_on,cd.auto_time_off,p.port,v.level, v.levelID
							FROM tbl_connected_devices cd
							JOIN tbl_appliances a
							ON cd.appID = a.appID
							JOIN tbl_board b
							ON cd.boardID = b.boardID
							JOIN tbl_mode m
							ON cd.modeID = m.modeID
                            JOIN tbl_location l
                            ON cd.locationID = l.locationID
                            JOIN tbl_ports p
                            ON cd.portID = p.portID
                            JOIN tbl_level v
                            ON cd.levelID = v.levelID
                            WHERE cd.conn_d_id = conn_d_id;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getConsumptionAlerts` ()  BEGIN
 		SELECT *,CONCAT(
        FLOOR((@_y := SUBSTRING_INDEX(@_x := TIMEDIFF(NOW(), al_date_time), ':', 1))/24), ' days ',
        MOD(@_y, 24) , ' hours ',
        0+SUBSTRING_INDEX(SUBSTRING_INDEX(@_x, ':', 2), ':', -1), ' minutes ',
        0+SUBSTRING_INDEX(SUBSTRING_INDEX(@_x, ':', 3), ':', -1), ' seconds'
    ) AS Diff
				FROM tbl_alerts
                WHERE isSeen = 0 AND al_category = 1
				ORDER BY alID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getDeviceActivity` (IN `_conn_d_id` INT)  BEGIN
  
  SELECT al.loggID,CONCAT(si.surname,' ',si.first_name) as onby, si.profile, TIME(al.turnon) as turnon, YEAR(al.turnon) as turnon_year,
							MONTHNAME(al.turnon) as turnon_month,al.turnon as turnontime, al.turnoff, DAY(al.turnon) as turnon_day,m.mode, 
							CONCAT(bi.surname,' ',bi.first_name) as offby,bi.profile as offprofile
							FROM tbl_activity_log al
							JOIN tbl_connected_devices cd
							ON al.conn_d_id = cd.conn_d_id
							JOIN tbl_user_info si
							ON al.turnonby = si.userName
							JOIN tbl_mode m
							ON al.modeID = m.modeID
							LEFT JOIN tbl_user_info bi
							ON bi.userName = al.turnoffby
							WHERE al.conn_d_id = _conn_d_id
							ORDER BY al.loggID DESC;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getElectricyCostWithRange` (IN `startDate` DATE, IN `endDate` DATE)  BEGIN
  SELECT cd.appID ,ap.appliance as label,
	SUM(TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) as "Hours", r.charge , 
	SUM(cd.watts) as TotalWatts,
	SUM(ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) ,2)) as "kWh",  
	SUM(ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) * r.charge,2)) as "Cost"
	FROM tbl_activity_log al
	INNER JOIN tbl_connected_devices cd
	ON al.conn_d_id = cd.conn_d_id
	INNER JOIN tbl_appliances ap
	ON cd.appID = ap.appID
	INNER JOIN tbl_rates r
	ON al.raID = r.raID
	WHERE (al.turnon BETWEEN startDate AND endDate) AND (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) > 0 AND cd.watts > 0 AND 
	ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) ,2) > 0
	GROUP BY cd.appID
	ORDER BY label;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getLiveAmps` ()  BEGIN
 		SELECT *
									FROM tbl_liveamps
									ORDER BY liveID DESC
                                    LIMIT 20;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMacros` (IN `_macID` INT)  BEGIN
  
 SELECT macID,macName,macDescription
									FROM tbl_macros
					        WHERE macID = _macID;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getPort` (IN `_portID` INT)  BEGIN
  
 SELECT portID,port
									FROM tbl_ports
					        WHERE portID = _portID;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getRole` (IN `_roleID` INT)  BEGIN
  
 SELECT roleID,roleName
									FROM tbl_roles
					        WHERE roleID = _roleID;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSettings` ()  BEGIN
 		SELECT * FROM tbl_settings;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getStateAlert` (IN `_al_id` INT)  BEGIN
  
  SELECT *,CONCAT(
        FLOOR((@_y := SUBSTRING_INDEX(@_x := TIMEDIFF(NOW(), al_date_time), ':', 1))/24), ' days ',
        MOD(@_y, 24) , ' hours ',
        0+SUBSTRING_INDEX(SUBSTRING_INDEX(@_x, ':', 2), ':', -1), ' minutes ',
        0+SUBSTRING_INDEX(SUBSTRING_INDEX(@_x, ':', 3), ':', -1), ' seconds'
    ) AS Diff
				FROM tbl_alerts
                WHERE al_category = 0 AND alID = _al_id;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getStateAlerts` ()  BEGIN
 		SELECT *,CONCAT(
        FLOOR((@_y := SUBSTRING_INDEX(@_x := TIMEDIFF(NOW(), al_date_time), ':', 1))/24), ' days ',
        MOD(@_y, 24) , ' hours ',
        0+SUBSTRING_INDEX(SUBSTRING_INDEX(@_x, ':', 2), ':', -1), ' minutes ',
        0+SUBSTRING_INDEX(SUBSTRING_INDEX(@_x, ':', 3), ':', -1), ' seconds'
    ) AS Diff
				FROM tbl_alerts
                WHERE isSeen = 0 AND al_category = 0
				ORDER BY alID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUnUsedPorts` ()  BEGIN
 	SELECT p.portID,p.port
            FROM tbl_ports p
            LEFT JOIN tbl_connected_devices c
            ON p.portID = c.portID
            WHERE c.portID IS NULL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUsageAlert` (IN `_al_id` INT)  BEGIN
  
  SELECT *,CONCAT(
        FLOOR((@_y := SUBSTRING_INDEX(@_x := TIMEDIFF(NOW(), al_date_time), ':', 1))/24), ' days ',
        MOD(@_y, 24) , ' hours ',
        0+SUBSTRING_INDEX(SUBSTRING_INDEX(@_x, ':', 2), ':', -1), ' minutes ',
        0+SUBSTRING_INDEX(SUBSTRING_INDEX(@_x, ':', 3), ':', -1), ' seconds'
    ) AS Diff
				FROM tbl_alerts
                WHERE al_category = 1 AND alID = _al_id;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUsageAlerts` ()  BEGIN
 		SELECT *,CONCAT(
        FLOOR((@_y := SUBSTRING_INDEX(@_x := TIMEDIFF(NOW(), al_date_time), ':', 1))/24), ' days ',
        MOD(@_y, 24) , ' hours ',
        0+SUBSTRING_INDEX(SUBSTRING_INDEX(@_x, ':', 2), ':', -1), ' minutes ',
        0+SUBSTRING_INDEX(SUBSTRING_INDEX(@_x, ':', 3), ':', -1), ' seconds'
    ) AS Diff
				FROM tbl_alerts
                WHERE isSeen = 0 AND al_category = 1
				ORDER BY alID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserActivity` (IN `_user_id` VARCHAR(20))  BEGIN
  
  SELECT CONCAT(si.surname,' ',si.first_name) as onby, si.profile, TIME(al.turnon) as turnon, YEAR(al.turnon) as turnon_year,
							MONTHNAME(al.turnon) as turnon_month, al.turnoff, DAY(al.turnon) as turnon_day,m.mode, 
							CONCAT(bi.surname,' ',bi.first_name) as offby,bi.profile as offprofile,ap.appliance, cd.device_name
							FROM tbl_activity_log al
							JOIN tbl_connected_devices cd
							ON al.conn_d_id = cd.conn_d_id
							JOIN tbl_user_info si
							ON al.turnonby = si.userName
							JOIN tbl_mode m
							ON al.modeID = m.modeID
							JOIN tbl_appliances ap
							ON cd.appID = ap.appID
							LEFT JOIN tbl_user_info bi
							ON bi.userName = al.turnoffby
							WHERE al.turnonby = _user_id OR al.turnoffby = _user_id
							ORDER BY al.loggID DESC;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `isInHouseLightsON` ()  BEGIN
 		SELECT state,count(state) FROM tbl_connected_devices 
        WHERE appID = 1 AND locationID = 1
        GROUP BY state;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `isOutSideLightsON` ()  BEGIN
 		SELECT state,count(state) FROM tbl_connected_devices 
        WHERE appID = 1 AND locationID = 2
        GROUP BY state;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `isPIR` (IN `pir_id` INT)  BEGIN
 SELECT cd.conn_d_id
	FROM tbl_connected_devices cd
    JOIN tbl_appliances ap
    ON cd.appID = ap.appID
    WHERE cd.conn_d_id = pir_id AND cd.appID = 6;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `macrosDevices` ()  BEGIN
 		SELECT cd.conn_d_id,a.appliance,l.location,v.levelID,v.level,cd.device_name,cd.watts,b.board,cd.PIN,
							cd.date_added,cd.state,m.mode,cd.auto_time_on,cd.auto_time_off
							FROM tbl_connected_devices cd
							JOIN tbl_appliances a
							ON cd.appID = a.appID
							JOIN tbl_board b
							ON cd.boardID = b.boardID
							JOIN tbl_mode m
							ON cd.modeID = m.modeID
                            JOIN tbl_location l
                            ON cd.locationID = l.locationID
                            JOIN tbl_level v
                            ON cd.levelID = v.levelID
                            WHERE cd.appID NOT IN(6,8,11)
							ORDER BY cd.conn_d_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `monthElectricyCost` (IN `ordering` INT)  BEGIN

SET @qry1 = "SELECT MONTHNAME(al.turnon) as label, ";
SET @qry3 = "GROUP BY label ";
SET @qry4 = "ORDER BY label ";
SET @qry2 = "SUM(TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) as \"Hours\", r.charge , 
                SUM(cd.watts) as TotalWatts,
                SUM(ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) ,2)) as \"kWh\",  
                SUM(ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) * r.charge,2)) as \"Cost\"
                FROM tbl_activity_log al
                INNER JOIN tbl_connected_devices cd
                ON al.conn_d_id = cd.conn_d_id
                INNER JOIN tbl_appliances ap
                ON cd.appID = ap.appID
                INNER JOIN tbl_rates r
                ON al.raID = r.raID
                WHERE (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) > 0 AND cd.watts > 0 AND 
                ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) ,2) > 0 ";
        
        IF ordering = 1 THEN
        	SET @qry1 = CONCAT(@qry1, " ap.appliance, ");
            SET @qry3 =  CONCAT(@qry3, " ,ap.appliance ");
			SET @qry4 =  CONCAT(@qry4, " ,ap.appliance ");
        END IF;
            
        SET @Query = CONCAT(@qry1, @qry2, @qry3, @qry4);
            
        PREPARE stmt FROM  @Query;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
   END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newAccount` (IN `_userName` VARCHAR(45), IN `_Email` VARCHAR(45), IN `_password` VARCHAR(40), IN `_IsApproved` INT, IN `_IsLocked` INT, IN `_roleID` INT, IN `_cCode` VARCHAR(10))  BEGIN
  INSERT INTO tbl_users (userName, Email, Password, IsApproved, IsLocked, roleID, cCode) 
              values (_userName , _Email, _password, _IsApproved, _IsLocked, _roleID, _cCode);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `newUser` (IN `_userName` VARCHAR(45), IN `_surname` VARCHAR(40), IN `_firstname` VARCHAR(40))  BEGIN
  INSERT INTO tbl_user_info (userName, surname, first_name) 
              values (_userName , _surname, _firstname);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `quarterElectricyCost` (IN `ordering` INT)  BEGIN

SET @qry1 = "SELECT (CASE 
               WHEN  QUARTER(al.turnon) = 1 THEN \"Quarter 1\"
               WHEN  QUARTER(al.turnon) = 2 THEN \"Quarter 2\"
               WHEN  QUARTER(al.turnon) = 3 THEN \"Quarter 3\"
               ELSE \"Quarter 4\" END) as label, ";
SET @qry3 = "GROUP BY label ";
SET @qry4 = "ORDER BY label ";
SET @qry2 = "SUM(TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) as \"Hours\", r.charge , 
                SUM(cd.watts) as TotalWatts,
                SUM(ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) ,2)) as \"kWh\",  
                SUM(ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) * r.charge,2)) as \"Cost\"
                FROM tbl_activity_log al
                INNER JOIN tbl_connected_devices cd
                ON al.conn_d_id = cd.conn_d_id
                INNER JOIN tbl_appliances ap
                ON cd.appID = ap.appID
                INNER JOIN tbl_rates r
                ON al.raID = r.raID
                WHERE (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) > 0 AND cd.watts > 0 AND 
                ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) ,2) > 0 ";
        
        IF ordering = 1 THEN
        	SET @qry1 = CONCAT(@qry1, " ap.appliance, ");
            SET @qry3 =  CONCAT(@qry3, " ,ap.appliance ");
			SET @qry4 =  CONCAT(@qry4, " ,ap.appliance ");
        END IF;
            
        SET @Query = CONCAT(@qry1, @qry2, @qry3, @qry4);
            
        PREPARE stmt FROM  @Query;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
   END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `todayElectricyCost` ()  BEGIN
  SELECT cd.appID ,ap.appliance as label,
	SUM(TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) as "Hours", r.charge , 
	SUM(cd.watts) as TotalWatts,
	SUM(ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) ,2)) as "kWh",  
	SUM(ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) * r.charge,2)) as "Cost"
	FROM tbl_activity_log al
	INNER JOIN tbl_connected_devices cd
	ON al.conn_d_id = cd.conn_d_id
	INNER JOIN tbl_appliances ap
	ON cd.appID = ap.appID
	INNER JOIN tbl_rates r
	ON al.raID = r.raID
	WHERE (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) > 0 AND cd.watts > 0 AND 
	ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) ,2) > 0
	AND (DATE(al.turnon) = CURDATE())
	GROUP BY cd.appID
	ORDER BY label;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `totalDevices` ()  BEGIN
  SELECT COUNT(conn_d_id) as devices
	FROM tbl_connected_devices;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `totalUsage` ()  BEGIN
  SELECT SUM(cd.watts) as TotalWatts,
	SUM(ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) ,2)) as "kWh",  
	SUM(ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) * r.charge,2)) as "Cost"
	FROM tbl_activity_log al
	INNER JOIN tbl_connected_devices cd
	ON al.conn_d_id = cd.conn_d_id
	INNER JOIN tbl_appliances ap
	ON cd.appID = ap.appID
	INNER JOIN tbl_rates r
	ON al.raID = r.raID
	WHERE (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) > 0 AND cd.watts > 0 AND 
	ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) ,2) > 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `weekElectricyCost` (IN `ordering` INT)  BEGIN

SET @qry1 = "SELECT DAYNAME(al.turnon) as label, ";
SET @qry3 = "GROUP BY label ";
SET @qry4 = "ORDER BY label ";
SET @qry2 = "SUM(TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) as \"Hours\", r.charge , 
                SUM(cd.watts) as TotalWatts,
                SUM(ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) ,2)) as \"kWh\",  
                SUM(ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) * r.charge,2)) as \"Cost\"
                FROM tbl_activity_log al
                INNER JOIN tbl_connected_devices cd
                ON al.conn_d_id = cd.conn_d_id
                INNER JOIN tbl_appliances ap
                ON cd.appID = ap.appID
                INNER JOIN tbl_rates r
                ON al.raID = r.raID
                WHERE (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) > 0 AND cd.watts > 0 AND 
                ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) ,2) > 0 
                AND YEARWEEK(al.turnon)=YEARWEEK(NOW()) ";
        
        IF ordering = 1 THEN
        	SET @qry1 = CONCAT(@qry1, " ap.appliance, ");
            SET @qry3 =  CONCAT(@qry3, " ,ap.appliance ");
			SET @qry4 =  CONCAT(@qry4, " ,ap.appliance ");
        END IF;
            
        SET @Query = CONCAT(@qry1, @qry2, @qry3, @qry4);
            
        PREPARE stmt FROM  @Query;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
   END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `yearlyElectricyCost` (IN `ordering` INT)  BEGIN

SET @qry1 = "SELECT YEAR(al.turnon) as label, ";
SET @qry3 = "GROUP BY label ";
SET @qry4 = "ORDER BY label ";
SET @qry2 = "SUM(TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) as ""Hours"", r.charge , \r\n                SUM(cd.watts) as TotalWatts,\r\n                SUM(ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) ,2)) as ""kWh"",  \r\n                SUM(ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) * r.charge,2)) as ""Cost""\r\n                FROM tbl_activity_log al\r\n                INNER JOIN tbl_connected_devices cd\r\n                ON al.conn_d_id = cd.conn_d_id\r\n                INNER JOIN tbl_appliances ap\r\n                ON cd.appID = ap.appID\r\n                INNER JOIN tbl_rates r\r\n                ON al.raID = r.raID\r\n                WHERE (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) > 0 AND cd.watts > 0 AND \r\n                ROUND(cd.watts / 1000 *  (TIMESTAMPDIFF(SECOND, al.turnon, al.turnoff) / 3600) ,2) > 0 ";
        
        IF ordering = 1 THEN
        	SET @qry1 = CONCAT(@qry1, " ap.appliance, ");
            SET @qry3 =  CONCAT(@qry3, " ,ap.appliance ");
			SET @qry4 =  CONCAT(@qry4, " ,ap.appliance ");
        END IF;
            
        SET @Query = CONCAT(@qry1, @qry2, @qry3, @qry4);
            
        PREPARE stmt FROM  @Query;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
   END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_activity_log`
--

CREATE TABLE `tbl_activity_log` (
  `loggID` int(11) NOT NULL,
  `turnonby` varchar(13) NOT NULL,
  `conn_d_id` int(11) NOT NULL,
  `turnon` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `turnoff` datetime DEFAULT NULL,
  `turnoffby` varchar(13) DEFAULT NULL,
  `modeID` int(11) NOT NULL DEFAULT '1',
  `raID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_alerts`
--

CREATE TABLE `tbl_alerts` (
  `alID` int(11) NOT NULL,
  `isSeen` bit(1) NOT NULL DEFAULT b'0',
  `al_state` bit(1) NOT NULL,
  `al_message` tinytext NOT NULL,
  `al_devices` tinytext NOT NULL,
  `al_date_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `al_category` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_appliances`
--

CREATE TABLE `tbl_appliances` (
  `appID` int(11) NOT NULL,
  `appliance` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_appliances`
--

INSERT INTO `tbl_appliances` (`appID`, `appliance`) VALUES
(1, 'Light Bulb'),
(2, 'Air Conditioner'),
(3, 'Garage Door'),
(4, 'Gate'),
(5, 'Alarm'),
(6, 'Motion Detector'),
(12, 'Geyser'),
(13, 'Heater'),
(14, 'Stove'),
(15, 'Fridge'),
(16, 'Washing Machine'),
(17, 'Sprinkler'),
(23, 'Camera'),
(24, 'LED'),
(25, 'Buzzer'),
(26, 'Siren');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_application`
--

CREATE TABLE `tbl_application` (
  `appName` varchar(45) NOT NULL,
  `appShortName` varchar(5) NOT NULL,
  `developedBy` varchar(60) NOT NULL,
  `yearDeveloped` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_application`
--

INSERT INTO `tbl_application` (`appName`, `appShortName`, `developedBy`, `yearDeveloped`) VALUES
('Smart Home', 'SHA!', 'Mothusi Molorane M', 2018);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_board`
--

CREATE TABLE `tbl_board` (
  `boardID` int(11) NOT NULL,
  `board` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_board`
--

INSERT INTO `tbl_board` (`boardID`, `board`) VALUES
(1, 'Arduino R3 Mega2560'),
(2, 'Raspberry Pi 3');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_connected_devices`
--

CREATE TABLE `tbl_connected_devices` (
  `conn_d_id` int(11) NOT NULL,
  `appID` int(11) NOT NULL,
  `locationID` int(11) NOT NULL,
  `device_name` varchar(45) NOT NULL,
  `watts` double NOT NULL,
  `boardID` int(11) NOT NULL,
  `PIN` int(11) NOT NULL,
  `date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` bit(1) NOT NULL DEFAULT b'0',
  `modeID` int(11) NOT NULL DEFAULT '1',
  `auto_time_on` time DEFAULT '00:00:00',
  `auto_time_off` time DEFAULT NULL,
  `portID` int(11) NOT NULL,
  `levelID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_connected_devices`
--

INSERT INTO `tbl_connected_devices` (`conn_d_id`, `appID`, `locationID`, `device_name`, `watts`, `boardID`, `PIN`, `date_added`, `state`, `modeID`, `auto_time_on`, `auto_time_off`, `portID`, `levelID`) VALUES
(1, 1, 2, 'Front', 100, 2, 26, '2019-05-22 17:39:56', b'1', 1, NULL, NULL, 75, 1),
(2, 1, 1, 'Kitchen', 100, 2, 19, '2019-05-22 17:41:16', b'1', 1, NULL, NULL, 72, 1),
(3, 1, 1, 'Bath Room', 100, 2, 13, '2019-05-22 17:41:39', b'1', 1, '00:00:00', NULL, 70, 1),
(4, 1, 1, 'Bed Room', 100, 2, 21, '2019-05-22 17:42:51', b'0', 1, '00:00:00', NULL, 74, 1),
(5, 1, 2, 'Likhohong', 100, 2, 20, '2019-05-22 17:43:10', b'0', 1, '00:00:00', NULL, 73, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_level`
--

CREATE TABLE `tbl_level` (
  `levelID` int(11) NOT NULL,
  `level` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_level`
--

INSERT INTO `tbl_level` (`levelID`, `level`) VALUES
(1, 'Block 1'),
(2, 'Block 2'),
(5, 'Block 3');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_liveamps`
--

CREATE TABLE `tbl_liveamps` (
  `liveID` int(11) NOT NULL,
  `liveTime` time NOT NULL,
  `liveValue` double NOT NULL,
  `liveRaw` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_location`
--

CREATE TABLE `tbl_location` (
  `locationID` int(11) NOT NULL,
  `location` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_location`
--

INSERT INTO `tbl_location` (`locationID`, `location`) VALUES
(1, 'InHouse'),
(2, 'Outside');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_macros`
--

CREATE TABLE `tbl_macros` (
  `macID` int(11) NOT NULL,
  `macName` varchar(45) NOT NULL,
  `macDescription` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_macros`
--

INSERT INTO `tbl_macros` (`macID`, `macName`, `macDescription`) VALUES
(2, 'Kitchen appliances', 'My kitchen appliances'),
(3, 'Test 1', 'Test 1');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_macros_list`
--

CREATE TABLE `tbl_macros_list` (
  `macID` int(11) NOT NULL,
  `conn_d_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_mode`
--

CREATE TABLE `tbl_mode` (
  `modeID` int(11) NOT NULL,
  `mode` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_mode`
--

INSERT INTO `tbl_mode` (`modeID`, `mode`) VALUES
(1, 'Manual'),
(2, 'Automatic');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_motionlights`
--

CREATE TABLE `tbl_motionlights` (
  `pirID` int(11) NOT NULL,
  `conn_d_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_ports`
--

CREATE TABLE `tbl_ports` (
  `portID` int(11) NOT NULL,
  `port` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_ports`
--

INSERT INTO `tbl_ports` (`portID`, `port`) VALUES
(70, 'RP13'),
(71, 'RP16'),
(72, 'RP19'),
(73, 'RP20'),
(74, 'RP21'),
(75, 'RP26');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_rates`
--

CREATE TABLE `tbl_rates` (
  `raID` int(11) NOT NULL,
  `raDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `charge` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_rates`
--

INSERT INTO `tbl_rates` (`raID`, `raDate`, `charge`) VALUES
(1, '2018-08-18 00:33:03', 1.6),
(2, '2018-10-11 01:45:39', 2.1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_roles`
--

CREATE TABLE `tbl_roles` (
  `roleID` int(11) NOT NULL,
  `roleName` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_roles`
--

INSERT INTO `tbl_roles` (`roleID`, `roleName`) VALUES
(2, 'Admin'),
(27, 'Security Guard'),
(28, 'Guest'),
(29, 'Child'),
(31, 'Parent');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_settings`
--

CREATE TABLE `tbl_settings` (
  `stID` int(11) NOT NULL,
  `setting` varchar(45) NOT NULL,
  `value` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_settings`
--

INSERT INTO `tbl_settings` (`stID`, `setting`, `value`) VALUES
(1, 'Energy consumption limit', '0.185'),
(2, 'Alert Email address', 'molorane.mothusi@gmail.com'),
(3, 'Receive email alert about consumption', 'Weekly'),
(4, 'Receive email alert when motion is detected', 'Yes'),
(5, 'Alert Phone Number', '0817150643'),
(6, 'Receive sms alert about consumption', 'Weekly'),
(7, 'Receive sms alert when motion is detected', 'Yes'),
(8, 'Daily expected consumption', '7'),
(9, 'Weekly expected consumption', '35'),
(10, 'Monthly expected consumption', '140'),
(11, 'Receive email about daily activities ', 'No');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_userpins`
--

CREATE TABLE `tbl_userpins` (
  `userName` varchar(45) NOT NULL,
  `pin` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_userpins`
--

INSERT INTO `tbl_userpins` (`userName`, `pin`) VALUES
('root', 'e6e9099e59636a015536fbb07f979201');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `userName` varchar(10) NOT NULL,
  `Email` varchar(45) NOT NULL,
  `Password` varchar(40) NOT NULL,
  `PasswordQuestion` varchar(256) DEFAULT NULL,
  `PasswordAnswer` varchar(128) DEFAULT NULL,
  `IsApproved` tinyint(4) NOT NULL DEFAULT '0',
  `IsLocked` tinyint(4) NOT NULL DEFAULT '0',
  `CreateDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `LastLoginDate` datetime DEFAULT NULL,
  `LastPasswordChangedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `LastLockoutDate` datetime DEFAULT NULL,
  `FailedPasswordAttemptCount` int(11) NOT NULL DEFAULT '0',
  `FailedPasswordAnswerAttemptCount` int(11) NOT NULL DEFAULT '0',
  `Comment` varchar(256) DEFAULT NULL,
  `roleID` int(11) NOT NULL DEFAULT '1',
  `cCode` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`userName`, `Email`, `Password`, `PasswordQuestion`, `PasswordAnswer`, `IsApproved`, `IsLocked`, `CreateDate`, `LastLoginDate`, `LastPasswordChangedDate`, `LastLockoutDate`, `FailedPasswordAttemptCount`, `FailedPasswordAnswerAttemptCount`, `Comment`, `roleID`, `cCode`) VALUES
('50668079', '50668079@gmail.com', '78f6b70424c32e9b31d35c25dc9fa3ed', NULL, NULL, 1, 0, '2018-07-22 18:18:38', NULL, '2018-10-18 21:46:27', NULL, 0, 0, NULL, 31, 'xtNkXnSuo2'),
('blessy', 'molorane.mothusi@gmail.com', '78f6b70424c32e9b31d35c25dc9fa3ed', NULL, NULL, 1, 0, '2018-06-19 02:07:55', NULL, '2018-10-18 21:46:23', NULL, 0, 0, NULL, 29, 'tKbyBCcUu4'),
('root', 'ta04051991@gmail.com', '78f6b70424c32e9b31d35c25dc9fa3ed', NULL, NULL, 1, 0, '2018-06-19 00:15:59', NULL, '2018-10-10 13:16:28', NULL, 0, 0, NULL, 2, 'abvceabvce'),
('system', 'info@gmail.com', '78f6b70424c32e9b31d35c25dc9fa3ed', NULL, NULL, 1, 1, '2018-06-19 00:15:59', NULL, '2018-09-26 07:57:00', NULL, 0, 0, NULL, 2, 'abvceabvce');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user_info`
--

CREATE TABLE `tbl_user_info` (
  `userName` varchar(13) NOT NULL,
  `surname` varchar(40) NOT NULL,
  `first_name` varchar(40) NOT NULL,
  `profile` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_user_info`
--

INSERT INTO `tbl_user_info` (`userName`, `surname`, `first_name`, `profile`) VALUES
('50668079', 'Molorane', '\'Makhahliso', 'assets/profiles/50668079.jpg'),
('blessy', 'Nomfundo', 'Mahlalela', 'assets/profiles/blessy.jpg'),
('root', 'Molorane', 'Mothusi', 'assets/profiles/root.jpg'),
('system', 'System', 'Computer', 'assets/img/system.png');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_activity_log`
--
ALTER TABLE `tbl_activity_log`
  ADD PRIMARY KEY (`loggID`),
  ADD KEY `turnonby` (`turnonby`),
  ADD KEY `conn_d_id` (`conn_d_id`),
  ADD KEY `mode` (`modeID`),
  ADD KEY `raID` (`raID`),
  ADD KEY `activity_log_ibfk_5` (`turnoffby`);

--
-- Indexes for table `tbl_alerts`
--
ALTER TABLE `tbl_alerts`
  ADD PRIMARY KEY (`alID`);

--
-- Indexes for table `tbl_appliances`
--
ALTER TABLE `tbl_appliances`
  ADD PRIMARY KEY (`appID`);

--
-- Indexes for table `tbl_application`
--
ALTER TABLE `tbl_application`
  ADD PRIMARY KEY (`appName`);

--
-- Indexes for table `tbl_board`
--
ALTER TABLE `tbl_board`
  ADD PRIMARY KEY (`boardID`);

--
-- Indexes for table `tbl_connected_devices`
--
ALTER TABLE `tbl_connected_devices`
  ADD PRIMARY KEY (`conn_d_id`),
  ADD UNIQUE KEY `boardID` (`boardID`,`PIN`),
  ADD KEY `appID` (`appID`),
  ADD KEY `mode` (`modeID`),
  ADD KEY `portID` (`portID`),
  ADD KEY `locationID` (`locationID`),
  ADD KEY `leveID` (`levelID`);

--
-- Indexes for table `tbl_level`
--
ALTER TABLE `tbl_level`
  ADD PRIMARY KEY (`levelID`);

--
-- Indexes for table `tbl_liveamps`
--
ALTER TABLE `tbl_liveamps`
  ADD PRIMARY KEY (`liveID`);

--
-- Indexes for table `tbl_location`
--
ALTER TABLE `tbl_location`
  ADD PRIMARY KEY (`locationID`);

--
-- Indexes for table `tbl_macros`
--
ALTER TABLE `tbl_macros`
  ADD PRIMARY KEY (`macID`);

--
-- Indexes for table `tbl_macros_list`
--
ALTER TABLE `tbl_macros_list`
  ADD PRIMARY KEY (`macID`,`conn_d_id`),
  ADD KEY `conn_d_id` (`conn_d_id`);

--
-- Indexes for table `tbl_mode`
--
ALTER TABLE `tbl_mode`
  ADD PRIMARY KEY (`modeID`);

--
-- Indexes for table `tbl_motionlights`
--
ALTER TABLE `tbl_motionlights`
  ADD PRIMARY KEY (`pirID`,`conn_d_id`),
  ADD KEY `conn_d_id` (`conn_d_id`);

--
-- Indexes for table `tbl_ports`
--
ALTER TABLE `tbl_ports`
  ADD PRIMARY KEY (`portID`),
  ADD UNIQUE KEY `port` (`port`);

--
-- Indexes for table `tbl_rates`
--
ALTER TABLE `tbl_rates`
  ADD PRIMARY KEY (`raID`);

--
-- Indexes for table `tbl_roles`
--
ALTER TABLE `tbl_roles`
  ADD PRIMARY KEY (`roleID`);

--
-- Indexes for table `tbl_settings`
--
ALTER TABLE `tbl_settings`
  ADD PRIMARY KEY (`stID`);

--
-- Indexes for table `tbl_userpins`
--
ALTER TABLE `tbl_userpins`
  ADD PRIMARY KEY (`userName`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`userName`),
  ADD KEY `roleID` (`roleID`);

--
-- Indexes for table `tbl_user_info`
--
ALTER TABLE `tbl_user_info`
  ADD PRIMARY KEY (`userName`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_activity_log`
--
ALTER TABLE `tbl_activity_log`
  MODIFY `loggID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbl_alerts`
--
ALTER TABLE `tbl_alerts`
  MODIFY `alID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbl_appliances`
--
ALTER TABLE `tbl_appliances`
  MODIFY `appID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
--
-- AUTO_INCREMENT for table `tbl_board`
--
ALTER TABLE `tbl_board`
  MODIFY `boardID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_connected_devices`
--
ALTER TABLE `tbl_connected_devices`
  MODIFY `conn_d_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `tbl_level`
--
ALTER TABLE `tbl_level`
  MODIFY `levelID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `tbl_liveamps`
--
ALTER TABLE `tbl_liveamps`
  MODIFY `liveID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `tbl_location`
--
ALTER TABLE `tbl_location`
  MODIFY `locationID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_macros`
--
ALTER TABLE `tbl_macros`
  MODIFY `macID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `tbl_mode`
--
ALTER TABLE `tbl_mode`
  MODIFY `modeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_ports`
--
ALTER TABLE `tbl_ports`
  MODIFY `portID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;
--
-- AUTO_INCREMENT for table `tbl_rates`
--
ALTER TABLE `tbl_rates`
  MODIFY `raID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tbl_roles`
--
ALTER TABLE `tbl_roles`
  MODIFY `roleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;
--
-- AUTO_INCREMENT for table `tbl_settings`
--
ALTER TABLE `tbl_settings`
  MODIFY `stID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_activity_log`
--
ALTER TABLE `tbl_activity_log`
  ADD CONSTRAINT `tbl_activity_log_ibfk_1` FOREIGN KEY (`turnonby`) REFERENCES `tbl_users` (`userName`),
  ADD CONSTRAINT `tbl_activity_log_ibfk_2` FOREIGN KEY (`conn_d_id`) REFERENCES `tbl_connected_devices` (`conn_d_id`),
  ADD CONSTRAINT `tbl_activity_log_ibfk_3` FOREIGN KEY (`modeID`) REFERENCES `tbl_mode` (`modeID`),
  ADD CONSTRAINT `tbl_activity_log_ibfk_4` FOREIGN KEY (`raID`) REFERENCES `tbl_rates` (`raID`),
  ADD CONSTRAINT `tbl_activity_log_ibfk_5` FOREIGN KEY (`turnoffby`) REFERENCES `tbl_users` (`userName`);

--
-- Constraints for table `tbl_connected_devices`
--
ALTER TABLE `tbl_connected_devices`
  ADD CONSTRAINT `tbl_connected_devices_ibfk_1` FOREIGN KEY (`appID`) REFERENCES `tbl_appliances` (`appID`),
  ADD CONSTRAINT `tbl_connected_devices_ibfk_3` FOREIGN KEY (`modeID`) REFERENCES `tbl_mode` (`modeID`),
  ADD CONSTRAINT `tbl_connected_devices_ibfk_5` FOREIGN KEY (`locationID`) REFERENCES `tbl_location` (`locationID`),
  ADD CONSTRAINT `tbl_connected_devices_ibfk_6` FOREIGN KEY (`levelID`) REFERENCES `tbl_level` (`levelID`),
  ADD CONSTRAINT `tbl_connected_devices_ibfk_7` FOREIGN KEY (`boardID`) REFERENCES `tbl_board` (`boardID`);

--
-- Constraints for table `tbl_macros_list`
--
ALTER TABLE `tbl_macros_list`
  ADD CONSTRAINT `tbl_macros_list_ibfk_1` FOREIGN KEY (`macID`) REFERENCES `tbl_macros` (`macID`),
  ADD CONSTRAINT `tbl_macros_list_ibfk_2` FOREIGN KEY (`conn_d_id`) REFERENCES `tbl_connected_devices` (`conn_d_id`);

--
-- Constraints for table `tbl_motionlights`
--
ALTER TABLE `tbl_motionlights`
  ADD CONSTRAINT `tbl_motionlights_ibfk_1` FOREIGN KEY (`pirID`) REFERENCES `tbl_connected_devices` (`conn_d_id`),
  ADD CONSTRAINT `tbl_motionlights_ibfk_2` FOREIGN KEY (`conn_d_id`) REFERENCES `tbl_connected_devices` (`conn_d_id`);

--
-- Constraints for table `tbl_userpins`
--
ALTER TABLE `tbl_userpins`
  ADD CONSTRAINT `tbl_userpins_ibfk_1` FOREIGN KEY (`userName`) REFERENCES `tbl_users` (`userName`);

--
-- Constraints for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD CONSTRAINT `tbl_users_ibfk_1` FOREIGN KEY (`roleID`) REFERENCES `tbl_roles` (`roleID`);

--
-- Constraints for table `tbl_user_info`
--
ALTER TABLE `tbl_user_info`
  ADD CONSTRAINT `tbl_user_info_ibfk_1` FOREIGN KEY (`userName`) REFERENCES `tbl_users` (`userName`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
