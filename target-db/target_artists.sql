truncate target_db_artists;
insert into target_db_artists (artid, name, roles, memids, groups, instrs, genres, urls, aka, type, releases, hasimg, profile)
select 
	artist.id as artid
	,artist.name
	,tbl_roles.roles
	,tbl_memids_groups.memids
	,tbl_memids_groups.groups
	,tbl_instrs.instrs
	,tbl_genres.genres
	,tbl_urls.urls
	,tbl_aka.aka
	,tbl_type.type
	,tbl_releases.releases
	,tbl_hasimg.hasimg::int
	,profile
from artist
left join (select artist_id, string_agg(alias_name, '	') as aka from artist_alias group by artist_id)
	as tbl_aka on artist.id = tbl_aka.artist_id
join (select artist.id, max(group_member.group_artist_id) as group_id, max(case when group_member.group_artist_id is null then 2 else 1 end) as type from artist full outer join group_member on artist.id = group_member.group_artist_id group by id)
	as tbl_type on artist.id = tbl_type.id 
left join (select artist.id, string_agg(release.id::text, ', ') as releases from artist join master_artist on artist.id = master_artist.artist_id join master on master.id = master_artist.master_id join release on master.main_release = release.id group by artist.id)
	as tbl_releases on artist.id = tbl_releases.id
join (select artist.id, (max(artist_image.type) is not null)::boolean as hasimg from artist_image full outer join artist on artist_image.artist_id = artist.id group by artist.id)
	as tbl_hasimg on tbl_hasimg.id = artist.id
left join (select group_artist_id  as artist_id, string_agg(member_artist_id::text, ',') as memids, string_agg(member_name, '	') as groups from group_member group by group_artist_id union select member_artist_id as artist_id, string_agg(group_artist_id::text, ', ') as memids, string_agg(artist.name, '	') as groups from group_member join artist on group_artist_id = artist.id group by member_artist_id)
	as tbl_memids_groups on tbl_memids_groups.artist_id = artist.id
left join (select artist_id, string_agg(url, '	') as urls from artist_url group by artist_id)
	as tbl_urls on tbl_urls.artist_id = artist.id
left join (select id, string_agg(genre, ', ') as genres from (select artist.id, concat(release_genre.genre, ': ', count(release_genre.genre)) as genre from artist  join master_artist on artist.id = master_artist.artist_id join master on master.id = master_artist.master_id join release on master.main_release = release.id join release_genre on release.id = release_genre.release_id group by artist.id, release_genre.genre) as tbl_genre group by id)
	as tbl_genres on tbl_genres.id = artist.id
left join (select artist_id as id, string_agg(instr, ', ') as instrs from (select artist_id, concat(max(abbr), ': ', count(abbr)) as instr from artist_instrument_release group by artist_id, abbr) tbl group by artist_id)
	as tbl_instrs on tbl_instrs.id = artist.id
left join (select artist_id, sum(val) as roles from (select artist_role_release.artist_id, max(role_to_binary.value) as val, role_to_binary.role from artist_role_release left join role_to_binary on role_to_binary.name = artist_role_release.role group by artist_id, role_to_binary.role) tbl group by artist_id)
	as tbl_roles on tbl_roles.artist_id = artist.id
where (artist.name <> 'error' and artist.data_quality is not null)
--order by artist.id
