CREATE TABLE IF NOT EXISTS `caldav_attachments` (
  `attachment_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `event_id` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `filename` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `mimetype` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `size` int(11) NOT NULL DEFAULT '0',
  `data` longtext COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`attachment_id`),
  KEY `rc_caldav_attachments_event_id` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `caldav_calendars` (
  `calendar_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `color` varchar(8) COLLATE utf8mb4_bin NOT NULL,
  `showalarms` tinyint(1) NOT NULL DEFAULT '1',
  `caldav_url` varchar(1000) COLLATE utf8mb4_bin NOT NULL,
  `caldav_tag` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `caldav_user` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `caldav_pass` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL,
  `caldav_oauth_provider` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `readonly` int(11) NOT NULL DEFAULT '0',
  `caldav_last_change` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`calendar_id`),
  KEY `caldav_user_name_idx` (`user_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE IF NOT EXISTS `caldav_events` (
  `event_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `calendar_id` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `recurrence_id` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `uid` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `instance` varchar(16) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `isexception` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `changed` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `sequence` int(1) UNSIGNED NOT NULL DEFAULT '0',
  `start` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `end` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `recurrence` varchar(1000) COLLATE utf8mb4_bin DEFAULT NULL,
  `title` varbinary(128) NOT NULL,
  `description` varbinary(128) NOT NULL,
  `location` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `categories` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `url` varchar(255) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `all_day` tinyint(1) NOT NULL DEFAULT '0',
  `free_busy` tinyint(1) NOT NULL DEFAULT '0',
  `priority` tinyint(1) NOT NULL DEFAULT '0',
  `sensitivity` tinyint(1) NOT NULL DEFAULT '0',
  `status` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `alarms` text COLLATE utf8mb4_bin,
  `attendees` text COLLATE utf8mb4_bin,
  `notifyat` datetime DEFAULT NULL,
  `caldav_url` varchar(1000) COLLATE utf8mb4_bin NOT NULL,
  `caldav_tag` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `caldav_last_change` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`event_id`),
  KEY `caldav_uid_idx` (`uid`),
  KEY `caldav_recurrence_idx` (`recurrence_id`),
  KEY `caldav_calendar_notify_idx` (`calendar_id`,`notifyat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

ALTER TABLE `caldav_attachments`
  ADD CONSTRAINT `rc_caldav_attachments_event_id` FOREIGN KEY (`event_id`) REFERENCES `caldav_events` (`event_id`) ON DELETE CASCADE ON UPDATE CASCADE;
  
ALTER TABLE `caldav_calendars`
  ADD CONSTRAINT `rc_caldav_calendars_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
  
ALTER TABLE `caldav_events`
  ADD CONSTRAINT `rc_caldav_events_calendar_id` FOREIGN KEY (`calendar_id`) REFERENCES `caldav_calendars` (`calendar_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

REPLACE INTO `system` (`name`, `value`) VALUES ('texxasrulez-caldav-version', '2020072000');
