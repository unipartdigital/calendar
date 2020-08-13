/*
* Roundcube Database, CalDav & iCal Calendar Schema
*
* @author Gene Hawkins <texxasrulez@yahoo.com>
*
* @licence GNU AGPL
*/
-- import to SQLite by running: sqlite3.exe db.sqlite3 -init sqlite.sql

PRAGMA journal_mode = MEMORY;
PRAGMA synchronous = OFF;
PRAGMA foreign_keys = OFF;
PRAGMA ignore_check_constraints = OFF;
PRAGMA auto_vacuum = NONE;
PRAGMA secure_delete = OFF;
BEGIN TRANSACTION;

CREATE TABLE `calendar_oauth_states` (
`provider` TEXT NOT NULL,
`client_config_id` TEXT NOT NULL,
`user_id` TEXT NOT NULL,
`scope` TEXT NOT NULL,
`issue_time` INTEGER NOT NULL,
`state` TEXT NOT NULL,
UNIQUE (`provider`(50), `client_config_id`(50), `user_id`(50), `scope`(50)),
PRIMARY KEY (`state`)
);

CREATE TABLE `calendar_oauth_access_tokens` (
`provider` TEXT NOT NULL,
`client_config_id` TEXT NOT NULL,
`user_id` TEXT NOT NULL,
`scope` TEXT NOT NULL,
`issue_time` INTEGER NOT NULL,
`access_token` TEXT NOT NULL,
`token_type` TEXT NOT NULL,
`expires_in` INTEGER DEFAULT NULL,
UNIQUE (`provider`(50), `client_config_id`(50), `user_id`(50), `scope`(50))
);

CREATE TABLE `calendar_oauth_refresh_tokens` (
`provider` TEXT NOT NULL,
`client_config_id` TEXT NOT NULL,
`user_id` TEXT NOT NULL,
`scope` TEXT NOT NULL,
`issue_time` INTEGER NOT NULL,
`refresh_token` TEXT DEFAULT NULL,
UNIQUE (`provider`(50), `client_config_id`(50), `user_id`(50), `scope`(50))
);

CREATE TABLE `caldav_calendars` (
`calendar_id` INTEGER  NOT NULL ,
`user_id` INTEGER  NOT NULL DEFAULT '0',
`name` TEXT NOT NULL,
`color` TEXT NOT NULL,
`showalarms` tinyINTEGER NOT NULL DEFAULT '1',
`caldav_url` TEXT DEFAULT NULL,
`caldav_tag` TEXT   NULL DEFAULT 'COLLATE',
`caldav_user` TEXT DEFAULT NULL,
`caldav_pass` TEXT DEFAULT NULL,
`caldav_oauth_provider` varbinary(200) DEFAULT NULL,
`readonly` int NOT NULL DEFAULT '0',
`caldav_last_change` timestamp NOT NULL ,
PRIMARY KEY(`calendar_id`),
INDEX `caldav_user_name_idx` (`user_id`, `name`),
FOREIGN KEY (`user_id`)
REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `caldav_events` (
`event_id` INTEGER  NOT NULL ,
`calendar_id` INTEGER  NOT NULL DEFAULT '0',
`recurrence_id` INTEGER  NOT NULL DEFAULT '0',
`uid` TEXT NOT NULL DEFAULT '',
`instance` TEXT NOT NULL DEFAULT '',
`isexception` tinyINTEGER NOT NULL DEFAULT '0',
`created` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
`changed` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
`sequence` INTEGER  NOT NULL DEFAULT '0',
`start` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
`end` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
`recurrence` TEXT DEFAULT NULL,
`title` varbinary(128) NOT NULL,
`description` varbinary(2048) NOT NULL,
`location` varbinary(128) NOT NULL DEFAULT '',
`categories` varbinary(128) NOT NULL DEFAULT '',
`url` TEXT NOT NULL DEFAULT '',
`all_day` tinyINTEGER NOT NULL DEFAULT '0',
`free_busy` tinyINTEGER NOT NULL DEFAULT '0',
`priority` tinyINTEGER NOT NULL DEFAULT '0',
`sensitivity` tinyINTEGER NOT NULL DEFAULT '0',
`status` TEXT NOT NULL DEFAULT '',
`alarms` text NULL DEFAULT NULL,
`attendees` text DEFAULT NULL,
`notifyat` datetime DEFAULT NULL,
`caldav_url` TEXT NOT NULL,
`caldav_tag` TEXT   NULL DEFAULT 'COLLATE',
`caldav_last_change` timestamp NOT NULL ,
PRIMARY KEY(`event_id`),
INDEX `caldav_uid_idx` (`uid`),
INDEX `caldav_recurrence_idx` (`recurrence_id`),
INDEX `caldav_calendar_notify_idx` (`calendar_id`,`notifyat`),
FOREIGN KEY (`calendar_id`)
REFERENCES `caldav_calendars`(`calendar_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `caldav_attachments` (
`attachment_id` INTEGER  NOT NULL ,
`event_id` INTEGER  NOT NULL DEFAULT '0',
`filename` TEXT NOT NULL DEFAULT '',
`mimetype` TEXT NOT NULL DEFAULT '',
`size` INTEGER NOT NULL DEFAULT '0',
`data` MEDIUMBLOB,
PRIMARY KEY(`attachment_id`),
FOREIGN KEY (`event_id`)
REFERENCES `caldav_events`(`event_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `database_calendars` (
`calendar_id` INTEGER  NOT NULL ,
`user_id` INTEGER  NOT NULL DEFAULT '0',
`name` TEXT NOT NULL,
`color` TEXT NOT NULL,
`showalarms` tinyINTEGER NOT NULL DEFAULT '1',
PRIMARY KEY(`calendar_id`),
INDEX `user_name_idx` (`user_id`, `name`),
FOREIGN KEY (`user_id`)
REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `database_events` (
`event_id` INTEGER  NOT NULL ,
`calendar_id` INTEGER  NOT NULL DEFAULT '0',
`recurrence_id` INTEGER  NOT NULL DEFAULT '0',
`uid` TEXT NOT NULL DEFAULT '',
`instance` TEXT NOT NULL DEFAULT '',
`isexception` tinyINTEGER NOT NULL DEFAULT '0',
`created` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
`changed` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
`sequence` INTEGER  NOT NULL DEFAULT '0',
`start` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
`end` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
`recurrence` TEXT DEFAULT NULL,
`title` TEXT NOT NULL,
`description` text NOT NULL,
`location` TEXT NOT NULL DEFAULT '',
`categories` TEXT NOT NULL DEFAULT '',
`url` TEXT NOT NULL DEFAULT '',
`all_day` tinyINTEGER NOT NULL DEFAULT '0',
`free_busy` tinyINTEGER NOT NULL DEFAULT '0',
`priority` tinyINTEGER NOT NULL DEFAULT '0',
`sensitivity` tinyINTEGER NOT NULL DEFAULT '0',
`status` TEXT NOT NULL DEFAULT '',
`alarms` text DEFAULT NULL,
`attendees` text DEFAULT NULL,
`notifyat` datetime DEFAULT NULL,
PRIMARY KEY(`event_id`),
INDEX `uid_idx` (`uid`),
INDEX `recurrence_idx` (`recurrence_id`),
INDEX `calendar_notify_idx` (`calendar_id`,`notifyat`),
FOREIGN KEY (`calendar_id`)
REFERENCES `database_calendars`(`calendar_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `database_attachments` (
`attachment_id` INTEGER  NOT NULL ,
`event_id` INTEGER  NOT NULL DEFAULT '0',
`filename` TEXT NOT NULL DEFAULT '',
`mimetype` TEXT NOT NULL DEFAULT '',
`size` INTEGER NOT NULL DEFAULT '0',
`data` TEXT NOT NULL,
PRIMARY KEY(`attachment_id`),
FOREIGN KEY (`event_id`)
REFERENCES `database_events`(`event_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `itipinvitations` (
`token` TEXT NOT NULL,
`event_uid` TEXT NOT NULL,
`user_id` INTEGER  NOT NULL DEFAULT '0',
`event` TEXT NOT NULL,
`expires` DATETIME DEFAULT NULL,
`cancelled` TINYINTEGER  NOT NULL DEFAULT '0',
PRIMARY KEY(`token`),
INDEX `uid_idx` (`user_id`,`event_uid`),
FOREIGN KEY (`user_id`)
REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `ical_calendars` (
`calendar_id` INTEGER  NOT NULL ,
`user_id` INTEGER  NOT NULL DEFAULT '0',
`name` TEXT NOT NULL,
`color` TEXT NOT NULL,
`showalarms` tinyINTEGER NOT NULL DEFAULT '1',
`ical_url` TEXT NOT NULL,
`ical_user` TEXT DEFAULT NULL,
`ical_pass` TEXT DEFAULT NULL,
`ical_last_change` timestamp NOT NULL ,
PRIMARY KEY(`calendar_id`),
INDEX `ical_user_name_idx` (`user_id`, `name`),
FOREIGN KEY (`user_id`)
REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `ical_events` (
`event_id` INTEGER  NOT NULL ,
`calendar_id` INTEGER  NOT NULL DEFAULT '0',
`recurrence_id` INTEGER  NOT NULL DEFAULT '0',
`uid` TEXT NOT NULL DEFAULT '',
`instance` TEXT NOT NULL DEFAULT '',
`isexception` tinyINTEGER NOT NULL DEFAULT '0',
`created` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
`changed` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
`sequence` INTEGER  NOT NULL DEFAULT '0',
`start` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
`end` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
`recurrence` TEXT DEFAULT NULL,
`title` varbinary(128) NOT NULL,
`description` varbinary(2048) NOT NULL,
`location` varbinary(128) NOT NULL DEFAULT '',
`categories` varbinary(128) NOT NULL DEFAULT '',
`url` TEXT NOT NULL DEFAULT '',
`all_day` tinyINTEGER NOT NULL DEFAULT '0',
`free_busy` tinyINTEGER NOT NULL DEFAULT '0',
`priority` tinyINTEGER NOT NULL DEFAULT '0',
`sensitivity` tinyINTEGER NOT NULL DEFAULT '0',
`status` TEXT NOT NULL DEFAULT '',
`alarms` text NULL DEFAULT NULL,
`attendees` text DEFAULT NULL,
`notifyat` datetime DEFAULT NULL,
`ical_url` TEXT NOT NULL,
`ical_last_change` timestamp NOT NULL ,
PRIMARY KEY(`event_id`),
INDEX `ical_uid_idx` (`uid`),
INDEX `ical_recurrence_idx` (`recurrence_id`),
INDEX `ical_calendar_notify_idx` (`calendar_id`,`notifyat`),
FOREIGN KEY (`calendar_id`)
REFERENCES `ical_calendars`(`calendar_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `ical_attachments` (
`attachment_id` INTEGER  NOT NULL ,
`event_id` INTEGER  NOT NULL DEFAULT '0',
`filename` TEXT NOT NULL DEFAULT '',
`mimetype` TEXT NOT NULL DEFAULT '',
`size` INTEGER NOT NULL DEFAULT '0',
`data` TEXT NOT NULL,
PRIMARY KEY(`attachment_id`),
FOREIGN KEY (`event_id`)
REFERENCES `ical_events`(`event_id`) ON DELETE CASCADE ON UPDATE CASCADE
);
REPLACE INTO `system` (`name`, `value`) VALUES ('calendar-version', '2020081200');





COMMIT;
PRAGMA ignore_check_constraints = ON;
PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;
