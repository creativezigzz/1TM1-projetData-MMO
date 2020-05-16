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


/*création d' un service qui retourne tout les animés correspondant au token de la personne connectée*/

CREATE SERVICE "getAnimeList"
    TYPE 'JSON'
    AUTHORIZATION OFF
    METHODS 'GET'
    USER "DBA"
    URL ON
AS CALL get_animeList(:token);


CREATE FUNCTION getPers_Id(IN @token char(32))
RETURNS char(30))
BEGIN
	DECLARE @pseudo char(30);
	SET @pseudo = (select p.pseudo
				   from personne as p
				   where @token = p.token);
    RETURN @pseudo;
END;

ALTER FUNCTION get_Id(IN @titre char(60))
RETURNS INTEGER
BEGIN
    DECLARE removeId INT;
    SET removeId = (select DBA.anime.animeId
                    from anime
                    where @titre = anime.titre);
    return removeId; 
END;

CREATE PROCEDURE removeAnime(IN @titre char(60), IN @token char(32))
RESULT(message char(255))
BEGIN
	DELETE FROM myList as li
	WHERE get_Id(@titre) = li.animeId AND @token = getPers_Id(@token);
END;
	
	
