create table if not exists artist_instrument_release (
	artist_id integer,
	release_id integer,
	instrument text,
	abbr text,
	lvl5 text,
	lvl4 text,
	lvl3 text,
	lvl2 text,
	lvl1 text
);
truncate artist_instrument_release;
insert into artist_instrument_release(artist_id, release_id, instrument, abbr, lvl5, lvl4, lvl3, lvl2, lvl1)
select artist_id, release_id, regexp_replace(trim(unnest(string_to_array(role, ','))), '\s?\[.*\]\s?', '') as instrument, abbr, lvl5, lvl4, lvl3, lvl2, lvl1
	from release_artist
	join master on master.main_release = release_id
	join instrument on instrument.instrument = role;

create table if not exists artist_instrument_track (
	artist_id integer,
	release_id integer,
	instrument text,
	abbr text,
	lvl5 text,
	lvl4 text,
	lvl3 text,
	lvl2 text,
	lvl1 text
);
truncate artist_instrument_track;
insert into artist_instrument_track(artist_id, release_id, instrument, abbr, lvl5, lvl4, lvl3, lvl2, lvl1)
select artist_id, release_id, regexp_replace(trim(unnest(string_to_array(role, ','))), '\s?\[.*\]\s?', '') as instrument, abbr, lvl5, lvl4, lvl3, lvl2, lvl1
from release_track_artist
join master on master.main_release = release_id
join instrument on instrument.instrument = role;

create table if not exists artist_role_release (
	artist_id integer,
	release_id integer,
	role text
);
truncate artist_role_release;
insert into artist_role_release (artist_id, release_id, role)
select artist_id, release_id, regexp_replace(trim(unnest(string_to_array(role, ','))), '\s?\[.*\]\s?', '') as role
	from release_artist
	join master on master.main_release = release_id
	full outer join instrument on instrument.instrument = role
	where instrument is null;

create table if not exists artist_role_track (
	artist_id integer,
	release_id integer,
	role text
);
truncate artist_role_track;
insert into artist_role_track (artist_id, release_id, role)
select artist_id, release_id, regexp_replace(trim(unnest(string_to_array(role, ','))), '\s?\[.*\]\s?', '') as role
	from release_track_artist
	join master on master.main_release = release_id
	full outer join instrument on instrument.instrument = role
	where instrument is null;