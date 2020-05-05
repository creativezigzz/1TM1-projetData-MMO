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
