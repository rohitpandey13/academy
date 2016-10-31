/*
  If you prefer to have the date in UTC format as default, set the TZ env variable to UTC
  TZ=UTC ../../apache-cassandra/bin/cqlsh
*/

TRUNCATE lbsn.events;
copy lbsn.events (uid, ts, lat, lon, vid) from '../loc-gowalla_events.csv' with DELIMITER='\t';

TRUNCATE lbsn.users;
copy lbsn.users (uid, id) from '../loc-gowalla_users.csv' with DELIMITER = '\t';

TRUNCATE lbsn.venues;
COPY lbsn.venues (vid,name,lat,lon) FROM '../loc-gowalla_venues.csv' with DELIMITER = '\t';