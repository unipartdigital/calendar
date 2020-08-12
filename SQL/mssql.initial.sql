/*
 * Roundcube Database, CalDav & iCal Calendar Schema
 *
 * @author Gene Hawkins <texxasrulez@yahoo.com>
 *
 * @licence GNU AGPL
 */

CREATE TABLE calendar_oauth_states (
  [provider] varchar(255) NOT NULL,
  [client_config_id] varchar(255) NOT NULL,
  [user_id] varchar(255) NOT NULL,
  [scope] varchar(255) NOT NULL,
  [issue_time] INTEGER NOT NULL,
  [state] varchar(255) NOT NULL,
  
  UNIQUE ([provider](50), `client_config_id`(50), `user_id`(50), `scope`(50)),
  PRIMARY KEY ([state])
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

CREATE TABLE calendar_oauth_access_tokens (
  [provider] varchar(255) NOT NULL,
  [client_config_id] varchar(255) NOT NULL,
  [user_id] varchar(255) NOT NULL,
  [scope] varchar(255) NOT NULL,
  [issue_time] INTEGER NOT NULL,
  [access_token] varchar(255) NOT NULL,
  [token_type] varchar(255) NOT NULL,
  [expires_in] INTEGER DEFAULT NULL,
  
  UNIQUE ([provider](50), `client_config_id`(50), `user_id`(50), `scope`(50))
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

CREATE TABLE calendar_oauth_refresh_tokens (
  [provider] varchar(255) NOT NULL,
  [client_config_id] varchar(255) NOT NULL,
  [user_id] varchar(255) NOT NULL,
  [scope] varchar(255) NOT NULL,
  [issue_time] INTEGER NOT NULL,
  [refresh_token] varchar(255) DEFAULT NULL,
  
  UNIQUE ([provider](50), `client_config_id`(50), `user_id`(50), `scope`(50))
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

CREATE TABLE caldav_calendars (
  [calendar_id] int CHECK ([calendar_id] > 0) NOT NULL IDENTITY,
  [user_id] int CHECK ([user_id] > 0) NOT NULL DEFAULT '0',
  [name] varchar(255) NOT NULL,
  [color] varchar(8) NOT NULL,
  [showalarms] smallint NOT NULL DEFAULT '1',
  [caldav_url] varchar(1000) DEFAULT NULL,
  [caldav_tag] varchar(32) NULL DEFAULT 'COLLATE',
  [caldav_user] varchar(1000) DEFAULT NULL,
  [caldav_pass] varchar(1000) DEFAULT NULL,
  [caldav_oauth_provider] varbinary(200) DEFAULT NULL,
  [readonly] int NOT NULL DEFAULT '0',
  [caldav_last_change] datetime2(0) NOT NULL DEFAULT GETDATE(),

  PRIMARY KEY([calendar_id]),
  CONSTRAINT [fk_caldav_calendars_user_id] FOREIGN KEY ([user_id])
  REFERENCES users([user_id]) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

CREATE INDEX [caldav_user_name_idx] ON caldav_calendars ([user_id], [name]);

CREATE TABLE caldav_events (
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
  [title] varbinary(128) NOT NULL,
  [description] varbinary(2048) NOT NULL,
  [location] varbinary(128) NOT NULL DEFAULT '',
  [categories] varbinary(128) NOT NULL DEFAULT '',
  [url] varchar(1000) NOT NULL DEFAULT '',
  [all_day] smallint NOT NULL DEFAULT '0',
  [free_busy] smallint NOT NULL DEFAULT '0',
  [priority] smallint NOT NULL DEFAULT '0',
  [sensitivity] smallint NOT NULL DEFAULT '0',
  [status] varchar(32) NOT NULL DEFAULT '',
  [alarms] varchar(max) NULL DEFAULT NULL,
  [attendees] varchar(max) DEFAULT NULL,
  [notifyat] datetime2(0) DEFAULT NULL,
  [caldav_url] varchar(1000) NOT NULL,
  [caldav_tag] varchar(32) NULL DEFAULT 'COLLATE',
  [caldav_last_change] datetime2(0) NOT NULL DEFAULT GETDATE(),

  PRIMARY KEY([event_id]),
  CONSTRAINT [fk_caldav_events_calendar_id] FOREIGN KEY ([calendar_id])
  REFERENCES caldav_calendars([calendar_id]) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

CREATE INDEX [caldav_uid_idx] ON caldav_events ([uid]);
CREATE INDEX [caldav_recurrence_idx] ON caldav_events ([recurrence_id]);
CREATE INDEX [caldav_calendar_notify_idx] ON caldav_events ([calendar_id],[notifyat]);

CREATE TABLE caldav_attachments (
  [attachment_id] int CHECK ([attachment_id] > 0) NOT NULL IDENTITY,
  [event_id] int CHECK ([event_id] > 0) NOT NULL DEFAULT '0',
  [filename] varchar(255) NOT NULL DEFAULT '',
  [mimetype] varchar(255) NOT NULL DEFAULT '',
  [size] int NOT NULL DEFAULT '0',
  [data] VARBINARY(max),
  
  PRIMARY KEY([attachment_id]),
  CONSTRAINT [fk_caldav_attachments_event_id] FOREIGN KEY ([event_id])
  REFERENCES caldav_events([event_id]) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

CREATE TABLE database_calendars (
  [calendar_id] int CHECK ([calendar_id] > 0) NOT NULL IDENTITY,
  [user_id] int CHECK ([user_id] > 0) NOT NULL DEFAULT '0',
  [name] varchar(255) NOT NULL,
  [color] varchar(8) NOT NULL,
  [showalarms] smallint NOT NULL DEFAULT '1',
  
  PRIMARY KEY([calendar_id]),
  CONSTRAINT [fk_calendars_user_id] FOREIGN KEY ([user_id])
    REFERENCES users([user_id]) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

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
  
  PRIMARY KEY([event_id]),
  CONSTRAINT [fk_events_calendar_id] FOREIGN KEY ([calendar_id])
    REFERENCES database_calendars([calendar_id]) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

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
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

CREATE TABLE itipinvitations (
  [token] VARCHAR(64) NOT NULL,
  [event_uid] VARCHAR(255) NOT NULL,
  [user_id] int CHECK ([user_id] > 0) NOT NULL DEFAULT '0',
  [event] VARCHAR(max) NOT NULL,
  [expires] DATETIME2(0) DEFAULT NULL,
  [cancelled] SMALLINT CHECK ([cancelled] > 0) NOT NULL DEFAULT '0',
  
  PRIMARY KEY([token]),
  CONSTRAINT [fk_itipinvitations_user_id] FOREIGN KEY ([user_id])
    REFERENCES users([user_id]) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

CREATE INDEX [uid_idx] ON itipinvitations ([user_id],[event_uid]);

CREATE TABLE ical_calendars (
  [calendar_id] int CHECK ([calendar_id] > 0) NOT NULL IDENTITY,
  [user_id] int CHECK ([user_id] > 0) NOT NULL DEFAULT '0',
  [name] varchar(255) NOT NULL,
  [color] varchar(8) NOT NULL,
  [showalarms] smallint NOT NULL DEFAULT '1',
  [ical_url] varchar(1000) NOT NULL,
  [ical_user] varchar(255) DEFAULT NULL,
  [ical_pass] varchar(1024) DEFAULT NULL,
  [ical_last_change] datetime2(0) NOT NULL DEFAULT GETDATE(),

  PRIMARY KEY([calendar_id]),
  CONSTRAINT [fk_ical_calendars_user_id] FOREIGN KEY ([user_id])
  REFERENCES users([user_id]) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

CREATE INDEX [ical_user_name_idx] ON ical_calendars ([user_id], [name]);

CREATE TABLE ical_events (
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
  [title] varbinary(128) NOT NULL,
  [description] varbinary(2048) NOT NULL,
  [location] varbinary(128) NOT NULL DEFAULT '',
  [categories] varbinary(128) NOT NULL DEFAULT '',
  [url] varchar(1000) NOT NULL DEFAULT '',
  [all_day] smallint NOT NULL DEFAULT '0',
  [free_busy] smallint NOT NULL DEFAULT '0',
  [priority] smallint NOT NULL DEFAULT '0',
  [sensitivity] smallint NOT NULL DEFAULT '0',
  [status] varchar(32) NOT NULL DEFAULT '',
  [alarms] varchar(max) NULL DEFAULT NULL,
  [attendees] varchar(max) DEFAULT NULL,
  [notifyat] datetime2(0) DEFAULT NULL,
  [ical_url] varchar(1000) NOT NULL,
  [ical_last_change] datetime2(0) NOT NULL DEFAULT GETDATE(),

  PRIMARY KEY([event_id]),
  CONSTRAINT [fk_ical_events_calendar_id] FOREIGN KEY ([calendar_id])
  REFERENCES ical_calendars([calendar_id]) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

CREATE INDEX [ical_uid_idx] ON ical_events ([uid]);
CREATE INDEX [ical_recurrence_idx] ON ical_events ([recurrence_id]);
CREATE INDEX [ical_calendar_notify_idx] ON ical_events ([calendar_id],[notifyat]);

CREATE TABLE ical_attachments (
  [attachment_id] int CHECK ([attachment_id] > 0) NOT NULL IDENTITY,
  [event_id] int CHECK ([event_id] > 0) NOT NULL DEFAULT '0',
  [filename] varchar(255) NOT NULL DEFAULT '',
  [mimetype] varchar(255) NOT NULL DEFAULT '',
  [size] int NOT NULL DEFAULT '0',
  [data] varchar(max) NOT NULL,
  
  PRIMARY KEY([attachment_id]),
  CONSTRAINT [fk_ical_attachments_event_id] FOREIGN KEY ([event_id])
  REFERENCES ical_events([event_id]) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

REPLACE INTO `system` ([name], [value]) SELECT ('calendar-version', '2020081200');
