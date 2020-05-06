CREATE PROCEDURE "DBA"."add_mylist" (IN @token char(32), IN titre char(60),IN note tinyint)

/*Rajouter un nouvel anime dans sa liste personnel*/
RESULT (succes BOOLEAN)
BEGIN
  DECLARE pseud CHAR(60);
  DECLARE animi INTEGER;
  /*On s'assure que la personne est connectée*/
  IF(SELECT 1 FROM personne WHERE token = @token ) = 1 THEN
    /*On regarde si l'anime n'est pas déjà dans la liste*/
    IF(SELECT 1 from myList natural join anime WHERE anime.titre=titre) THEN
    SELECT 0;
    ELSE
      SET pseud = (SELECT pseudo from personne where token = @token);
      SET animi = (SELECT animId from anime where anime.titre= titre);
      /*On rajoute les donnnées dans la table personnelle;*/
      INSERT INTO myList VALUES (
        pseud,
        animi,
        note
      );
      SELECT 1;
    ENDIF
  ELSE SELECT 0;
  ENDIF
END;

CREATE SERVICE "add_mylist"
  TYPE 'JSON'
  AUTHORIZATION OFF
  USER "DBA"
  URL ON
  METHODS 'POST,GET'
AS call "DBA"."add_mylist"(:token,:titre,:note);

CREATE PROCEDURE "DBA"."add_anime" (IN titre char(60) ,IN genre char(30))
RESULT (success BOOLEAN)
BEGIN
/*On regarde d'abord si l'anim est dans la table */
  DECLARE gr integer;
  IF (SELECT 1 from anime natural join genre WHERE titre = titre AND  genre.genreNom =genre) = 1 THEN
  SELECT 0;
  /*Sinon juste on continue*/
  ELSE

    SET gr = (select genreId from genre where genre.genreNom = genre);
    INSERT INTO anime (
      titre,
      genrId
    ) ;
    VALUES(
      titre,
      gr
    );

    SELECT 1;
  ENDIF;
END

CREATE SERVICE "add_anime"
  TYPE 'JSON'
  AUTHORIZATION OFF
  USER "DBA"
  URL ON
  METHODS 'POST,GET'
AS call "DBA"."add_anime"(:titre,:genre);
