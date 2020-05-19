
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
