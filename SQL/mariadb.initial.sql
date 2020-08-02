/*
 * Roundcube CalDav Calendar Oauth Schema
 *
 * @author Gene Hawkins <texxasrulez@yahoo.com>
 *
 * @licence GNU AGPL
 */

CREATE TABLE IF NOT EXISTS calendar_oauth_states (
  `provider` varchar(255) NOT NULL,
  `client_config_id` varchar(255) NOT NULL,
  `user_id` varchar(255) NOT NULL,
  `scope` varchar(255) NOT NULL,
  `issue_time` INTEGER NOT NULL,
  `state` varchar(255) NOT NULL,
  UNIQUE (`provider`(50), `client_config_id`(50), `user_id`(50), `scope`(50)),
  PRIMARY KEY (`state`)
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE TABLE IF NOT EXISTS calendar_oauth_access_tokens (
  `provider` varchar(255) NOT NULL,
  `client_config_id` varchar(255) NOT NULL,
  `user_id` varchar(255) NOT NULL,
  `scope` varchar(255) NOT NULL,
  `issue_time` INTEGER NOT NULL,
  `access_token` varchar(255) NOT NULL,
  `token_type` varchar(255) NOT NULL,
  `expires_in` INTEGER DEFAULT NULL,
  UNIQUE (`provider`(50), `client_config_id`(50), `user_id`(50), `scope`(50))
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE TABLE IF NOT EXISTS calendar_oauth_refresh_tokens (
  `provider` varchar(255) NOT NULL,
  `client_config_id` varchar(255) NOT NULL,
  `user_id` varchar(255) NOT NULL,
  `scope` varchar(255) NOT NULL,
  `issue_time` INTEGER NOT NULL,
  `refresh_token` varchar(255) DEFAULT NULL,
  UNIQUE (`provider`(50), `client_config_id`(50), `user_id`(50), `scope`(50))
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

REPLACE INTO `system` (`name`, `value`) SELECT ('tx-oauth2-calendar-version', '2020080200');
