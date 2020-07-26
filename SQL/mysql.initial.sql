/*
 * Roundcube CalDav Oauth Calendar
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

CREATE TABLE IF NOT EXISTS `calendar_oauth_states` (
  `provider_id` varchar(255) NOT NULL,
  `client_config_id` varchar(255) NOT NULL,
  `user_id` varchar(255) NOT NULL,
  `scope` varchar(255) NOT NULL,
  `issue_time` integer NOT NULL,
  `state` varchar(255) NOT NULL,
  UNIQUE (`provider_id`, `client_config_id`, `user_id`, `scope`),
  PRIMARY KEY (state)
);

CREATE TABLE IF NOT EXISTS `calendar_oauth_access_tokens` (
  `provider_id` varchar(255) NOT NULL,
  `client_config_id` varchar(255) NOT NULL,
  `user_id` varchar(255) NOT NULL,
  `scope` varchar(255) NOT NULL,
  `issue_time` integer NOT NULL,
  `access_token` varchar(255) NOT NULL,
  `token_type` varchar(255) NOT NULL,
  `expires_in` integer DEFAULT NULL,
  UNIQUE (`provider_id`, `client_config_id`, `user_id`, `scope`)
);

CREATE TABLE IF NOT EXISTS `calendar_oauth_refresh_tokens` (
  `provider_id` varchar(255) NOT NULL,
  `client_config_id` varchar(255) NOT NULL,
  `user_id` varchar(255) NOT NULL,
  `scope` varchar(255) NOT NULL,
  `issue_time` integer NOT NULL,
  `refresh_token` varchar(255) DEFAULT NULL,
  UNIQUE (`provider_id`, `client_config_id`, `user_id`, `scope`)
);

REPLACE INTO `system` (`name`, `value`) VALUES ('texxasrulez-calendar-version', '2020072000');
