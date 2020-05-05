/*
creation de la procedure qui renvoie tout anime present dans la base de donnée
dans un objet json.
*/
CREATE PROCEDURE get_animeListRatio()
result(titre char(256),genre char (256), note int)
BEGIN 
    select an.titre ,gr.genrNom, sum(li.rating)/count(li.pseudo) from myList as li
    natural join anime as an
    natural join genre as gr
    group by titre, li.animeId,gr.genrNom
    order by titre asc
end;

/*
creation du service qui renvoie tout les anime existant dans la base de donée
 et leur ratio dans un objet json.
*/
create service "getAnimeListRatio"
    type 'JSON'
    authorization off
    methods 'get'
    user "DBA"
    url on
as call get_animeListRatio()


/*
creation de la procedure qui ressemble tout les genre que la base de donnée a enregistré
*/
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