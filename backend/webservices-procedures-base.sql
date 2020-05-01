CREATE FUNCTION getPath()
/*
	renvoie le chemin (path) de la racine du site (où est située la base de données)
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


CREATE PROCEDURE http_getPage(in url char(255))
/*
	Récupère le contenu d'un fichier tout en mettant l'en-tête 'Content-Type'
	associée à l'extension du fichier (html par défaut).
*/
BEGIN
	DECLARE @ext varchar(5);
	DECLARE @file long varchar;

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
	SET @file = xp_read_file(dba.getPath() || '..\\site\\' || url);

	IF @file is NULL THEN /* Si le fichier n'existe pas, il est NULL */
		/* Donc on retourne le code d'erreur 404 (NotFound) */
		CALL sa_set_http_header('@HttpStatus', '404');
	END IF;

	SELECT @file; /* On retourne le fichier demandé */
END;
