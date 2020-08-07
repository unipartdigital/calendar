/*
 * Roundcube CalDav Calendar Schema
 *
 * @author Gene Hawkins <texxasrulez@yahoo.com>
 *
 * @licence GNU AGPL
 */

CREATE TABLE calendar_oauth_states (
  provider varchar2(255) NOT NULL,
  client_config_id varchar2(255) NOT NULL,
  user_id varchar2(255) NOT NULL,
  scope varchar2(255) NOT NULL,
  issue_time NUMBER(10) NOT NULL,
  state varchar2(255) NOT NULL,
  UNIQUE (provider(50), `client_config_id`(50), `user_id`(50), `scope`(50)),
  PRIMARY KEY (state)
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

CREATE TABLE calendar_oauth_access_tokens (
  provider varchar2(255) NOT NULL,
  client_config_id varchar2(255) NOT NULL,
  user_id varchar2(255) NOT NULL,
  scope varchar2(255) NOT NULL,
  issue_time NUMBER(10) NOT NULL,
  access_token varchar2(255) NOT NULL,
  token_type varchar2(255) NOT NULL,
  expires_in NUMBER(10) DEFAULT NULL,
  UNIQUE (provider(50), `client_config_id`(50), `user_id`(50), `scope`(50))
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

CREATE TABLE calendar_oauth_refresh_tokens (
  provider varchar2(255) NOT NULL,
  client_config_id varchar2(255) NOT NULL,
  user_id varchar2(255) NOT NULL,
  scope varchar2(255) NOT NULL,
  issue_time NUMBER(10) NOT NULL,
  refresh_token varchar2(255) DEFAULT NULL,
  UNIQUE (provider(50), `client_config_id`(50), `user_id`(50), `scope`(50))
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;CREATE TABLE caldav_calendars (
  calendar_id number(10) CHECK (calendar_id > 0) NOT NULL,
  user_id number(10) DEFAULT '0' CHECK (user_id > 0) NOT NULL,
  name varchar2(255) NOT NULL,
  color varchar2(8) NOT NULL,
  showalarms number(3) DEFAULT '1' NOT NULL,
  caldav_url varchar2(1000) DEFAULT NULL,
  caldav_tag raw(32) DEFAULT NULL,
  caldav_user varchar2(1000) DEFAULT NULL,
  caldav_pass varchar2(1000) DEFAULT NULL,
  caldav_oauth_provider raw(200) DEFAULT NULL,
  readonly number(10) DEFAULT '0' NOT NULL,
  caldav_last_change timestamp(0) DEFAULT SYSTIMESTAMP NOT NULL,

  PRIMARY KEY(calendar_id)
 ,
  CONSTRAINT fk_caldav_calendars_user_id FOREIGN KEY (user_id)
  REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

-- Generate ID using sequence and trigger
CREATE SEQUENCE caldav_calendars_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER caldav_calendars_seq_tr
 BEFORE INSERT ON caldav_calendars FOR EACH ROW
 WHEN (NEW.calendar_id IS NULL)
BEGIN
 SELECT caldav_calendars_seq.NEXTVAL INTO :NEW.calendar_id FROM DUAL;
END;
/

CREATE INDEX caldav_user_name_idx ON caldav_calendars (user_id, name);

CREATE TABLE caldav_events (
  event_id number(10) CHECK (event_id > 0) NOT NULL,
  calendar_id number(10) DEFAULT '0' CHECK (calendar_id > 0) NOT NULL,
  recurrence_id number(10) DEFAULT '0' CHECK (recurrence_id > 0) NOT NULL,
  uid varchar2(255) DEFAULT '' NOT NULL,
  instance varchar2(16) DEFAULT '' NOT NULL,
  isexception number(3) DEFAULT '0' NOT NULL,
  created timestamp(0) DEFAULT TO_TIMESTAMP('1000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') NOT NULL,
  changed timestamp(0) DEFAULT TO_TIMESTAMP('1000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') NOT NULL,
  sequence number(10) DEFAULT '0' CHECK (sequence > 0) NOT NULL,
  start timestamp(0) DEFAULT TO_TIMESTAMP('1000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') NOT NULL,
  end timestamp(0) DEFAULT TO_TIMESTAMP('1000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') NOT NULL,
  recurrence varchar2(255) DEFAULT NULL,
  title raw(128) NOT NULL,
  description raw(2048) NOT NULL,
  location raw(128) DEFAULT '' NOT NULL,
  categories raw(128) DEFAULT '' NOT NULL,
  url varchar2(1000) DEFAULT '' NOT NULL,
  all_day number(3) DEFAULT '0' NOT NULL,
  free_busy number(3) DEFAULT '0' NOT NULL,
  priority number(3) DEFAULT '0' NOT NULL,
  sensitivity number(3) DEFAULT '0' NOT NULL,
  status varchar2(32) DEFAULT '' NOT NULL,
  alarms clob DEFAULT NULL NULL,
  attendees clob DEFAULT NULL,
  notifyat timestamp(0) DEFAULT NULL,
  caldav_url varchar2(1000) NOT NULL,
  caldav_tag varchar2(255) NOT NULL,
  caldav_last_change timestamp(0) DEFAULT SYSTIMESTAMP NOT NULL,

  PRIMARY KEY(event_id)
 ,
  CONSTRAINT fk_caldav_events_calendar_id FOREIGN KEY (calendar_id)
  REFERENCES caldav_calendars(calendar_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

-- Generate ID using sequence and trigger
CREATE SEQUENCE caldav_events_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER caldav_events_seq_tr
 BEFORE INSERT ON caldav_events FOR EACH ROW
 WHEN (NEW.event_id IS NULL)
BEGIN
 SELECT caldav_events_seq.NEXTVAL INTO :NEW.event_id FROM DUAL;
END;
/

CREATE INDEX caldav_uid_idx ON caldav_events (uid);
CREATE INDEX caldav_recurrence_idx ON caldav_events (recurrence_id);
CREATE INDEX caldav_calendar_notify_idx ON caldav_events (calendar_id,notifyat);

CREATE TABLE caldav_attachments (
  attachment_id number(10) CHECK (attachment_id > 0) NOT NULL,
  event_id number(10) DEFAULT '0' CHECK (event_id > 0) NOT NULL,
  filename varchar2(255) DEFAULT '' NOT NULL,
  mimetype varchar2(255) DEFAULT '' NOT NULL,
  size number(10) DEFAULT '0' NOT NULL,
  data BLOB,
  
  PRIMARY KEY(attachment_id),
  CONSTRAINT fk_caldav_attachments_event_id FOREIGN KEY (event_id)
  REFERENCES caldav_events(event_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

-- Generate ID using sequence and trigger
CREATE SEQUENCE caldav_attachments_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER caldav_attachments_seq_tr
 BEFORE INSERT ON caldav_attachments FOR EACH ROW
 WHEN (NEW.attachment_id IS NULL)
BEGIN
 SELECT caldav_attachments_seq.NEXTVAL INTO :NEW.attachment_id FROM DUAL;
END;
/
CREATE TABLE database_calendars (
  calendar_id number(10) CHECK (calendar_id > 0) NOT NULL,
  user_id number(10) DEFAULT '0' CHECK (user_id > 0) NOT NULL,
  name varchar2(255) NOT NULL,
  color varchar2(8) NOT NULL,
  showalarms number(3) DEFAULT '1' NOT NULL,
  PRIMARY KEY(calendar_id)
 ,
  CONSTRAINT fk_calendars_user_id FOREIGN KEY (user_id)
    REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

-- Generate ID using sequence and trigger
CREATE SEQUENCE database_calendars_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER database_calendars_seq_tr
 BEFORE INSERT ON database_calendars FOR EACH ROW
 WHEN (NEW.calendar_id IS NULL)
BEGIN
 SELECT database_calendars_seq.NEXTVAL INTO :NEW.calendar_id FROM DUAL;
END;
/

CREATE INDEX user_name_idx ON database_calendars (user_id, name);

CREATE TABLE database_events (
  event_id number(10) CHECK (event_id > 0) NOT NULL,
  calendar_id number(10) DEFAULT '0' CHECK (calendar_id > 0) NOT NULL,
  recurrence_id number(10) DEFAULT '0' CHECK (recurrence_id > 0) NOT NULL,
  uid varchar2(255) DEFAULT '' NOT NULL,
  instance varchar2(16) DEFAULT '' NOT NULL,
  isexception number(3) DEFAULT '0' NOT NULL,
  created timestamp(0) DEFAULT TO_TIMESTAMP('1000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') NOT NULL,
  changed timestamp(0) DEFAULT TO_TIMESTAMP('1000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') NOT NULL,
  sequence number(10) DEFAULT '0' CHECK (sequence > 0) NOT NULL,
  start timestamp(0) DEFAULT TO_TIMESTAMP('1000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') NOT NULL,
  end timestamp(0) DEFAULT TO_TIMESTAMP('1000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') NOT NULL,
  recurrence varchar2(255) DEFAULT NULL,
  title varchar2(255) NOT NULL,
  description clob NOT NULL,
  location varchar2(255) DEFAULT '' NOT NULL,
  categories varchar2(255) DEFAULT '' NOT NULL,
  url varchar2(255) DEFAULT '' NOT NULL,
  all_day number(3) DEFAULT '0' NOT NULL,
  free_busy number(3) DEFAULT '0' NOT NULL,
  priority number(3) DEFAULT '0' NOT NULL,
  sensitivity number(3) DEFAULT '0' NOT NULL,
  status varchar2(32) DEFAULT '' NOT NULL,
  alarms clob DEFAULT NULL,
  attendees clob DEFAULT NULL,
  notifyat timestamp(0) DEFAULT NULL,
  PRIMARY KEY(event_id)
 ,
  CONSTRAINT fk_events_calendar_id FOREIGN KEY (calendar_id)
    REFERENCES database_calendars(calendar_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

-- Generate ID using sequence and trigger
CREATE SEQUENCE database_events_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER database_events_seq_tr
 BEFORE INSERT ON database_events FOR EACH ROW
 WHEN (NEW.event_id IS NULL)
BEGIN
 SELECT database_events_seq.NEXTVAL INTO :NEW.event_id FROM DUAL;
END;
/

CREATE INDEX uid_idx ON database_events (uid);
CREATE INDEX recurrence_idx ON database_events (recurrence_id);
CREATE INDEX calendar_notify_idx ON database_events (calendar_id,notifyat);

CREATE TABLE database_attachments (
  attachment_id number(10) CHECK (attachment_id > 0) NOT NULL,
  event_id number(10) DEFAULT '0' CHECK (event_id > 0) NOT NULL,
  filename varchar2(255) DEFAULT '' NOT NULL,
  mimetype varchar2(255) DEFAULT '' NOT NULL,
  size number(10) DEFAULT '0' NOT NULL,
  data clob NOT NULL,
  PRIMARY KEY(attachment_id),
  CONSTRAINT fk_attachments_event_id FOREIGN KEY (event_id)
    REFERENCES database_events(event_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

-- Generate ID using sequence and trigger
CREATE SEQUENCE database_attachments_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER database_attachments_seq_tr
 BEFORE INSERT ON database_attachments FOR EACH ROW
 WHEN (NEW.attachment_id IS NULL)
BEGIN
 SELECT database_attachments_seq.NEXTVAL INTO :NEW.attachment_id FROM DUAL;
END;
/

CREATE TABLE itipinvitations (
  token VARCHAR2(64) NOT NULL,
  event_uid VARCHAR2(255) NOT NULL,
  user_id number(10) DEFAULT '0' CHECK (user_id > 0) NOT NULL,
  event CLOB NOT NULL,
  expires TIMESTAMP(0) DEFAULT NULL,
  cancelled NUMBER(3) DEFAULT '0' CHECK (cancelled > 0) NOT NULL,
  PRIMARY KEY(token)
 ,
  CONSTRAINT fk_itipinvitations_user_id FOREIGN KEY (user_id)
    REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

CREATE INDEX uid_idx ON itipinvitations (user_id,event_uid);
CREATE TABLE ical_calendars (
  calendar_id number(10) CHECK (calendar_id > 0) NOT NULL,
  user_id number(10) DEFAULT '0' CHECK (user_id > 0) NOT NULL,
  name varchar2(255) NOT NULL,
  color varchar2(8) NOT NULL,
  showalarms number(3) DEFAULT '1' NOT NULL,

  ical_url varchar2(1000) NOT NULL,
  ical_user varchar2(255) DEFAULT NULL,
  ical_pass varchar2(1024) DEFAULT NULL,
  ical_last_change timestamp(0) DEFAULT SYSTIMESTAMP NOT NULL,

  PRIMARY KEY(calendar_id)
 ,
  CONSTRAINT fk_ical_calendars_user_id FOREIGN KEY (user_id)
  REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

-- Generate ID using sequence and trigger
CREATE SEQUENCE ical_calendars_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER ical_calendars_seq_tr
 BEFORE INSERT ON ical_calendars FOR EACH ROW
 WHEN (NEW.calendar_id IS NULL)
BEGIN
 SELECT ical_calendars_seq.NEXTVAL INTO :NEW.calendar_id FROM DUAL;
END;
/

CREATE INDEX ical_user_name_idx ON ical_calendars (user_id, name);

CREATE TABLE ical_events (
  event_id number(10) CHECK (event_id > 0) NOT NULL,
  calendar_id number(10) DEFAULT '0' CHECK (calendar_id > 0) NOT NULL,
  recurrence_id number(10) DEFAULT '0' CHECK (recurrence_id > 0) NOT NULL,
  uid varchar2(255) DEFAULT '' NOT NULL,
  instance varchar2(16) DEFAULT '' NOT NULL,
  isexception number(3) DEFAULT '0' NOT NULL,
  created timestamp(0) DEFAULT TO_TIMESTAMP('1000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') NOT NULL,
  changed timestamp(0) DEFAULT TO_TIMESTAMP('1000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') NOT NULL,
  sequence number(10) DEFAULT '0' CHECK (sequence > 0) NOT NULL,
  start timestamp(0) DEFAULT TO_TIMESTAMP('1000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') NOT NULL,
  end timestamp(0) DEFAULT TO_TIMESTAMP('1000-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS.FF') NOT NULL,
  recurrence varchar2(255) DEFAULT NULL,
  title raw(128) NOT NULL,
  description raw(2048) NOT NULL,
  location raw(128) DEFAULT '' NOT NULL,
  categories raw(128) DEFAULT '' NOT NULL,
  url varchar2(1000) DEFAULT '' NOT NULL,
  all_day number(3) DEFAULT '0' NOT NULL,
  free_busy number(3) DEFAULT '0' NOT NULL,
  priority number(3) DEFAULT '0' NOT NULL,
  sensitivity number(3) DEFAULT '0' NOT NULL,
  status varchar2(32) DEFAULT '' NOT NULL,
  alarms clob DEFAULT NULL NULL,
  attendees clob DEFAULT NULL,
  notifyat timestamp(0) DEFAULT NULL,

  ical_url varchar2(1000) NOT NULL,
  ical_last_change timestamp(0) DEFAULT SYSTIMESTAMP NOT NULL,

  PRIMARY KEY(event_id)
 ,
  CONSTRAINT fk_ical_events_calendar_id FOREIGN KEY (calendar_id)
  REFERENCES ical_calendars(calendar_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

-- Generate ID using sequence and trigger
CREATE SEQUENCE ical_events_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER ical_events_seq_tr
 BEFORE INSERT ON ical_events FOR EACH ROW
 WHEN (NEW.event_id IS NULL)
BEGIN
 SELECT ical_events_seq.NEXTVAL INTO :NEW.event_id FROM DUAL;
END;
/

CREATE INDEX ical_uid_idx ON ical_events (uid);
CREATE INDEX ical_recurrence_idx ON ical_events (recurrence_id);
CREATE INDEX ical_calendar_notify_idx ON ical_events (calendar_id,notifyat);

CREATE TABLE ical_attachments (
  attachment_id number(10) CHECK (attachment_id > 0) NOT NULL,
  event_id number(10) DEFAULT '0' CHECK (event_id > 0) NOT NULL,
  filename varchar2(255) DEFAULT '' NOT NULL,
  mimetype varchar2(255) DEFAULT '' NOT NULL,
  size number(10) DEFAULT '0' NOT NULL,
  data clob NOT NULL,
  PRIMARY KEY(attachment_id),
  CONSTRAINT fk_ical_attachments_event_id FOREIGN KEY (event_id)
  REFERENCES ical_events(event_id) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

-- Generate ID using sequence and trigger
CREATE SEQUENCE ical_attachments_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER ical_attachments_seq_tr
 BEFORE INSERT ON ical_attachments FOR EACH ROW
 WHEN (NEW.attachment_id IS NULL)
BEGIN
 SELECT ical_attachments_seq.NEXTVAL INTO :NEW.attachment_id FROM DUAL;
END;
/

REPLACE INTO `system` (name, value) SELECT  'tx-calendar-version', '2020080100'  FROM dual;
