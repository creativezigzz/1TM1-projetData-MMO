/* auteur : SERVAIS Quentin HE201860*/
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
	ORDER BY titre ASC
END;

CREATE PROCEDURE get_titre(IN @token char(32))
RESULT(anime char(255), id INTEGER)/*renverra le titre des animes la note et le genre*/
BEGIN
    /*évitez une erreur CORS*/
	CALL sa_set_http_header('Access-Control-Allow-Origin', '*');
    /*retourne les infos si le token de la personne connectée correspond au token enregistré dans la table personne
	de la base de données*/
	SELECT titre, anime.animeId
  FROM myList NATURAL JOIN personne NATURAL JOIN anime
  WHERE personne.token = @token
	ORDER BY titre ASC;
END;

CREATE SERVICE "getTitre"
		TYPE 'JSON'
		AUTHORIZATION off
		METHODS 'GET'
		USER "DBA"
		URL ON
AS CALL get_titre(:token);

/*création d' un service qui retourne tout les animés correspondant au token de la personne connectée*/

CREATE SERVICE "getAnimeList"
    TYPE 'JSON'
    AUTHORIZATION OFF
    METHODS 'GET'
    USER "DBA"
    URL ON
AS CALL get_animeList(:token);

/*création d'une fonction qui retourne un pseudo en fonction de la personne connectée*/

CREATE FUNCTION getPers_Id(IN @token char(32))
RETURNS char(30)
BEGIN
	DECLARE @pseudo char(30);
	SET @pseudo = (select p.pseudo
				   from personne as p
				   where @token = p.token);
    RETURN @pseudo;
END;


/*création d'une procédure qui supprime un anime dans sa liste personnelle qui prend en parametres le titre de l'anime et le token de la personne concernée*/

CREATE PROCEDURE removeAnime(IN @id TINYINT, IN @token char(32))
RESULT(msg char(255))
BEGIN
	DELETE FROM myList as li
	WHERE @id = li.animeId AND li.pseudo = getPers_Id(@token);
	SELECT 'L''anime est bien supprimer';
END;


CREATE SERVICE "remove"
	TYPE 'RAW'
	AUTHORIZATION OFF
	METHODS 'GET'
	USER "DBA"
	URL ON
AS CALL removeAnime(:id, :token);
