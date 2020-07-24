CREATE TABLE IF NOT EXISTS caldav_calendars (
  calendar_id INTEGER UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  synctoken INTEGER UNSIGNED NOT NULL DEFAULT '1',
  components VARBINARY(21),
  user_id INT(10) UNSIGNED NOT NULL DEFAULT '0',
  name VARCHAR(255) NOT NULL,
  color VARCHAR(8) NOT NULL,
  timezone TEXT,
  transparent TINYINT(1) NOT NULL DEFAULT '0',
  showalarms TINYINT(1) NOT NULL DEFAULT '1',

  caldav_url VARBINARY(512) DEFAULT NULL,
  caldav_tag VARBINARY(128) DEFAULT NULL,
  caldav_user VARBINARY(50) DEFAULT NULL,
  caldav_pass VARBINARY(255) DEFAULT NULL,
  caldav_oauth_provider VARBINARY(200) DEFAULT NULL,
  readonly INT NOT NULL DEFAULT '0',
  caldav_last_change timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX caldav_user_name_idx (user_id, name),
  CONSTRAINT fk_caldav_calendars_user_id FOREIGN KEY (user_id)
  REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 */;

CREATE TABLE IF NOT EXISTS caldav_events (
  event_id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  calendar_id INT(11) UNSIGNED NOT NULL DEFAULT '0',
  lastmodified INT(11) UNSIGNED,
  etag VARBINARY(32),
  size INT(11) NOT NULL DEFAULT '0',
  componenttype VARBINARY(8),
  firstoccurence INT(11) UNSIGNED,
  lastoccurence INT(11) UNSIGNED,
  recurrence_id INT(11) UNSIGNED NOT NULL DEFAULT '0',
  uid VARCHAR(255) NOT NULL DEFAULT '',
  instance VARCHAR(16) NOT NULL DEFAULT '',
  isexception TINYINT(1) NOT NULL DEFAULT '0',
  created timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  changed timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  sequence INT(1) UNSIGNED NOT NULL DEFAULT '0',
  start timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  end timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  recurrence VARCHAR(255) NOT NULL,
  title VARBINARY(128) NOT NULL,
  description VARBINARY(2048) NOT NULL,
  location VARCHAR(255) NOT NULL DEFAULT '',
  categories VARCHAR(255) NOT NULL DEFAULT '',
  url VARBINARY(2048) NOT NULL DEFAULT '',
  all_day TINYINT(1) NOT NULL DEFAULT '0',
  free_busy TINYINT(1) NOT NULL DEFAULT '0',
  priority TINYINT(1) NOT NULL DEFAULT '0',
  sensitivity TINYINT(1) NOT NULL DEFAULT '0',
  status VARCHAR(32) NOT NULL DEFAULT '',
  alarms text NULL DEFAULT NULL,
  attendees text DEFAULT NULL,
  notifyat datetime DEFAULT NULL,

  caldav_url VARBINARY(512) NOT NULL,
  caldav_tag VARBINARY(128),
  caldav_last_change timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY(event_id),
  INDEX caldav_uid_idx (uid),
  INDEX caldav_recurrence_idx (recurrence_id),
  INDEX caldav_calendar_notify_idx (calendar_id,notifyat),
  CONSTRAINT fk_caldav_events_calendar_id FOREIGN KEY (calendar_id)
  REFERENCES caldav_calendars(calendar_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 */;

CREATE TABLE IF NOT EXISTS caldav_attachments (
  attachment_id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  event_id INT(11) UNSIGNED NOT NULL DEFAULT '0',
  filename VARCHAR(255) NOT NULL DEFAULT '',
  mimetype VARCHAR(255) NOT NULL DEFAULT '',
  size INT(11) NOT NULL DEFAULT '0',
  data MEDIUMBLOB,
  
  PRIMARY KEY(attachment_id),
  CONSTRAINT fk_caldav_attachments_event_id FOREIGN KEY (event_id)
  REFERENCES caldav_events(event_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 */;

CREATE TABLE IF NOT EXISTS caldav_propertystorage (
    property_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    path VARBINARY(1024) NOT NULL,
    name VARBINARY(100) NOT NULL,
    valuetype INT UNSIGNED,
    value MEDIUMBLOB,
	
	PRIMARY KEY(property_id)
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 */;

CREATE UNIQUE INDEX path_property ON caldav_propertystorage (path(600), name(100));

REPLACE INTO system (name, value) VALUES ('texxasrulez-caldav-version', '2020072002');
