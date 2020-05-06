CREATE PROCEDURE "DBA"."add_mylist" (IN @token char(32), IN animei integer,IN note tinyint)

/*Rajouter un nouvel anime dans sa liste personnel*/
RESULT (success BOOLEAN)
BEGIN
  Call sa_set_http_header('Access-Control-Allow-Origin', '*');
  /*On s'assure que la personne est connectée*/
  IF((SELECT 1 FROM personne WHERE token != @token) = 1 OR (SELECT 1 from myList natural join personne WHERE myList.animeId=animei AND personne.token=@token) = 1) THEN
    /*On regarde si l'anime n'est pas déjà dans la liste*/
    SELECT 0;
    RETURN;
  ENDIF;
  INSERT INTO myList VALUES (
    (SELECT pseudo from personne where token = @token),
    animei,
    note
  );
  SELECT 1;
END;

CREATE SERVICE "add_mylist"
  TYPE 'JSON'
  AUTHORIZATION OFF
  USER "DBA"
  URL ON
  METHODS 'POST,GET'
AS call "DBA"."add_mylist"(:token,:titre,:note);

CREATE PROCEDURE "DBA"."add_anime" (IN @titre char(60) ,IN genre char(30))
RESULT (success BOOLEAN)
BEGIN
/*On regarde d'abord si l'anim est dans la table */
  DECLARE gr integer;
  IF ((SELECT 1 from anime natural join genre WHERE anime.titre = @titre AND  genre.genrNom =genre) = 1) THEN
  SELECT 0;
  /*Sinon juste on continue*/
  ELSE

    SET gr = (select genreId from genre where genre.genrNom = genre);
    INSERT INTO anime (
      titre,
      genrId
    )
    VALUES(
      @titre,
      gr
    );

    SELECT 1;
  ENDIF;
END;

CREATE SERVICE "add_anime"
  TYPE 'JSON'
  AUTHORIZATION OFF
  USER "DBA"
  URL ON
  METHODS 'POST,GET'
AS call "DBA"."add_anime"(:titre,:genre);
