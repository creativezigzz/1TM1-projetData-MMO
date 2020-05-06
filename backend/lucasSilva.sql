CREATE PROCEDURE "DBA"."add_mylist" (IN @token char(32), IN titre char(60),IN note tinyint)

/*Rajouter un nouvel anime dans sa liste personnel*/
RESULT (success BOOLEAN)
BEGIN
  Call sa_set_http_header('Access-Control-Allow-Origin', '*');

  /*On s'assure que la personne est connectée*/
  IF((SELECT 1 FROM personne WHERE token = @token ) = 1) THEN
    /*On regarde si l'anime n'est pas déjà dans la liste*/
    IF((SELECT 1 from myList natural join anime WHERE anime.titre=titre) = 1 )THEN
    SELECT 0;
    ELSE
      /*On rajoute les donnnées dans la table personnelle;*/
      INSERT INTO myList VALUES (
        (SELECT pseudo from personne where token = @token),
        (SELECT animId from anime where anime.titre= titre),
        note
      );
      SELECT 1;
    ENDIF;
  ELSE SELECT 0;
  ENDIF;
END;
