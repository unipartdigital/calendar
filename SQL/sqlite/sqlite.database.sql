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
  calendar_id integer NOT NULL PRIMARY KEY,
  user_id integer NOT NULL default '0',
  name varchar(255) NOT NULL default '',
  color varchar(255) NOT NULL default '',
  showalarms tinyint(1) NOT NULL default '1',
  CONSTRAINT fk_calendars_user_id FOREIGN KEY (user_id)
    REFERENCES users(user_id)
);

CREATE TABLE database_events (
  event_id integer NOT NULL PRIMARY KEY,
  calendar_id integer NOT NULL default '0',
  recurrence_id integer NOT NULL default '0',
  uid varchar(255) NOT NULL default '',
  instance varchar(16) NOT NULL default '',
  isexception tinyint(1) NOT NULL default '0',
  created datetime NOT NULL default '1000-01-01 00:00:00',
  changed datetime NOT NULL default '1000-01-01 00:00:00',
  sequence integer NOT NULL default '0',
  start datetime NOT NULL default '1000-01-01 00:00:00',
  end datetime NOT NULL default '1000-01-01 00:00:00',
  recurrence varchar(255) default NULL,
  title varchar(255) NOT NULL,
  description text NOT NULL,
  location varchar(255) NOT NULL default '',
  categories varchar(255) NOT NULL default '',
  url varchar(255) NOT NULL default '',
  all_day tinyint(1) NOT NULL default '0',
  free_busy tinyint(1) NOT NULL default '0',
  priority tinyint(1) NOT NULL default '0',
  sensitivity tinyint(1) NOT NULL default '0',
  status varchar(32) NOT NULL default '',
  alarms text default NULL,
  attendees text default NULL,
  notifyat datetime default NULL,
  CONSTRAINT fk_events_calendar_id FOREIGN KEY (calendar_id)
    REFERENCES database_calendars(calendar_id)
);

CREATE TABLE database_attachments (
  attachment_id integer NOT NULL PRIMARY KEY,
  event_id integer NOT NULL default '0',
  filename varchar(255) NOT NULL default '',
  mimetype varchar(255) NOT NULL default '',
  size integer NOT NULL default '0',
  data text NOT NULL default '',
  CONSTRAINT fk_attachment_event_id FOREIGN KEY (event_id)
    REFERENCES database_events(event_id)
);

CREATE TABLE itipinvitations (
  token varchar(64) NOT NULL PRIMARY KEY,
  event_uid varchar(255) NOT NULL,
  user_id integer NOT NULL default '0',
  event text NOT NULL,
  expires datetime NOT NULL default '1000-01-01 00:00:00',
  cancelled tinyint(1) NOT NULL default '0',
  CONSTRAINT fk_itipinvitations_user_id FOREIGN KEY (user_id)
    REFERENCES users(user_id)
);

CREATE INDEX ix_itipinvitations_uid ON itipinvitations(user_id, event_uid);

INSERT INTO system (name, value) VALUES ('tx-database-calendar-version', '2020080200');
