create procedure get_genreList()/*creation de la procedure get_genreList*/
result( id integer, genre char(30))/*renvoie un id qui est un nombre et le genre qui est un charactere*/
begin
    select * from dba.genre/*selectionne toutes les données de la table genre*/
    order by genrNom ASC /*les trie sur les noms par ordre croissant */
end;

/*
creation du service qui renvoie tout les genre et leur id
dans un objet json.
*/
create service "getGenrList"
    type 'JSON'
    authorization off
    methods 'get'
    user "DBA"
    url on
as call get_genreList()