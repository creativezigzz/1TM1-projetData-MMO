/* auteur : WALRAVENS Mathieu HE201799 */

/*************/
/* Fonctions */
/*************/

CREATE FUNCTION createToken()
/*
	Génère un nouveau token unique à l'aide des fonctions rand() et hash()
	Renvoie le token (32 caractères)
*/
RETURNS char(32)
BEGIN
	DECLARE @token char(32);
	SET @token = hash(rand(), 'md5');

	/* On s'assure que le token est unique */
	IF (SELECT 1 FROM personne WHERE token = @token) = 1 THEN
		/* Sinon on le re-génère */
		SET @token = createToken();
	ENDIF;

	RETURN @token;
END;

/**************/
/* Procédures */
/**************/

CREATE PROCEDURE "DBA"."login"( IN @pseudo char(30), IN @mdp char(64) )
/* Connexion d'un utilisateur.
   Prends en paramètres le pseudo et le mot de passe de l'utilisateur.
   Renvoie son nom, prénom et un nouveau token si les identifiants sont correct.
   Renvoie null dans les trois champs dans le cas contraire.
*/
RESULT( nom char(60), prenom char(30), token char(32) )
BEGIN
	/* Le mot de passe est-il correct ? */
	IF (SELECT 1 FROM personne WHERE pseudo = @pseudo AND mdp = @mdp) = 1 THEN
		/* Oui, on crée un nouveau token (max 1 session) */
		UPDATE personne
		SET token = createToken()
		WHERE pseudo = @pseudo;

		/* Et on retourne les infos */
		SELECT nomP, prenomP, token FROM personne WHERE pseudo = @pseudo;
	ELSE
		SELECT null, null, null; /* Non, on retourne NULL */
	ENDIF;
END;

CREATE PROCEDURE "DBA"."add_user"( IN @pseudo char(30), IN nom char(60), IN prenom char(30), IN @mdp char(64) )
/* Ajoute un nouvel utilisateur dans la base de donnée */
RESULT( success BOOLEAN, "message" char(60), token char(32)  )
BEGIN
	DECLARE @token char(32);

	/* On vérifie que le pseudo est unique. */
	IF (SELECT 1 FROM personne WHERE pseudo = @pseudo) = 1 THEN
		SELECT 0, 'Ce pseudo n''est pas disponible.', NULL;
		RETURN;
	ENDIF;

	/* On crée un nouvel token */
	SET @token = createToken();

	/* On ajoute la personne à la table personne */
	INSERT INTO personne VALUES (
		@pseudo,
		nom,
		prenom,
		@mdp,
		@token
	);

	/* Tout s'est bien déroulé, on retourne le token */
	SELECT 1, NULL, @token;
END;

CREATE PROCEDURE "DBA"."get_top"()
/*
	Renvoie la liste de tous les animes noté avec leur note globale (moyenne).
	Trié par ordre décroissant sur la note.
 */
RESULT( titre char(255), note decimal(8, 2), genre char(50) )
BEGIN
	SELECT titre, CAST(avg(li.rating) as decimal(8,2)) as rating, g.genrNom
	FROM anime AS a
	JOIN myList AS li ON li.animeId = a.animeId
	JOIN genre AS g ON g.genrId = a.genrId
	GROUP BY titre, g.genrNom
	ORDER BY rating DESC;
END;

/************/
/* Services */
/************/

CREATE SERVICE "get_top"
	TYPE 'JSON'
	AUTHORIZATION OFF
	USER "DBA"
	URL ON
	METHODS 'GET'
AS call "DBA"."get_top"();

CREATE SERVICE "add_user"
	TYPE 'JSON'
	AUTHORIZATION OFF
	USER "DBA"
	URL ON
	METHODS 'GET'
AS call "DBA"."add_user"(:pseudo, :nom, :prenom, :mdp);

CREATE SERVICE "login"
	TYPE 'JSON'
	AUTHORIZATION OFF
	USER "DBA"
	URL ON
	METHODS 'GET'
AS call "DBA"."login"(:pseudo, :mdp);