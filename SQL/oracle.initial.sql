/*
 * Roundcube CalDav Calendar Oauth Schema
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
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

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
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE TABLE calendar_oauth_refresh_tokens (
  provider varchar2(255) NOT NULL,
  client_config_id varchar2(255) NOT NULL,
  user_id varchar2(255) NOT NULL,
  scope varchar2(255) NOT NULL,
  issue_time NUMBER(10) NOT NULL,
  refresh_token varchar2(255) DEFAULT NULL,
  UNIQUE (provider(50), `client_config_id`(50), `user_id`(50), `scope`(50))
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

REPLACE INTO `system` (name, value) SELECT  'tx-oauth2-calendar-version', '2020080200'  FROM dual;
