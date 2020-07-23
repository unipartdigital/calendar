CREATE TABLE IF NOT EXISTS `caldav_calendars` (
  `calendar_id` INTEGER UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `user_id` INTEGER UNSIGNED NOT NULL DEFAULT '0',
  `name` VARBINARY(50),
  `color` VARBINARY(10),
  `showalarms` TINYINT(1) NOT NULL DEFAULT '1',

  `caldav_url` VARBINARY(200),
  `caldav_tag` VARBINARY(32),
  `caldav_user` VARCHAR(255) DEFAULT NULL,
  `caldav_pass` VARCHAR(1024) DEFAULT NULL,
  `caldav_oauth_provider` VARCHAR(255) DEFAULT NULL,
  `readonly` INT(11) NOT NULL DEFAULT '0',
  `caldav_last_change` INT(11) UNSIGNED, 
  `components` VARBINARY(21),
  
  INDEX `caldav_user_name_idx` (`user_id`, `name`),
  CONSTRAINT `rc_caldav_calendars_user_id` FOREIGN KEY (`user_id`)
  REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `caldav_events` (
  `event_id` INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `calendar_id` INTEGER UNSIGNED NOT NULL DEFAULT '0',
  `recurrence_id` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
  `uid` VARBINARY(200) NOT NULL DEFAULT '0',
  `instance` VARCHAR(16) NOT NULL DEFAULT '',
  `isexception` TINYINT(1) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `componenttype` VARBINARY(8) NOT NULL DEFAULT '0',
  `changed` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `sequence` INT(1) UNSIGNED NOT NULL DEFAULT '0',
  `start` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `end` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `recurrence` VARCHAR(1000) DEFAULT NULL,
  `title` varbinary(128) NOT NULL,
  `description` varbinary(128) NOT NULL,
  `location` VARCHAR(255) NOT NULL DEFAULT '',
  `categories` VARCHAR(255) NOT NULL DEFAULT '',
  `url` VARBINARY(200),
  `all_day` TINYINT(1) NOT NULL DEFAULT '0',
  `free_busy` TINYINT(1) NOT NULL DEFAULT '0',
  `priority` TINYINT(1) NOT NULL DEFAULT '0',
  `sensitivity` TINYINT(1) NOT NULL DEFAULT '0',
  `status` VARCHAR(32) NOT NULL DEFAULT '',
  `alarms` text COLLATE utf8mb4_bin,
  `attendees` text COLLATE utf8mb4_bin,
  `notifyat` datetime DEFAULT NULL,
  `caldav_url` VARBINARY(200),
  `caldav_tag` VARBINARY(32),
  `caldav_last_change` INT(11) UNSIGNED,
  
  INDEX `caldav_uid_idx` (`uid`),
  INDEX `caldav_recurrence_idx` (`recurrence_id`),
  INDEX `caldav_calendar_notify_idx` (`calendar_id`,`notifyat`),
  CONSTRAINT `rc_caldav_events_calendar_id` FOREIGN KEY (`calendar_id`)
  REFERENCES `caldav_calendars`(`calendar_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `caldav_attachments` (
  `attachment_id` INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `event_id` INT(11) UNSIGNED NOT NULL DEFAULT '0',
  `filename` VARCHAR(255) NOT NULL DEFAULT '',
  `mimetype` VARCHAR(255) NOT NULL DEFAULT '',
  `size` INT(11) NOT NULL DEFAULT '0',
  `data` MEDIUMBLOB,
  
  CONSTRAINT `rc_caldav_attachments_event_id` FOREIGN KEY (`event_id`)
  REFERENCES `caldav_events`(`event_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

REPLACE INTO `system` (`name`, `value`) VALUES ('texxasrulez-caldav-version', '2020072000');
