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
