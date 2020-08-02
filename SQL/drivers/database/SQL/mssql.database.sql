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
  [calendar_id] int CHECK ([calendar_id] > 0) NOT NULL IDENTITY,
  [user_id] int CHECK ([user_id] > 0) NOT NULL DEFAULT '0',
  [name] varchar(255) NOT NULL,
  [color] varchar(8) NOT NULL,
  [showalarms] smallint NOT NULL DEFAULT '1',
  PRIMARY KEY([calendar_id])
 ,
  CONSTRAINT [fk_calendars_user_id] FOREIGN KEY ([user_id])
    REFERENCES users([user_id]) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE INDEX [user_name_idx] ON database_calendars ([user_id], [name]);

CREATE TABLE database_events (
  [event_id] int CHECK ([event_id] > 0) NOT NULL IDENTITY,
  [calendar_id] int CHECK ([calendar_id] > 0) NOT NULL DEFAULT '0',
  [recurrence_id] int CHECK ([recurrence_id] > 0) NOT NULL DEFAULT '0',
  [uid] varchar(255) NOT NULL DEFAULT '',
  [instance] varchar(16) NOT NULL DEFAULT '',
  [isexception] smallint NOT NULL DEFAULT '0',
  [created] datetime2(0) NOT NULL DEFAULT '1000-01-01 00:00:00',
  [changed] datetime2(0) NOT NULL DEFAULT '1000-01-01 00:00:00',
  [sequence] int CHECK ([sequence] > 0) NOT NULL DEFAULT '0',
  [start] datetime2(0) NOT NULL DEFAULT '1000-01-01 00:00:00',
  [end] datetime2(0) NOT NULL DEFAULT '1000-01-01 00:00:00',
  [recurrence] varchar(255) DEFAULT NULL,
  [title] varchar(255) NOT NULL,
  [description] varchar(max) NOT NULL,
  [location] varchar(255) NOT NULL DEFAULT '',
  [categories] varchar(255) NOT NULL DEFAULT '',
  [url] varchar(255) NOT NULL DEFAULT '',
  [all_day] smallint NOT NULL DEFAULT '0',
  [free_busy] smallint NOT NULL DEFAULT '0',
  [priority] smallint NOT NULL DEFAULT '0',
  [sensitivity] smallint NOT NULL DEFAULT '0',
  [status] varchar(32) NOT NULL DEFAULT '',
  [alarms] varchar(max) DEFAULT NULL,
  [attendees] varchar(max) DEFAULT NULL,
  [notifyat] datetime2(0) DEFAULT NULL,
  PRIMARY KEY([event_id])
 ,
  CONSTRAINT [fk_events_calendar_id] FOREIGN KEY ([calendar_id])
    REFERENCES database_calendars([calendar_id]) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE INDEX [uid_idx] ON database_events ([uid]);
CREATE INDEX [recurrence_idx] ON database_events ([recurrence_id]);
CREATE INDEX [calendar_notify_idx] ON database_events ([calendar_id],[notifyat]);

CREATE TABLE database_attachments (
  [attachment_id] int CHECK ([attachment_id] > 0) NOT NULL IDENTITY,
  [event_id] int CHECK ([event_id] > 0) NOT NULL DEFAULT '0',
  [filename] varchar(255) NOT NULL DEFAULT '',
  [mimetype] varchar(255) NOT NULL DEFAULT '',
  [size] int NOT NULL DEFAULT '0',
  [data] varchar(max) NOT NULL,
  PRIMARY KEY([attachment_id]),
  CONSTRAINT [fk_attachments_event_id] FOREIGN KEY ([event_id])
    REFERENCES database_events([event_id]) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE TABLE itipinvitations (
  [token] VARCHAR(64) NOT NULL,
  [event_uid] VARCHAR(255) NOT NULL,
  [user_id] int CHECK ([user_id] > 0) NOT NULL DEFAULT '0',
  [event] VARCHAR(max) NOT NULL,
  [expires] DATETIME2(0) DEFAULT NULL,
  [cancelled] SMALLINT CHECK ([cancelled] > 0) NOT NULL DEFAULT '0',
  PRIMARY KEY([token])
 ,
  CONSTRAINT [fk_itipinvitations_user_id] FOREIGN KEY ([user_id])
    REFERENCES users([user_id]) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE INDEX [uid_idx] ON itipinvitations ([user_id],[event_uid]);

REPLACE INTO system (name, value) SELECT ('tx-database-calendar-version', '2020080200');
