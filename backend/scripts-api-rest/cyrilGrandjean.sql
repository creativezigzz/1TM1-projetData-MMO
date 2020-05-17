
/* auteur : grandjean cyril HE201803*/
/*
creation de la procedure qui renvoie tout anime present dans la base de donnée
dans un objet json.
*/
CREATE PROCEDURE get_allAnime()
result(titre char(256), id int)
BEGIN 
	Call sa_set_http_header('Access-Control-Allow-Origin', '*');
    select titre, animeId from anime
    order by titre asc;
end;

/*
creation du service qui renvoie tout les anime existant dans la base de donée
 et leur ratio dans un objet json.
*/
create service "getAllAnime"
    type 'JSON'
    authorization off
    methods 'get'
    user "DBA"
    url on
as call get_allAnime();


/*
creation de la procedure qui ressemble tout les genre que la base de donnée a enregistré
*/
create procedure get_genreList()/*creation de la procedure get_genreList*/
result( id integer, genre char(30))/*renvoie un id qui est un nombre et le genre qui est un charactere*/
begin
	Call sa_set_http_header('Access-Control-Allow-Origin', '*');
    select * from dba.genre/*selectionne toutes les données de la table genre*/
    order by genrNom ASC; /*les trie sur les noms par ordre croissant */
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
as call get_genreList();

/*
creation de la procédure qui verifie si la perssonne est bien connecter.
elle prend comme parametre le token de la personne.
*/
create PROCEDURE "DBA"."verifLog"(in @token char(32))
result (nom char(256))
begin
    if((SELECT 1 from personne as p where p.token = @token)=1) THEN 
        select p.pseudo from personne as p where p.token = @token;
    ELSE 
        select null;
    ENDIF;
end;
/*
creation du service qui renvoie le pseudo ou la valeur null
dans un objet json.
*/
create service "verifLog"
    type 'JSON'
    authorization off
    methods 'get'
    user "DBA"
    url on
as call verifLog(:token);