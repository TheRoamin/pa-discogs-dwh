--this script fixes foreign key constraints by introducing error values in the referenced tables

insert into artist (id, name, realname, profile, data_quality)
select member_artist_id as id, 'error' as name, null as realname, null as profile, null as data_quality
from group_member
full outer join artist on artist.id = member_artist_id
where artist.id is null
group by member_artist_id;

insert into artist (id, name, realname, profile, data_quality)
select with_errors.id2 as id, 'error' as name, null as realname, null as profile, null as data_quality
from (select master_artist.id as id1, master_artist.artist_id as id2 from master_artist
join artist on artist.id = master_artist.artist_id
order by master_artist.id) as no_errors
full outer join (select master_artist.id as id1, master_artist.artist_id as id2 from master_artist) as with_errors on no_errors.id1 = with_errors.id1
where no_errors.id1 is null or no_errors.id2 is null
group by with_errors.id2;

insert into release (id, title, released, country, notes, data_quality, main, master_id, status)
select with_errors.r_id as id, 'error' as title, null as released, null as country, null as notes, null as data_quality, null as main, with_errors.m_id as master_id, null as status
from (select master.id as m_id, release.id as r_id from master
	join release on master.main_release = release.id order by master.id) as no_errors
full outer join (select master.id as m_id, main_release as r_id from master where main_release is not null) as with_errors on with_errors.m_id = no_errors.m_id
where no_errors.m_id is null or no_errors.r_id is null;

insert into artist (id, name, realname, profile, data_quality)
select with_errors.id2 as id, 'error' as name, null as realname, null as profile, null as data_quality
from (select release_artist.id as id1, release_artist.artist_id as id2 from release_artist
join artist on artist.id = release_artist.artist_id
order by release_artist.id) as no_errors
full outer join (select release_artist.id as id1, release_artist.artist_id as id2 from release_artist) as with_errors on no_errors.id1 = with_errors.id1
where no_errors.id1 is null or no_errors.id2 is null
group by with_errors.id2;

insert into master (id, title, year, main_release, data_quality)
select with_errors.master_id as id, 'error' as title, null as year, min(id2)as main_release, null as data_quality
from (select release.id as id1, master_id from release
	join master on master_id = master.id where master_id is not null) as no_errors
full outer join (select release.id as id2, master_id from release where master_id is not null) as with_errors on id1 = id2
where id1 is null or no_errors.master_id is null
group by with_errors.master_id;

insert into artist (id, name, realname, profile, data_quality)
select with_errors.id2 as id, 'error' as name, null as realname, null as profile, null as data_quality
from (select release_track_artist.id as id1, release_track_artist.artist_id as id2 from release_track_artist
join artist on artist.id = release_track_artist.artist_id
order by release_track_artist.id) as no_errors
full outer join (select release_track_artist.id as id1, release_track_artist.artist_id as id2 from release_track_artist) as with_errors on no_errors.id1 = with_errors.id1
where no_errors.id1 is null or no_errors.id2 is null
group by with_errors.id2;

--fix
ALTER TABLE master add unique (id);
ALTER TABLE release add unique (id);
ALTER TABLE artist add unique (id);
ALTER TABLE release_track add unique (id);

ALTER TABLE release ADD CONSTRAINT release_fk_master FOREIGN KEY (master_id) REFERENCES master(id);
ALTER TABLE master ADD CONSTRAINT master_fk_release FOREIGN KEY (main_release) REFERENCES release(id);
ALTER TABLE master_artist ADD CONSTRAINT master_artist_fk_artist FOREIGN KEY (artist_id) REFERENCES artist(id);
ALTER TABLE release_artist ADD CONSTRAINT release_artist_fk_artist FOREIGN KEY (artist_id) REFERENCES artist(id);
ALTER TABLE release_track_artist ADD CONSTRAINT release_track_artist_fk_artist FOREIGN KEY (artist_id) REFERENCES artist(id);
ALTER TABLE group_member ADD CONSTRAINT group_member_fk_artist FOREIGN KEY (member_artist_id) REFERENCES artist(id);


--convert track_id on release_track_artist type to int first
ALTER TABLE release_track_artist
ALTER COLUMN track_id SET DATA TYPE integer USING track_id::integer;
ALTER TABLE release_track_artist ADD CONSTRAINT release_track_artist_fk_release_track FOREIGN KEY (track_id) REFERENCES release_track(id);


--images:

ALTER TABLE artist_image ADD CONSTRAINT artist_image_fk_artist FOREIGN KEY (artist_id) REFERENCES artist(id);
ALTER TABLE release_image ADD CONSTRAINT release_image_fk_release FOREIGN KEY (release_id) REFERENCES release(id);
ALTER TABLE master_image ADD CONSTRAINT master_image_fk_master FOREIGN KEY (master_id) REFERENCES master(id);

