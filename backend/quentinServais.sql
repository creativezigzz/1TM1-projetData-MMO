/*création d' une procedure qui renvoie sur base du token de la personne connecté sa liste d'animé personnelle dans un objet JSON*/

CREATE PROCEDURE get_animeList(IN @token char(32))
RESULT(anime char(255), note tinyint, genre char(50))/*renverra le titre des animes la note et le genre*/
BEGIN
    /*évitez une erreur CORS*/
	CALL sa_set_http_header('Access-Control-Allow-Origin', '*');
    /*retourne les infos si le token de la personne connectée correspond au token enregistré dans la table personne
	de la base de données*/
	SELECT titre, rating, genrNom FROM genre NATURAL JOIN anime NATURAL JOIN myList NATURAL JOIN personne
    WHERE personne.token = @token
END;


/*création d' un service qui retourne tout les animés correspondant au token de la personne connectée*/

CREATE SERVICE "getAnimeList"
    TYPE 'JSON'
    AUTHORIZATION OFF
    METHODS 'GET'
    USER "DBA"
    URL ON
AS CALL get_animeList(:token);