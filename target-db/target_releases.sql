insert into target_db_releases (relid, name, title, notes, country, year, label, genres, styles, hasimg, videos, tracks, trcnt, albartists, artists, type)
select 
	release.id as relID, 
	name.name as name,
	release.title as title, 
	release.notes as notes, 
	release.country as country, 
	release.released as year, 
	label.label_name as label, 
	release_genre.genre as genres,
	style.styles as styles,
	image.hasimg as hasimg,
	videos.videos as videos,
	tracks.tracks as tracks,
	tracks.trcount as trcnt,
	albartists.albartists as albartists,
	artists.artists as artists,
	types.type as type
from master
join release on master.main_release = release.id
join master_artist on master.id = master_artist.master_id
join artist on artist.id = master_artist.artist_id
left join (select release_label.release_id, max(release_label.label_name) as label_name from release_label group by release_id) as label on release.id = label.release_id
left join release_genre on release.id = release_genre.release_id
left join (select release_id, string_agg(style, ', ') as styles from release_style group by release_id) as style on release.id = style.release_id
left join (select release.id, (tbl.release_id is not null)::int as hasimg from release full outer join (select release_id from release_image group by release_id) as tbl on release.id = tbl.release_id) as image on release.id = image.id
left join (select release_id, string_agg(concat(title, '	', duration, ' ', uri), '\n') as videos from release_video group by release_id) as videos on release.id = videos.release_id
left join (select release_id, count(release_id) as trcount, string_agg(concat(title, '	', duration, '	'), '\n') as tracks from release_track group by release_id) as tracks on release.id = tracks.release_id
left join (select release_id, string_agg(artist_name, '	') as albartists from release_artist where extra = 0 group by release_id) as albartists on release.id = albartists.release_id
left join (select release_id, string_agg(concat(artist_name, ' ', join_string), ' ') as name from release_artist where extra = 0 group by release_id) as name on release.id = name.release_id
left join (select release_id, string_agg(artists, '\n') as artists from (select release_id, concat(artist_name, '	', string_agg(role, ',')) as artists from release_artist where extra = 1 group by artist_name, release_id) as tbl group by release_id) as artists on release.id = artists.release_id
left join (select release_id, 
	case
		when album and name = 'Shellac' then 2
		when album and name = 'Vinyl' then 3
		when album and name = 'CD' then 4
		when album then 1 
		when compilation and name = 'Vinyl' then 6
		when compilation and name = 'CD' then 7
		when compilation then 5
		when live and name = 'Vinyl' then 9
		when live and name = 'CD' then 10
		when live then 8
		when single and name = 'Vinyl' then 12
		when single and name = 'CD' then 13
		when single then 11
		when name = 'Cassette' then 14
		when name = 'CDr' then 15
		when name = 'File' and mp3 then 17
		when name = 'File' and m4a then 18
		when name = 'File' and wav then 19
		when name = 'File' then 16
		when promotion then 20
		when bootleg then 21
		when name = 'DVD' then 22
		else 0
	end as type
from
(select * from type_intermediate
join release on type_intermediate.release_id = release.id) tbl) as types on release.id = types.release_id
where (master.title <> 'error' and master.data_quality is not null) and (release.title <> 'error' and release.data_quality is not null) and (artist.name <> 'error' and artist.data_quality is not null)
order by release.id
