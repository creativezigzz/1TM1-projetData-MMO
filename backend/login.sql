CREATE PROCEDURE "DBA"."login"( IN username char(30), IN password char(64) )
RESULT( nom char(30), prenom char(30), token char(32) )
BEGIN
	/* Le mot de passe est-il correct ? */
	IF (SELECT 1 FROM personne WHERE pseudo = username AND mdp = password) = 1 THEN
		/* Oui, on crée un nouveau token (max 1 session) */
		UPDATE personne
		SET token = hash(rand(), 'md5')
		WHERE pseudo = username;

		/* Et on retourne les infos */
		SELECT nomP, prenomP, token FROM personne WHERE pseudo = username;
	ELSE
		SELECT null, null, null; /* Non, on retourne NULL */
	ENDIF;
END;

CREATE SERVICE "login"
	TYPE 'JSON'
	AUTHORIZATION OFF
	USER "DBA"
	URL ON
	METHODS 'POST,GET'
AS call "DBA"."login"(:username, :mdp);

CREATE PROCEDURE "DBA"."add_user"( IN username char(30), IN nom char(30), IN prenom char(30), IN mdp char(64) )
RESULT( success BOOLEAN, token char(32)  )
BEGIN
	DECLARE @token char(32);

	IF (SELECT 1 FROM personne WHERE pseudo = username) = 1 THEN
		SELECT 0, null;
	ELSE
		SET @token = hash(rand(), 'md5');

		INSERT INTO personne (
			pseudo,
			nomP,
			prenomP,
			token,
			mdp
		)
		VALUES (
			username,
			nom,
			prenom,
			@token,
			mdp
		);

		SELECT 1, @token;
	ENDIF;
END;

CREATE SERVICE "add_user"
	TYPE 'JSON'
	AUTHORIZATION OFF
	USER "DBA"
	URL ON
	METHODS 'POST,GET'
AS call "DBA"."add_user"(:username, :nom, :prenom, :mdp);
