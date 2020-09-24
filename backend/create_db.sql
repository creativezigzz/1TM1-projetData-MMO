/* create_tables.sql */
create table personne (
    pseudo char(30) not null,
    nomP char(60) not null,
    prenomP char(30) not null,
    mdp char(30) not null,
    token char(32) not null,
    CONSTRAINT PK_pseudo PRIMARY KEY (pseudo)
);

create table genre(
    genrId integer not null default autoincrement,
    genrNom char(30) not null,
    CONSTRAINT PK_genrId PRIMARY KEY (genrId)
);

create table anime (
    animeId integer not null default autoincrement,
    titre char(60) not null,
    genrId integer not null,
    CONSTRAINT PK_animeId PRIMARY KEY (animeId),
    CONSTRAINT FK_genrId FOREIGN KEY (genrId) REFERENCES genre(genrId)
);

create table myList (
    pseudo char(30) not null,
    animeId integer not null,
    rating integer not null,
    CONSTRAINT PK_pseudoanimeIdrating PRIMARY KEY (pseudo, animeId),
    CONSTRAINT FK_pseudo FOREIGN KEY (pseudo) REFERENCES personne(pseudo),
    CONSTRAINT FK_animeId FOREIGN KEY (animeId) REFERENCES anime(animeId)
);

CREATE DOMAIN "boolean" BIT NOT NULL DEFAULT 0 check(@col in( 0,1 ) );

/******* scripts-api-rest\cyrilGrandjean.sql *******/

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

/******* scripts-api-rest\lucasSilva.sql *******/

/*
Procedure permettant de rajouter un nouvel anime dans sa liste personnel
@author: Lucas Silva HE201892
*/

CREATE PROCEDURE "DBA"."add_mylist" (IN @token char(32), IN animei integer,IN note tinyint)
RESULT (success BOOLEAN)
BEGIN
  DECLARE hope char(30);

  Call sa_set_http_header('Access-Control-Allow-Origin', '*');
  /*On s'assure que la personne est connectée pour pouvoir rajouter l'anime à la bdd*/
  IF((SELECT 1 FROM personne WHERE token = @token) != 1) THEN

    SELECT 0;
    RETURN;
  ENDIF;
  /*On cap le maximum de la note à 5 */
  IF(note > 5) THEN SET note = 5 ENDIF ;
  /*Ensuite on regarde si l'anime n'est pas déjà dans la base de donnée de la personne*/
  SET hope = (SELECT pseudo from personne where token = @token);
  IF((SELECT 1 from myList natural join personne WHERE myList.animeId=animei AND personne.token=@token) = 1) THEN
  /*Si oui, on mest a jour la note*/
  UPDATE myList SET rating=note  WHERE myList.animeId=animei AND myList.pseudo=hope;
  SELECT 1;
  RETURN;
  ENDIF;
  /* Sinon on rentre une nouvelle entrée dans la bdd personnelle de la personne*/
  INSERT INTO myList VALUES (
    hope,
    animei,
    note
  );
  SELECT 1;
END;
/*
  On crée le service add_mylist
  @author: Lucas Silva HE201892
*/
CREATE SERVICE "add_mylist"
  TYPE 'JSON'
  AUTHORIZATION OFF
  USER "DBA"
  URL ON
  METHODS 'POST,GET'
AS call "DBA"."add_mylist"(:token,:titre,:note);

/*
  Procédure pour ajouter un anime dans la base de donnée général
  @author: Lucas Silva HE201892
*/
CREATE PROCEDURE "DBA"."add_anime" (IN @titre char(60) ,IN @genre integer)
RESULT (success BOOLEAN)
BEGIN
/*On regarde d'abord si l'anim n'est pas déjà dans la table d'animé */
  IF ((SELECT 1 from anime WHERE anime.titre = @titre) = 1) THEN
  SELECT 0;
  /*Si pas, on rajoute une entrée dans la table anime avec son titre et genre*/
  ELSE


    INSERT INTO anime (
      titre,
      genrId
    )
    VALUES(
      @titre,
      @genre
    );

    SELECT 1;
  ENDIF;
END;

/*
  Création du service add_anime
  @author: Lucas Silva HE201892
*/
CREATE SERVICE "add_anime"
  TYPE 'JSON'
  AUTHORIZATION OFF
  USER "DBA"
  URL ON
  METHODS 'POST,GET'
AS call "DBA"."add_anime"(:titre,:genre);


/******* scripts-api-rest\mathieuWalravens.sql *******/
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

/******* scripts-api-rest\quentinServais.sql *******/
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


/******* scripts-base-de-donnees\data_tables.sql *******/
insert into genre
	(genrNom)
values
	('Action'),
	('Aventure'),
	('Comédie'),
	('Drama'),
	('Slice of Life'),
	('Fantaisie'),
	('Horreur'),
	('Mystères'),
	('Psychologique'),
	('Romance'),
	('Science-Fiction'),
	('Arts martiaux'),
	('Furyo');

insert into personne
	(pseudo, nomP,prenomP, mdp, token)
values
	('igzz', 'Silva', 'Lucas', 'kikou', hash(rand(), 'md5')),
	('math', 'Walravens', 'Mathieu', 'koko', hash(rand(), 'md5')),
	('qServais', 'Servais', 'Quentin', 'kiki', hash(rand(), 'md5')),
	('slime789', 'Grandjean', 'Cyril', 'kuku', hash(rand(),'md5'));

insert into anime
	(titre, genrId)
values
	('Full Metal Alchimist: Brotherhood', 2),
	('Cowboy Bebop', 11),
	('Code Geass', 9),
	('Neon Genenis Evangelion', 11),
	('Dragon Ball Z', 1),
	('Naruto Shippuden', 2),
	('Samurai Champloo', 12),
	('Détective Conan', 8),
	('One Piece', 2),
	('Hunter x Hunter', 2),
	('Attack on Titan', 1),
	('Jojos Bizarre Adventure', 2),
	('Sword Art Online', 6);

insert into myList
	(pseudo, animeId, rating)
values
	('igzz', 2, 5),
	('igzz', 4, 5),
	('qServais', 2, 4),
	('qServais', 10, 5),
	('slime789', 10, 4),
	('slime789', 1, 4),
	('slime789', 5, 1),
	('slime789', 6, 2),
	('slime789', 8, 3),
	('math', 8, 5),
	('math', 6, 5),
	('math', 2, 5),
	('math', 1, 5);


/******* scripts-serveur-web\webservices-procedures-base.sql *******/
/*************/
/* Fonctions */
/*************/

CREATE FUNCTION getPath()
/*
	Renvoie le chemin (path) de la racine du site (où est située la base de données)
	Ce script a été écrit par Mr Christian Lambeau.
*/
returns long varchar
deterministic
BEGIN
	declare dbPath long varchar; /* chemin de la db */
	declare dbName long varchar; /* nom de la db */
	--
	set dbPath = (select db_property ('file'));        -- path + nom de la db
	set dbName = (select db_property('name')) + '.db'; -- nom de la db
	set dbPath = left(dbPath, length(dbPath)-length(dbName)); -- path seul
	--
	return dbPath; /* renvoyer path */
END;


CREATE FUNCTION getExtension(filename varchar(255))
/*
	Renvoie l'extension du fichier ou null si le fichier n'en a pas.
*/
RETURNS CHAR(5)
BEGIN
	DECLARE @pos int;
	/* On récupère l'index du dernier . */
	SET @pos = charindex('.', reverse(filename));

	IF @pos = 0 OR @pos > 5 THEN
		/* Si la position est égale à 0 ou plus grande que 5 alors il n'y a pas d'extension */
		RETURN NULL;
	END IF;
	RETURN RIGHT(filename, @pos - 1); /* On retourne les X derniers caractères */
END;


/**************/
/* Procédures */
/**************/

CREATE PROCEDURE http_getPage(in url char(255))
/*
	Récupère le contenu d'un fichier tout en mettant l'en-tête 'Content-Type'
	associée à l'extension du fichier (html par défaut).
*/
BEGIN
	DECLARE @ext varchar(5);
	DECLARE @file long varchar;

	IF url is NULL OR url = '' THEN /* Si l'url est vide, on récupère index.html */
		SET url = 'index.html';
	END IF;

	SET @ext = getExtension(url); /* On récupère l'extension du fichier */
	IF @ext is NULL THEN /* Si elle n'existe pas, on suppose que c'est un fichier html */
		SET url = url || '.html';
		SET @ext = 'html';
	END IF;
	CALL sa_set_http_header('Content-Type',
		CASE /* On utilise le mimetype associé à l'extension */
			WHEN @ext = 'html' THEN 'text/html; charset=utf-8'
			WHEN @ext = 'js' THEN 'application/javascript'
			WHEN @ext = 'css' THEN 'text/css'
			WHEN @ext = 'png' THEN 'image/png'
		END
	);

	/* On récupère le contenu du fichier */
	SET @file = xp_read_file(dba.getPath() || '..\\frontend\\' || url);

	IF @file is NULL THEN /* Si le fichier n'existe pas, il est NULL */
		/* Donc on retourne le code d'erreur 404 (NotFound) */
		CALL sa_set_http_header('@HttpStatus', '404');
	END IF;

	SELECT @file; /* On retourne le fichier demandé */
END;

CREATE PROCEDURE http_redirect(in url char(255))
/*
	Redirige le client à une adresse donnée.
*/
BEGIN
	CALL sa_set_http_header('@HttpStatus', '301');
	CALL sa_set_http_header('Location', url);
END;

/************/
/* Services */
/************/

CREATE SERVICE "site"
	TYPE 'RAW'
	AUTHORIZATION OFF
	USER "DBA"
	URL ON
	METHODS 'GET'
AS call dba.http_getPage(:url);


CREATE SERVICE root
	TYPE 'RAW'
	AUTHORIZATION OFF
	USER "DBA"
	URL ON
	METHODS 'GET'
AS call dba.http_redirect('/site');
