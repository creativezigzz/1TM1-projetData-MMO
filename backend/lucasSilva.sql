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
