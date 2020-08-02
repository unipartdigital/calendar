/*
 * Database Client Schema
 *
 * Forked and Currently maintained by Gene
 *
 * @version @package_version@
 * @author Gene Hawkins <texxasrulez@yahoo.com>
 * @website <https://www.genesworld.net>
 *
 * Original Author Credits
 * @version @package_version@
 * @author Daniel Morlock <daniel.morlock@awesome-it.de>
 *
 * Copyright (C) Awesome IT GbR <info@awesome-it.de>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

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
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

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
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

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
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

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
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE INDEX uid_idx ON itipinvitations (user_id,event_uid);

REPLACE INTO dbms_scheduler.create_job(job_name => '_job', job_type => 'EXECUTABLE', job_action => (, enabled => true)name, value) SELECT  'tx-database-calendar-version', '2020080200'  FROM dual;
