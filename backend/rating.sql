select cast(avg(DBA.myList.rating) as decimal(8, 2)) as rating
from myList natural join anime 
group by animeId
order by animeId