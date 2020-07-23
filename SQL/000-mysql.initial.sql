CREATE TABLE calendar_oauth_states (
  provider VARCHAR(128) NOT NULL,
  client_config_id VARCHAR(128) NOT NULL,
  user_id VARCHAR(128) NOT NULL,
  scope VARCHAR(128) NOT NULL,
  issue_time INTEGER NOT NULL,
  state VARCHAR(128) NOT NULL PRIMARY KEY,
  CONSTRAINT calendar_oauth_states_unique_key UNIQUE (provider, client_config_id, user_id, scope)
);

CREATE TABLE calendar_oauth_access_tokens (
  provider VARCHAR(128) NOT NULL,
  client_config_id VARCHAR(128) NOT NULL,
  user_id VARCHAR(128) NOT NULL,
  scope VARCHAR(128) NOT NULL,
  issue_time INTEGER NOT NULL,
  access_token VARCHAR(128) NOT NULL,
  token_type VARCHAR(128) NOT NULL,
  expires_in INTEGER DEFAULT NULL,
  CONSTRAINT calendar_oauth_access_tokens_unique_key UNIQUE (provider, client_config_id, user_id, scope)
);

CREATE TABLE calendar_oauth_refresh_tokens (
  provider VARCHAR(128) NOT NULL,
  client_config_id VARCHAR(128) NOT NULL,
  user_id VARCHAR(128) NOT NULL,
  scope VARCHAR(128) NOT NULL,
  issue_time INTEGER NOT NULL,
  refresh_token VARCHAR(128) DEFAULT NULL,
  CONSTRAINT calendar_oauth_refresh_tokens_unique_key UNIQUE (provider, client_config_id, user_id, scope)
);

REPLACE INTO `system` (`name`, `value`) VALUES ('texxasrulez-oauth2-version', '2020072000');
