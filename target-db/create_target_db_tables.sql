CREATE TABLE IF NOT EXISTS target_db_releases (
  relID integer NOT NULL,
  name text NOT NULL,
  title text NOT NULL,
  notes text,
  albArtists text,
  genres text,
  styles text,
  artists text,
  label text,
  hasImg integer DEFAULT '0',
  urls text,
  videos text,
  trCnt integer DEFAULT NULL,
  tracks text,
  country text DEFAULT NULL,
  year text DEFAULT NULL,
  type integer DEFAULT '0'
);

CREATE TABLE IF NOT EXISTS target_db_artists (
  artID integer NOT NULL,
  name text NOT NULL,
  aka text,
  type text DEFAULT '0',
  profile text,
  roles integer DEFAULT NULL,
  genres text,
  groups text,
  memIDs text,
  urls text,
  hasImg smallint DEFAULT '0',
  country text DEFAULT NULL,
  place text,
  lifespan text DEFAULT NULL,
  instrs text,
  releases text
)