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
