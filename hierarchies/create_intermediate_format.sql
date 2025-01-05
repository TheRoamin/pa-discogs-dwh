create table if not exists type_intermediate(release_id integer, name text, descriptions text, album boolean, compilation boolean, single boolean, live boolean, mp3 boolean, m4a boolean, wav boolean, promotion boolean, bootleg boolean);
insert into type_intermediate 
select 
	release_id, 
	name, 
	descriptions, 
	descriptions like '%Album%' as album,
	descriptions like '%Compilation%' as compilation,
	descriptions like '%Single%' as single,
	descriptions like '%Live%' as live,
	descriptions like '%MP3%' as mp3,
	descriptions like '%M4A%' as m4a,
	descriptions like '%WAV%' as wav,
	descriptions like '%Promo%' as promotion,
	descriptions like '%Bootleg%' as bootleg
from release_format
order by release_id
