CREATE PROCEDURE "DBA"."add_anime"( IN titre char(60), IN genre char(30) )
RESULT( success BOOLEAN )
BEGIN
	/* Vérifier que l'anime n'existe pas puis insérer dans la table 'anime' */
END;

CREATE PROCEDURE "DBA"."get_genre"( IN genre int )
RESULT( titre char(60) )
BEGIN
	SELECT titre FROM anime WHERE genrId = genre;
END;

CREATE PROCEDURE "DBA"."get_list"()
RESULT( nom char(60), genre char(30) )
BEGIN
END;

CREATE PROCEDURE "DBA"."get_top"()
RESULT( titre char(60), rating decimal(8, 2) )
BEGIN
END;

CREATE PROCEDURE "DBA"."login"( IN username char(30), IN mdp char(64) )
RESULT( nom char(30), prenom char(30), token char(32) )
BEGIN
	/* Le mot de passe est-il correct ? */
	IF (SELECT 1 FROM personne WHERE pseudo = username AND mdp = mdp) = 1 THEN
		SELECT null, null, null; /* Non, on retourne NULL */
	ELSE
		/* Oui, on crée un nouveau token (max 1 session) */
		UPDATE personne
		SET token = hash(rand(), 'md5')
		WHERE pseudo = username;

		/* Et on retourne les infos */
		SELECT nomP, prenomP, token FROM personne WHERE pseudo = username;
	ENDIF;
END;

CREATE PROCEDURE "DBA"."search"( IN name char(60) )
RESULT( name char(60) )
BEGIN
END;

CREATE PROCEDURE "DBA"."add_user"( IN username char(30), IN nom char(30), IN prenom char(30), IN mdp char(64) )
RESULT( success BOOLEAN )
BEGIN
	/* Vérifier que l'utilisateur n'existe pas */
END;