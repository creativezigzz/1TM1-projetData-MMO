CREATE PROCEDURE "DBA"."examHE201799"( IN nbr int )
RESULT( anime char(70), number int )
BEGIN
	SELECT anime.animeId || ' - ' || titre, count(*) as number FROM anime
    RIGHT JOIN myList
        ON anime.animeId = myList.animeId
        WHERE myList.rating = 1
        GROUP BY myList.animeId, anime.animeId, anime.titre
        HAVING number > nbr
    ORDER BY number DESC, anime.titre ASC;
END