create procedure get_animeList(in token char(32))
result( animeNom char(255), note tinyint, genrNom char(50))
begin
    call sa_set_http_header('Access-Control-Allow-Origin', '*');
	select titre, rating from anime natural join mylist 
end;


create service "getAnimeList"
    type 'JSON'
    authorization off
    methods 'get'
    user "DBA"
    url on
as call get_animeList(:token)